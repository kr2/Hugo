/* H-Set3
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <H-Z-End.scad>
include <H-EndstopHolder.scad>
include <H-Y-SupportFootEnd.scad>
include <H-BarClamp.scad>
include <H-Y-BeltDivert.scad>
include <BearingGuide.scad>

$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);


translate([30, -25, 0]) 
H_Z_end_printSet2();

translate([20, -66, 0]) 
rotate(a=90,v=Z) 
H_barClamp_printSet();

translate([35, 23, 0]) 
rotate(a=0,v=Z) 
H_Y_supportFootEnd_printSet();

translate([-15, 57, 0]) 
mirror([1, 0, 0])  
H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[0], nuttraps = [-1,1]);


translate([-43, -16, 0])
mirror([0, 1, 0])   
rotate(a=30,v=Z) 
bearingGuid_printSet();

translate([35, 55, 0]) 
rotate(a=-0,v=[0,0,1]) 
H_Y_beltDivert_print();