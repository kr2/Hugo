/* pRb-Xtruder-Mount
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <units.scad>
include <metric.scad>
include <nuts_and_bolts.scad>
include <roundEdges.scad>


/*------------------------------------general---------------------------------*/
mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//mode = "inspect";

/*------------------------------------belt------------------------------------*/
belt_thickness = 2.5;
belt_width = 6 + 1;
belt_teethDist = 5;
belt_teethDepth = 1.5;
belt_topOffset =14.6;  // from top plate to the top edge of the belt
belt_tolerance = [2,1,1]; //x,y,z

strongWallThickness = 10;
genWallThickness = 2;



module pRb_yBeltClam() {
	y_mainLength = m3_diameter+genWallThickness+strongWallThickness+belt_tolerance[0]+belt_thickness;

	difference() {
		union(){
			//main block
			cube(size=[strongWallThickness, y_mainLength, belt_width+belt_tolerance[2]], center=false);
			//deflection
			translate([strongWallThickness+belt_thickness+belt_tolerance[0], y_mainLength- strongWallThickness, 0]) {
				difference() {
					cube(size=[strongWallThickness, strongWallThickness, belt_width+belt_tolerance[2]], center=false);
					translate([0, 0, -OS])
						roundEdge(_a=0,_r=strongWallThickness,_l=belt_width+belt_tolerance[2]+2*OS,_fn=100) ;
				}
			}

			//belt holder
			for (i=[belt_teethDist/4:belt_teethDist:strongWallThickness])
			translate([i, -belt_teethDepth, 0]) 
				cube(size=[belt_teethDist/2, belt_teethDepth, belt_width+belt_tolerance[2]], center=false); 

			// bootom plate
			translate([0, 0, -genWallThickness]){ 
				translate([0, 0, -m3_nut_diameter/2-m3_diameter/2]) 
				difference() {
					cube(size=[strongWallThickness, y_mainLength- strongWallThickness, m3_nut_diameter/2+m3_diameter/2+genWallThickness], center=false);
					translate([0, y_mainLength- strongWallThickness, 0]) 
					rotate(a=90,v=Y) 
						roundEdge(_a=180,_r=(m3_nut_diameter/2+m3_diameter/2+genWallThickness)/2,_l=strongWallThickness,_fn=100);
					rotate(a=-90,v=X) 
						roundEdge(_a=-90,_r=(m3_nut_diameter/2+m3_diameter/2+genWallThickness)/2,_l=strongWallThickness,_fn=100);
					translate([strongWallThickness, 0, 0]) 
					rotate(a=-90,v=X) 
						roundEdge(_a=180,_r=(m3_nut_diameter/2+m3_diameter/2+genWallThickness)/2,_l=strongWallThickness,_fn=100);
				}
				translate([0, y_mainLength- strongWallThickness, 0]) 
				cube(size=[2*strongWallThickness+belt_thickness+belt_tolerance[0], strongWallThickness, genWallThickness], center=false);
			}

			// top plate
			translate([0, 0, belt_width+belt_tolerance[2]]){ 
				cube(size=[strongWallThickness, y_mainLength, belt_topOffset], center=false);
				translate([0, y_mainLength- strongWallThickness, 0]) 
					cube(size=[2*strongWallThickness+belt_thickness+belt_tolerance[0], strongWallThickness, belt_topOffset], center=false);
			}

			// support rounded edge
			translate([0, y_mainLength,  belt_width+belt_tolerance[2]+belt_topOffset-genWallThickness]) {
				cube(size=[2*strongWallThickness+belt_thickness+belt_tolerance[0], belt_topOffset/3*2, genWallThickness], center=false);
				rotate(a=90,v=Y) 
					roundEdge(_a=0,_r=belt_topOffset/3*2,_l=2*strongWallThickness+belt_thickness+belt_tolerance[0],_fn=4);
			}
		}
		union(){
			//tentener screw
			translate([-OS, genWallThickness+m3_nut_diameter/2, (belt_width+belt_tolerance[2])/2])  
			rotate(a=90,v=Y) {
				cylinder(r=m3_diameter/2, h=strongWallThickness+2*OS, center=false,$fn=24);
				translate([0, 0, strongWallThickness-m3_nut_heigth+2*OS]) 
					cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);

			}

			//fastening screws
			for (i=[strongWallThickness/2, strongWallThickness + belt_thickness+belt_tolerance[0] + strongWallThickness/2]) 
			translate([i, y_mainLength- m3_nut_diameter+genWallThickness, -genWallThickness-OS]){
				translate([0, 0, OS]) 
				cylinder(r=m3_diameter/2, h=belt_topOffset+ belt_width+belt_tolerance[2]+2*genWallThickness, center=false,$fn=24);
				cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);
			} 

			// belt fastening screws
			for (i=[-m3_diameter/2,m3_diameter/2+belt_width+belt_tolerance[2]]) 
			translate([strongWallThickness/2, -OS, i]){
				rotate(a=-90,v=X) 
					cylinder(r=m3_diameter/2, h=y_mainLength- m3_nut_diameter-2*genWallThickness, center=false,$fn=48); 
				//nuttraps
				translate([0, genWallThickness+m3_nut_diameter/2-m3_nut_heigth, 0]) 
				rotate(a=-90,v=X) 
					cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);
				translate([-(strongWallThickness/2+OS)/2, genWallThickness+m3_nut_diameter/2+m3_nut_heigth/2-m3_nut_heigth, 0]) 
				cube(size=[strongWallThickness/2+OS, m3_nut_heigth, m3_nut_wallDist], center=true);
			}

			//oblique edge
			translate([0, 0, m3_diameter+belt_width+belt_tolerance[2] + genWallThickness]) 
			rotate(a=-35,v=X) 
			translate([-OS, -(y_mainLength- strongWallThickness),0]) 
			cube(size=[strongWallThickness+2*OS, y_mainLength- strongWallThickness, belt_topOffset], center=false);
		}
	}
	
}

module beltProtector() {
	difference() {
		cylinder(r=m3_nut_diameter/2, h= belt_width, center=false,$fn=48);
		translate([-m3_nut_diameter/4, 0, (belt_width)/2]) 
			cube(size=[m3_nut_diameter/2+OS, m3_nut_diameter+2*OS, belt_width+2*OS], center=true);
		translate([0, 0, (belt_width)/2]) 
		rotate(a=90,v=Y) 
			cylinder(r=m3_diameter/2, h=(m3_nut_diameter)/2-1, center=false,$fn=8);
	}
}

module beltClamp() {
	holeDist = (belt_width+belt_tolerance[2]+2*(m3_diameter/2));
	difference() {
		union(){
			translate([0, 0, genWallThickness/2]) 
			cube(size=[strongWallThickness, belt_width+belt_tolerance[2]+2*(m3_diameter/2), genWallThickness], center=true);
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, 0]) { 
				cylinder(r=strongWallThickness/2, h=genWallThickness, center=false,$fn=48);
			}
		}
		union(){
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, -OS]) { 
				cylinder(r=m3_diameter/2, h=genWallThickness+2*OS, center=false,$fn=12);
			}
		}
	}

}


if (mode == "inspect") {
	pRb_yBeltClam();
	translate([strongWallThickness+1,  genWallThickness+m3_nut_diameter/2, +belt_tolerance[2]/2]) 
	beltProtector();
	translate([strongWallThickness/2, -belt_thickness, (belt_width+belt_tolerance[2])/2]) 
	rotate(a=90,v=X) 
	beltClamp();
}
module pRb_yBeltClam_print() {
	rotate(a=180,v=X) 
	translate([0, 0, -(belt_topOffset+ belt_width+belt_tolerance[2])]) 
	pRb_yBeltClam();
	translate([strongWallThickness*1.6, strongWallThickness/3, 0]) 
	beltClamp();

	translate([strongWallThickness, m3_nut_diameter/2+belt_thickness, 0]) 
	rotate(a=-90,v=Y) 
	beltProtector();
}
if (mode == "print") 
	pRb_yBeltClam_print();

