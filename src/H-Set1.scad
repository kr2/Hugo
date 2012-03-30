/* H-Set1
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <H-Xtruder-Mount.scad>
include <H-X-End.scad>
include <H-X-Carriager.scad>

$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);



translate([25,0, 0]) 
H_x_End_print();

translate([-30, 29, 0]) 
rotate(a=-90,v=Z) 
H_x_Carriage_print();

translate([-2, -36, 0]) 
rotate(a=90,v=Z) 
H_Xtruder_mount_print();

