with Ada.Unchecked_Deallocation;

with Types; use Types;

package Messages is

   type Message_Id is (UNDEFINED, NOP, PING,
                       EXTERNAL_LIGHT_SENSOR,
                       EXTERNAL_DISTANCE_SENSOR,
                       EXTERNAL_IMAGE_DATA,
                       EXTERNAL_JOIN_SUCCESS,
                       EXTERNAL_ADD_REQUEST,
                       WEBOTS_VELOCITY,
                       BACKEND_JOIN_CHALLENGE,
                       BACKEND_POSITION_UPDATE,
                       BACKEND_ROUTE_UPDATE,
                       ERROR_BACKEND_DISCONNECTED,
                       ERROR_WEBOTS_DISCONNECTED,
                       ERROR_PORTS_NOT_SET);

   for Message_Id use (UNDEFINED => 16#1#, NOP => 16#2#, Ping => 16#3#,
                       EXTERNAL_LIGHT_SENSOR => 16#41#,
                       EXTERNAL_DISTANCE_SENSOR => 16#42#,
                       EXTERNAL_IMAGE_DATA => 16#43#,
                       EXTERNAL_JOIN_SUCCESS => 16#44#,
                       EXTERNAL_ADD_REQUEST => 16#45#,
                       WEBOTS_VELOCITY => 16#81#,
                       BACKEND_JOIN_CHALLENGE => 16#C1#,
                       BACKEND_POSITION_UPDATE => 16#C2#,
                       BACKEND_ROUTE_UPDATE => 16#C3#,
                       ERROR_BACKEND_DISCONNECTED => 16#D1#,
                       ERROR_WEBOTS_DISCONNECTED => 16#D2#,
                       ERROR_PORTS_NOT_SET => 16#D3#);

   for Message_Id'Size use Types.Uint8'Size;
   
   -- base message type
   type Message is tagged record
      Size : Types.Uint32;
      Id : Message_Id;
   end record;

   type Distance_Sensor_Array is array(0 .. 8) of Types.Float64;

   type Distance_Sensor_Message is new Message with record
      Payload : Distance_Sensor_Array;
   end record;
   
   type Light_Sensor_Array is array(0 .. 0) of Types.Float64;
   
   type Light_Sensor_Message is new Message with record
      Payload : Light_Sensor_Array;
   end record;

   type Image_Data_Message is new Message with record
      Payload : Types.Payload_Ptr;
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
   
   type Position_Update_Message is new Message with record
      Position : Types.Uint8;
   end record;
   
   type Route_Update_Message is new Message with record
      Route : Types.Payload_Ptr;
   end record;
   
   type Add_Request_Message is new Message with record
      Src : Types.Uint8;
      Dst : Types.Uint8;
      Passengers : Types.Uint32;
   end record;
      
   -- pointer types for all messages
   type Message_Ptr is access all Message'Class;
   type DS_Message_Ptr is access all Distance_Sensor_Message;
   type LS_Message_Ptr is access all Light_Sensor_Message;
   type ID_Message_Ptr is access all Image_Data_Message;
   type JS_Message_Ptr is access all Join_Success_Message;
   type JC_Message_Ptr is access all Join_Challenge_Message;
   type V_Message_Ptr is access all Velocity_Message;
   type PU_Message_Ptr is access all Position_Update_Message;
   type RU_Message_Ptr is access all Route_Update_Message;
   type AR_Message_Ptr is access all Add_Request_Message;
   
   function Velocity_Message_Create (Left_Speed, Right_Speed : in Types.Float64) 
                                     return Velocity_Message;
   function Join_Challenge_Message_Create return Join_Challenge_Message;
   function Position_Update_Message_Create (Position : Types.Uint8) 
                                            return Position_Update_Message;
   function Route_Update_Message_Create (Route : Types.Payload_Ptr) 
                                         return Route_Update_Message;
   
   procedure Free_DS_Message is new Ada.Unchecked_Deallocation
     (Object => Distance_Sensor_Message, Name => DS_Message_Ptr);
   
   procedure Free_LS_Message is new Ada.Unchecked_Deallocation
     (Object => Light_Sensor_Message, Name => LS_Message_Ptr);
   
   procedure Free_ID_Message is new Ada.Unchecked_Deallocation
     (Object => Image_Data_Message, Name => ID_Message_Ptr);
   
   procedure Free_JS_Message is new Ada.Unchecked_Deallocation
     (Object => Join_Success_Message, Name => JS_Message_Ptr);
   
   procedure Free_JC_Message is new Ada.Unchecked_Deallocation
     (Object => Join_Challenge_Message, Name => JC_Message_Ptr);
   
   procedure Free_V_Message is new Ada.Unchecked_Deallocation
     (Object => Velocity_Message, Name => V_Message_Ptr);
   
   procedure Free_PU_Message is new Ada.Unchecked_Deallocation
     (Object => Position_Update_Message, Name => PU_Message_Ptr);
   
   procedure Free_RU_Message is new Ada.Unchecked_Deallocation
     (Object => Route_Update_Message, Name => RU_Message_Ptr);
   
   procedure Free_AR_Message is new Ada.Unchecked_Deallocation
     (Object => Add_Request_Message, Name => AR_Message_Ptr);

end Messages;
