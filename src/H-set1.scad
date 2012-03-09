/* set1
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */
include <units.scad>

include <H-Xtruder-Mount.scad>
include <H-X-End.scad>
include <H-X-Carriage.scad>
include <H-base.scad>
include <H-Y-beltDivert.scad>

$fn = 48*2;

%cube(size=[150, 150, 1], center=true);

translate([30, -25, 0]) 
H_base_print();

translate([-48.5, 10, 0]) 
H_x_End_print();

translate([30, 50, 0]) 
rotate(a=-90,v=Z) 
H_x_Carriage_print();

translate([73, 40, 0]) 
rotate(a=90,v=Z) 
H_Xtruder_mount_print();

translate([-35, -63, 0]) 
H_Y_beltDivert_print();