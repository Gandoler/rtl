#  Введение в TCL

## тренировка

```TCL
call  C:\Xilinx\Vivado\2023.1\settings64.bat
vivado -mode=batch -nojournal -nolog -source C:\Users\glkru\intership\Internship\06_TCL_intership\demoproject.tcl

```

## разбор сгенерированного скрипта



###  процедура checkRequiredFiles (38-72)

<details>
  <summary>Посмотреть код</summary>

 ```TCL

proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/source_files/demo.sv"]"\
 "[file normalize "$origin_dir/source_files/demo_wrapper_nexys_a7.sv"]"\
 "[file normalize "$origin_dir/source_files/Nexys-A7-100T-Master.xdc"]"\
 "[file normalize "$origin_dir/source_files/tb_demo.sv"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find remote file $ifile "
      set status false
    }
  }

  return $status
}
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "demoproject"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "demoproject.tcl"

 ```

</details>

1. proc -  означает объявление процедуры checkRequiredFiles { origin_dir}, которая принимает на вход базовую директорию
2. Базово задает статус  true
3. Создает список необходимых файлов и пути к ним
4. Проверяет существование файлов по указанным путям через foreach и если , что-то не находит, ставит статус в фолз
5. Процедура возвращает статус

Дальше идут отдельные команды

1. ставит базовой директорией текущую, но если в окружении определена переменная ::origin_dir_loc, она будет использована как базовая директория
2. Установка имени проекта
3. запись названия скрипта


###  процедура print_help (75-155)

<details>
  <summary>Посмотреть код</summary>

```TCL
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

```

</details>

Эта процедура будет вызываться, когда пользователь запускает скрипт с аргументом --help. Она предоставляет полную информацию о:

1. Назначении скрипта

2. Доступных параметрах командной строки

3. Значениях по умолчанию

4. Способах использования


###  основной код часть 1

<details>
  <summary>Посмотреть код</summary>

```TCL

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/../../../demoproject"]"

# Check for paths and files needed for project creation
set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a100tcsg324-1

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xc7a100tcsg324-1" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "sim_compile_state" -value "1" -objects $obj

```

</details>

1. Обработка аргументов командной строки
   1. Проверяет, есть ли аргументы ($::argc > 0)
   2. Перебирает все аргументы в цикле
   3. Для каждого аргумента:
      1. --origin_dir - устанавливает путь к исходным файлам
      2. --project_name - устанавливает имя проекта
      3. --help - вызывает функцию печати справки
   4. Неизвестные опции (начинающиеся с -) вызывают ошибку
2. Установка пути к оригинальному проекту
   1. Нормализует путь к оригинальному проекту (преобразует в абсолютный путь)
   2. Путь строится относительно origin_dir с переходом на три уровня вверх и затем в папку demoproject
3. Проверка необходимых файлов
   1. Флаг validate_required (0/1) контролирует проверку файлов
   2. Если проверка включена (1), вызывает ранее определенную функцию checkRequiredFiles
   3. В зависимости от результата выводит сообщение о доступности файлов
   4. При недоступных файлах завершает выполнение
4. Создание проекта Vivado
   1. Создает новый проект Vivado с указанными параметрами:
      1. Имя проекта: ${_xil_proj_name_}
      2. Путь: ./${_xil_proj_name_} (текущая директория + имя проекта)
      3. Целевая плата: xc7a100tcsg324-1 (Nexys A7-100T)
5. Установка пути к новому проекту
   1. Получает и сохраняет абсолютный путь к только что созданному проекту
6. Настройка свойств проекта
   1. Устанавливает различные свойства проекта:
      1. Библиотека по умолчанию: xil_defaultlib
      2. Поддержка VHDL-2008: включена
      3. Права доступа к IP-кэшу: чтение/запись
      4. Пути для хранения IP-ядер и файлов симуляции
      5. Генерация карты памяти: включена
      6. Язык симулятора: Mixed (смешанный)
      7. И другие специфичные настройки Vivado

###  основной код часть 2 (158 - 242)

<details>
  <summary>Посмотреть код</summary>

```TCL


# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/source_files/demo.sv"] \
 [file normalize "${origin_dir}/source_files/demo_wrapper_nexys_a7.sv"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/source_files/demo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/source_files/demo_wrapper_nexys_a7.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "dataflow_viewer_settings" -value "min_width=16" -objects $obj
set_property -name "top" -value "demo_wrapper_nexys_a7" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/source_files/Nexys-A7-100T-Master.xdc"]"
set file_added [add_files -norecurse -fileset $obj [list $file]]
set file "$origin_dir/source_files/Nexys-A7-100T-Master.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_part" -value "xc7a100tcsg324-1" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
set files [list \
 [file normalize "${origin_dir}/source_files/tb_demo.sv"] \
]
add_files -norecurse -fileset $obj $files

# Set 'sim_1' fileset file properties for remote files
set file "$origin_dir/source_files/tb_demo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj


# Set 'sim_1' fileset file properties for local files
# None

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "demo_wrapper_nexys_a7" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
# Empty (no sources present)

# Set 'utils_1' fileset properties
set obj [get_filesets utils_1]
```

</details>

1. Создание и настройка файловых наборов (filesets)
   1. Набор исходных файлов (sources_1) (158 - 188)
      1. Проверка и создание набора
         1. Проверяет существование набора sources_1 через get_filesets -quiet
         2. Создает новый набор create_fileset -srcset при отсутствии
      2. Добавление исходных файлов
         1. Получает ссылку на набор через get_filesets
         2. Формирует список файлов с нормализацией путей:
            1. demo.sv
            2. demo_wrapper_nexys_a7.sv
         3. Добавляет файлы через add_files -norecurse
      3. Настройка свойств файлов
         1. Для каждого файла устанавливает:
            1. Тип файла: SystemVerilog
      4. Настройка свойств набора
         1. Параметры просмотра потоков данных: min_width=16
         2. Установка верхнего уровня иерархии: demo_wrapper_nexys_a7

   2. Набор файлов ограничений (constrs_1) (191 - 208)
      1. Проверка и создание набора
         1. Аналогичная проверка через get_filesets -quiet
         2. Создание create_fileset -constrset при необходимости
      2. Добавление файла ограничений
         1. Добавляет Nexys-A7-100T-Master.xdc
         2. Нормализует путь к файлу
      3. Настройка свойств
         1. Тип файла: XDC (Xilinx Design Constraints)
         2. Целевая плата: xc7a100tcsg324-1

   3. Набор файлов симуляции (sim_1) (211 - 235)
      1. Проверка и создание набора
         1. Стандартная проверка существования
         2. Создание create_fileset -simset при отсутствии
      2. Добавление тестового файла
         1. Добавляет tb_demo.sv
      3. Настройка свойств
         1. Тип файла: SystemVerilog
         2. Верхний уровень для симуляции: demo_wrapper_nexys_a7
         3. Целевая библиотека: xil_defaultlib

   4. Утилитарный набор (utils_1) (242 - 248)
      1. Получение ссылки на набор
      2. (В текущем скрипте остается пустым для будущего использования)

#### Небольшое обьяснение:

utils_1 — это "служебный" набор для управления проектом через скрипты.

* Если проект простой — он может оставаться пустым.
* Если нужна автоматизация — в него добавляют TCL/Python-скрипты для пред- и пост-обработки.


###  основной код часть 3 (244 - 298)

<details>
  <summary>Посмотреть код</summary>

```TCL
set idrFlowPropertiesConstraints ""
catch {
 set idrFlowPropertiesConstraints [get_param runs.disableIDRFlowPropertyConstraints]
 set_param runs.disableIDRFlowPropertyConstraints 1
}

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7a100tcsg324-1 -flow {Vivado Synthesis 2023} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2023" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {

}
set obj [get_runs synth_1]
set_property -name "part" -value "xc7a100tcsg324-1" -objects $obj
set_property -name "auto_incremental_checkpoint" -value "1" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7a100tcsg324-1 -flow {Vivado Implementation 2023} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2023" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_1_init_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_init_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps init_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_init_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
```

</details>

Вот объяснение предоставленного кода в запрошенном формате:

1. Настройка параметров IDR Flow Properties (242 - 248)
   1. Инициализация переменной
      1. Создается переменная idrFlowPropertiesConstraints с пустым значением
   2. Блок обработки ошибок (catch)
      1. Пытается получить текущее значение параметра runs.disableIDRFlowPropertyConstraints
      2. Устанавливает параметр runs.disableIDRFlowPropertyConstraints в 1
         (отключает ограничения свойств потока IDR)

2. Создание и настройка запуска синтеза (synth_1) (251 - 277)
   1. Проверка существования запуска
      1. Проверяет существование запуска synth_1 через get_runs -quiet
   2. Создание нового запуска (если не существует)
      1. Создает запуск create_run с параметрами:
         - Имя: synth_1
         - Плата: xc7a100tcsg324-1
         - Поток: Vivado Synthesis 2023
         - Стратегия: Vivado Synthesis Defaults
         - Без отчетов
         - Набор ограничений: constrs_1
   3. Настройка существующего запуска (если существует)
      1. Устанавливает стратегию "Vivado Synthesis Defaults"
      2. Устанавливает поток "Vivado Synthesis 2023"
   4. Настройка отчетов для запуска
      1. Устанавливает имя стратегии отчетов
      2. Настраивает стратегию отчетов "Vivado Synthesis Default Reports"
   5. Создание отчета об утилизации (utilization report)
      1. Проверяет существование отчета synth_1_synth_report_utilization_0
      2. Создает новый отчет если не существует:
         - Имя: synth_1_synth_report_utilization_0
         - Тип: report_utilization:1.0
         - Шаги: synth_design
         - Для запуска: synth_1
   6. Дополнительные настройки запуска
      1. Устанавливает параметры:
         - Плата: xc7a100tcsg324-1
         - Автоинкрементные контрольные точки: 1
         - Стратегия: Vivado Synthesis Defaults
   7. Установка текущего запуска синтеза
      1. Устанавливает synth_1 как текущий запуск синтеза

3. Создание и настройка запуска имплементации (impl_1)  (278 - 298)
   1. Проверка существования запуска
      1. Проверяет существование запуска impl_1 через get_runs -quiet
   2. Создание нового запуска (если не существует)
      1. Создает запуск create_run с параметрами:
         - Имя: impl_1
         - Плата: xc7a100tcsg324-1
         - Поток: Vivado Implementation 2023
         - Стратегия: Vivado Implementation Defaults
         - Без отчетов
         - Набор ограничений: constrs_1
         - Родительский запуск: synth_1
   3. Настройка существующего запуска (если существует)
      1. Устанавливает стратегию "Vivado Implementation Defaults"
      2. Устанавливает поток "Vivado Implementation 2023"
   4. Настройка отчетов для запуска
      1. Устанавливает имя стратегии отчетов
      2. Настраивает стратегию отчетов "Vivado Implementation Default Reports"
   5. Создание отчета временных характеристик (timing summary)
      1. Проверяет существование отчета impl_1_init_report_timing_summary_0
      2. Создает новый отчет если не существует:
         - Имя: impl_1_init_report_timing_summary_0
         - Тип: report_timing_summary:1.0
         - Шаги: init_design
         - Для запуска: impl_1
   6. Настройка отчета временных характеристик
      1. Отключает отчет по умолчанию (is_enabled = 0)
      2. Устанавливает максимальное количество путей: 10
      3. Включает отчет о несвязанных путях


#### Небольшое обьяснение:

1. IDR (Interactive Design Rule) Flow — это механизм в Vivado, который:
   1. Автоматически применяет дополнительные проверки и ограничения во время синтеза и имплементации.
   2. Может влиять на оптимизацию, размещение и маршрутизацию (Place & Route).
   3. Иногда мешает ручной настройке или требует дополнительных ресурсов.

2. Параметр disableIDRFlowPropertyConstraints:

   * 0 (по умолчанию) → Vivado применяет дополнительные проверки IDR.
   * 1 → Vivado отключает часть этих проверок, давая больше свободы при реализации дизайна.

3. В  TCL блок try-catch обьеденен в один блок  catch

###  основной код часть 4 (300 - 362)

<details>
  <summary>Посмотреть код</summary>

```TCL
# Create 'impl_1_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0] "" ] } {
  create_report_config -report_name impl_1_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_place_report_utilization_0 -report_type report_utilization:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_control_sets_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0] "" ] } {
  create_report_config -report_name impl_1_place_report_control_sets_0 -report_type report_control_sets:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_control_sets_0]
if { $obj != "" } {
set_property -name "options.verbose" -value "1" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
```

</details>

1. Создание и настройка отчетов для реализации (impl_1) (300 - 306)
   1. Отчет о проверке правил проектирования (DRC) после оптимизации (impl_1_opt_report_drc_0) (300 - 306)
      1. Проверка существования отчета
         1. Проверяет существование отчета через get_report_configs
         2. Создает новый отчет create_report_config при отсутствии:
            - Тип: report_drc:1.0
            - Этап: opt_design
            - Запуск: impl_1
      2. Получение ссылки на созданный отчет

   2. Отчет временных характеристик после оптимизации ()(impl_1_opt_report_timing_summary_0) (308 - 317)
      1. Проверка и создание отчета (аналогично DRC)
         1. Тип: report_timing_summary:1.0
      2. Настройка свойств отчета:
         1. Отключение отчета по умолчанию (is_enabled = 0)
         2. Ограничение количества путей до 10 (options.max_paths)
         3. Включение отчета о несвязанных путях (options.report_unconstrained)

   3. Отчет временных характеристик после оптимизации мощности (impl_1_power_opt_report_timing_summary_0) (319 - 328)
      1. Проверка и создание отчета
         1. Тип: report_timing_summary:1.0
         2. Этап: power_opt_design
      2. Настройка свойств (аналогично предыдущему отчету):
         1. Отключение по умолчанию
         2. Ограничение путей
         3. Отчет о несвязанных путях

   4. Отчет о вводе-выводе после размещения (impl_1_place_report_io_0) (330 - 336)
      1. Проверка и создание отчета
         1. Тип: report_io:1.0
         2. Этап: place_design
      2. Получение ссылки на отчет (без дополнительных настроек)

   5. Отчет об утилизации ресурсов после размещения (impl_1_place_report_utilization_0) (338 - 344)
      1. Проверка и создание отчета
         1. Тип: report_utilization:1.0
      2. Получение ссылки (без настроек)

   6. Отчет о наборах управления после размещения (impl_1_place_report_control_sets_0) (346 - 353)
      1. Проверка и создание отчета
         1. Тип: report_control_sets:1.0
      2. Настройка свойств:
         1. Включение подробного отчета (options.verbose = 1)

   7. Отчеты о повторном использовании при размещении (impl_1_place_report_incremental_reuse_0/1) (355 - 362)
      1. Проверка и создание двух отчетов:
         1. Тип: report_incremental_reuse:1.0
      2. Настройка свойств:
         1. Отключение отчетов по умолчанию (is_enabled = 0)

#### Особенности:

Все отчеты связаны с запуском impl_1

* Для временных отчетов установлено ограничение на количество отображаемых путей
* Некоторые отчеты отключены по умолчанию для уменьшения времени выполнения
* Отчеты создаются только при их отсутствии (проверка через string equal)

###  основной код часть 5 (363 - 420)

<details>
  <summary>Посмотреть код</summary>

```TCL
# Create 'impl_1_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj

}
# Create 'impl_1_place_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_place_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_post_place_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_place_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_place_power_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_place_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "options.max_paths" -value "10" -objects $obj
set_property -name "options.report_unconstrained" -value "1" -objects $obj

}
# Create 'impl_1_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0] "" ] } {
  create_report_config -report_name impl_1_route_report_methodology_0 -report_type report_methodology:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_methodology_0]
if { $obj != "" } {

}
```

</details>

1. Создание и настройка отчетов (reports) для этапа имплементации (impl_1)
   1. Отчет о повторном использовании при размещении (impl_1_place_report_incremental_reuse_1)
      1. Проверка существования отчета
         1. Проверяет наличие отчета через get_report_configs
         2. Создает новый отчет create_report_config при отсутствии:
            1. Тип отчета: report_incremental_reuse:1.0
            2. Для этапа: place_design
            3. В рамках запуска: impl_1
      2. Настройка свойств отчета
         1. Получает ссылку на отчет через get_report_configs
         2. Отключает отчет: is_enabled = 0

   2. Отчет временных характеристик при размещении (impl_1_place_report_timing_summary_0)
      1. Проверка и создание отчета
         1. Аналогичная проверка существования
         2. Создание отчета типа report_timing_summary:1.0
      2. Настройка свойств
         1. Отключает отчет: is_enabled = 0
         2. Устанавливает параметры:
            1. Максимальное количество путей для анализа: 10
            2. Включение отчета по несвязанным путям: 1 (включено)

   3. Отчет временных характеристик после оптимизации мощности (impl_1_post_place_power_opt_report_timing_summary_0)
      1. Проверка и создание
         1. Для этапа post_place_power_opt_design
      2. Настройка
         1. Аналогичные параметры как в предыдущем отчете:
            1. Отключен
            2. Макс. путей: 10
            3. Отчет по несвязанным путям

   4. Отчет временных характеристик после физической оптимизации (impl_1_phys_opt_report_timing_summary_0)
      1. Создание для этапа phys_opt_design
      2. Настройка идентична предыдущим временным отчетам

   5. Отчет проверки правил проектирования (DRC) при трассировке (impl_1_route_report_drc_0)
      1. Создание отчета типа report_drc:1.0
      2. Для этапа route_design
      3. Без дополнительных настроек (используются параметры по умолчанию)

   6. Отчет методологии при трассировке (impl_1_route_report_methodology_0)
      1. Создание отчета типа report_methodology:1.0
      2. Также для этапа route_design
      3. Без модификации параметров

#### Особенности конфигурации:
* Все временные отчеты (timing summary) отключены на этапе настройки (is_enabled=0)
* Для временных отчетов установлено ограничение на количество анализируемых путей (10)
* Включен отчет по несвязанным временным путям (unconstrained)
* Отчеты DRC и Methodology оставлены с настройками по умолчанию