/* H-Set2
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 *
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <H-Base.scad>

include <H-Y-BeltClamp_alternativ.scad>
include <H-Z-Coupling.scad>
include <H-Y-BarEnd.scad>

$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);

translate([0, -10, 0])
H_base_print();

translate([40, 43, 0])
rotate(a=-90,v=Z)
H_Y_BarEnd_print();


translate([-22, -55, 0])
H_Z_Coupling_printSet();


translate([0, 40, 0])
rotate(a=90,v=[0,0,1])
H_yBeltClam_alt_prinSet();

