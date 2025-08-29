set project_path "C:/Users/glkru/demoproject/demoproject.xpr"

if {[file exists $project_path]} {
    open_project $project_path


set_property top tb_demo [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -mode behavioral 
run 100 us
start_gui


}