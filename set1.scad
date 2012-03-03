/* set1
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

use <pRb-Xtruder-Mount.scad>
use <pRb-X-End.scad>
use <pRb-X-Carriage.scad>

$fn =48;
%cube(size=[150, 150, 1], center=true);

translate([-35, 10, 0]) 
pb_x_End_print();

translate([-10, -40, 0]) 
xCarriage();

translate([0, 30, 0]) 
rotate(a=-90,v=[0,0,1]) 
pb_Xtruder_mount_print();