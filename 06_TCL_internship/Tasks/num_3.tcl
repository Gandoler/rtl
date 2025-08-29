set project_path "C:/Users/glkru/demoproject/demoproject.xpr"

if {[file exists $project_path]} {
    open_project $project_path
    start_gui



    set_property top demo_wrapper_nexys_a7 [current_fileset]


    reset_run   synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    reset_run   impl_1
    launch_runs impl_1  -jobs 4
    wait_on_run impl_1


    open_run impl_1
    report_utilization -name utilization_1
    report_timing_summary -name timing_1
}
