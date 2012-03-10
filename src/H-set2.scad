/* H-set2
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <H-Y-beltClamp.scad>
include <H-Y-BarEnd.scad>
include <bearing-guide.scad>

$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);


translate([5, 0, 0]) 
bearingGuid_printSet();

translate([45, -30, 0]) 
rotate(a=-30,v=Z) 
H_Y_BarEnd_print();


translate([-33, 30, 0]) 
rotate(a=-90-30,v=[0,0,1]) 
H_yBeltClam_printSet();