/* H-Y-beltClamp [Ybc]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>
include <metric.scad>
include <roundEdges.scad>


/*------------------------------------general---------------------------------*/
Ybc_mode = "-";
//Ybc_mode = "print";  $fn=24*4;   // can be print or inspect [overlays the Ybc_model with the original Ybc_model] (uncomment next line)
//Ybc_mode = "printSet";  $fn=24*4; 
//Ybc_mode = "inspect";
//Ybc_mode = "assembly";

/*------------------------------------belt------------------------------------*/
Ybc_belt_thickness = 2.5;
Ybc_belt_width = 6 + 1;
Ybc_belt_teethDist = 5;
Ybc_belt_teethDepth = 1.5;
Ybc_belt_topOffset =14.6;  // from top plate to the top edge of the belt
Ybc_belt_tolerance = [2,1,1]; //x,y,z

Ybc_strongWallThickness = 10;
Ybc_genWallThickness = 2;

Ybc_nutSlotTolerance = 0.4;

module H_yBeltClam() {
	y_mainLength = m3_diameter+Ybc_genWallThickness+Ybc_strongWallThickness+Ybc_belt_tolerance[0]+Ybc_belt_thickness;

	difference() {
		union(){
			//main block
			cube(size=[Ybc_strongWallThickness, y_mainLength, Ybc_belt_width+Ybc_belt_tolerance[2]], center=false);
			//deflection
			translate([Ybc_strongWallThickness+Ybc_belt_thickness+Ybc_belt_tolerance[0], y_mainLength- Ybc_strongWallThickness, 0]) {
				difference() {
					cube(size=[Ybc_strongWallThickness, Ybc_strongWallThickness, Ybc_belt_width+Ybc_belt_tolerance[2]], center=false);
					translate([0, 0, -OS])
						roundEdge(_a=0,_r=Ybc_strongWallThickness,_l=Ybc_belt_width+Ybc_belt_tolerance[2]+2*OS,_fn=100) ;
				}
			}

			//belt holder
			for (i=[Ybc_belt_teethDist/4:Ybc_belt_teethDist:Ybc_strongWallThickness])
			translate([i, -Ybc_belt_teethDepth, 0]) 
			difference() {
				cube(size=[Ybc_belt_teethDist/2, Ybc_belt_teethDepth, Ybc_belt_width+Ybc_belt_tolerance[2]], center=false); 
				translate([0, 0, Ybc_belt_width+Ybc_belt_tolerance[2]]) 
				rotate(a=90,v=Y) 
					roundEdge(_a=0,_r=Ybc_belt_teethDepth,_l=Ybc_belt_teethDist/2+2*OS,_fn=4);
			}	

			// bootom plate
			translate([0, 0, -Ybc_genWallThickness]){ 
				translate([0, 0, -m3_nut_diameter/2-m3_diameter/2]) 
				difference() {
					cube(size=[Ybc_strongWallThickness, y_mainLength- Ybc_strongWallThickness, m3_nut_diameter/2+m3_diameter/2+Ybc_genWallThickness], center=false);
					translate([0, y_mainLength- Ybc_strongWallThickness, 0]) 
					rotate(a=90,v=Y) 
						roundEdge(_a=180,_r=(m3_nut_diameter/2+m3_diameter/2+Ybc_genWallThickness)/2,_l=Ybc_strongWallThickness,_fn=100);
					rotate(a=-90,v=X) 
						roundEdge(_a=-90,_r=(m3_nut_diameter/2+m3_diameter/2+Ybc_genWallThickness)/2,_l=Ybc_strongWallThickness,_fn=100);
					translate([Ybc_strongWallThickness, 0, 0]) 
					rotate(a=-90,v=X) 
						roundEdge(_a=180,_r=(m3_nut_diameter/2+m3_diameter/2+Ybc_genWallThickness)/2,_l=Ybc_strongWallThickness,_fn=100);
				}
				translate([0, y_mainLength- Ybc_strongWallThickness, 0]) 
				cube(size=[2*Ybc_strongWallThickness+Ybc_belt_thickness+Ybc_belt_tolerance[0], Ybc_strongWallThickness, Ybc_genWallThickness], center=false);
			}

			// top plate
			translate([0, 0, Ybc_belt_width+Ybc_belt_tolerance[2]]){ 
				cube(size=[Ybc_strongWallThickness, y_mainLength, Ybc_belt_topOffset], center=false);
				translate([0, y_mainLength- Ybc_strongWallThickness, 0]) 
					cube(size=[2*Ybc_strongWallThickness+Ybc_belt_thickness+Ybc_belt_tolerance[0], Ybc_strongWallThickness, Ybc_belt_topOffset], center=false);
			}

			// support rounded edge
			translate([0, y_mainLength,  Ybc_belt_width+Ybc_belt_tolerance[2]+Ybc_belt_topOffset-Ybc_genWallThickness]) {
				intersection() {
					union() {
						cube(size=[2*Ybc_strongWallThickness+Ybc_belt_thickness+Ybc_belt_tolerance[0], Ybc_belt_topOffset/3*2, Ybc_genWallThickness], center=false);
						rotate(a=90,v=Y) 
							roundEdge(_a=0,_r=Ybc_belt_topOffset/3*2,_l=2*Ybc_strongWallThickness+Ybc_belt_thickness+Ybc_belt_tolerance[0],_fn=4);

					}
					union() {
						for (i=[Ybc_strongWallThickness/2,Ybc_strongWallThickness + Ybc_belt_thickness+Ybc_belt_tolerance[0] + Ybc_strongWallThickness/2]) 
						translate([i, 0, -(Ybc_belt_topOffset)]) 
						scale([1, (Ybc_belt_topOffset/3*2)/(Ybc_strongWallThickness/2), 1]) 
							cylinder(r=Ybc_strongWallThickness/2, h=Ybc_belt_topOffset+Ybc_genWallThickness, center=false,$fn=48);
					}
				}
			}
		}
		union(){
			//tentener screw
			translate([-OS, Ybc_genWallThickness+m3_nut_diameter/2, (Ybc_belt_width+Ybc_belt_tolerance[2])/2])  
			rotate(a=90,v=Y) {
				cylinder(r=m3_diameter/2, h=Ybc_strongWallThickness+2*OS, center=false,$fn=24);
				translate([0, 0, Ybc_strongWallThickness-m3_nut_heigth+2*OS]) 
					cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);

			}

			//fastening screws
			for (i=[Ybc_strongWallThickness/2, Ybc_strongWallThickness + Ybc_belt_thickness+Ybc_belt_tolerance[0] + Ybc_strongWallThickness/2]) 
			translate([i, y_mainLength- m3_nut_diameter+Ybc_genWallThickness, -Ybc_genWallThickness-OS]){
				translate([0, 0, OS]) 
				cylinder(r=m3_diameter/2, h=Ybc_belt_topOffset+ Ybc_belt_width+Ybc_belt_tolerance[2]+2*Ybc_genWallThickness, center=false,$fn=24);
				cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);
			} 

			// belt fastening screws
			for (i=[-m3_diameter/2,m3_diameter/2+Ybc_belt_width+Ybc_belt_tolerance[2]]) 
			translate([Ybc_strongWallThickness/2, -OS, i]){
				rotate(a=-90,v=X) 
					cylinder(r=m3_diameter/2, h=y_mainLength- m3_nut_diameter-2*Ybc_genWallThickness, center=false,$fn=48); 
				//nuttraps
				translate([0, Ybc_genWallThickness+m3_nut_diameter/2-m3_nut_heigth-Ybc_nutSlotTolerance/2, 0]) 
				rotate(a=-90,v=X) 
					cylinder(r=(m3_nut_diameter+Ybc_nutSlotTolerance)/2, h=m3_nut_heigth+Ybc_nutSlotTolerance, center=false,$fn=6);
				translate([-(Ybc_strongWallThickness/2+OS)/2, Ybc_genWallThickness+m3_nut_diameter/2+m3_nut_heigth/2-m3_nut_heigth, 0]) 
				cube(size=[Ybc_strongWallThickness/2+OS, m3_nut_heigth+Ybc_nutSlotTolerance, m3_nut_wallDist+Ybc_nutSlotTolerance], center=true);
			}

			//oblique edge
			translate([0, 0,  m3_diameter/2+Ybc_belt_width+Ybc_belt_tolerance[2]]) 
			rotate(a=-30,v=X)  {
				difference() {
					translate([-OS, -(y_mainLength- Ybc_strongWallThickness),0])
					cube(size=[Ybc_strongWallThickness+2*OS, y_mainLength- Ybc_strongWallThickness, Ybc_belt_topOffset], center=false);
					
					translate([Ybc_strongWallThickness/2, 0, 0]) 
					scale([1, 0.55, 1]) 
						cylinder(r=Ybc_strongWallThickness/2, h=Ybc_belt_topOffset*4, center=true,$fn=24);
				}
			}
		}
	}
	
}

module yBeltClamp_beltProtector() {
	difference() {
		cylinder(r=m3_nut_diameter/2, h= Ybc_belt_width, center=false,$fn=48);
		translate([-m3_nut_diameter/4, 0, (Ybc_belt_width)/2]) 
			cube(size=[m3_nut_diameter/2+OS, m3_nut_diameter+2*OS, Ybc_belt_width+2*OS], center=true);
		translate([0, 0, (Ybc_belt_width)/2]) 
		rotate(a=90,v=Y) 
			cylinder(r=m3_diameter/2, h=(m3_nut_diameter)/2-1, center=false,$fn=8);
	}
}

module beltClamp() {
	holeDist = (Ybc_belt_width+Ybc_belt_tolerance[2]+2*(m3_diameter/2));
	difference() {
		union(){
			translate([0, 0, Ybc_genWallThickness/2]) 
			cube(size=[Ybc_strongWallThickness, Ybc_belt_width+Ybc_belt_tolerance[2]+2*(m3_diameter/2), Ybc_genWallThickness], center=true);
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, 0]) { 
				cylinder(r=Ybc_strongWallThickness/2, h=Ybc_genWallThickness, center=false,$fn=48);
			}
		}
		union(){
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, -OS]) { 
				cylinder(r=m3_diameter/2, h=Ybc_genWallThickness+2*OS, center=false,$fn=12);
			}
		}
	}

}


if (Ybc_mode == "inspect") {
	H_yBeltClam();
	translate([Ybc_strongWallThickness+1,  Ybc_genWallThickness+m3_nut_diameter/2, +Ybc_belt_tolerance[2]/2]) 
	yBeltClamp_beltProtector();
	translate([Ybc_strongWallThickness/2, -Ybc_belt_thickness, (Ybc_belt_width+Ybc_belt_tolerance[2])/2]) 
	rotate(a=90,v=X) 
	beltClamp();
}
module H_yBeltClam_print() {
	rotate(a=180,v=X) 
	translate([0, 0, -(Ybc_belt_topOffset+ Ybc_belt_width+Ybc_belt_tolerance[2])]) 
	H_yBeltClam();
	translate([Ybc_strongWallThickness*1.6, Ybc_strongWallThickness/3, 0]) 
	beltClamp();

	translate([Ybc_strongWallThickness, m3_nut_diameter/2+Ybc_belt_thickness, 0]) 
	rotate(a=-90,v=Y) 
	yBeltClamp_beltProtector();
}
if (Ybc_mode == "print") 
	H_yBeltClam_print();

if (Ybc_mode == "printSet") {
	H_yBeltClam_print();
	translate([-26, 0, 0]) 
	H_yBeltClam_print();

}



/*------------------------------------assembly--------------------------------*/
module _H_yBeltClam_assembly() {
	translate([-Ybc_strongWallThickness -(Ybc_belt_thickness+Ybc_belt_tolerance[0])/2, -4, -( Ybc_belt_width+Ybc_belt_tolerance[2]+Ybc_belt_topOffset)]) {
		H_yBeltClam();
		translate([Ybc_strongWallThickness+1,  Ybc_genWallThickness+m3_nut_diameter/2, +Ybc_belt_tolerance[2]/2]) 
		yBeltClamp_beltProtector();
		translate([Ybc_strongWallThickness/2, -Ybc_belt_thickness, (Ybc_belt_width+Ybc_belt_tolerance[2])/2]) 
		rotate(a=90,v=X) 
		beltClamp();
	}
}

module H_yBeltClamBack_assembly() {
	rotate(a=180,v=Z) 
	_H_yBeltClam_assembly();
}

module H_yBeltClamFront_assembly() {
	mirror([1, 0, 0])  
	_H_yBeltClam_assembly();
}

if (Ybc_mode == "assembly"){
	//H_yBeltClam_assembly();
	H_yBeltClamBack_assembly();
}