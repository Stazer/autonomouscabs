with Ada.Command_line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO;


package body Webots_Thread is

   procedure Main is

   begin

      for i in 1 .. Argument_Count loop
         Webots_Channel(i-1) := Tcp_Client.Connect (Webots_Client, Port_Type'Value(Argument(i)), Webots_Address);
      end loop;

      while true loop

         for i in 0 .. Argument_Count - 1 loop
            Tcp_Client.Read_Packet(Webots_Channel(i), Webots_Vector_Buffer, Webots_Mailbox(i));
         end loop;

      end loop;




   end Main;

end Webots_Thread;
