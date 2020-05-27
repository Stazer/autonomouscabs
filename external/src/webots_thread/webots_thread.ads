with GNAT.Sockets; use GNAT.Sockets;
with Ada.Streams; use Ada.Streams;
with tcp_client; use tcp_client;

package webots_thread is

   -- Webots thread variables
   Webots_Client  : Socket_Type; -- stores the socket for the webots controller
   Webots_Channel : Stream_Access; -- socket I/O interface
   Webots_Header : Stream_Element_Array(1..8); --header to check protocol
   Webots_Offset : Stream_Element_Count; -- info on how many inc. elements
   Webots_Address : Sock_Addr_Type; -- stores the server address
   Webots_Cmd : Command; -- command to send over socket
   Webots_Socket_Set : Socket_Set_Type; -- set to monitor if data incoming

   procedure webots_main;

end webots_thread;
