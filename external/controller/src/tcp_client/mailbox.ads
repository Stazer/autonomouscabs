with types; use types;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;

package mailbox is

   type Mail_List is array (types.uint8 range <>) of types.Communication_Packet;
   
   protected type Mailbox (Size : types.uint8) is
      procedure Clear;
      entry Deposit(X: in types.Communication_Packet);
      entry Collect(X: out types.Communication_Packet);
      procedure View_Inbox(Remaining_Items: out types.uint8);
      procedure Empty;
   private
      Items: Mail_List(1..Size);
      Last : types.uint8 := 0;
   end Mailbox;

   procedure check_mailbox ( first : in out Mailbox; second : in out Mailbox; new_packet : out types.Communication_Packet; alternator: types.uint8 ) ;
   
   procedure update_alternator(alternator: in out types.uint8);
      
   function isExpired(Time_In_Question: in Time) return Boolean;
   
end mailbox;
