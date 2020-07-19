with Ada.Real_Time; use Ada.Real_Time;
--with Ada.Text_IO;

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

   procedure Check_Mailbox (First : in out Mailbox; Second : in out Mailbox; Message : out Messages.Message_Ptr; Alternator: in out Types.Uint8);
   
   procedure Update_Alternator (Alternator: in out Types.Uint8);
      
   function Is_Expired (Time_In_Question: in Time) return Boolean;
   
   function Create_Mail (Message : Messages.Message_Ptr) return Mail;
   
end Mailbox;
