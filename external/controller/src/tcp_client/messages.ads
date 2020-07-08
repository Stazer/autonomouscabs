with Types; use Types;

package Messages is

   type Message_Id is (UNDEFINED, NOP, PING,
                       EXTERNAL_LIGHT_SENSOR,
                       EXTERNAL_DISTANCE_SENSOR,
                       EXTERNAL_IMAGE_DATA,
                       EXTERNAL_JOIN_SUCCESS,
                       WEBOTS_VELOCITY,
                       BACKEND_JOIN_CHALLENGE);

   for Message_Id use (UNDEFINED => 16#1#, NOP => 16#2#, Ping => 16#3#,
                       EXTERNAL_LIGHT_SENSOR => 16#41#,
                       EXTERNAL_DISTANCE_SENSOR => 16#42#,
                       EXTERNAL_IMAGE_DATA => 16#43#,
                       EXTERNAL_JOIN_SUCCESS => 16#44#,
                       WEBOTS_VELOCITY => 16#81#,
                       BACKEND_JOIN_CHALLENGE => 16#C1#);

   for Message_Id'Size use Types.Uint8'Size;

   type Message (In_Size : Types.Uint32; In_Id : Message_Id) is tagged record
      Size : Types.Uint32 := In_Size;
      Id : Types.Uint8 := Types.Uint8 (Message_Id'Enum_Rep (In_Id));
   end record;

   type Distance_Sensor_Array is array(0 .. 7) of Types.Float64;

   type Distance_Sensor_Message is new Message (5 + 16, EXTERNAL_DISTANCE_SENSOR) with record
     Payload : Distance_Sensor_Array;
   end record;

   type Image_Data_Array is array(0 .. (50 * 50 * 4) - 1) of Types.Uint8;

   type Image_Data_Message is new Message (5 + (50 * 50 * 4), EXTERNAL_IMAGE_DATA) with record
     Payload : Image_Data_Array;
   end record;

   type Join_Success_Message is new Message (5 + 4, EXTERNAL_JOIN_SUCCESS) with record
     Cab_Id : Types.Uint32;
   end record;

   type Velocity_Message is new Message (5 + 16, WEBOTS_VELOCITY) with record
      Left_Speed : Types.Float64;
      Right_Speed : Types.Float64;
   end record;
   
   type Join_Challenge_Message is new Message (5, BACKEND_JOIN_CHALLENGE) with record
      null;
   end record;

end Messages;
