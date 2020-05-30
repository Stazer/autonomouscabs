with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with tcp_client; use tcp_client;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;
with communication_queues; use communication_queues;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


package backend_thread is

   -- Backend thread variables
   Backend_Client: Socket_Type; -- stores the socket for the backend
   Backend_Channel : Stream_Access; -- socket I/O interface
   Backend_Header : Stream_Element_Array(1..8); --header to check protocol
   Backend_Offset : Stream_Element_Count; -- info on how many inc. elements
   Backend_Address : Sock_Addr_Type; -- stores the server address
   Backend_Cmd : Command; -- command to send over socket
   Backend_Socket_Set : Socket_Set_Type; -- set to monitor if data incmoing

   procedure backend_main;

end backend_thread;
