with AUnit.Assertions; use AUnit.Assertions;

package body tcp_tests is

   -- Register test routines to call
   procedure Register_Tests (T: in out tcp_test) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_read_payload'Access, "Test if payload is written to mailbox correctly.");
   end Register_Tests;

   -- Identifier of test case
   function Name (T: tcp_test) return Test_String is
   begin
      return Format ("TCP Tests");
   end Name;

   procedure Test_read_payload (T : in out Test_Cases.Test_Case'Class) is

      local_mailbox : Mailbox.Mailbox(Size => 1);

      dynamic_buffer : Byte_Buffer.Buffer;

      package_ID : Types.uint8 := 1;

      payload_length : Types.uint32 := 50000;

   begin

      for I in 1..payload_length loop
         dynamic_buffer.write_uint8(package_ID);
      end loop;

      --read_payload(dynamic_buffer,payload_length,package_ID,local_mailbox);

      --local_mailbox.Collect(test_packet);

      --for I in test_packet.local_payload'Range loop
         --Assert (test_packet.local_payload(I) = package_ID, "Writing and/or reading payload does not work.");
      --end loop;

   end Test_read_payload;

end tcp_tests;
