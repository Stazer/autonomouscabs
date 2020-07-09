with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO; use Ada.Text_IO;

with Types; use Types;
with Messages;

package Mailbox is
   
   type Mail is record 
      Message : Messages.Message_Ptr;
      TTL : Ada.Real_Time.Time;
   end record;

   type Mail_List is array (Types.Uint8 range <>) of Mail;
   
   protected type Mailbox (Size : Types.Uint8) is
      procedure Clear;
      entry Deposit (X: in Mail);
      entry Collect (X: out Mail);
      procedure View_Inbox (Remaining_Items: out Types.Uint8);
      procedure Empty;
   private
      Items: Mail_List (1..Size);
      Last : Types.Uint8 := 0;
   end Mailbox;

   procedure Check_Mailbox (first : in out Mailbox; second : in out Mailbox; new_packet : out Mail; alternator: Types.Uint8);
   
   procedure Update_Alternator (alternator: in out Types.Uint8);
      
   function Is_Expired (Time_In_Question: in Time) return Boolean;
   
end Mailbox;
