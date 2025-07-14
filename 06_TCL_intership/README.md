#  Введение в TCL

## тренировка

```TCL
call  C:\Xilinx\Vivado\2023.1\settings64.bat
vivado -mode=batch -nojournal -nolog -source C:\Users\glkru\intership\Internship\06_TCL_intership\demoproject.tcl

```

## разбор сгенерированного скрипта



###  процедура checkRequiredFiles

 ```md

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

1. proc -  означает объявление процедуры checkRequiredFiles { origin_dir}, которая принимает на вход базовую директорию
2. Базово задает статус  true
3. Создает список необходимых файлов и пути к ним
4. Проверяет существование файлов по указанным путям через foreach и если , что-то не находит, ставит статус в фолз
5. Процедура возвращает статус

Дальше идут отдельные команды

1. ставит базовой директорией текущую, но если в окружении определена переменная ::origin_dir_loc, она будет использована как базовая директория
2. Установка имени проекта
3. запись названия скрипта


###  процедура print_help

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

Эта процедура будет вызываться, когда пользователь запускает скрипт с аргументом --help. Она предоставляет полную информацию о:

1. Назначении скрипта

2. Доступных параметрах командной строки

3. Значениях по умолчанию

4. Способах использования


###  основной код часть 1

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

###  основной код часть 2

