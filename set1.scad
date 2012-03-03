use <pb-Xtruder-Mount.scad>
use <pb-X-End.scad>
use <xCarriage.scad>

$fn =48;
%cube(size=[150, 150, 1], center=true);

translate([-35, 20, 0]) 
pb_x_End_print();

translate([-10, -30, 0]) 
xCarriage();

translate([0, 30, 0]) 
rotate(a=-90,v=[0,0,1]) 
pb_Xtruder_mount_print();