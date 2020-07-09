package body Byte_Buffer is
      
   procedure Read_Uint8 (Self : in out Buffer; Val : out Types.Uint8) is
   begin
      if Self.Bytes_Remaining < 1 then
         raise Not_Enough_Data;
      end if;
      
      Val := Self.Vector.Element (Integer (Self.Read));
      Self.Read := Self.Read + 1;
   end Read_Uint8;
   
   procedure Read_Uint16 (Self : in out Buffer; Val : out Types.Uint16) is
      O2 : Types.Octets_2;
   begin
      if Self.Bytes_Remaining < 4 then
         raise Not_Enough_Data;
      end if;
      
      O2 (0) := Self.Vector.Element (Integer (Self.Read));
      O2 (1) := Self.Vector.Element (Integer (Self.Read) + 1);
      Val := Types.octets_to_Uint16 (O2);
      Self.Read := Self.Read + 2;
   end Read_Uint16;
   
   procedure Read_Uint32 (Self : in out Buffer; Val : out Types.Uint32) is
      O4 : Types.Octets_4;
   begin
      if Self.Bytes_Remaining < 4 then
         raise Not_Enough_Data;
      end if;
      
      O4 (0) := Self.Vector.Element (Integer (Self.Read));
      O4 (1) := Self.Vector.Element (Integer (Self.Read) + 1);
      O4 (2) := Self.Vector.Element (Integer (Self.Read) + 2);
      O4 (3) := Self.Vector.Element (Integer (Self.Read) + 3);
      Val := Types.octets_to_Uint32 (O4);
      Self.Read := Self.Read + 4;
   end Read_Uint32;
   
   procedure Read_Uint64 (Self : in out Buffer; Val : out Types.Uint64) is
      o8 : Types.Octets_8;
   begin
      if Self.Bytes_Remaining < 8 then
         raise Not_Enough_Data;
      end if;
      
      O8 (0) := Self.Vector.Element (Integer (Self.Read));
      O8 (1) := Self.Vector.Element (Integer (Self.Read) + 1);
      O8 (2) := Self.Vector.Element (Integer (Self.Read) + 2);
      O8 (3) := Self.Vector.Element (Integer (Self.Read) + 3);
      O8 (4) := Self.Vector.Element (Integer (Self.Read) + 4);
      O8 (5) := Self.Vector.Element (Integer (Self.Read) + 5);
      O8 (6) := Self.Vector.Element (Integer (Self.Read) + 6);
      O8 (7) := Self.Vector.Element (Integer (Self.Read) + 7);
      Val := Types.octets_to_Uint64 (O8);
      Self.Read := Self.Read + 8;
   end Read_Uint64; 
   
   procedure Read_Float64 (Self : in out Buffer; Val : out Types.Float64) is
      U64 : Types.Uint64;
   begin
      Self.Read_Uint64 (U64);
      Val := Types.Uint64_To_Float64 (U64);
   end Read_Float64;
      
   procedure Read_Payload (Self : in out Buffer; Val : access Types.Payload) is
      Count : Types.Uint32 := 0;
   begin
      if Self.Bytes_Remaining < Val'Size then
         raise Not_Enough_Data;
      end if;
      
      for I in Val'Range loop
         Val (I) := Self.Vector.Element (Integer (Self.Read + Count));
         Count := Count + 1;
      end loop;
      Self.Read := Self.Read + Count; 
   end Read_Payload;

   procedure Write_Uint8 (Self : in out Buffer; Val : in Types.Uint8) is
   begin
      Self.Vector.Append (Val);
      Self.Written := Self.Written + 1;
   end Write_Uint8;
      
   procedure Write_Uint16 (Self : in out Buffer; Val : in Types.Uint16) is
      O2 : Types.Octets_2 := Types.Uint16_To_Octets (Val);
   begin
      Self.Vector.Append (O2 (0));
      Self.Vector.Append (O2 (1));
      Self.Written := Self.Written + 2;
   end Write_Uint16;
   
   procedure Write_Uint32 (Self : in out Buffer; Val : in Types.Uint32) is
      O4 : Types.Octets_4 := Types.Uint32_To_Octets (Val);
   begin
      Self.Vector.Append (O4 (0));
      Self.Vector.Append (O4 (1));
      Self.Vector.Append (O4 (2));
      Self.Vector.Append (O4 (3));
      Self.Written := Self.Written + 4;
   end Write_Uint32;
      
   procedure Write_Uint64 (Self : in out Buffer; Val : in Types.Uint64) is
      O8 : Types.Octets_8 := Types.Uint64_To_Octets (Val);
   begin
      Self.Vector.Append (O8 (0));
      Self.Vector.Append (O8 (1));
      Self.Vector.Append (O8 (2));
      Self.Vector.Append (O8 (3));
      Self.Vector.Append (O8 (4));
      Self.Vector.Append (O8 (5));
      Self.Vector.Append (O8 (6));
      Self.Vector.Append (O8 (7));
      Self.Written := Self.Written + 8;
   end Write_Uint64; 
   
   procedure Write_Float64 (Self : in out Buffer; Val : in Types.Float64) is
      U64 : Types.Uint64;
   begin
      U64 := Types.Float64_To_Uint64 (Val);
      Self.Write_Uint64 (U64);
   end Write_Float64;
   
   procedure Write_Payload (Self : in out Buffer; Val : access Types.Payload) is
      Count : Types.Uint32 := 0;
   begin
      for I in Val'Range loop
         Self.Vector.Append (Val (I));
         Count := Count + 1;
      end loop;
      Self.Written := Self.Written + Count;
   end Write_Payload;
      
   procedure Read_Message (Self : in out Buffer; Val : out Messages.Message_Ptr) is
      Size, P_Size : Types.Uint32;
      Id : Types.Uint8;
      M_Id : Messages.Message_Id;
   begin
      Self.Read_Uint32 (Size);
      Size := Size - 4;
      
      if Self.Bytes_Remaining < Size then
         Self.Unwind (4);
         raise Not_Enough_Data;
      end if;
      
      Self.Read_Uint8 (Id);
      
      begin
         M_Id := Messages.Message_Id'Enum_Val (Id);
      exception
         when E : Constraint_Error  => 
            Self.Unwind (5);
            raise Unknown_Message_Id;
      end;
      
      case M_Id is
         when Messages.EXTERNAL_DISTANCE_SENSOR =>
            Val := new Messages.Distance_Sensor_Message;
            
            for I in Messages.DS_Message_Ptr (Val).Payload'Range loop
               Self.Read_Float64 (Messages.DS_Message_Ptr (Val).Payload (I));
            end loop;
         when Messages.EXTERNAL_LIGHT_SENSOR => 
            Val := new Messages.Light_Sensor_Message;
            
            Self.Read_Float64 (Messages.LS_Message_Ptr (Val).Payload (0));
         when Messages.EXTERNAL_IMAGE_DATA => 
            Val := new Messages.Image_Data_Message;
            Self.Read_Uint32 (P_Size);
            Messages.ID_Message_Ptr (Val).Payload := new Types.Payload (0 .. P_Size - 1);
            
            for I in Messages.ID_Message_Ptr (Val).Payload'Range loop
               Self.Read_Uint8 (Messages.ID_Message_Ptr (Val).Payload (I));
            end loop; 
         when Messages.EXTERNAL_JOIN_SUCCESS => 
            Val := new Messages.Join_Success_Message;
            Self.Read_Uint32 (Messages.JS_Message_Ptr (Val).Cab_Id);
         when others => null;
      end case;
      
      Val.Size := Size;
      Val.Id := M_Id;
   end Read_Message;
   
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Join_Success_Message) is
   begin
      Self.Write_Uint32 (Val.Size);
      Self.Write_Uint8 (Types.Uint8 (Messages.Message_Id'Enum_Rep (Val.Id)));
      Self.Write_Uint32 (Val.Cab_Id);      
   end Write_Message;
   
   procedure Write_Message (Self : in out Buffer; Val : in Messages.Velocity_Message) is
   begin
      Self.Write_Uint32 (Val.Size);
      Self.Write_Uint8 (Types.Uint8 (Messages.Message_Id'Enum_Rep (Val.Id)));
      Self.Write_Float64 (Val.Left_Speed);
      Self.Write_Float64 (Val.Right_Speed);
   end Write_Message;
   
   function Bytes_Read (Self : in out Buffer) return Types.Uint32 is
   begin
      return Self.Read;
   end Bytes_Read;
   
   function Bytes_Written (Self : in out Buffer) return Types.Uint32 is
   begin
      return Self.Written;
   end Bytes_Written;
   
   function Bytes_Remaining (Self : in out Buffer) return Types.Uint32 is
   begin
      return Self.Written - Self.Read;
   end Bytes_Remaining;
   
   function Size (Self : in out Buffer) return Types.Uint32 is
   begin
      return Types.Uint32 (Self.Vector.Length);
   end Size;
      
   procedure Unwind (Self : in out Buffer; N : in Types.Uint32) is
      N_Bytes : Types.Uint32 := (if N > Self.Read then Self.Read else N);
   begin
      Self.Read := Self.Read - N_Bytes;
   end Unwind;
   
   procedure Delete_Bytes (Self : in out Buffer; N : in Types.Uint32) is
      N_Bytes : Types.Uint32 := (if N > Self.Written then Self.Written else N);
   begin
      Self.Vector.Delete (0, Ada.Containers.Count_Type (N_Bytes));
      Self.Read := (if N_Bytes > Self.Read then 0 else Self.Read - N_Bytes);
      Self.Written := Self.Written - N_Bytes;
   end Delete_Bytes;
   
   procedure Write_Stream (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                           In_Buffer : in Buffer) is
      B : Buffer := In_Buffer;
      Stream_Buffer : Ada.Streams.Stream_Element_Array (0 .. Ada.Streams.Stream_Element_Offset (B.Bytes_Remaining - 1));
   begin
      for I in Stream_Buffer'Range loop
         B.Read_Uint8 (Types.Uint8 (Stream_Buffer (I)));
      end loop;
      
      Stream.Write (Stream_Buffer);
   end Write_Stream;
   
   procedure Read_Stream (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
                          B : out Buffer) is
      Size : Types.Uint32;
      O4 : Types.Octets_4;
      Stream_Buffer1 : Ada.Streams.Stream_Element_Array (0 .. 3);
      Last : Ada.Streams.Stream_Element_Offset;
   begin
      Stream.Read (Stream_Buffer1, Last);
      
      for I in Stream_Buffer1'Range loop
         O4 (Types.Uint32 (I)) := Types.Uint8 (Stream_Buffer1 (I));
      end loop;
      
      Size := Types.Octets_To_Uint32 (O4);
      
      declare 
         Stream_Buffer2 : Ada.Streams.Stream_Element_Array (0 .. Ada.Streams.Stream_Element_Offset (Size - 5));
      begin
         Stream.Read (Stream_Buffer2, Last);
         
         B.Write_Uint32 (Size);
         for I in Stream_Buffer2'Range loop
            B.Write_Uint8 (Types.Uint8 (Stream_Buffer2 (I)));
         end loop;
      end; 
   end Read_Stream; 
   
end Byte_Buffer;
