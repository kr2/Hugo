/* A-X-Carriage
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <nuts_and_bolts.scad>;
include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <A-Y-beltClamp.scad>

/*------------------------------------general---------------------------------*/
mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//mode = "inspect";
//$fn=96;

axis_dist = 25.38;
genWallThickness = 2.5;
strongWallThickness = 5;

slot_width = 5;

horizontalSuportThickness = 0.3;
verticalSupportThickness = 0.7;

/*------------------------------------linear bearings-------------------------*/
lber_length = 24;
lber_diam = 15.3;


/*------------------------------------notch-----------------------------------*/
// connecot notch to the xtruder holder
notch_width = 5.4;
notch_depth = 1.2;
notch_lengt = 24 + 2.5 + 0.5;

/*------------------------------------xtruder carriag holes-------------------*/
holes_diam = m4_diameter;
holes_dist = 18;

/*------------------------------------rod-------------------------------------*/
rod_diam = 8.5;

/*------------------------------------belt------------------------------------*/
belt_axisYdir_dist = 30; // distece between center x axis and nerest belt edge
belt_axisZdir_offset = -5; // distece between center x axis and toothed side of the belt in z dir
belt_thickness = 2.5;
belt_width = 6 + 1;
belt_teethDist = 5;
belt_teethDepth = 1.5;
belt_tolerance = [1,2,1]; //[t,w,-1]

beltClamp_depth = 10;


/*------------------------------------internals-------------------------------*/
// belt connector
beltClamp_beltHole = [belt_thickness+belt_tolerance[0],belt_width+belt_tolerance[1],-1];
beltClamp_center_height = genWallThickness+m3_nut_wallDist;
beltClamp_width = belt_width+belt_tolerance[1]+m3_diameter*2+m3_nut_diameter;
beltClamp_heigth = belt_thickness+belt_tolerance[0]+genWallThickness+m3_nut_wallDist;

xdir = axis_dist+lber_diam+2*genWallThickness;
ydir = lber_diam+2*genWallThickness;
zdir = lber_length*2+genWallThickness;

matCoutout_scale = (lber_length/2)/(axis_dist/2+lber_diam/2+genWallThickness); // material coutout scale
matCoutout_rounded_r = xdir/2;


belt_axisDist = distance1D(belt_axisYdir_dist+belt_width/2,belt_axisZdir_offset+(beltClamp_center_height+beltClamp_beltHole[0])/2);
belt_holder_angle = atan((belt_axisZdir_offset+(beltClamp_center_height+beltClamp_beltHole[0])/2)/(belt_axisYdir_dist+belt_width/2));



module A_x_Carriage(hasSupport = true, hasBeltConnector = true) {

	
	difference() {
		union(){
			for (i=[-axis_dist/2,axis_dist/2]) 
			translate([i, 0, 0]) 
				cylinder(r=lber_diam/2+genWallThickness, h=lber_length*2+genWallThickness, center=false);
			translate([0, 0, lber_length+genWallThickness/2]) 
				cube(size=[axis_dist, lber_diam+2*genWallThickness, lber_length*2+genWallThickness], center=true);

			if (hasBeltConnector) {
				union() {
					intersection() {
						translate([-axis_dist/2, 0, 0]) 
						rotate(a=90-belt_holder_angle,v=Z) 
						rotate(a=-90,v=Y)
						linear_extrude(height=zdir)
							barbell(beltClamp_width/2,beltClamp_width/2,zdir*0.5,zdir*0.55,zdir+2*OS);
			
						linear_extrude(height=zdir)
						translate([-axis_dist/2, 0, 0]) 
						rotate(a=-belt_holder_angle,v=Z) 
						rotate(a=-90,v=[0,0,1]) 
							barbell((lber_diam+genWallThickness*2)/2,beltClamp_width/2,belt_axisYdir_dist*0.35,belt_axisYdir_dist*0.3,belt_axisDist);
					}

					// place for tabel for conectors
					for (i=[0,zdir- beltClamp_depth]) 
					translate([-(axis_dist/2+belt_axisZdir_offset), -(belt_axisYdir_dist+belt_width/2), 0]){//belt center
						translate([-beltClamp_width, -(beltClamp_width-beltClamp_depth)/2, i]) {
							cube(size=[beltClamp_width, beltClamp_width-beltClamp_depth,beltClamp_depth], center=false);
						}
						for (c=[-(beltClamp_width-beltClamp_depth)/2,(beltClamp_width-beltClamp_depth)/2])
						translate([-beltClamp_width-(beltClamp_center_height+beltClamp_beltHole[0])/2, c, i+beltClamp_depth/2])
						rotate(a=90,v=Y) 
							cylinder(r=beltClamp_depth/2, h=beltClamp_width, center=false);
					}
				}
				
				
				
				
			
			}
		}
		union(){
			if (hasBeltConnector) {
				// top coutoff
				translate([-(axis_dist/2+belt_axisZdir_offset), -(belt_axisYdir_dist+belt_width/2), 0]){ // center belt 
					// tabel center coutout
					*translate([-beltClamp_width, -beltClamp_width/2, +beltClamp_depth]) {
						cube(size=[beltClamp_width, beltClamp_width, zdir-beltClamp_depth*2], center=false);
						translate([beltClamp_width/2, beltClamp_width, 0]) 
							roundEdge(_a=0,_r=beltClamp_width/2,_l=zdir-2*beltClamp_depth,_fn=100);
					}
					// tabel top coutout
					translate([-beltClamp_width-beltClamp_heigth, -beltClamp_width/2-OS, -OS]) {
						cube(size=[beltClamp_width, beltClamp_width+OS*2, zdir+OS*2], center=false);
						translate([beltClamp_width/8*7, beltClamp_width, 0]) 
							roundEdge(_a=0,_r=beltClamp_width/8,_l=zdir+2*OS,_fn=100);
					}

					//belt coutout
					for (i=[-OS,zdir- beltClamp_depth-OS])
					translate([-(belt_thickness+belt_tolerance[0]), -(belt_width+belt_tolerance[1])/2, i])  
						cube(size=[belt_thickness+belt_tolerance[0], belt_width+belt_tolerance[1], beltClamp_depth+2*OS], center=false);

					translate([-beltClamp_width, -(belt_width+belt_tolerance[1])/2, beltClamp_depth])  
						cube(size=[beltClamp_width*2, belt_width+belt_tolerance[1], zdir- beltClamp_depth*2], center=false);
					
				} 
				
				translate([-(axis_dist/2+belt_axisZdir_offset), -(belt_axisYdir_dist+belt_width/2), 0]){//belt center bottom
					for (i=[0,zdir- beltClamp_depth]) {
						
						for (c=[-(beltClamp_width-beltClamp_depth)/2,(beltClamp_width-beltClamp_depth)/2]){
							// belt fixiating screw holes
							translate([-beltClamp_width/2-beltClamp_beltHole[0], c, i+beltClamp_depth/2])
							rotate(a=90,v=Y) 
								cylinder(r=m3_diameter/2, h=beltClamp_width+OS*2, center=false,$fn=12);
							// eleongeteated nuttraps
							translate([-beltClamp_beltHole[0]-beltClamp_center_height/4-m3_elongNtt_height/2, c, i+beltClamp_depth/2])
							rotate(a=90,v=Y) 
								cylinder(r=m3_elongNtt_diameter/2, h=m3_elongNtt_height, center=false,$fn=6); 
							
						}

						// belt tentener holes
						translate([-(beltClamp_center_height)/2-beltClamp_beltHole[0], 0, i-OS])
							cylinder(r=m3_diameter/2, h=beltClamp_depth+2*OS, center=false,$fn=12);
					} 
					//belt tenter holes
					for (i=[beltClamp_depth- m3_nut_heigth, zdir-beltClamp_depth-OS]) 
					translate([-(beltClamp_center_height)/2-beltClamp_beltHole[0], 0, i])
					rotate(a=30,v=[0,0,1]) 
						cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth+OS, center=false,$fn=6); 

					// elengeteated nuttraps
					for (i=[-OS,zdir-beltClamp_depth/2]) 
					for (c=[-(beltClamp_width-beltClamp_depth)/2,(beltClamp_width-beltClamp_depth)/2])// center screws
					translate([-beltClamp_beltHole[0]-beltClamp_center_height/4-m3_elongNtt_height/2, c- m3_elongNtt_wallDist/2, i]) 
						cube(size=[m3_elongNtt_height, m3_elongNtt_wallDist, beltClamp_depth], center=false);
				}
				
				
			}

			// slot
			translate([0, 0, zdir/2])
				cube(size=[axis_dist, slot_width, zdir+2*OS], center=true); 

			//bearin coutout
			translate([-axis_dist/2, 0, -OS])
				difference() {
					cylinder(r=lber_diam/2, h=lber_length*2+genWallThickness+2*OS, center=false);
				 	*translate([0, 0, lber_length])
				 		_bearingStop(); 
				} 
			translate([axis_dist/2, 0, -OS])
				difference() {
					cylinder(r=lber_diam/2, h=lber_length*2+genWallThickness+2*OS, center=false);
				 	*translate([0, 0, lber_length/2])
				 		_bearingStop(); 
				} 

			//material coutout
			for (i=[0,lber_length*2+genWallThickness]){
				translate([axis_dist/2+lber_diam/2+genWallThickness, 0, i])
				scale([1, 1, matCoutout_scale])
				rotate(a=90,v=X) 
					cylinder(r=matCoutout_rounded_r, h=lber_diam+2*genWallThickness +2*OS, center=true,$fn=48); 			
			}

			//notch coutout
			translate([0, ydir/2- notch_depth/2+OS, zdir/2]){ 
				cube(size=[notch_width, notch_depth, notch_lengt], center=true);
				for (i=[-notch_width/2,notch_width/2])
				translate([i-notch_depth/2-0.1, notch_depth/2, 0]) 
				rotate(a=-30,v=[0,0,1]) 
					triangle(l=notch_depth,h=notch_lengt+OS);
			}

			// screw holes
			for (i=[zdir/2- holes_dist/2,zdir/2+ holes_dist/2]) 
			translate([0, 0, i]) {
				rotate(a=90,v=X) 
					cylinder(r=holes_diam/2, h=ydir+2*OS, center=true,$fn=24);
				translate([0, -ydir/2-OS, 0]) 
				rotate(a=-90,v=X) 
				rotate(a=30,v=Z) 
					cylinder(r=m4_nut_diameter/2, h=m4_nut_heigth, center=false,$fn=6);

			}
		}
	}

	if (hasSupport) {
		// lower coutout suport
		intersection() {
			union() {
				for (i=[-lber_diam/2- genWallThickness:genWallThickness*2: lber_diam/2+genWallThickness]) 
				translate([xdir/4, i, matCoutout_rounded_r*matCoutout_scale/2]) 
					cube(size=[matCoutout_rounded_r, verticalSupportThickness, matCoutout_rounded_r*matCoutout_scale], center=true);
			}
			translate([axis_dist/2+lber_diam/2+genWallThickness, 0, 0])
					scale([1, 1, matCoutout_scale])
					rotate(a=90,v=X) 
						cylinder(r=matCoutout_rounded_r, h=lber_diam+2*genWallThickness +2*verticalSupportThickness+2*OS, center=true,$fn=48); 			
		}
		intersection() {
			translate([xdir/4, 0, matCoutout_rounded_r*matCoutout_scale/2]) 
				cube(size=[matCoutout_rounded_r, ydir+2*OS, matCoutout_rounded_r*matCoutout_scale], center=true);
			translate([axis_dist/2+lber_diam/2+genWallThickness, 0, 0])
			scale([1, 1, matCoutout_scale])
			rotate(a=90,v=X) 
			difference() {
				cylinder(r=matCoutout_rounded_r, h=lber_diam+2*genWallThickness +2*verticalSupportThickness, center=true,$fn=48);
				cylinder(r=matCoutout_rounded_r- horizontalSuportThickness/matCoutout_scale, h=lber_diam+2*genWallThickness +2*verticalSupportThickness+2*OS, center=true,$fn=48);
			}
		}

		// bottom plate for better sticking of the vertikal support
		translate([0, -lber_diam/2- genWallThickness, 0])  
			cube(size=[matCoutout_rounded_r, lber_diam+2*genWallThickness, horizontalSuportThickness], center=false);

		// top nuttrap for belt tentner support
		translate([-(axis_dist/2+belt_axisZdir_offset), -(belt_axisYdir_dist+belt_width/2), 0]) {  // center belt
			translate([-(beltClamp_center_height)/2-beltClamp_beltHole[0], 0, zdir- beltClamp_depth]){
				translate([0, 0, m3_nut_heigth]) 
					cylinder(r=m3_nut_diameter/2 + OS, h=horizontalSuportThickness, center=false); 
				
				cylinder(r=m3_nut_diameter*0.6, h=verticalSupportThickness, center=false);
			}
		}


	}
}

module _bearingStop() {
	difference() {
		cylinder(r=lber_diam/2+2*OS, h=genWallThickness, center=false);
		translate([0, 0, horizontalSuportThickness]) 
		cylinder(r=rod_diam/2, h=genWallThickness- horizontalSuportThickness+OS, center=false);
	}
}
//!union(){_bearingStop();}


if (mode == "inspect") {
	A_x_Carriage(hasSupport = false);

	translate([-(axis_dist/2+belt_axisZdir_offset), -(belt_axisYdir_dist+belt_width/2), 0]){//belt center bottom
		for (i=[0,zdir- beltClamp_depth]) 
		translate([-beltClamp_width/2-beltClamp_beltHole[0]- belt_thickness, 0, i+beltClamp_depth/2])
		rotate(a=90,v=Y) 
			carr_beltClamp();

		for (i=[[beltClamp_depth+1,0],[zdir-beltClamp_depth-1,180]]) 
		translate([-beltClamp_center_height, 0, i[0]]) 
		rotate(a=i[1],v=X) 
		rotate(a=90,v=Z) 
		translate([belt_width/2, 0, 0])//centerd 
		rotate(a=-90,v=Y) 
			yBeltClamp_beltProtector();
	}
}
module A_x_Carriage_print() {
	A_x_Carriage();
}
if (mode == "print") {
	A_x_Carriage_print();

	for (i=[0, beltClamp_depth+1]) 
	translate([belt_width+i, -lber_diam*2-3, 0]){
		carr_beltClamp();
		translate([0,beltClamp_width/2+4.5 , 0]) 
		rotate(a=-90,v=Y) 
		yBeltClamp_beltProtector();
	}
}



module triangle(l,h){
	translate(v=[2*l/3,0,0]) rotate (a=180, v=[0,0,1])
	cylinder(r=2*l/3,h=h,center=true,$fn=3);
}



module carr_beltClamp() {
	holeDist = beltClamp_width-beltClamp_depth;
	difference() {
		union(){
			translate([0, 0, genWallThickness/2]) 
			cube(size=[beltClamp_depth, beltClamp_width- beltClamp_depth, genWallThickness], center=true);
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, 0]) { 
				cylinder(r=beltClamp_depth/2, h=genWallThickness, center=false,$fn=48);
			}

			for (i=[-beltClamp_depth/2+ belt_teethDist/4 : belt_teethDist: beltClamp_depth/2])
			translate([i, -beltClamp_beltHole[1]/2, genWallThickness-OS])  
				cube(size=[belt_teethDist/2, beltClamp_beltHole[1], belt_teethDepth], center=false);
		}
		union(){
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, -OS]) { 
				cylinder(r=m3_diameter/2, h=genWallThickness+2*OS, center=false,$fn=12);
			}
		}
	}

}
//!beltClamp();