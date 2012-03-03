/* pb-X-End
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <units.scad>
use <teardrop.scad>
/*------------------------------------general---------------------------------*/
mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//mode = "inspect";

outline           = [56.33, 47.41, 41.712];   // absolute outline [x,y,z]

Z_nutTrap_pos     = [23.27, (45.45+30.56)/2]; //[x,y] // pos of the vertical nutrap with spring thing
Z_bearingHole_pos = [23.27, 9.69]; //[x,y] // pos of the vertical bearing holder
Z_bearingHole_dia = 15.59; // bearing hole diameter

X_RodHoles_pos    = [ // x direction rod hole positions 
					   [8.08, 8.34],//[x,z] // bottom// reference
					   [8.08, 33.72]//[x,z] // top
				    ];
X_Rod_dia         = 8; // x direction diameter
X_Rod_depth       = 37.5; // x direction rode hole depth


m8_diameter       = 9; // m8 rod diameter
m8_nut_diameter   = 16.4; // m8 nut diameter (one vertical edge to the other) !!! this is not the wrench width !!!
thin_wall         = 3; // thin wall for different walls
corection         = 1.17; //correction factor for the nuttrap

/*------------------------------------idler-----------------------------------*/

idle_hole_pos   = [outline[1]/2, 14]; //[y,z] // postion of the idler hole
idle_hole_dia   = 8; // diameter of the idler hole
idle_hole_depth = 17.5; // depth of the idler hole

/*------------------------------------motorholder-----------------------------*/
motor_xdirBar_size     = [4.22, 5.39]; //[y,z] // size of the suport bares betwen the x end and the motor plate
motor_plate_thick      = 3; // motor plate thickness
motor_cutout_diameter  = 24; // diameter of the coutout around the motoraxis
motor_holes_centerDist = 43.841/2; // distace of the motor holes from the motor axis center
motor_holes_diameter   = 3; // motor hole diameter



/******************************************************************************/ 
/*                                  implementation                            */
/******************************************************************************/


X_BlockSize = [min(Z_nutTrap_pos[0]-m8_nut_diameter/2,Z_bearingHole_pos[0]-Z_bearingHole_dia/2),outline[1],outline[2]];




module pb_x_End(isIdle = false, isMotor = false) {

	//x belt
	xb_r1=X_RodHoles_pos[0][1]; // bottom
	xb_r2=outline[2]-X_RodHoles_pos[1][1]; // top

	intersection() {
		cube(size=outline, center=false);
		
		
		

		difference()
		{
			union ()
			{
				//Nut Trap
				translate([Z_nutTrap_pos[0],Z_nutTrap_pos[1],0]) 
					cylinder(h=outline[2],r=m8_nut_diameter/2+thin_wall*corection,$fn=6);

				// z rod hole
				translate(Z_bearingHole_pos) 
					cylinder(r=Z_bearingHole_dia/2+thin_wall,h=outline[2],center=false,$fn=48);

				// x rod solid
				translate([X_RodHoles_pos[0][0], outline[1], X_RodHoles_pos[0][1]])  rotate(a=90,v=X)  rotate(a=90,v=Z) linear_extrude(height=outline[1])
					barbell(xb_r1,xb_r2,20,50,abs(X_RodHoles_pos[0][1]-X_RodHoles_pos[1][1]));
				
				difference() {
					translate([X_RodHoles_pos[0][0], 0, 0]) 
						cube(size=[Z_bearingHole_pos[0]-X_RodHoles_pos[0][0], outline[1], outline[2]], center=false);
					translate([Z_bearingHole_pos[0], outline[1]/2, -OS])
						cylinder(r=Z_bearingHole_pos[0]-xb_r1*2, h=outline[2]+OS, center=false); 
				}

				if (isIdle) {
					//idler outline
					translate([Z_bearingHole_pos[0]+Z_bearingHole_dia/2+thin_wall-idle_hole_depth/2, idle_hole_pos[0], idle_hole_pos[1]]) 
						cube(size=[idle_hole_depth, abs(X_RodHoles_pos[0][1]-X_RodHoles_pos[1][1]), idle_hole_dia+2*thin_wall], center=true);
						//cylinder(r=idle_hole_dia/2+thin_wall, h=idle_hole_depth, center=false);
				}
				

				if (isMotor) {
					// x dir bars
					for (y=[0,outline[1]-motor_xdirBar_size[0]]) {
						for (z=[0,outline[2]-motor_xdirBar_size[1]]) {
							translate([+X_RodHoles_pos[0][0], y, z]) 
								cube(size=[outline[0]-X_RodHoles_pos[0][0], motor_xdirBar_size[0], motor_xdirBar_size[1]], center=false);
						}
					}

					// motor plate
					translate([outline[0]-motor_plate_thick, 0, 0])
						cube(size=[motor_plate_thick, outline[1], outline[2]], center=false);

					// suport cylinder
					for (y=[motor_xdirBar_size[0]/2,outline[1]-motor_xdirBar_size[0]/2]) 
					translate([outline[0]-motor_plate_thick, y,0])
						cylinder(r=motor_xdirBar_size[0]/2, h=outline[1], center=false, $fn=24);
					  
				}
			}

			//nut Rod hole.
			difference()
			{
				translate([Z_nutTrap_pos[0],Z_nutTrap_pos[1],39.5]) 
					cylinder(h=90,r=m8_nut_diameter/2,$fn=6,center=true);
				translate([Z_nutTrap_pos[0],Z_nutTrap_pos[1],8.5]) 
					cylinder(h=4,r=m8_nut_diameter/2+thin_wall,$fn=6,center=true);
			}
			translate([Z_nutTrap_pos[0],Z_nutTrap_pos[1],52]) 
				cylinder(h=90,r=m8_diameter/2,$fn=9,center=true);

			// z rod hole
			translate(Z_bearingHole_pos-[0,0,OS]) 
				cylinder(r=Z_bearingHole_dia/2,h=outline[2]+2*OS,center=false);

			// x block rounded edges
			roundEdge(_a=0,_r=X_Rod_dia/2,_l=outline[2],_fn=100);
			translate([0, outline[1], 0]) 
				roundEdge(_a=-90,_r=X_BlockSize[0],_l=outline[2],_fn=100);

			// x rod holes
			for (i=X_RodHoles_pos) 
			translate([i[0], -OS, i[1]])  rotate(a=-90,v=X) 
				cylinder(r=X_Rod_dia/2, h=X_Rod_depth, center=false,$fn=48);

			if (isIdle) {
				//idler coutout
				translate([Z_bearingHole_pos[0]+Z_bearingHole_dia/2+thin_wall+OS, idle_hole_pos[0], idle_hole_pos[1]])  rotate(a=-90,v=Y) 
					cylinder(r=idle_hole_dia/2, h=idle_hole_depth, center=false, $fn=24);
			}

			if (isMotor) {
				// motor ceter coutout
				translate(outline/2+[outline[1]/2,0,0]) 
					teardrop (r=motor_cutout_diameter/2,h=motor_plate_thick+2,top_and_bottom=false);

				// rounded edges
				translate([outline[0], 0, 0]) 
					roundEdge(_a=90,_r=motor_plate_thick,_l=outline[2]+OS,_fn=100);
				translate([outline[0], outline[1], 0]) 
					roundEdge(_a=180,_r=motor_plate_thick,_l=outline[2],_fn=100);

				// motor holes
				for (a=[45:90:350]) {
					translate(outline/2+[outline[1]/2,0,0]) 
					rotate(a=a,v=X) 
					translate([0, motor_holes_centerDist, 0]) 
					rotate(a=90,v=Y) 
						cylinder(r=motor_holes_diameter/2, h=motor_plate_thick+2, center=false, $fn=12);
				}
				
			}
			
		}
	}
}
if (mode == "inspect") {
	translate([outline[0]/2, outline[1]/2, 0]) 
		%import_stl("pb-X-Motor-v2.stl", convexity = 5);
	pb_x_End();

}
module pb_x_End_print() {
	translate([-outline[1]/2, 0, 0]) 
	pb_x_End(isMotor=true);

	translate([-outline[1]/2,-3, 0]) 
	mirror([0, 1, 0]) 
		pb_x_End(isIdle=true);
}
if (mode == "print") 
	pb_x_End_print();


// ring with inner radius r and w as witth and h as heigt
module ring(r,w,h,center=false){
	difference() {
		union () {
			cylinder(r=r+w,h=h, center=center);
		}
		union () {
			translate([0, 0, -OS]) 
			cylinder(r=r,h=h+2*OS, center=center);
		}
	}
}

module roundEdge(_a=0,_r=1,_l=1,_fn=100){
	rotate (a=[0,0,_a]){
		translate(v=[_r,_r,0]){
			rotate (a=[0,0,0]) rotate (a=[0,0,180]){
				difference() {
					translate (v=[-OS/2,-OS/2,-OS/2])
						cube (size = [_r+OS,_r+OS,_l+OS],center=false );
					translate (v=[0,0,-OS*2/2])
						cylinder (h = _l+OS*2, r=_r, center = false, $fn=_fn);
				}
			}
		}
	}
}


module barbell (r1,r2,r3,r4,separation) 
{
	x1=[0,0];
	x2=[separation,0];
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
	difference ()
	{
		union()
		{
			translate(x1)
			circle (r=r1);
			translate(x2)
			circle(r=r2);
			polygon (points=[x1,x3,x2,x4]);
		}
		translate(x3)
		circle(r=r3,$fa=5);
		translate(x4)
		circle(r=r4,$fa=5);
	}
}


function triangulate (point1, point2, length1, length2) = 
point1 + 
length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b)); 

function rotated(a)=[cos(a),sin(a),0];

