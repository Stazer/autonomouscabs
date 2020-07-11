with AUnit.Assertions; use AUnit.Assertions;

with Types; use Types;
with Byte_Buffer; use Byte_Buffer;

package body buffer_tests is

   procedure Register_Tests (T: in out buffer_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Read_Write_Uint8'Access, "Test write and read uint8 from buffer.");
      Register_Routine (T, Test_Read_Write_Uint16'Access, "Test write and read uint16 from buffer.");
      Register_Routine (T, Test_Read_Write_Uint32'Access, "Test write and read uint32 from buffer.");
      Register_Routine (T, Test_Read_Write_Uint64'Access, "Test write and read uint64 from buffer.");
      Register_Routine (T, Test_Read_Write_Payload'Access, "Test write and read payload from buffer.");
      Register_Routine (T, Test_Delete_Bytes'Access, "Test deleting bytes from buffer.");
      Register_Routine (T, Test_Read_Message'Access, "Test write and read messages from buffer.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: buffer_test) return Test_String is
   begin
      return Format ("Buffer Tests");
   end Name;
   
   procedure Test_Read_Write_Uint8 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u8, u8t : Uint8;
   begin
      u8 := 230;
      b.Write_Uint8 (u8);
      b.Read_Uint8 (u8t);
      
      Assert (u8 = u8t, "Writing and reading uint8 does not work");
   end Test_Read_Write_Uint8;
   
   procedure Test_Read_Write_Uint16 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u16, u16t : Uint16;
   begin
      u16 := 5000;
      b.Write_Uint16 (u16);
      b.Read_Uint16 (u16t);
      
      Assert (u16 = u16t, "Writing and reading uint16 does not work");
   end Test_Read_Write_Uint16;
   
   procedure Test_Read_Write_Uint32 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u32, u32t : Uint32;
   begin
      u32 := 200000;
      b.Write_Uint32 (u32);
      b.Read_Uint32 (u32t);
      
      Assert (u32 = u32t, "Writing and reading uint32 does not work");
   end Test_Read_Write_Uint32;
   
   procedure Test_Read_Write_Uint64 (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      u64, u64t : Uint64;
   begin
      u64 := 5000000;
      b.Write_Uint64 (u64);
      b.Read_Uint64 (u64t);
      
      Assert (u64 = u64t, "Writing and reading uint64 does not work");
   end Test_Read_Write_Uint64;
   
   procedure Test_Read_Write_Payload (T : in out Test_Cases.Test_Case'Class) is
      b : Buffer;
      p_in, p_out : access Payload := new payload (0 .. 31);
      u8 : Uint8 := 0;
   begin
      for I in p_in'Range loop
         p_in (I) := u8;
         u8 := u8 + 1;
      end loop;
      
      b.Write_Payload (p_in);
      b.Read_Payload (p_out);
      
      for I in p_out'Range loop
         Assert (p_out (I) = p_in (I), "Writing and reading payload does not work");
      end loop;
      null;
   end Test_Read_Write_Payload;
   
   procedure Test_Delete_Bytes (T : in out Test_Cases.Test_Case'Class) is
      b1, b2, b3, b4 : Buffer;
   begin
      for I in Uint8 range 0 .. 15 loop
         b1.Write_Uint8 (I);
         b2.Write_Uint8 (I);
         b3.Write_Uint8 (I);
         b4.Write_Uint8 (I);
      end loop;
      
      b1.Delete_Bytes (6);
      Assert (b1.Size = 10, "Deleting bytes does not work");
      
      b2.Delete_Bytes (0);
      Assert (b2.Size = 16, "Deleting 0 bytes does not work");
      
      b3.Delete_Bytes (16);
      Assert (b3.Size = 0, "Deleting b.Size bytes does not work");
      
      b4.Delete_Bytes (20);
      Assert (b4.Size = 0, "Deleting more than b.Size bytes is not handled correctly");
   end Test_Delete_Bytes;
   
   procedure Test_Read_Message (T : in out Test_Cases.Test_Case'Class) is
      B : Buffer;
      
      M1 : Light_Sensor_Message;
      M2 : Distance_Sensor_Message;
      M3 : Image_Data_Message;
      M4 : Join_Success_Message;
      M5 : Join_Challenge_Message;
      M6 : Velocity_Message;
      
      MP1 : LS_Message_Ptr;
      MP2 : DS_Message_Ptr;
      MP3 : ID_Message_Ptr;
      MP4 : JS_Message_Ptr;
      MP5 : JC_Message_Ptr;
      MP6 : V_Message_Ptr;
   begin
      M1.Id := EXTERNAL_LIGHT_SENSOR;
      M1.Size := 5 + 8;
      M1.Payload (0) := 30.4;
      
      M2.Id := EXTERNAL_DISTANCE_SENSOR;
      M2.Size := 5 + 72;
      for I in M2.Payload'Range loop
         M2.Payload (i) := Float64 (I);
      end loop;
      
      M3.Id := EXTERNAL_IMAGE_DATA;
      M3.Size := 5 + 5;
      M3.Payload := new Payload (0 .. 4);
      for I in M3.Payload'Range loop 
         M3.Payload (I) := Uint8 (I);
      end loop;
      
      M4.Id := EXTERNAL_JOIN_SUCCESS;
      M4.Size := 5 + 4;
      M4.Cab_Id := 340;
      
      M5.Id := BACKEND_JOIN_CHALLENGE;
      M5.Size := 5;
      
      M6.Id := WEBOTS_VELOCITY;
      M6.Size := 5 + 16;
      M6.Left_Speed := 4.3;
      M6.Right_Speed := 2.1;
      
      B.Write_Message (M1);
      B.Write_Message (M2);
      B.Write_Message (M3);
      B.Write_Message (M4);
      B.Write_Message (M5);
      B.Write_Message (M6);
      
      B.Read_Message (Message_Ptr (MP1));
      B.Read_Message (Message_Ptr (MP2));
      B.Read_Message (Message_Ptr (MP3));
      B.Read_Message (Message_Ptr (MP4));
      B.Read_Message (Message_Ptr (MP5));
      B.Read_Message (Message_Ptr (MP6));
      
      Assert (MP1.Id = M1.Id, "Writing Light_Sensor_Message does not work");
      Assert (MP2.Id = M2.Id, "Writing Distance_Sensor_Message does not work");
      Assert (MP3.Id = M3.Id, "Writing Image_Data_Message does not work");
      Assert (MP4.Id = M4.Id, "Writing Join_Success_Message does not work");
      Assert (MP5.Id = M5.Id, "Writing Join_Challenge_Message does not work");
      Assert (MP6.Id = M6.Id, "Writing Velocity_Message does not work");
      
   end Test_Read_Message;
      
end buffer_tests;
