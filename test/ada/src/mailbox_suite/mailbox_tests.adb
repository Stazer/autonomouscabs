package body mailbox_tests is
   
   -- test fixture for mailbox tests
   type Communication_Array is array(Types.Uint8 range <> ) of Types.Communication_Packet;
   
   local_mailbox : mailbox.Mailbox(Size => 5);
   
   test_packets : Communication_Array(1..5);

   dynamic_buffer : byte_buffer.Buffer;
   
   current_packet : types.Communication_Packet;
   
   procedure Set_Up (T: in out mailbox_test) is
   begin
      
      -- set up all 5 test Comm_Packet with asc package_IDs
      for I in test_packets'Range loop
         test_packets(I).Package_ID := types.uint8(I);
         test_packets(I).Payload_Length := 2;
         test_packets(I).Local_Payload := new Payload(0..(test_packets(I).Payload_Length - 1));
         test_packets(I).TTL := Ada.Real_Time.Clock;
         
         -- set up payload values
         for J in 0..(test_packets(I).Payload_Length - 1) loop
            test_packets(I).Local_Payload(J) := 1;
         end loop;
      end loop;
      
      
   end Set_Up;
   
   procedure Tear_Down (T : in out mailbox_test) is 
   begin
      
      local_mailbox.Empty;
      
   end;
   
   -- Register test routines to call
   procedure Register_Tests (T: in out mailbox_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Collect_and_Deposit'Access, "Mailbox.Collect and Mailbox.Deposit.");
      Register_Routine (T, Test_View_Inbox'Access, "Mailbox.View_Inbox and if Mailbox.Last.");
      Register_Routine (T, Test_Clear_not_isExpired'Access, "Mailbox.Clear(not_isExpired): Test unexpired items in mailbox.");
      Register_Routine (T, Test_Clear_isExpired'Access, "Mailbox.Clear(isExpired): Test expired items in mailbox.");
      Register_Routine (T, Test_Empty'Access, "Mailbox.Empty: Delete all items from Mailbox.");
      Register_Routine (T, Test_Is_Expired'Access, "Is_Expired.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: mailbox_test) return Test_String is
   begin
      return Format ("Mailbox Tests");
   end Name;

   -- test both collect and deposit
   procedure Test_Collect_and_Deposit (T : in out Test_Cases.Test_Case'Class) is
      
      last_package_ID : Types.Uint8 := 0;

   begin
      
      -- deposit
      for I in test_packets'Range loop
         local_mailbox.Deposit(test_packets(I));
      end loop;

      -- collect and check that package_ID is asc --> correct order
      for I in test_packets'Range loop
         local_mailbox.Collect(current_packet);
         Assert (current_packet.package_ID > last_package_ID, "Mailbox.Deposit and/or Mailbox.Collect are/is not working as intended.");
         last_package_ID := current_packet.package_ID;
      end loop;
      
   end Test_Collect_and_Deposit;
   
   -- test if View_Inbox works, and if Last is set correctly
   procedure Test_View_Inbox (T : in out Test_Cases.Test_Case'Class) is
      
      mailbox_last : types.uint8;
      
   begin

      for I in test_packets'Range loop
         local_mailbox.Deposit(test_packets(I));
      end loop;
      
      local_mailbox.View_Inbox(mailbox_last);

      Assert (mailbox_last = local_mailbox.Size, "Mailbox.Last is not set correctly upon depositing.");

   end Test_View_Inbox;
   
   -- test unexpired items in mailbox
   procedure Test_Clear_not_isExpired (T : in out Test_Cases.Test_Case'Class) is 
   begin

      local_mailbox.Deposit(test_packets(1));
      local_mailbox.Deposit(test_packets(2));

      local_mailbox.Clear;

      select
         local_mailbox.Collect(current_packet);
      else
         null;
      end select;

      Assert (current_packet.package_ID = 1, "Mailbox.Clear (not_isExpired) is not working as intended.");
      
   end Test_Clear_not_isExpired;
   
   -- test expired items in mailbox
   procedure Test_Clear_isExpired (T : in out Test_Cases.Test_Case'Class) is 
   begin
      
      current_packet.package_ID := 0;
      
      test_packets(1).TTL := Ada.Real_Time.Clock - Ada.Real_Time.Milliseconds(10000);
      
      local_mailbox.Deposit(test_packets(1));
      
      local_mailbox.Clear;
      
      select
         local_mailbox.Collect(current_packet);
      else
         null;
      end select;
      
      Assert (current_packet.package_ID = 0, "Mailbox.Clear (isExpired) is not working as intended.");    
      
   end Test_Clear_isExpired;
   
   -- test delete all items in mailbox
   procedure Test_Empty (T : in out Test_Cases.Test_Case'Class) is 
   begin
      
      local_mailbox.Deposit(test_packets(1));
      local_mailbox.Deposit(test_packets(2));
      local_mailbox.Deposit(test_packets(3));
      
      local_mailbox.Empty;
      
      select
         local_mailbox.Collect(current_packet);
      else
         current_packet.package_ID := 0;
      end select;
      
      Assert (current_packet.package_ID = 0, "Mailbox.Empty is not working as intended.");    
      
   end Test_Empty;
   
   -- test ttl expired
   procedure Test_Is_Expired (T : in out Test_Cases.Test_Case'Class) is
      
      expiration_result : Boolean;
      
      test_time : Ada.Real_Time.Time;
      
   begin
      
      test_time := Ada.Real_Time.Clock - Ada.Real_Time.Milliseconds(10000);
      
      expiration_result := mailbox.Is_Expired(test_time);
      
      Assert (expiration_result = True, "Is_Expired is not working as intended.");    
      
   end Test_Is_Expired;
   
end mailbox_tests;
