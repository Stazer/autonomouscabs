with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;

with Types; use Types;

package Mailbox is

   type Mail_List is array (Types.Uint8 range <>) of types.Communication_Packet;
   
   protected type Mailbox (Size : Types.Uint8) is
      procedure Clear;
      entry Deposit(X: in Types.Communication_Packet);
      entry Collect(X: out Types.Communication_Packet);
      procedure View_Inbox(Remaining_Items: out Types.Uint8);
      procedure Empty;
   private
      Items: Mail_List(1..Size);
      Last : types.uint8 := 0;
   end Mailbox;

   procedure Check_Mailbox (first : in out Mailbox; second : in out Mailbox; new_packet : out Types.Communication_Packet; alternator: Types.Uint8);
   
   procedure Update_Alternator(alternator: in out Types.Uint8);
      
   function Is_Expired(Time_In_Question: in Time) return Boolean;
   
end Mailbox;
