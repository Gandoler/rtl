set project_path "C:/Users/glkru/demoproject/demoproject.xpr"

if {[file exists $project_path]} {
    open_project $project_path
    start_gui


    reset_run   synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    reset_run   impl_1
    launch_runs impl_1  -to_step write_bitstream -jobs 4
    wait_on_run impl_1

    open_hw
    connect_hw_server -allow_non_jtag
    open_hw_target
    set_property PROGRAM.FILE {C:/Users/glkru/demoproject/demoproject.runs/impl_1/demo_wrapper_nexys_a7.bit} [get_hw_devices xc7a100t_0]
    current_hw_device [get_hw_devices xc7a100t_0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7a100t_0] 0]
    set_property PROBES.FILE {} [get_hw_devices xc7a100t_0]
    set_property FULL_PROBES.FILE {} [get_hw_devices xc7a100t_0]
    set_property PROGRAM.FILE {C:/Users/glkru/demoproject/demoproject.runs/impl_1/demo_wrapper_nexys_a7.bit} [get_hw_devices xc7a100t_0]
    program_hw_devices [get_hw_devices xc7a100t_0]
    refresh_hw_device [lindex [get_hw_devices xc7a100t_0] 0]
}