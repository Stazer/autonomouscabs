with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets; use GNAT.Sockets;
with tcp_client; use tcp_client;
with backend_communication; use backend_communication;
with webots_communication; use webots_communication;

procedure Main is

   -- Client1  : Socket_Type; -- stores the socket
   --Address1 : Sock_Addr_Type; -- stores the server address
   --Channel1 : Stream_Access; -- socket I/O interface
   task webots_thread;
   task backend_thread;

   task body webots_thread is
   begin
      webots_main;
   end webots_thread;

   task body backend_thread is
   begin
      backend_main;
   end backend_thread;




begin

   -- only use of main so far is to start the backend and webots threads

   null;

end Main;
