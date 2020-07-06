package body mailbox is

   protected body Mailbox is
      procedure Clear is -- throws out all the old items and updates Last
      begin
         if Last > 0 then
            for I in Items'Range loop
               exit when Last = 0 or I = Last;
               if isExpired(Items(I).TTL) = True then
                  Last := Last - 1;
                  Items(1..Last) := Items(2..Last+1);
               end if;
            end loop;
         end if;
      end Clear;
      entry Deposit(X: in types.Communication_Packet) when Last < Size is
      begin
         Items(Last + 1) := X;
         Last := Last + 1;
      end Deposit;
      entry Collect(X: out types.Communication_Packet) when Last > 0 is
      begin
         X := Items(1);
         Last := Last - 1;
         Items(1..Last) := Items(2..Last+1);
      end Collect;
      procedure View_Inbox(Remaining_Items: out types.uint8) is
      begin
         Remaining_Items:= Last;
      end View_Inbox;
   end Mailbox;
   
   procedure check_mailbox ( first : in out Mailbox; second : in out Mailbox; new_packet : out types.Communication_Packet; alternator: types.uint8 ) is
   begin
      if alternator = 1 then
         select
            first.Collect(new_packet);
         else
            delay(0.00005);
            check_mailbox(second,first,new_packet,alternator);
         end select;
      else
         select
            second.Collect(new_packet);
         else
            delay(0.00005);
            check_mailbox(second,first,new_packet,alternator);
         end select;
      end if;
   end check_mailbox;
   
   procedure update_alternator (alternator: in out types.uint8) is
   begin
      if alternator = 1 then
         alternator := 2;
      else
         alternator := 1;
      end if;
   end update_alternator;
   
   function isExpired(Time_In_Question: in Time) return Boolean is
   begin
      if (Ada.Real_Time.Clock - Time_In_Question) >= Ada.Real_Time.Milliseconds(6000) then
         return True;
      else 
         return False;
      end if;  
   end isExpired;

end mailbox;
