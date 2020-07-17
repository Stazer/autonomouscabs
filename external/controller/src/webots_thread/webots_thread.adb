with Ada.Command_line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO;


package body Webots_Thread is

   procedure Main is

   begin

   ada.Text_IO.Put(" COmmmand ");
   ada.Integer_Text_IO.put(Argument_Count);
   ada.Text_IO.Put(Argument(1));

      Webots_Channel := Tcp_Client.Connect (Webots_Client, Integer(Argument(1)), Webots_Address);

      while true loop
         Tcp_Client.Read_Packet (Webots_Channel, Webots_Vector_Buffer, Webots_Mailbox);
      end loop;


   end Main;

end Webots_Thread;
