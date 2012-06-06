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
include <H-BearingGuide.scad>
include <RampsHolder.scad>


$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);


translate([30, -25, 0])
H_Z_end_printSet2();

translate([20, -66, 0])
rotate(a=90,v=Z)
H_barClamp_printSet();

translate([-56, -35.5, 0])
rotate(a=90,v=Z)
H_Y_supportFootEnd_printSet();

translate([-60, 44, 0])
mirror([1, 0, 0])
H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[0], nuttraps = [-1,1]);


translate([25, 48, 0])
mirror([0, 1, 0])
rotate(a=30+90,v=Z)
H_BearingGuid_printSet();

translate([-26, -35, 0])
rotate(a=-90,v=[0,0,1])
H_Y_beltDivert_print();

translate([20, 7, 0])
rh_rampsholder_print_set();