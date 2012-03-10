/* H-set3
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <H-Z-End.scad>
include <H-enstop-holder.scad>
include <H-Y-supportFootEnd.scad>
include <H-bar-clamp.scad>
include <H-bar-clamp-cross.scad>

$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);


translate([35, -25, 0]) 
H_Z_end_printSet1();

translate([20, -65, 0]) 
rotate(a=90,v=Z) 
H_barClamp_printSet();

translate([57, 38, 0]) 
rotate(a=90,v=Z) 
H_Y_supportFootEnd_printSet();

translate([-10, 35, 0]) 
H_endstop_printSet();

translate([-38, -45, 0]) 
H_barClampCross_printSet();