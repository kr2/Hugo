/* H-X-End [Xe]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * derivative of the original design by abdrumm for the PrintrBot
 */

include <config.scad>
include <units.scad>
include <metric.scad>
include <teardrop.scad>
include <barbell.scad>
include <roundEdges.scad>

/*------------------------------------general---------------------------------*/
Xe_mode = "-";
//Xe_mode = "printSet"; $fn=24*4;  // can be print or inspect [overlays the Xe_model with the original Xe_model] (uncomment next line)
//Xe_mode = "print Left"; $fn=24*4;
//Xe_mode = "print Reight"; $fn=24*4;
Xe_mode = "inspect";
//Xe_mode = "assembly";


Xe_outline           = [56.33, 49, 43.712];   // absolute Xe_outline [x,y,z]

Xe_Z_nutTrap_pos     = [23.27, (45.45+30.56)/2+1]; //[x,y] // pos of the vertical nutrap with spring thing
Xe_Z_bearingHole_dia = c_zAxis_lber_diam; // bearing hole diameter
Xe_Z_bearingHole_pos = [23.27, Xe_Z_bearingHole_dia/2]; //[x,y] // pos of the vertical bearing holder

Xe_X_RodHoles_pos    =  [ // x direction rod hole positions 
						   [9.08, 9.34],//[x,z] // bottom// reference
						   [9.08, 34.72]//[x,z] // top
				    	];
Xe_X_Rod_dia         = 8.1; // x direction diameter
Xe_X_Rod_depth       = 37.5; // x direction rode hole depth


Xe_m8_diameter       = 8.5; // m8 rod diameter
//metric.scad: m8_nut_diameter   = m8_nut_diameter; // m8 nut diameter (one vertical edge to the other) !!! this is not the wrench width !!!
Xe_gen_wall         = 3.25; // general  wall for different walls

Xe_overhang_angle    = 20;

/*------------------------------------idler-----------------------------------*/

Xe_idle_hole_pos   = [Xe_outline[1]/2, 14]; //[y,z] // postion of the idler hole
Xe_idle_hole_dia   = 8.25; // diameter of the idler hole
Xe_idle_hole_depth = 17.5; // depth of the idler hole


/*------------------------------------motorholder-----------------------------*/
Xe_motor_xdirBar_size     = [4.22, 5.39]; //[y,z] // size of the suport bares betwen the x end and the motor plate
Xe_motor_plate_thick      = 3; // motor plate Xe_thickness
Xe_motor_cutout_diameter  = 27.5; // diameter of the coutout around the motoraxis
Xe_motor_holes_centerDist = 43.841/2; // distace of the motor holes from the motor axis center
Xe_motor_holes_diameter   = 3.2; // motor hole diameter


/*------------------------------------elongated hole--------------------------*/
// lower hole could be elongeteded to compensate inaccuracies, which ouccour by the fact that the carriage beearing holes are printed in the other direction

Xe_elongHole_addDia = 1.0;



/******************************************************************************/ 
/*                                  implementation                            */
/******************************************************************************/


Xe_X_BlockSize = [min(Xe_Z_nutTrap_pos[0]-m8_nut_diameter/2,Xe_Z_bearingHole_pos[0]-Xe_Z_bearingHole_dia/2),Xe_outline[1],Xe_outline[2]];





module H_x_End(isIdle = false, isMotor = false,bottomRounded=false,adjustable_z_stop=false,elongetededLowerHole = true) {

	//x belt
	xb_r1=Xe_X_RodHoles_pos[0][1]; // bottom
	xb_r2=Xe_outline[2]-Xe_X_RodHoles_pos[1][1]; // top


	if (adjustable_z_stop) {
		translate([0, Xe_outline[1]+5, 0]) 
			z_stop();
	}

	intersection() {
		cube(size=Xe_outline, center=false);
		
		difference()
		{
			union ()
			{
				//Nut Trap
				translate([Xe_Z_nutTrap_pos[0],Xe_Z_nutTrap_pos[1],0]) 
					cylinder(h=Xe_outline[2],r= (m8_nut_wallDist/2+Xe_gen_wall)/cos(30) ,$fn=6);

				// z rod hole
				translate(Xe_Z_bearingHole_pos) 
					cylinder(r=Xe_Z_bearingHole_dia/2+Xe_gen_wall,h=Xe_outline[2],center=false,$fn=48);

				// x rod solid
				translate([Xe_X_RodHoles_pos[0][0], Xe_outline[1], Xe_X_RodHoles_pos[0][1]])  rotate(a=90,v=X)  rotate(a=90,v=Z) linear_extrude(height=Xe_outline[1])
					barbell(xb_r1,xb_r2,20,50,abs(Xe_X_RodHoles_pos[0][1]-Xe_X_RodHoles_pos[1][1]));
				
				difference() {
					translate([Xe_X_RodHoles_pos[0][0], 0, 0]) 
						cube(size=[Xe_Z_bearingHole_pos[0]-Xe_X_RodHoles_pos[0][0], Xe_outline[1], Xe_outline[2]], center=false);
					translate([Xe_Z_bearingHole_pos[0], Xe_outline[1]/2, -OS])
						cylinder(r=Xe_Z_bearingHole_pos[0]-xb_r1*2, h=Xe_outline[2]+OS, center=false); 
				}

				if (isIdle) {
					//idler Xe_outline
					translate([Xe_Z_bearingHole_pos[0]+Xe_Z_bearingHole_dia/2+Xe_gen_wall-Xe_idle_hole_depth/2, Xe_idle_hole_pos[0], Xe_idle_hole_pos[1]]) 
						cube(size=[Xe_idle_hole_depth, abs(Xe_X_RodHoles_pos[0][1]-Xe_X_RodHoles_pos[1][1]), Xe_idle_hole_dia+2*Xe_gen_wall], center=true);
						//cylinder(r=Xe_idle_hole_dia/2+Xe_gen_wall, h=Xe_idle_hole_depth, center=false);
				}
				

				if (isMotor) {
					// x dir bars
					for (y=[0,Xe_outline[1]-Xe_motor_xdirBar_size[0]]) {
						for (z=[0,Xe_outline[2]-Xe_motor_xdirBar_size[1]]) {
							translate([+Xe_X_RodHoles_pos[0][0], y, z]) 
								cube(size=[Xe_outline[0]-Xe_X_RodHoles_pos[0][0], Xe_motor_xdirBar_size[0], Xe_motor_xdirBar_size[1]], center=false);
						}
					}

					// motor plate
					translate([Xe_outline[0]-Xe_motor_plate_thick, 0, 0])
						cube(size=[Xe_motor_plate_thick, Xe_outline[1], Xe_outline[2]], center=false);

					// suport cylinder
					for (y=[Xe_motor_xdirBar_size[0]/2,Xe_outline[1]-Xe_motor_xdirBar_size[0]/2]) 
					translate([Xe_outline[0]-Xe_motor_plate_thick, y,0])
						cylinder(r=Xe_motor_xdirBar_size[0]/2, h=Xe_outline[1], center=false, $fn=24);
				}

				if (!bottomRounded) {
					cube(size=[Xe_X_RodHoles_pos[0][0], Xe_outline[1], Xe_X_RodHoles_pos[0][1]], center=false);
	
				}
				
			}

			//nut Rod hole.
			difference()
			{
				translate([Xe_Z_nutTrap_pos[0],Xe_Z_nutTrap_pos[1],39.5]) 
					cylinder(h=90,r=m8_nut_diameter/2,$fn=6,center=true);
				translate([Xe_Z_nutTrap_pos[0],Xe_Z_nutTrap_pos[1],8.5]) 
					cylinder(h=4,r=m8_nut_diameter/2+Xe_gen_wall,$fn=6,center=true);
			}
			translate([Xe_Z_nutTrap_pos[0],Xe_Z_nutTrap_pos[1],52]) 
				cylinder(h=90,r=Xe_m8_diameter/2,$fn=9,center=true);

			// z rod hole
			translate(Xe_Z_bearingHole_pos-[0,0,OS]) 
				cylinder(r=Xe_Z_bearingHole_dia/2,h=Xe_outline[2]+2*OS,center=false);

			// x block rounded edges
			roundEdge(_a=0,_r=Xe_X_Rod_dia/2,_l=Xe_outline[2],_fn=100);
			translate([0, Xe_outline[1], 0]) 
				roundEdge(_a=-90,_r=Xe_X_BlockSize[0],_l=Xe_outline[2],_fn=100);

			// x rod holes
			if (!elongetededLowerHole) {
				for (i=Xe_X_RodHoles_pos) 
				translate([i[0], -OS, i[1]])  rotate(a=-90,v=X) 
					cylinder(r=Xe_X_Rod_dia/2, h=Xe_X_Rod_depth, center=false,$fn=48);
				
			} else {
				translate([Xe_X_RodHoles_pos[1][0], -OS, Xe_X_RodHoles_pos[1][1]])  rotate(a=-90,v=X) 
					cylinder(r=Xe_X_Rod_dia/2, h=Xe_X_Rod_depth, center=false,$fn=48);

				// elongetated one
				translate([Xe_X_RodHoles_pos[0][0], -OS, Xe_X_RodHoles_pos[0][1]-Xe_elongHole_addDia/2])  rotate(a=-90,v=X) 
					cylinder(r=Xe_X_Rod_dia/2, h=Xe_X_Rod_depth, center=false,$fn=48);
				translate([Xe_X_RodHoles_pos[0][0], -OS, Xe_X_RodHoles_pos[0][1]+Xe_elongHole_addDia/2])  rotate(a=-90,v=X) 
					cylinder(r=Xe_X_Rod_dia/2, h=Xe_X_Rod_depth, center=false,$fn=48);
				translate([Xe_X_RodHoles_pos[0][0]-Xe_X_Rod_dia/2, -OS, Xe_X_RodHoles_pos[0][1]-Xe_elongHole_addDia/2])
					cube(size=[Xe_X_Rod_dia, Xe_X_Rod_depth, Xe_elongHole_addDia], center=false);
			}


			if (isIdle) {
				//idler coutout
				translate([Xe_Z_bearingHole_pos[0]+Xe_Z_bearingHole_dia/2+Xe_gen_wall+OS, Xe_idle_hole_pos[0], Xe_idle_hole_pos[1]])  rotate(a=-90,v=Y) 
					cylinder(r=Xe_idle_hole_dia/2, h=Xe_idle_hole_depth, center=false, $fn=8);
			}

			if (isMotor) {
				// motor ceter coutout
				translate(Xe_outline/2+[Xe_outline[0]/2-Xe_motor_plate_thick-OS,0,0]) 
					teardrop (r=Xe_motor_cutout_diameter/2,h=Xe_motor_plate_thick+2,top_and_bottom=false);

				// rounded edges
				translate([Xe_outline[0], 0, 0]) 
					roundEdge(_a=90,_r=Xe_motor_plate_thick,_l=Xe_outline[2]+OS,_fn=100);
				translate([Xe_outline[0], Xe_outline[1], 0]) 
					roundEdge(_a=180,_r=Xe_motor_plate_thick,_l=Xe_outline[2],_fn=100);

				// motor holes
				for (a=[45:90:350]) {
					translate(Xe_outline/2+[Xe_outline[0]/2-Xe_motor_plate_thick-OS,0,0]) 
					rotate(a=a,v=X) 
					translate([0, Xe_motor_holes_centerDist, 0]) 
					rotate(a=90,v=Y) 
						cylinder(r=Xe_motor_holes_diameter/2, h=Xe_motor_plate_thick+2, center=false, $fn=12);
				}
				
			}
			if (!bottomRounded) {
				translate([tan(Xe_overhang_angle)*Xe_X_RodHoles_pos[0][1], 0, 0]) 
				rotate(a=-Xe_overhang_angle+180,v=Y) 
				translate([0, 0, - Xe_X_RodHoles_pos[0][1]*2]) 
					cube(size=[Xe_outline[0], Xe_outline[1], Xe_X_RodHoles_pos[0][1]*4], center=false);
				
			}
			
		}
	}
}

if (Xe_mode == "inspect") {
	H_x_End(isMotor=true,,adjustable_z_stop=true);
}
module H_x_End_print() {
	translate([-Xe_outline[1]/2, 0, 0]) 
	H_x_End(isMotor=true,adjustable_z_stop=true,elongetededLowerHole = false);

	translate([-Xe_outline[1]/2,-3, 0]) 
	mirror([0, 1, 0]) 
		H_x_End(isIdle=true,elongetededLowerHole = false);
}
if (Xe_mode == "printSet") 
	H_x_End_print();

if (Xe_mode == "print Left") {
	H_x_End(isMotor=true,adjustable_z_stop=true,elongetededLowerHole = false);
}
if (Xe_mode == "print Reight") {
	mirror([0, 1, 0]) 
		H_x_End(isIdle=true,elongetededLowerHole = false);
}

/*------------------------------------assembly--------------------------------*/
include <basicMetalParts.scad>
include <BearingGuide.scad>
include <motors.scad>

module H_x_End_idle_assembly() {
	translate([-Xe_Z_bearingHole_pos[1],-Xe_Z_bearingHole_pos[0], 0]) 
	rotate(a=90,v=Z) 
	mirror([0, 1, 0]) {
		H_x_End(isIdle=true,elongetededLowerHole = false);

		translate([2 + 7 + 2 + m8_nut_heigth + Xe_Z_bearingHole_pos[0]+Xe_Z_bearingHole_dia/2+Xe_gen_wall+OS, Xe_idle_hole_pos[0], Xe_idle_hole_pos[1]])  
		rotate(a=-90,v=Y) 
			threadedRod(r=4, h=Xe_idle_hole_depth + 2 + 7 + 2 + m8_nut_heigth, center=false,info = "x end idler bearing holder rod");

		translate([1.5+Xe_Z_bearingHole_pos[0]+Xe_Z_bearingHole_dia/2+Xe_gen_wall+OS, Xe_idle_hole_pos[0], Xe_idle_hole_pos[1]])  
		rotate(a=90,v=Y) 
			bearGuid_ass();
	}
}

module H_x_End_motor_assembly() {
	rotate(a=90,v=Z) 
	translate([-Xe_Z_bearingHole_pos[0],-Xe_Z_bearingHole_pos[1], 0]) 
	{
		H_x_End(isMotor=true,adjustable_z_stop=true,elongetededLowerHole = false);

		translate([Xe_outline[0], Xe_outline[1]/2, Xe_outline[2]/2]) 
		rotate(a=-90,v=Y) 
		stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
	}
}

if (Xe_mode == "assembly"){
	//H_x_End_idle_assembly();
	H_x_End_motor_assembly();
}


/******************************************************************************/ 
/*                                  helper foo                                */
/******************************************************************************/


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





Xe_nema17_width            = 1.7*25.4;
Xe_thickness               = 9;
Xe_motor_mount_translation = [44-Xe_thickness,8,23.5-4.7-12+24.5];
module z_stop()
{
	z_stop_width=10;
	z_stop_height=1.8;
	z_stop_length = Xe_outline[0];
	z_stop_holderOffset =7;

	//spring
	difference() {
		union(){
			translate([z_stop_length- z_stop_width, -z_stop_holderOffset, 0]) 
			cube(size=[z_stop_width, z_stop_holderOffset+z_stop_width, z_stop_height], center=false);
			translate([z_stop_width/2,0,0])
			cube([z_stop_length-z_stop_width/2,z_stop_width,z_stop_height]);

			translate([z_stop_length- z_stop_width+OS, OS, 0]) 
				roundEdge(_a=180,_r=z_stop_width/2,_l=z_stop_height,_fn=100);
		}
		union(){
			translate([z_stop_length, z_stop_width, -OS]) 
				roundEdge(_a=180,_r=z_stop_width,_l=z_stop_height+2*OS,_fn=100);
		}
	}
	
	

	translate([z_stop_width/2,z_stop_width/2,0])
	difference()
	{
		cylinder(r=z_stop_width/2,h=z_stop_height*2,$fn=32);
	}


	difference()
	{
		union()
		{
			//screw connector
			//translate([0,-5,8])
			translate([8.75/2,5,0])
			translate([0,0,8])
			rotate(a=30,v=[0,0,1]) 
			translate([-(m3_nut_wallDist+2)/2, -(z_stop_width/2+z_stop_holderOffset+z_stop_holderOffset), 0]) 
				cube([m3_nut_wallDist+2,z_stop_width/2+z_stop_holderOffset*2,15.8-8]);

			// screw counter holder
			translate([8.75/2,5,2*z_stop_height+0.8])
				cylinder(r=m3_nut_diameter/2+1.28,h=15.8-2*z_stop_height-0.8-7.8-0.8,$fn=6);
			
			translate([8.75/2,5,0])
				cylinder(r=m3_nut_diameter/2+0.3*2.1,h=15.8-1,$fn=6);
			
			translate([8.75/2,5,8])
				cylinder(r=m3_nut_diameter/2+1.28,h=7.8,$fn=6);
		}

		translate([8.75/2,5,0])
		cylinder(r=m3_diameter/2,h=8,$fn=16);

		translate([8.75/2,5,8+2+0.4])
		cylinder(r=m3_diameter/2,h=10,$fn=16);

		translate([8.75/2,5,z_stop_height])
		cylinder(r=m3_nut_diameter/2,h=8+2-z_stop_height,$fn=6);

		translate([8.75/2,5,15.8-2])
		cylinder(r=m3_nut_diameter/2,h=3,$fn=6);
	}
}

