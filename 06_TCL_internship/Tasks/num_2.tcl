set project_path "C:/Users/glkru/demoproject/demoproject.xpr"

if {[file exists $project_path]} {
    open_project $project_path
    start_gui

    set_property top demo_wrapper_nexys_a7 [current_fileset]
    update_compile_order -fileset sources_1

    reset_run synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1


        open_run synth_1 -name synth_1
        show_schematic -name "The Grates scheme" [get_cells demo_wrapper_nexys_a7]

}
