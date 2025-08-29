set project_path "C:/Users/glkru/demoproject/demoproject.xpr"

if {[file exists $project_path]} {
    open_project $project_path
    start_gui

     set_property top demo_wrapper_nexys_a7 [current_fileset]

     update_compile_order -fileset sources_1

     synth_design -rtl
     show_schematic  -name "The Grates scheme"  [get_cells demo_wrapper_nexys_a7]



}
