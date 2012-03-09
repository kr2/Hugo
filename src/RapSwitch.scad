/* RapSwitch
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

mode = "-";
//mode = "print";

OS = 0.01;

springThickness  = 0.7;
springR          = 6;

openingA         = 15;

switchSize       = [27,-1,7.5];

knobSize         = [2,3,switchSize[2]];

contactReduction = 1;
contactFrontOff  = 1.5;
contactLength    = 5;

screwHoleD       = 4.5;

genWallT         = 1.5;

cabelHoleD       = 1.5;




// ring with inner radius r and w as witth and h as heigt
module ring(r,w,h,center = false){
	difference() {
		union () {
			cylinder(r=r+w,h=h, center=center);
		}
		union () {
			translate([0, 0, -OS]) 
			cylinder(r=r,h=h+3*OS, center=center);
		}
	}
}
// ring(1,0.5,1);

module contactHolder(springSpace = 0, knob = false,cabelHolder = false) {
	difference() {
		union(){
			translate([springSpace, 0, 0]) 
			cube(size=[switchSize[0]-springSpace, springThickness, switchSize[2]], center=false);
			
		}
		union(){
			//contact coutouts
			for (i=[0:1]) {
				translate([switchSize[0] - contactFrontOff -contactLength, -OS, i*(switchSize[2]-contactReduction+2*OS)-OS]) 
					cube(size=[contactLength, springThickness+2*OS, contactReduction], center=false);
			}
			translate([switchSize[0] - contactFrontOff -contactLength - cabelHoleD, OS+springThickness, switchSize[2]/2]) rotate(a=90,v=[1,0,0]) 
				cylinder(r=cabelHoleD/2, h=springThickness+2*OS, center=false);
		}
	}

	if (knob) {
		translate([switchSize[0]-OS, 0, 0]) {
			translate([knobSize[0]/2, knobSize[1]- knobSize[0]/2, 0]) 
				cylinder(r=knobSize[0]/2, h=knobSize[2], center=false,$fn = 10);

			cube(size=knobSize-[0,knobSize[0]/2,0], center=false);
		}
	}
	else{ // ending for better pinting
		translate([switchSize[0]-OS, , 0]) 
		translate([knobSize[0]/2 - springThickness*1.5,0, 0]) 
			cylinder(r=springThickness, h=knobSize[2], center=false,$fn = 15);
	}

	if (cabelHolder) {
		translate([-cabelHoleD*1.75, -springThickness, 0]) {
			difference() {
				cube(size=[cabelHoleD*1.75, springThickness*2, switchSize[2]], center=false);
				
				#translate([cabelHoleD, -OS, switchSize[2]/2])  rotate(a=-90,v=[1,0,0]) 
					cylinder(r=cabelHoleD/2, h=springThickness*2 +2*OS, center=false);
			}
		}
	}
}




module springRing() {
	outerSpringR = springR+springThickness;
	//spring ring
	difference() {
		union(){
			ring(r=springR,w=springThickness,h=switchSize[2],center = false);
		}
		union(){
			translate([-outerSpringR+OS, +OS, -OS]) 
				cube(size=[(outerSpringR+OS)*2, outerSpringR+OS, switchSize[2]+2*OS], center=false);
		}
	}
}

module rapSwitch() {
	// lower clapm
	contactHolder(springSpace=springR*2+springThickness);

	// upper clamp
	rotate(a=openingA,v=[0,0,1]) 
	contactHolder(knob = true,cabelHolder = true);

	// srping ring
	translate([springR+springThickness/2, springThickness, 0])
	springRing();

	//screw and cabel holes
	screwHoleXdist = springR*1.5;
	screwHoleYdist = springR*2+genWallT+screwHoleD/2;
	translate([screwHoleYdist, 0, 0]) {
		// screw holde
		translate([0, -screwHoleXdist, switchSize[2]/2])	
			ring(r=screwHoleD/2,w=genWallT,h=switchSize[2],center = true);
		translate([0,  -(screwHoleXdist - screwHoleD/2)/2,  switchSize[2]/2])
		difference() {
			cube(size=[genWallT, screwHoleXdist - screwHoleD/2, switchSize[2]], center=true);

			// cabel holes in the holder
			for (i=[-1,1]) {
				translate([0, 0, i*switchSize[2]/4])  rotate(a=90,v=[0,1,0]) 
					cylinder(r=cabelHoleD/2, h=genWallT+2*OS, center=true);
			}
		}
	}
}

//rapSwitch();

module rapSwitch_ass() {
	translate([-(springR*2+genWallT+screwHoleD/2), springR*1.5, 0])
		rapSwitch();
}

if (mode == "print") {
	rapSwitch();
}






