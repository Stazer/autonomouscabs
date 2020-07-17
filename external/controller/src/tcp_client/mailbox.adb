package body Mailbox is

   protected body Mailbox is
      procedure Clear is -- throws out all the old items and updates Last
      begin
         if Last > 0 then
            for I in Items'Range loop
               if Is_Expired(Items(I).TTL) = True then
                     Last := Last - 1;
                     Items(1..Last) := Items(2..Last+1);
               end if;
               exit when Last = 0 or I = Last;
            end loop;
         end if;   
      end Clear;
      
      entry Deposit(X: in Mail) when Last < Size is
      begin
         Items(Last + 1) := X;
         Last := Last + 1;
      end Deposit;
      
      entry Collect(X: out Mail) when Last > 0 is
      begin
         X := Items(1);
         Last := Last - 1;
         Items(1..Last) := Items(2..Last+1);
      end Collect;
      
      procedure View_Inbox(Remaining_Items: out Types.Uint8) is
      begin
         Remaining_Items:= Last;
      end View_Inbox;
      procedure Empty is
      begin
         Last := 0;
      end Empty;
   end Mailbox;
   
   procedure Check_Mailbox (First : in out Mailbox; Second : in out Mailbox; Message : out Messages.Message_Ptr; Alternator: Types.Uint8 ) is
      M : Mail;
   begin
      if alternator = 1 then
         select
            First.Collect(M);
            Message := M.Message;
         else
            delay(0.0000005);
            Check_Mailbox (Second, First, Message, Alternator);
         end select;
      else
         select
            Second.Collect(M);
            Message := M.Message;
         else
            delay(0.0000005);
            Check_Mailbox (Second, First, Message, Alternator);
         end select;
      end if;
   end Check_Mailbox;
   
   procedure Update_Alternator (Alternator: in out Types.Uint8) is
   begin
      if Alternator = 1 then
         Alternator := 2;
      else
         Alternator := 1;
      end if;
   end Update_Alternator;
   
   function Is_Expired(Time_In_Question: in Time) return Boolean is
   begin
      if (Ada.Real_Time.Clock - Time_In_Question) >= Ada.Real_Time.Milliseconds(6000) then
         return True;
      else
         return False;
      end if;  
   end Is_Expired;

end Mailbox;
