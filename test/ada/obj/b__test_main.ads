pragma Warnings (Off);
pragma Ada_95;
with System;
with System.Parameters;
with System.Secondary_Stack;
package ada_main is

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: Community 2019 (20190517-83)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_test_main" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#0d282f0b#;
   pragma Export (C, u00001, "test_mainB");
   u00002 : constant Version_32 := 16#050ff2f0#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#0f7d71d4#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#76789da1#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#510c5068#;
   pragma Export (C, u00005, "ada__task_identificationB");
   u00006 : constant Version_32 := 16#c716434e#;
   pragma Export (C, u00006, "ada__task_identificationS");
   u00007 : constant Version_32 := 16#085b6ffb#;
   pragma Export (C, u00007, "systemS");
   u00008 : constant Version_32 := 16#a0d3d22b#;
   pragma Export (C, u00008, "system__address_imageB");
   u00009 : constant Version_32 := 16#a9b7f2c1#;
   pragma Export (C, u00009, "system__address_imageS");
   u00010 : constant Version_32 := 16#bd45c2cc#;
   pragma Export (C, u00010, "system__secondary_stackB");
   u00011 : constant Version_32 := 16#4dcf97e2#;
   pragma Export (C, u00011, "system__secondary_stackS");
   u00012 : constant Version_32 := 16#d90c4a0d#;
   pragma Export (C, u00012, "ada__exceptionsB");
   u00013 : constant Version_32 := 16#16307b94#;
   pragma Export (C, u00013, "ada__exceptionsS");
   u00014 : constant Version_32 := 16#5726abed#;
   pragma Export (C, u00014, "ada__exceptions__last_chance_handlerB");
   u00015 : constant Version_32 := 16#41e5552e#;
   pragma Export (C, u00015, "ada__exceptions__last_chance_handlerS");
   u00016 : constant Version_32 := 16#ae860117#;
   pragma Export (C, u00016, "system__soft_linksB");
   u00017 : constant Version_32 := 16#4d58644d#;
   pragma Export (C, u00017, "system__soft_linksS");
   u00018 : constant Version_32 := 16#75bf515c#;
   pragma Export (C, u00018, "system__soft_links__initializeB");
   u00019 : constant Version_32 := 16#5697fc2b#;
   pragma Export (C, u00019, "system__soft_links__initializeS");
   u00020 : constant Version_32 := 16#86dbf443#;
   pragma Export (C, u00020, "system__parametersB");
   u00021 : constant Version_32 := 16#40b73bd0#;
   pragma Export (C, u00021, "system__parametersS");
   u00022 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00022, "system__stack_checkingB");
   u00023 : constant Version_32 := 16#86e40413#;
   pragma Export (C, u00023, "system__stack_checkingS");
   u00024 : constant Version_32 := 16#ced09590#;
   pragma Export (C, u00024, "system__storage_elementsB");
   u00025 : constant Version_32 := 16#259825ff#;
   pragma Export (C, u00025, "system__storage_elementsS");
   u00026 : constant Version_32 := 16#34742901#;
   pragma Export (C, u00026, "system__exception_tableB");
   u00027 : constant Version_32 := 16#55f506b9#;
   pragma Export (C, u00027, "system__exception_tableS");
   u00028 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00028, "system__exceptionsB");
   u00029 : constant Version_32 := 16#6038020d#;
   pragma Export (C, u00029, "system__exceptionsS");
   u00030 : constant Version_32 := 16#69416224#;
   pragma Export (C, u00030, "system__exceptions__machineB");
   u00031 : constant Version_32 := 16#d27d9682#;
   pragma Export (C, u00031, "system__exceptions__machineS");
   u00032 : constant Version_32 := 16#aa0563fc#;
   pragma Export (C, u00032, "system__exceptions_debugB");
   u00033 : constant Version_32 := 16#76d1963f#;
   pragma Export (C, u00033, "system__exceptions_debugS");
   u00034 : constant Version_32 := 16#6c2f8802#;
   pragma Export (C, u00034, "system__img_intB");
   u00035 : constant Version_32 := 16#0a808f39#;
   pragma Export (C, u00035, "system__img_intS");
   u00036 : constant Version_32 := 16#39df8c17#;
   pragma Export (C, u00036, "system__tracebackB");
   u00037 : constant Version_32 := 16#5679b13f#;
   pragma Export (C, u00037, "system__tracebackS");
   u00038 : constant Version_32 := 16#9ed49525#;
   pragma Export (C, u00038, "system__traceback_entriesB");
   u00039 : constant Version_32 := 16#0800998b#;
   pragma Export (C, u00039, "system__traceback_entriesS");
   u00040 : constant Version_32 := 16#bb296fbb#;
   pragma Export (C, u00040, "system__traceback__symbolicB");
   u00041 : constant Version_32 := 16#c84061d1#;
   pragma Export (C, u00041, "system__traceback__symbolicS");
   u00042 : constant Version_32 := 16#701f9d88#;
   pragma Export (C, u00042, "ada__exceptions__tracebackB");
   u00043 : constant Version_32 := 16#20245e75#;
   pragma Export (C, u00043, "ada__exceptions__tracebackS");
   u00044 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00044, "system__wch_conB");
   u00045 : constant Version_32 := 16#13264d29#;
   pragma Export (C, u00045, "system__wch_conS");
   u00046 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00046, "system__wch_stwB");
   u00047 : constant Version_32 := 16#3e376128#;
   pragma Export (C, u00047, "system__wch_stwS");
   u00048 : constant Version_32 := 16#a831679c#;
   pragma Export (C, u00048, "system__wch_cnvB");
   u00049 : constant Version_32 := 16#1c91f7da#;
   pragma Export (C, u00049, "system__wch_cnvS");
   u00050 : constant Version_32 := 16#5ab55268#;
   pragma Export (C, u00050, "interfacesS");
   u00051 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00051, "system__wch_jisB");
   u00052 : constant Version_32 := 16#9ce1eefb#;
   pragma Export (C, u00052, "system__wch_jisS");
   u00053 : constant Version_32 := 16#fde20231#;
   pragma Export (C, u00053, "system__task_primitivesS");
   u00054 : constant Version_32 := 16#352452d1#;
   pragma Export (C, u00054, "system__os_interfaceB");
   u00055 : constant Version_32 := 16#b9c37c0a#;
   pragma Export (C, u00055, "system__os_interfaceS");
   u00056 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00056, "interfaces__cB");
   u00057 : constant Version_32 := 16#467817d8#;
   pragma Export (C, u00057, "interfaces__cS");
   u00058 : constant Version_32 := 16#64ad9f76#;
   pragma Export (C, u00058, "interfaces__c__extensionsS");
   u00059 : constant Version_32 := 16#b870d14d#;
   pragma Export (C, u00059, "system__os_constantsS");
   u00060 : constant Version_32 := 16#7a0a06a1#;
   pragma Export (C, u00060, "system__task_primitives__operationsB");
   u00061 : constant Version_32 := 16#1951cab5#;
   pragma Export (C, u00061, "system__task_primitives__operationsS");
   u00062 : constant Version_32 := 16#89b55e64#;
   pragma Export (C, u00062, "system__interrupt_managementB");
   u00063 : constant Version_32 := 16#1a73cd21#;
   pragma Export (C, u00063, "system__interrupt_managementS");
   u00064 : constant Version_32 := 16#f65595cf#;
   pragma Export (C, u00064, "system__multiprocessorsB");
   u00065 : constant Version_32 := 16#30f7f088#;
   pragma Export (C, u00065, "system__multiprocessorsS");
   u00066 : constant Version_32 := 16#2b2125d3#;
   pragma Export (C, u00066, "system__os_primitivesB");
   u00067 : constant Version_32 := 16#0fa60a0d#;
   pragma Export (C, u00067, "system__os_primitivesS");
   u00068 : constant Version_32 := 16#e0fce7f8#;
   pragma Export (C, u00068, "system__task_infoB");
   u00069 : constant Version_32 := 16#8841d2fa#;
   pragma Export (C, u00069, "system__task_infoS");
   u00070 : constant Version_32 := 16#2281c1c8#;
   pragma Export (C, u00070, "system__taskingB");
   u00071 : constant Version_32 := 16#34147ee0#;
   pragma Export (C, u00071, "system__taskingS");
   u00072 : constant Version_32 := 16#3cdd1378#;
   pragma Export (C, u00072, "system__unsigned_typesS");
   u00073 : constant Version_32 := 16#6ec3c867#;
   pragma Export (C, u00073, "system__stack_usageB");
   u00074 : constant Version_32 := 16#3a3ac346#;
   pragma Export (C, u00074, "system__stack_usageS");
   u00075 : constant Version_32 := 16#4e0ce0a1#;
   pragma Export (C, u00075, "system__crtlS");
   u00076 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00076, "system__ioB");
   u00077 : constant Version_32 := 16#961998b4#;
   pragma Export (C, u00077, "system__ioS");
   u00078 : constant Version_32 := 16#1036f432#;
   pragma Export (C, u00078, "system__tasking__debugB");
   u00079 : constant Version_32 := 16#de1ac8b1#;
   pragma Export (C, u00079, "system__tasking__debugS");
   u00080 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00080, "system__concat_2B");
   u00081 : constant Version_32 := 16#0afbb82b#;
   pragma Export (C, u00081, "system__concat_2S");
   u00082 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00082, "system__concat_3B");
   u00083 : constant Version_32 := 16#032b335e#;
   pragma Export (C, u00083, "system__concat_3S");
   u00084 : constant Version_32 := 16#273384e4#;
   pragma Export (C, u00084, "system__img_enum_newB");
   u00085 : constant Version_32 := 16#6917693b#;
   pragma Export (C, u00085, "system__img_enum_newS");
   u00086 : constant Version_32 := 16#9dca6636#;
   pragma Export (C, u00086, "system__img_lliB");
   u00087 : constant Version_32 := 16#19143a2a#;
   pragma Export (C, u00087, "system__img_lliS");
   u00088 : constant Version_32 := 16#0b29e756#;
   pragma Export (C, u00088, "system__tasking__utilitiesB");
   u00089 : constant Version_32 := 16#0f670827#;
   pragma Export (C, u00089, "system__tasking__utilitiesS");
   u00090 : constant Version_32 := 16#d398a95f#;
   pragma Export (C, u00090, "ada__tagsB");
   u00091 : constant Version_32 := 16#12a0afb8#;
   pragma Export (C, u00091, "ada__tagsS");
   u00092 : constant Version_32 := 16#796f31f1#;
   pragma Export (C, u00092, "system__htableB");
   u00093 : constant Version_32 := 16#8c99dc11#;
   pragma Export (C, u00093, "system__htableS");
   u00094 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00094, "system__string_hashB");
   u00095 : constant Version_32 := 16#2ec7b76f#;
   pragma Export (C, u00095, "system__string_hashS");
   u00096 : constant Version_32 := 16#b8e72903#;
   pragma Export (C, u00096, "system__val_lluB");
   u00097 : constant Version_32 := 16#51139e9a#;
   pragma Export (C, u00097, "system__val_lluS");
   u00098 : constant Version_32 := 16#269742a9#;
   pragma Export (C, u00098, "system__val_utilB");
   u00099 : constant Version_32 := 16#a4fbd905#;
   pragma Export (C, u00099, "system__val_utilS");
   u00100 : constant Version_32 := 16#ec4d5631#;
   pragma Export (C, u00100, "system__case_utilB");
   u00101 : constant Version_32 := 16#378ed9af#;
   pragma Export (C, u00101, "system__case_utilS");
   u00102 : constant Version_32 := 16#0a1cacd7#;
   pragma Export (C, u00102, "system__tasking__initializationB");
   u00103 : constant Version_32 := 16#fc2303e6#;
   pragma Export (C, u00103, "system__tasking__initializationS");
   u00104 : constant Version_32 := 16#3b415298#;
   pragma Export (C, u00104, "system__soft_links__taskingB");
   u00105 : constant Version_32 := 16#e939497e#;
   pragma Export (C, u00105, "system__soft_links__taskingS");
   u00106 : constant Version_32 := 16#17d21067#;
   pragma Export (C, u00106, "ada__exceptions__is_null_occurrenceB");
   u00107 : constant Version_32 := 16#e1d7566f#;
   pragma Export (C, u00107, "ada__exceptions__is_null_occurrenceS");
   u00108 : constant Version_32 := 16#6213e14a#;
   pragma Export (C, u00108, "system__tasking__task_attributesB");
   u00109 : constant Version_32 := 16#e81a3c25#;
   pragma Export (C, u00109, "system__tasking__task_attributesS");
   u00110 : constant Version_32 := 16#2e4883f4#;
   pragma Export (C, u00110, "system__tasking__queuingB");
   u00111 : constant Version_32 := 16#6dba2805#;
   pragma Export (C, u00111, "system__tasking__queuingS");
   u00112 : constant Version_32 := 16#9fcf5d7f#;
   pragma Export (C, u00112, "system__tasking__protected_objectsB");
   u00113 : constant Version_32 := 16#15001baf#;
   pragma Export (C, u00113, "system__tasking__protected_objectsS");
   u00114 : constant Version_32 := 16#92cd7102#;
   pragma Export (C, u00114, "system__tasking__protected_objects__entriesB");
   u00115 : constant Version_32 := 16#7daf93e7#;
   pragma Export (C, u00115, "system__tasking__protected_objects__entriesS");
   u00116 : constant Version_32 := 16#100eaf58#;
   pragma Export (C, u00116, "system__restrictionsB");
   u00117 : constant Version_32 := 16#4329b6aa#;
   pragma Export (C, u00117, "system__restrictionsS");
   u00118 : constant Version_32 := 16#86c56e5a#;
   pragma Export (C, u00118, "ada__finalizationS");
   u00119 : constant Version_32 := 16#10558b11#;
   pragma Export (C, u00119, "ada__streamsB");
   u00120 : constant Version_32 := 16#67e31212#;
   pragma Export (C, u00120, "ada__streamsS");
   u00121 : constant Version_32 := 16#92d882c5#;
   pragma Export (C, u00121, "ada__io_exceptionsS");
   u00122 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00122, "system__finalization_rootB");
   u00123 : constant Version_32 := 16#47a91c6b#;
   pragma Export (C, u00123, "system__finalization_rootS");
   u00124 : constant Version_32 := 16#b94060f8#;
   pragma Export (C, u00124, "aunitB");
   u00125 : constant Version_32 := 16#76cdf7c6#;
   pragma Export (C, u00125, "aunitS");
   u00126 : constant Version_32 := 16#b6c145a2#;
   pragma Export (C, u00126, "aunit__memoryB");
   u00127 : constant Version_32 := 16#dea7c97b#;
   pragma Export (C, u00127, "aunit__memoryS");
   u00128 : constant Version_32 := 16#17d955ab#;
   pragma Export (C, u00128, "aunit__reporterS");
   u00129 : constant Version_32 := 16#e99cd447#;
   pragma Export (C, u00129, "aunit__optionsS");
   u00130 : constant Version_32 := 16#e9d6512d#;
   pragma Export (C, u00130, "aunit__test_filtersB");
   u00131 : constant Version_32 := 16#9a67cba8#;
   pragma Export (C, u00131, "aunit__test_filtersS");
   u00132 : constant Version_32 := 16#6e9501f4#;
   pragma Export (C, u00132, "aunit__simple_test_casesB");
   u00133 : constant Version_32 := 16#f9679d50#;
   pragma Export (C, u00133, "aunit__simple_test_casesS");
   u00134 : constant Version_32 := 16#8872fb1a#;
   pragma Export (C, u00134, "aunit__assertionsB");
   u00135 : constant Version_32 := 16#3b7b7e5b#;
   pragma Export (C, u00135, "aunit__assertionsS");
   u00136 : constant Version_32 := 16#1dca5d24#;
   pragma Export (C, u00136, "ada_containers__aunit_listsB");
   u00137 : constant Version_32 := 16#c8d9569a#;
   pragma Export (C, u00137, "ada_containers__aunit_listsS");
   u00138 : constant Version_32 := 16#11329e00#;
   pragma Export (C, u00138, "ada_containersS");
   u00139 : constant Version_32 := 16#9b1c7ff2#;
   pragma Export (C, u00139, "aunit__memory__utilsB");
   u00140 : constant Version_32 := 16#fb2f6c57#;
   pragma Export (C, u00140, "aunit__memory__utilsS");
   u00141 : constant Version_32 := 16#01adf261#;
   pragma Export (C, u00141, "aunit__test_resultsB");
   u00142 : constant Version_32 := 16#1087836e#;
   pragma Export (C, u00142, "aunit__test_resultsS");
   u00143 : constant Version_32 := 16#9df5edcf#;
   pragma Export (C, u00143, "aunit__time_measureB");
   u00144 : constant Version_32 := 16#99399b1d#;
   pragma Export (C, u00144, "aunit__time_measureS");
   u00145 : constant Version_32 := 16#fc54e290#;
   pragma Export (C, u00145, "ada__calendarB");
   u00146 : constant Version_32 := 16#31350a81#;
   pragma Export (C, u00146, "ada__calendarS");
   u00147 : constant Version_32 := 16#6b6cea8f#;
   pragma Export (C, u00147, "aunit__testsS");
   u00148 : constant Version_32 := 16#d96e3c40#;
   pragma Export (C, u00148, "system__finalization_mastersB");
   u00149 : constant Version_32 := 16#53a75631#;
   pragma Export (C, u00149, "system__finalization_mastersS");
   u00150 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00150, "system__img_boolB");
   u00151 : constant Version_32 := 16#fd821e10#;
   pragma Export (C, u00151, "system__img_boolS");
   u00152 : constant Version_32 := 16#6d4d969a#;
   pragma Export (C, u00152, "system__storage_poolsB");
   u00153 : constant Version_32 := 16#2bb6f156#;
   pragma Export (C, u00153, "system__storage_poolsS");
   u00154 : constant Version_32 := 16#5a895de2#;
   pragma Export (C, u00154, "system__pool_globalB");
   u00155 : constant Version_32 := 16#7141203e#;
   pragma Export (C, u00155, "system__pool_globalS");
   u00156 : constant Version_32 := 16#e31b7c4e#;
   pragma Export (C, u00156, "system__memoryB");
   u00157 : constant Version_32 := 16#512609cf#;
   pragma Export (C, u00157, "system__memoryS");
   u00158 : constant Version_32 := 16#b5988c27#;
   pragma Export (C, u00158, "gnatS");
   u00159 : constant Version_32 := 16#9c857b76#;
   pragma Export (C, u00159, "gnat__source_infoS");
   u00160 : constant Version_32 := 16#ea75efa1#;
   pragma Export (C, u00160, "gnat__tracebackB");
   u00161 : constant Version_32 := 16#b183b1eb#;
   pragma Export (C, u00161, "gnat__tracebackS");
   u00162 : constant Version_32 := 16#4b271bfa#;
   pragma Export (C, u00162, "gnat__traceback__symbolicS");
   u00163 : constant Version_32 := 16#9a578b55#;
   pragma Export (C, u00163, "aunit__reporter__textB");
   u00164 : constant Version_32 := 16#28ca7b1a#;
   pragma Export (C, u00164, "aunit__reporter__textS");
   u00165 : constant Version_32 := 16#b48102f5#;
   pragma Export (C, u00165, "gnat__ioB");
   u00166 : constant Version_32 := 16#2a95b695#;
   pragma Export (C, u00166, "gnat__ioS");
   u00167 : constant Version_32 := 16#b602a99c#;
   pragma Export (C, u00167, "system__exn_intB");
   u00168 : constant Version_32 := 16#4ad773a7#;
   pragma Export (C, u00168, "system__exn_intS");
   u00169 : constant Version_32 := 16#039168f8#;
   pragma Export (C, u00169, "system__stream_attributesB");
   u00170 : constant Version_32 := 16#8bc30a4e#;
   pragma Export (C, u00170, "system__stream_attributesS");
   u00171 : constant Version_32 := 16#e11af2d7#;
   pragma Export (C, u00171, "aunit__runB");
   u00172 : constant Version_32 := 16#4b2a8016#;
   pragma Export (C, u00172, "aunit__runS");
   u00173 : constant Version_32 := 16#276e73f2#;
   pragma Export (C, u00173, "aunit__test_suitesB");
   u00174 : constant Version_32 := 16#f3c7e671#;
   pragma Export (C, u00174, "aunit__test_suitesS");
   u00175 : constant Version_32 := 16#3e15f701#;
   pragma Export (C, u00175, "composite_suiteB");
   u00176 : constant Version_32 := 16#28c47b3f#;
   pragma Export (C, u00176, "composite_suiteS");
   u00177 : constant Version_32 := 16#1c722c17#;
   pragma Export (C, u00177, "buffer_suiteB");
   u00178 : constant Version_32 := 16#d90da88b#;
   pragma Export (C, u00178, "buffer_suiteS");
   u00179 : constant Version_32 := 16#cec9cd66#;
   pragma Export (C, u00179, "buffer_testsB");
   u00180 : constant Version_32 := 16#6b3ced34#;
   pragma Export (C, u00180, "buffer_testsS");
   u00181 : constant Version_32 := 16#ec10d536#;
   pragma Export (C, u00181, "byte_bufferB");
   u00182 : constant Version_32 := 16#d863b3a6#;
   pragma Export (C, u00182, "byte_bufferS");
   u00183 : constant Version_32 := 16#3842a026#;
   pragma Export (C, u00183, "typesB");
   u00184 : constant Version_32 := 16#f05fd2f3#;
   pragma Export (C, u00184, "typesS");
   u00185 : constant Version_32 := 16#f4e097a7#;
   pragma Export (C, u00185, "ada__text_ioB");
   u00186 : constant Version_32 := 16#3913d0d6#;
   pragma Export (C, u00186, "ada__text_ioS");
   u00187 : constant Version_32 := 16#73d2d764#;
   pragma Export (C, u00187, "interfaces__c_streamsB");
   u00188 : constant Version_32 := 16#b1330297#;
   pragma Export (C, u00188, "interfaces__c_streamsS");
   u00189 : constant Version_32 := 16#ec083f01#;
   pragma Export (C, u00189, "system__file_ioB");
   u00190 : constant Version_32 := 16#af2a8e9e#;
   pragma Export (C, u00190, "system__file_ioS");
   u00191 : constant Version_32 := 16#e4774a28#;
   pragma Export (C, u00191, "system__os_libB");
   u00192 : constant Version_32 := 16#d8e681fb#;
   pragma Export (C, u00192, "system__os_libS");
   u00193 : constant Version_32 := 16#2a8e89ad#;
   pragma Export (C, u00193, "system__stringsB");
   u00194 : constant Version_32 := 16#684d436e#;
   pragma Export (C, u00194, "system__stringsS");
   u00195 : constant Version_32 := 16#f5c4f553#;
   pragma Export (C, u00195, "system__file_control_blockS");
   u00196 : constant Version_32 := 16#e772e15d#;
   pragma Export (C, u00196, "tcp_clientB");
   u00197 : constant Version_32 := 16#c5619aa7#;
   pragma Export (C, u00197, "tcp_clientS");
   u00198 : constant Version_32 := 16#6368532a#;
   pragma Export (C, u00198, "system__tasking__protected_objects__operationsB");
   u00199 : constant Version_32 := 16#ba36ad85#;
   pragma Export (C, u00199, "system__tasking__protected_objects__operationsS");
   u00200 : constant Version_32 := 16#891dbac0#;
   pragma Export (C, u00200, "system__tasking__entry_callsB");
   u00201 : constant Version_32 := 16#6342024e#;
   pragma Export (C, u00201, "system__tasking__entry_callsS");
   u00202 : constant Version_32 := 16#7382e823#;
   pragma Export (C, u00202, "system__tasking__rendezvousB");
   u00203 : constant Version_32 := 16#5618a4d0#;
   pragma Export (C, u00203, "system__tasking__rendezvousS");
   u00204 : constant Version_32 := 16#09924dd9#;
   pragma Export (C, u00204, "ada__real_timeB");
   u00205 : constant Version_32 := 16#69ea8064#;
   pragma Export (C, u00205, "ada__real_timeS");
   u00206 : constant Version_32 := 16#942614a0#;
   pragma Export (C, u00206, "gnat__socketsB");
   u00207 : constant Version_32 := 16#9f5e3240#;
   pragma Export (C, u00207, "gnat__socketsS");
   u00208 : constant Version_32 := 16#179d7d28#;
   pragma Export (C, u00208, "ada__containersS");
   u00209 : constant Version_32 := 16#1de6b9ca#;
   pragma Export (C, u00209, "gnat__sockets__linker_optionsS");
   u00210 : constant Version_32 := 16#b0810072#;
   pragma Export (C, u00210, "gnat__sockets__thinB");
   u00211 : constant Version_32 := 16#d8662f96#;
   pragma Export (C, u00211, "gnat__sockets__thinS");
   u00212 : constant Version_32 := 16#357666d8#;
   pragma Export (C, u00212, "ada__calendar__delaysB");
   u00213 : constant Version_32 := 16#d86d2f1d#;
   pragma Export (C, u00213, "ada__calendar__delaysS");
   u00214 : constant Version_32 := 16#ef2c0748#;
   pragma Export (C, u00214, "gnat__os_libS");
   u00215 : constant Version_32 := 16#485b8267#;
   pragma Export (C, u00215, "gnat__task_lockS");
   u00216 : constant Version_32 := 16#05c60a38#;
   pragma Export (C, u00216, "system__task_lockB");
   u00217 : constant Version_32 := 16#69d15895#;
   pragma Export (C, u00217, "system__task_lockS");
   u00218 : constant Version_32 := 16#c21c4ce8#;
   pragma Export (C, u00218, "gnat__sockets__thin_commonB");
   u00219 : constant Version_32 := 16#ae33425a#;
   pragma Export (C, u00219, "gnat__sockets__thin_commonS");
   u00220 : constant Version_32 := 16#27986d94#;
   pragma Export (C, u00220, "interfaces__c__stringsB");
   u00221 : constant Version_32 := 16#603c1c44#;
   pragma Export (C, u00221, "interfaces__c__stringsS");
   u00222 : constant Version_32 := 16#5de653db#;
   pragma Export (C, u00222, "system__communicationB");
   u00223 : constant Version_32 := 16#113b3a29#;
   pragma Export (C, u00223, "system__communicationS");
   u00224 : constant Version_32 := 16#637ab3c9#;
   pragma Export (C, u00224, "system__pool_sizeB");
   u00225 : constant Version_32 := 16#097527a2#;
   pragma Export (C, u00225, "system__pool_sizeS");
   u00226 : constant Version_32 := 16#0f9783a4#;
   pragma Export (C, u00226, "system__val_intB");
   u00227 : constant Version_32 := 16#bda40698#;
   pragma Export (C, u00227, "system__val_intS");
   u00228 : constant Version_32 := 16#383fd226#;
   pragma Export (C, u00228, "system__val_unsB");
   u00229 : constant Version_32 := 16#09db6ec1#;
   pragma Export (C, u00229, "system__val_unsS");
   u00230 : constant Version_32 := 16#b8eede7c#;
   pragma Export (C, u00230, "mailboxB");
   u00231 : constant Version_32 := 16#03cef3bc#;
   pragma Export (C, u00231, "mailboxS");
   u00232 : constant Version_32 := 16#bcec81df#;
   pragma Export (C, u00232, "ada__containers__helpersB");
   u00233 : constant Version_32 := 16#4adfc5eb#;
   pragma Export (C, u00233, "ada__containers__helpersS");
   u00234 : constant Version_32 := 16#020a3f4d#;
   pragma Export (C, u00234, "system__atomic_countersB");
   u00235 : constant Version_32 := 16#bc074276#;
   pragma Export (C, u00235, "system__atomic_countersS");
   u00236 : constant Version_32 := 16#2e260032#;
   pragma Export (C, u00236, "system__storage_pools__subpoolsB");
   u00237 : constant Version_32 := 16#cc5a1856#;
   pragma Export (C, u00237, "system__storage_pools__subpoolsS");
   u00238 : constant Version_32 := 16#84042202#;
   pragma Export (C, u00238, "system__storage_pools__subpools__finalizationB");
   u00239 : constant Version_32 := 16#fe2f4b3a#;
   pragma Export (C, u00239, "system__storage_pools__subpools__finalizationS");
   u00240 : constant Version_32 := 16#3d2551c0#;
   pragma Export (C, u00240, "aunit__test_casesB");
   u00241 : constant Version_32 := 16#b9f05298#;
   pragma Export (C, u00241, "aunit__test_casesS");
   u00242 : constant Version_32 := 16#45b6954c#;
   pragma Export (C, u00242, "mailbox_suiteB");
   u00243 : constant Version_32 := 16#65089e03#;
   pragma Export (C, u00243, "mailbox_suiteS");
   u00244 : constant Version_32 := 16#33e6d58e#;
   pragma Export (C, u00244, "mailbox_testsB");
   u00245 : constant Version_32 := 16#54f215ed#;
   pragma Export (C, u00245, "mailbox_testsS");
   u00246 : constant Version_32 := 16#54e95db7#;
   pragma Export (C, u00246, "pathfollowing_suiteB");
   u00247 : constant Version_32 := 16#6509e0de#;
   pragma Export (C, u00247, "pathfollowing_suiteS");
   u00248 : constant Version_32 := 16#bb4c851d#;
   pragma Export (C, u00248, "pathfollowing_testsB");
   u00249 : constant Version_32 := 16#16da3ebe#;
   pragma Export (C, u00249, "pathfollowing_testsS");
   u00250 : constant Version_32 := 16#cb940a6d#;
   pragma Export (C, u00250, "tcp_suiteB");
   u00251 : constant Version_32 := 16#26df2448#;
   pragma Export (C, u00251, "tcp_suiteS");
   u00252 : constant Version_32 := 16#c0d03c30#;
   pragma Export (C, u00252, "tcp_testsB");
   u00253 : constant Version_32 := 16#a42125ca#;
   pragma Export (C, u00253, "tcp_testsS");
   u00254 : constant Version_32 := 16#bdc52d37#;
   pragma Export (C, u00254, "types_suiteB");
   u00255 : constant Version_32 := 16#164ee890#;
   pragma Export (C, u00255, "types_suiteS");
   u00256 : constant Version_32 := 16#493f7427#;
   pragma Export (C, u00256, "types_testsB");
   u00257 : constant Version_32 := 16#2bc9ef51#;
   pragma Export (C, u00257, "types_testsS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  interfaces%s
   --  system%s
   --  system.atomic_counters%s
   --  system.atomic_counters%b
   --  system.exn_int%s
   --  system.exn_int%b
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.io%s
   --  system.io%b
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.restrictions%s
   --  system.restrictions%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.stack_usage%s
   --  system.stack_usage%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%s
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.task_info%s
   --  system.task_info%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  system.unsigned_types%s
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%s
   --  system.wch_cnv%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.traceback%s
   --  system.traceback%b
   --  system.secondary_stack%s
   --  system.standard_library%s
   --  ada.exceptions%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.soft_links%s
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  ada.exceptions.traceback%s
   --  ada.exceptions.traceback%b
   --  system.address_image%s
   --  system.address_image%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.exceptions.machine%s
   --  system.exceptions.machine%b
   --  system.memory%s
   --  system.memory%b
   --  system.secondary_stack%b
   --  system.soft_links.initialize%s
   --  system.soft_links.initialize%b
   --  system.soft_links%b
   --  system.standard_library%b
   --  system.traceback.symbolic%s
   --  system.traceback.symbolic%b
   --  ada.exceptions%b
   --  ada.containers%s
   --  ada.exceptions.is_null_occurrence%s
   --  ada.exceptions.is_null_occurrence%b
   --  ada.io_exceptions%s
   --  gnat%s
   --  gnat.io%s
   --  gnat.io%b
   --  gnat.source_info%s
   --  interfaces.c%s
   --  interfaces.c%b
   --  interfaces.c.extensions%s
   --  interfaces.c.strings%s
   --  interfaces.c.strings%b
   --  system.case_util%s
   --  system.case_util%b
   --  system.multiprocessors%s
   --  system.multiprocessors%b
   --  system.os_constants%s
   --  system.os_interface%s
   --  system.os_interface%b
   --  system.interrupt_management%s
   --  system.interrupt_management%b
   --  system.os_lib%s
   --  system.os_lib%b
   --  gnat.os_lib%s
   --  system.task_lock%s
   --  system.task_lock%b
   --  gnat.task_lock%s
   --  system.task_primitives%s
   --  system.tasking%s
   --  system.task_primitives.operations%s
   --  system.tasking.debug%s
   --  system.tasking.debug%b
   --  system.task_primitives.operations%b
   --  system.tasking%b
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_llu%s
   --  system.val_llu%b
   --  ada.tags%s
   --  ada.tags%b
   --  ada.streams%s
   --  ada.streams%b
   --  system.communication%s
   --  system.communication%b
   --  system.file_control_block%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  ada.containers.helpers%s
   --  ada.containers.helpers%b
   --  system.file_io%s
   --  system.file_io%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.finalization_masters%b
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools.finalization%s
   --  system.storage_pools.subpools.finalization%b
   --  system.storage_pools.subpools%b
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.val_uns%s
   --  system.val_uns%b
   --  system.val_int%s
   --  system.val_int%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.delays%s
   --  ada.calendar.delays%b
   --  ada.real_time%s
   --  ada.real_time%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  gnat.traceback%s
   --  gnat.traceback%b
   --  gnat.traceback.symbolic%s
   --  system.pool_global%s
   --  system.pool_global%b
   --  system.pool_size%s
   --  system.pool_size%b
   --  gnat.sockets%s
   --  gnat.sockets.linker_options%s
   --  gnat.sockets.thin_common%s
   --  gnat.sockets.thin_common%b
   --  gnat.sockets.thin%s
   --  gnat.sockets.thin%b
   --  gnat.sockets%b
   --  system.soft_links.tasking%s
   --  system.soft_links.tasking%b
   --  system.tasking.initialization%s
   --  system.tasking.task_attributes%s
   --  system.tasking.task_attributes%b
   --  system.tasking.initialization%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  system.tasking.protected_objects.entries%s
   --  system.tasking.protected_objects.entries%b
   --  system.tasking.queuing%s
   --  system.tasking.queuing%b
   --  system.tasking.utilities%s
   --  system.tasking.utilities%b
   --  ada.task_identification%s
   --  ada.task_identification%b
   --  system.tasking.entry_calls%s
   --  system.tasking.rendezvous%s
   --  system.tasking.protected_objects.operations%s
   --  system.tasking.protected_objects.operations%b
   --  system.tasking.entry_calls%b
   --  system.tasking.rendezvous%b
   --  ada_containers%s
   --  aunit%s
   --  aunit.memory%s
   --  aunit.memory%b
   --  aunit%b
   --  aunit.memory.utils%s
   --  aunit.memory.utils%b
   --  ada_containers.aunit_lists%s
   --  ada_containers.aunit_lists%b
   --  aunit.tests%s
   --  aunit.time_measure%s
   --  aunit.time_measure%b
   --  aunit.test_results%s
   --  aunit.test_results%b
   --  aunit.assertions%s
   --  aunit.assertions%b
   --  aunit.test_filters%s
   --  aunit.options%s
   --  aunit.simple_test_cases%s
   --  aunit.simple_test_cases%b
   --  aunit.test_filters%b
   --  aunit.reporter%s
   --  aunit.reporter.text%s
   --  aunit.reporter.text%b
   --  aunit.test_cases%s
   --  aunit.test_cases%b
   --  aunit.test_suites%s
   --  aunit.test_suites%b
   --  aunit.run%s
   --  aunit.run%b
   --  types%s
   --  byte_buffer%s
   --  byte_buffer%b
   --  mailbox%s
   --  mailbox%b
   --  tcp_client%s
   --  tcp_client%b
   --  types%b
   --  buffer_tests%s
   --  buffer_tests%b
   --  buffer_suite%s
   --  buffer_suite%b
   --  mailbox_tests%s
   --  mailbox_tests%b
   --  mailbox_suite%s
   --  mailbox_suite%b
   --  pathfollowing_tests%s
   --  pathfollowing_tests%b
   --  pathfollowing_suite%s
   --  pathfollowing_suite%b
   --  tcp_tests%s
   --  tcp_tests%b
   --  tcp_suite%s
   --  tcp_suite%b
   --  types_tests%s
   --  types_tests%b
   --  types_suite%s
   --  types_suite%b
   --  composite_suite%s
   --  composite_suite%b
   --  test_main%b
   --  END ELABORATION ORDER

end ada_main;
