package body mailbox_tests is
   
   -- test fixture for mailbox tests
   type Mail_Array is array(Types.Uint8 range <> ) of Mailbox.Mail;
   
   Local_Mailbox : Mailbox.Mailbox (Size => 5);
   
   Test_Mail : Mail_Array (1 .. 4);
   
   procedure Set_Up (T: in out mailbox_test) is
   begin
      
      -- set up all 5 test Comm_Packet with asc package_IDs
      Test_Mail (1).Message := new Messages.Light_Sensor_Message;
      Test_Mail (1).Message.Id := Messages.EXTERNAL_LIGHT_SENSOR;
      Messages.LS_Message_Ptr (Test_Mail (1).Message).Payload (0) := 5.0;
      Test_Mail (1).TTL := Ada.Real_Time.Clock;
      
      Test_Mail (2).Message := new Messages.Distance_Sensor_Message;
      Test_Mail (2).Message.Id := Messages.EXTERNAL_DISTANCE_SENSOR;
      for I in Messages.DS_Message_Ptr (Test_Mail (2).Message).Payload'Range loop
         Messages.DS_Message_Ptr (Test_Mail (2).Message).Payload (I) := Types.Float64 (I);
      end loop;
      Test_Mail (2).TTL := Ada.Real_Time.Clock;
      
      Test_Mail (3).Message := new Messages.Image_Data_Message;
      Test_Mail (3).Message.Id := Messages.EXTERNAL_IMAGE_DATA;
      Test_Mail (3).TTL := Ada.Real_Time.Clock;
      
      Test_Mail (4).Message := new Messages.Join_Success_Message;
      Test_Mail (4).Message.Id := Messages.EXTERNAL_JOIN_SUCCESS;
      Messages.JS_Message_Ptr (Test_Mail (4).Message).Cab_Id := 340;
      Test_Mail (4).TTL := Ada.Real_Time.Clock;
   end Set_Up;
   
   procedure Tear_Down (T : in out mailbox_test) is 
   begin
      
      Local_Mailbox.Empty;
      
   end;
   
   -- Register test routines to call
   procedure Register_Tests (T: in out mailbox_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Collect_and_Deposit'Access, "Mailbox.Collect and Mailbox.Deposit.");
      Register_Routine (T, Test_View_Inbox'Access, "Mailbox.View_Inbox and if Mailbox.Last.");
      Register_Routine (T, Test_Clear_Is_Not_Expired'Access, "Mailbox.Clear(not expired): Test unexpired items in mailbox.");
      Register_Routine (T, Test_Clear_Is_Expired'Access, "Mailbox.Clear(is expired): Test expired items in mailbox.");
      Register_Routine (T, Test_Empty'Access, "Mailbox.Empty: Delete all items from Mailbox.");
      Register_Routine (T, Test_Is_Expired'Access, "Is expired.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: mailbox_test) return Test_String is
   begin
      return Format ("Mailbox Tests");
   end Name;

   -- test both collect and deposit
   procedure Test_Collect_and_Deposit (T : in out Test_Cases.Test_Case'Class) is
      M : Mailbox.Mail;
   begin
      
      -- deposit
      for I in Test_Mail'Range loop
         Local_Mailbox.Deposit(Test_Mail(I));
      end loop;

      -- collect and check that package_ID is asc --> correct order
      for I in Test_Mail'Range loop
         Local_Mailbox.Collect(M);
         Assert (M.Message.Id = Test_Mail (I).Message.Id, "Mailbox.Deposit and/or Mailbox.Collect are/is not working as intended.");
      end loop;
      
   end Test_Collect_and_Deposit;
   
   -- test if View_Inbox works, and if Last is set correctly
   procedure Test_View_Inbox (T : in out Test_Cases.Test_Case'Class) is
      Last : types.uint8;
      Dummy: Mailbox.Mail := (Message => null, TTL => Ada.Real_Time.Clock);
   begin

      for I in Test_Mail'Range loop
         Local_Mailbox.Deposit(Test_Mail(I));
      end loop;
      Local_Mailbox.Deposit (Dummy);
      
      Local_Mailbox.View_Inbox(Last);

      Assert (Last = Local_Mailbox.Size, "Mailbox.Last is not set correctly upon depositing.");

   end Test_View_Inbox;
   
   -- test unexpired items in mailbox
   procedure Test_Clear_Is_Not_Expired (T : in out Test_Cases.Test_Case'Class) is 
      M : Mailbox.Mail;
   begin

      Local_Mailbox.Deposit(Test_Mail(1));
      Local_Mailbox.Deposit(Test_Mail(2));

      Local_Mailbox.Clear;

      select
         Local_Mailbox.Collect(M);
      else
         null;
      end select;

      Assert (M.Message.Id = Test_Mail(1).Message.Id, "Mailbox.Clear (is not expired) is not working as intended.");
      
   end Test_Clear_Is_Not_Expired;
   
   -- test expired items in mailbox
   procedure Test_Clear_Is_Expired (T : in out Test_Cases.Test_Case'Class) is 
      M : Mailbox.Mail;
   begin
      
      M.Message := null;
      Test_Mail (1).TTL := Ada.Real_Time.Clock - Ada.Real_Time.Milliseconds(10000);
      Local_Mailbox.Deposit(Test_Mail(1));
      
      Local_Mailbox.Clear;
      
      select
         Local_Mailbox.Collect(M);
      else
         null;
      end select;
      
      Assert (M.Message = null, "Mailbox.Clear (is expired) is not working as intended.");    
      
   end Test_Clear_Is_Expired;
   
   -- test delete all items in mailbox
   procedure Test_Empty (T : in out Test_Cases.Test_Case'Class) is 
      M :Mailbox.Mail;
   begin
      
      Local_Mailbox.Deposit(Test_Mail(1));
      Local_Mailbox.Deposit(Test_Mail(2));
      Local_Mailbox.Deposit(Test_Mail(3));
      
      Local_Mailbox.Empty;
      
      select
         Local_Mailbox.Collect(M);
      else
         M.Message := null;
      end select;
      
      Assert (M.Message = null, "Mailbox.Empty is not working as intended.");    
      
   end Test_Empty;
   
   -- test ttl expired
   procedure Test_Is_Expired (T : in out Test_Cases.Test_Case'Class) is
      Expiration_Result : Boolean;
      Test_Time : Ada.Real_Time.Time;
   begin
      
      Test_Time := Ada.Real_Time.Clock - Ada.Real_Time.Milliseconds(10000);
      
      Expiration_Result := Mailbox.Is_Expired(Test_Time);
      
      Assert (Expiration_Result = True, "Is_Expired is not working as intended.");    
      
   end Test_Is_Expired;
   
end mailbox_tests;
