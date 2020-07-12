pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is

   E073 : Short_Integer; pragma Import (Ada, E073, "system__os_lib_E");
   E011 : Short_Integer; pragma Import (Ada, E011, "system__soft_links_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exception_table_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__io_exceptions_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "ada__strings_E");
   E038 : Short_Integer; pragma Import (Ada, E038, "ada__containers_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exceptions_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__strings__maps_E");
   E059 : Short_Integer; pragma Import (Ada, E059, "ada__strings__maps__constants_E");
   E043 : Short_Integer; pragma Import (Ada, E043, "interfaces__c_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__soft_links__initialize_E");
   E079 : Short_Integer; pragma Import (Ada, E079, "system__object_reader_E");
   E048 : Short_Integer; pragma Import (Ada, E048, "system__dwarf_lines_E");
   E037 : Short_Integer; pragma Import (Ada, E037, "system__traceback__symbolic_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "ada__tags_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "ada__streams_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "gnat_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "interfaces__c__strings_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "system__file_control_block_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "system__finalization_root_E");
   E141 : Short_Integer; pragma Import (Ada, E141, "ada__finalization_E");
   E140 : Short_Integer; pragma Import (Ada, E140, "system__file_io_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "system__storage_pools_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "system__finalization_masters_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "system__storage_pools__subpools_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "system__task_info_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "system__task_primitives__operations_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "ada__calendar_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "ada__calendar__delays_E");
   E097 : Short_Integer; pragma Import (Ada, E097, "ada__real_time_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "ada__text_io_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "system__pool_global_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "system__pool_size_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "gnat__sockets_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "gnat__sockets__thin_common_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "gnat__sockets__thin_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "system__tasking__initialization_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "system__tasking__protected_objects_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "system__tasking__protected_objects__entries_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "system__tasking__queuing_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "system__tasking__stages_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "types_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "messages_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "byte_buffer_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "mailbox_E");
   E228 : Short_Integer; pragma Import (Ada, E228, "path_following_E");
   E226 : Short_Integer; pragma Import (Ada, E226, "tcp_client_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "backend_thread_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "webots_thread_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E251 := E251 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "webots_thread__finalize_spec");
      begin
         F1;
      end;
      E146 := E146 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "backend_thread__finalize_spec");
      begin
         F2;
      end;
      E148 := E148 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "byte_buffer__finalize_spec");
      begin
         F3;
      end;
      E168 := E168 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "messages__finalize_spec");
      begin
         F4;
      end;
      E208 := E208 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "gnat__sockets__finalize_body");
      begin
         E175 := E175 - 1;
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "gnat__sockets__finalize_spec");
      begin
         F7;
      end;
      E194 := E194 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "system__pool_size__finalize_spec");
      begin
         F8;
      end;
      E150 := E150 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "system__pool_global__finalize_spec");
      begin
         F9;
      end;
      E136 := E136 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "ada__text_io__finalize_spec");
      begin
         F10;
      end;
      E156 := E156 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "system__storage_pools__subpools__finalize_spec");
      begin
         F11;
      end;
      E158 := E158 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "system__finalization_masters__finalize_spec");
      begin
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "system__file_io__finalize_body");
      begin
         E140 := E140 - 1;
         F13;
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
           False, False, False, True, True, True, True, False, 
           False, False, False, False, True, True, False, True, 
           True, False, True, True, True, True, False, False, 
           False, False, False, True, False, False, True, False, 
           True, False, True, True, False, True, False, True, 
           True, False, False, True, False, True, False, False, 
           False, True, False, True, False, True, True, True, 
           False, False, True, False, True, True, True, False, 
           True, True, False, True, True, True, True, False, 
           False, True, False, False, False, True, False, False, 
           True, False, True, False),
         Count => (0, 0, 0, 2, 0, 0, 1, 0, 3, 0),
         Unknown => (False, False, False, False, False, False, True, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
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
      E023 := E023 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E068 := E068 + 1;
      Ada.Strings'Elab_Spec;
      E053 := E053 + 1;
      Ada.Containers'Elab_Spec;
      E038 := E038 + 1;
      System.Exceptions'Elab_Spec;
      E025 := E025 + 1;
      System.Os_Lib'Elab_Body;
      E073 := E073 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E059 := E059 + 1;
      Interfaces.C'Elab_Spec;
      System.Soft_Links.Initialize'Elab_Body;
      E019 := E019 + 1;
      E011 := E011 + 1;
      E055 := E055 + 1;
      E043 := E043 + 1;
      System.Object_Reader'Elab_Spec;
      System.Dwarf_Lines'Elab_Spec;
      E048 := E048 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E037 := E037 + 1;
      E079 := E079 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E130 := E130 + 1;
      Ada.Streams'Elab_Spec;
      E128 := E128 + 1;
      Gnat'Elab_Spec;
      E173 := E173 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E190 := E190 + 1;
      System.File_Control_Block'Elab_Spec;
      E144 := E144 + 1;
      System.Finalization_Root'Elab_Spec;
      E143 := E143 + 1;
      Ada.Finalization'Elab_Spec;
      E141 := E141 + 1;
      System.File_Io'Elab_Body;
      E140 := E140 + 1;
      System.Storage_Pools'Elab_Spec;
      E154 := E154 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E158 := E158 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E156 := E156 + 1;
      System.Task_Info'Elab_Spec;
      E114 := E114 + 1;
      System.Task_Primitives.Operations'Elab_Body;
      E106 := E106 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E182 := E182 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E180 := E180 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E097 := E097 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E136 := E136 + 1;
      System.Pool_Global'Elab_Spec;
      E150 := E150 + 1;
      System.Pool_Size'Elab_Spec;
      E194 := E194 + 1;
      Gnat.Sockets'Elab_Spec;
      E188 := E188 + 1;
      E178 := E178 + 1;
      Gnat.Sockets'Elab_Body;
      E175 := E175 + 1;
      System.Tasking.Initialization'Elab_Body;
      E212 := E212 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E202 := E202 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E208 := E208 + 1;
      System.Tasking.Queuing'Elab_Body;
      E220 := E220 + 1;
      System.Tasking.Stages'Elab_Body;
      E249 := E249 + 1;
      E172 := E172 + 1;
      Messages'Elab_Spec;
      Messages'Elab_Body;
      E168 := E168 + 1;
      Byte_Buffer'Elab_Spec;
      Byte_Buffer'Elab_Body;
      E148 := E148 + 1;
      E200 := E200 + 1;
      Path_Following'Elab_Body;
      E228 := E228 + 1;
      E226 := E226 + 1;
      Backend_Thread'Elab_Spec;
      E146 := E146 + 1;
      Webots_Thread'Elab_Spec;
      E251 := E251 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

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
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/gnat.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/types.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/messages.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/byte_buffer.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/mailbox.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/path_following.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/tcp_client.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/backend_thread.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/webots_thread.o
   --   /home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/main.o
   --   -L/home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/
   --   -L/home/kingmoon/Documents/Github/autonomouscabs/external/controller/obj/
   --   -L/usr/lib/gcc/x86_64-linux-gnu/9/adalib/
   --   -shared
   --   -lgnarl-9
   --   -lgnat-9
   --   -lpthread
   --   -lrt
   --   -ldl
--  END Object file/option list   

end ada_main;
