/* pRb-assembly
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <units.scad>;
include <metric.scad>

use <pRb-X-End.scad>
use <pRb-X-Carriage.scad>
use <pRb-Xtruder-Mount.scad>

use <bearing-guide.scad>
use <motors.scad>

bearingDiameter = 22;
bearingHeight = 7;

/*------------------------------------general---------------------------------*/

module xAxis(axisLenth = 100) {
	//axis
	color("gray")
	for (i=[ [8.08,0, 8.34], [8.08, 0,33.72]]) 
	translate(i) 
	rotate(a=90,v=X) 
	cylinder(r=smooth_bar_diameter/2, h=axisLenth+20, center=true);

	// x end
	translate([0, axisLenth/2, 0]) 
	pb_x_End(isMotor=true,adjustable_z_stop=true,elongetededLowerHole = true);

	translate([0,-axisLenth/2, 0]) 
	mirror([0, 1, 0]) 
		pb_x_End(isIdle=true,elongetededLowerHole = true);

	// carriage
	translate([7, -25, 20]) 
	rotate(a=-90,v=X) 
	rotate(a=90,v=[0,0,1]) 
	pRb_x_Carriage(hasSupport = false, hasBeltConnector = true);

	// bearing
	color("gray")
	translate([35+1.5+1.5, -75, 14])
	rotate(a=90,v=Y)  
	cylinder(r=bearingDiameter/2, h=bearingHeight, center=false);
	
	translate([35+1.5-3+1.5, -75, 14])
	rotate(a=90,v=Y)  
	bearGuid_ass();

	//belt
	color("white")
	translate([39+1.5, 0, 22+7]) 
	cube(size=[6, 200, 2.5], center=true);
	
	color("white") 
	rotate(a=4,v=X) 
	translate([39+1.5, 0, 22+7-23]) 
	cube(size=[6, 200, 2.5], center=true);

	//stepper motor
	translate([58, 76, 21]) 
	rotate(a=-90,v=[0,1,0]) 
	stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
}
xAxis();