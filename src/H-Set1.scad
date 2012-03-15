/* H-Set1
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <H-Xtruder-Mount.scad>
include <H-X-End.scad>
include <H-X-Carriage.scad>
include <H-Base.scad>
include <H-Y-BeltDivert.scad>

$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);

translate([30, -25.5, 0]) 
H_base_print();

translate([-48.5, 10, 0]) 
H_x_End_print();

translate([29.5, 50, 0]) 
rotate(a=-90,v=Z) 
H_x_Carriage_print();

translate([73, 40.5, 0]) 
rotate(a=90,v=Z) 
H_Xtruder_mount_print();

translate([-37, -60, 0]) 
rotate(a=-15,v=[0,0,1]) 
H_Y_beltDivert_print();