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
   
   -- base message type
   type Message is tagged record
      Size : Types.Uint32;
      Id : Message_Id;
   end record;

   type Distance_Sensor_Array is array(0 .. 8) of Types.Float64;

   -- interesting ones: 2: front ,3,6,5,8
   type Distance_Sensor_Message is new Message with record
      Payload : Distance_Sensor_Array;
   end record;
   
   type Light_Sensor_Array is array(0 .. 0) of Types.Float64;
   
   type Light_Sensor_Message is new Message with record
      Payload : Light_Sensor_Array;
   end record;

   type Image_Data_Message is new Message with record
      Payload : access Types.Payload;
   end record;

   type Join_Success_Message is new Message with record
      Cab_Id : Types.Uint32;
   end record;

   type Velocity_Message is new Message with record
      Left_Speed : Types.Float64;
      Right_Speed : Types.Float64;
   end record;
   
   type Join_Challenge_Message is new Message with record
      null;
   end record;
   
   -- pointer types for all messages
   type Message_Ptr is access all Message'Class;
   type DS_Message_Ptr is access all Distance_Sensor_Message;
   type LS_Message_Ptr is access all Light_Sensor_Message;
   type ID_Message_Ptr is access all Image_Data_Message;
   type JS_Message_Ptr is access all Join_Success_Message;
   type JC_Message_Ptr is access all Join_Challenge_Message;
   type V_Message_Ptr is access all Velocity_Message;
   
   function Velocity_Message_Create (Left_Speed, Right_Speed : in Types.Float64) return Velocity_Message;
   function Join_Challenge_Message_Create return Join_Challenge_Message;

end Messages;
