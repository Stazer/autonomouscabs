pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__test_main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__test_main.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is

   E017 : Short_Integer; pragma Import (Ada, E017, "system__soft_links_E");
   E027 : Short_Integer; pragma Import (Ada, E027, "system__exception_table_E");
   E029 : Short_Integer; pragma Import (Ada, E029, "system__exceptions_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__soft_links__initialize_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "ada__containers_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "ada__io_exceptions_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "gnat_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "interfaces__c_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "interfaces__c__strings_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "system__os_lib_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "ada__tags_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "ada__streams_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "system__file_control_block_E");
   E123 : Short_Integer; pragma Import (Ada, E123, "system__finalization_root_E");
   E118 : Short_Integer; pragma Import (Ada, E118, "ada__finalization_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "system__file_io_E");
   E153 : Short_Integer; pragma Import (Ada, E153, "system__storage_pools_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "system__finalization_masters_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "system__storage_pools__subpools_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "ada__calendar_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "ada__calendar__delays_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "ada__real_time_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "ada__text_io_E");
   E155 : Short_Integer; pragma Import (Ada, E155, "system__pool_global_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "system__pool_size_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "gnat__sockets_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "gnat__sockets__thin_common_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "gnat__sockets__thin_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "system__tasking__initialization_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "system__tasking__protected_objects_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "system__tasking__protected_objects__entries_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "system__tasking__queuing_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "aunit_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "aunit__memory_E");
   E140 : Short_Integer; pragma Import (Ada, E140, "aunit__memory__utils_E");
   E137 : Short_Integer; pragma Import (Ada, E137, "ada_containers__aunit_lists_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "aunit__tests_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "aunit__time_measure_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "aunit__test_results_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "aunit__assertions_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "aunit__test_filters_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "aunit__simple_test_cases_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "aunit__reporter_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "aunit__reporter__text_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "aunit__test_cases_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "aunit__test_suites_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "aunit__run_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "types_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "byte_buffer_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "mailbox_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "tcp_client_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "buffer_tests_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "buffer_suite_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "mailbox_tests_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "mailbox_suite_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "pathfollowing_tests_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "pathfollowing_suite_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "tcp_tests_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "tcp_suite_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "types_tests_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "types_suite_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "composite_suite_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E257 := E257 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "types_tests__finalize_spec");
      begin
         F1;
      end;
      E253 := E253 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "tcp_tests__finalize_spec");
      begin
         F2;
      end;
      E249 := E249 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "pathfollowing_tests__finalize_spec");
      begin
         F3;
      end;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mailbox_tests__finalize_body");
      begin
         E245 := E245 - 1;
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mailbox_tests__finalize_spec");
      begin
         F5;
      end;
      E180 := E180 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "buffer_tests__finalize_spec");
      begin
         F6;
      end;
      E182 := E182 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "byte_buffer__finalize_spec");
      begin
         F7;
      end;
      E174 := E174 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "aunit__test_suites__finalize_spec");
      begin
         F8;
      end;
      E241 := E241 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "aunit__test_cases__finalize_spec");
      begin
         F9;
      end;
      E164 := E164 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "aunit__reporter__text__finalize_spec");
      begin
         F10;
      end;
      E131 := E131 - 1;
      E133 := E133 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "aunit__simple_test_cases__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "aunit__test_filters__finalize_spec");
      begin
         F12;
      end;
      E135 := E135 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "aunit__assertions__finalize_spec");
      begin
         F13;
      end;
      E142 := E142 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "aunit__test_results__finalize_spec");
      begin
         F14;
      end;
      declare
         procedure F15;
         pragma Import (Ada, F15, "aunit__tests__finalize_spec");
      begin
         E147 := E147 - 1;
         F15;
      end;
      E115 := E115 - 1;
      declare
         procedure F16;
         pragma Import (Ada, F16, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F16;
      end;
      declare
         procedure F17;
         pragma Import (Ada, F17, "gnat__sockets__finalize_body");
      begin
         E207 := E207 - 1;
         F17;
      end;
      declare
         procedure F18;
         pragma Import (Ada, F18, "gnat__sockets__finalize_spec");
      begin
         F18;
      end;
      E225 := E225 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "system__pool_size__finalize_spec");
      begin
         F19;
      end;
      E155 := E155 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "system__pool_global__finalize_spec");
      begin
         F20;
      end;
      E186 := E186 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "ada__text_io__finalize_spec");
      begin
         F21;
      end;
      E237 := E237 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "system__storage_pools__subpools__finalize_spec");
      begin
         F22;
      end;
      E149 := E149 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "system__finalization_masters__finalize_spec");
      begin
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "system__file_io__finalize_body");
      begin
         E190 := E190 - 1;
         F24;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Exception_Tracebacks : Integer;
      pragma Import (C, Exception_Tracebacks, "__gl_exception_tracebacks");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, True, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (True, False, False, False, True, True, True, False, 
           True, False, False, True, True, True, True, False, 
           False, False, False, False, True, True, False, True, 
           True, False, True, True, True, True, False, False, 
           False, False, False, True, False, True, True, False, 
           True, False, True, True, False, True, False, True, 
           True, False, False, True, False, True, False, False, 
           False, False, False, False, False, True, True, True, 
           False, False, True, False, True, True, True, False, 
           True, True, False, True, True, True, True, False, 
           False, True, False, False, False, True, False, False, 
           False, False, True, False),
         Count => (0, 0, 0, 2, 0, 0, 0, 0, 4, 0),
         Unknown => (False, False, False, False, False, False, False, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Exception_Tracebacks := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E027 := E027 + 1;
      System.Exceptions'Elab_Spec;
      E029 := E029 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E019 := E019 + 1;
      E017 := E017 + 1;
      Ada.Containers'Elab_Spec;
      E208 := E208 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E121 := E121 + 1;
      Gnat'Elab_Spec;
      E158 := E158 + 1;
      Interfaces.C'Elab_Spec;
      E057 := E057 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E221 := E221 + 1;
      System.Os_Lib'Elab_Body;
      E192 := E192 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E091 := E091 + 1;
      Ada.Streams'Elab_Spec;
      E120 := E120 + 1;
      System.File_Control_Block'Elab_Spec;
      E195 := E195 + 1;
      System.Finalization_Root'Elab_Spec;
      E123 := E123 + 1;
      Ada.Finalization'Elab_Spec;
      E118 := E118 + 1;
      System.File_Io'Elab_Body;
      E190 := E190 + 1;
      System.Storage_Pools'Elab_Spec;
      E153 := E153 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E149 := E149 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E237 := E237 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E146 := E146 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E213 := E213 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E205 := E205 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E186 := E186 + 1;
      System.Pool_Global'Elab_Spec;
      E155 := E155 + 1;
      System.Pool_Size'Elab_Spec;
      E225 := E225 + 1;
      Gnat.Sockets'Elab_Spec;
      E219 := E219 + 1;
      E211 := E211 + 1;
      Gnat.Sockets'Elab_Body;
      E207 := E207 + 1;
      System.Tasking.Initialization'Elab_Body;
      E103 := E103 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E113 := E113 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E115 := E115 + 1;
      System.Tasking.Queuing'Elab_Body;
      E111 := E111 + 1;
      E127 := E127 + 1;
      E125 := E125 + 1;
      E140 := E140 + 1;
      E137 := E137 + 1;
      Aunit.Tests'Elab_Spec;
      E147 := E147 + 1;
      Aunit.Time_Measure'Elab_Spec;
      E144 := E144 + 1;
      Aunit.Test_Results'Elab_Spec;
      E142 := E142 + 1;
      Aunit.Assertions'Elab_Spec;
      Aunit.Assertions'Elab_Body;
      E135 := E135 + 1;
      Aunit.Test_Filters'Elab_Spec;
      Aunit.Simple_Test_Cases'Elab_Spec;
      E133 := E133 + 1;
      E131 := E131 + 1;
      Aunit.Reporter'Elab_Spec;
      E128 := E128 + 1;
      Aunit.Reporter.Text'Elab_Spec;
      E164 := E164 + 1;
      Aunit.Test_Cases'Elab_Spec;
      E241 := E241 + 1;
      Aunit.Test_Suites'Elab_Spec;
      E174 := E174 + 1;
      E172 := E172 + 1;
      byte_buffer'elab_spec;
      byte_buffer'elab_body;
      E182 := E182 + 1;
      E231 := E231 + 1;
      E197 := E197 + 1;
      E184 := E184 + 1;
      buffer_tests'elab_spec;
      buffer_tests'elab_body;
      E180 := E180 + 1;
      buffer_suite'elab_body;
      E178 := E178 + 1;
      mailbox_tests'elab_spec;
      mailbox_tests'elab_body;
      E245 := E245 + 1;
      mailbox_suite'elab_body;
      E243 := E243 + 1;
      pathfollowing_tests'elab_spec;
      pathfollowing_tests'elab_body;
      E249 := E249 + 1;
      pathfollowing_suite'elab_body;
      E247 := E247 + 1;
      tcp_tests'elab_spec;
      tcp_tests'elab_body;
      E253 := E253 + 1;
      tcp_suite'elab_body;
      E251 := E251 + 1;
      types_tests'elab_spec;
      types_tests'elab_body;
      E257 := E257 + 1;
      types_suite'elab_body;
      E255 := E255 + 1;
      E176 := E176 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_test_main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/byte_buffer.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/mailbox.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/tcp_client.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/types.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/buffer_tests.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/buffer_suite.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/mailbox_tests.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/mailbox_suite.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/pathfollowing_tests.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/pathfollowing_suite.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/tcp_tests.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/tcp_suite.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/types_tests.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/types_suite.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/composite_suite.o
   --   /Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/test_main.o
   --   -L/Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/
   --   -L/Users/luyandamlangeni/Documents/RoboticsProject/autonomouscabs/test/ada/obj/
   --   -L/users/luyandamlangeni/opt/gnat/gnat_ada/lib/aunit/
   --   -L/users/luyandamlangeni/opt/gnat/gnat_ada/lib/gcc/x86_64-apple-darwin17.7.0/8.3.1/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
--  END Object file/option list   

end ada_main;
