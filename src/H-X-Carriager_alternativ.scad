/* H-X-Carriage [Xc]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 *
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * derivative of the original design by abdrumm for the PrintrBot
 */
include <config.scad>
include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <A-Y-BeltClamp.scad>

/*------------------------------------general---------------------------------*/
Xc_mode = "-";
//Xc_mode = "print"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
//Xc_mode = "inspect";
//Xc_mode = "assembly";

Xc_genWallThickness          = 2.5;
Xc_strongWallThickness       = 5;

Xc_slot_width                = 2.5;

Xc_horizontalSuportThickness = 0.35;
Xc_verticalSupportThickness  = 0.7;

Xc_supportDistance           = 0.45; // suport distance for coutout


Xc_axis_dist                 = c_x_axis_dist;

/*------------------------------------linear bearings-------------------------*/
Xc_lber_length               = c_xAxis_lber_length;
Xc_lber_diam                 = c_xAxis_lber_diam;


/*------------------------------------notch-----------------------------------*/
// connecot notch to the xtruder holder
Xc_notch_width               = 5.4 + 0.5;
Xc_notch_depth               = 1.7;
Xc_notch_lengt               = 24 + 2.5 + 1.5;

/*------------------------------------xtruder carriag holes-------------------*/
Xc_holes_diam              = m4_diameter;
Xc_holes_dist              = 18;

/*------------------------------------rod-------------------------------------*/
Xc_rod_diam                = m8_diameter;

/*------------------------------------belt------------------------------------*/
Xc_belt_thickness          = c_xAxis_belt_thickness;
Xc_belt_width              = c_xAxis_belt_width;
Xc_belt_teethDist          = c_xAxis_belt_teethDist;
Xc_belt_teethDepth         = c_xAxis_belt_teethDepth;
Xc_belt_tolerance          = [1,2,1]; //[t,w,-1]
Xc_belt_axisXc_ydir_dist   = c_xAxis_beltCenter_xAxisDist - c_xAxis_belt_width/2; // distece between center x axis and nerest belt edge
Xc_belt_axisXc_zdir_offset = c_xAxis_beltTop_topxAxisDist - Xc_belt_tolerance[0]; // distece between center of the top x axis and toothed side of the belt in z dir

Xc_beltClamp_depth         = 10;

/*------------------------------------elongetated hole------------------------*/
//elongetated hole for the lower x axis beratin to compensate the different
//print directions of xEnd and this
Xc_elongHole_addDia = 0.5; // aditional distenace


/******************************************************************************/
/*                                  internal                                  */
/******************************************************************************/

// belt connector
Xc_beltClamp_beltHole      = [Xc_belt_thickness+Xc_belt_tolerance[0],Xc_belt_width+Xc_belt_tolerance[1],-1];
Xc_beltClamp_center_height = Xc_genWallThickness+m3_nut_wallDist;
Xc_beltClamp_width         = Xc_belt_width+Xc_belt_tolerance[1]+m3_diameter*2+m3_nut_diameter;
Xc_beltClamp_heigth        = Xc_belt_thickness+Xc_belt_tolerance[0]+Xc_genWallThickness+m3_nut_wallDist;

Xc_xdir                    = Xc_axis_dist+Xc_lber_diam+2*Xc_genWallThickness;
Xc_ydir                    = Xc_lber_diam+2*Xc_genWallThickness;
Xc_zdir                    = Xc_lber_length*2+Xc_genWallThickness;

Xc_matCoutout_rounded_r    = Xc_xdir/2 + Xc_elongHole_addDia;
Xc_matCoutout_scale        = (Xc_lber_length/2)/Xc_matCoutout_rounded_r; // material coutout scale


Xc_belt_axisDist           = distance1D(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2,Xc_belt_axisXc_zdir_offset+(Xc_beltClamp_center_height+Xc_beltClamp_beltHole[0])/2);
Xc_belt_holder_angle       = atan((Xc_belt_axisXc_zdir_offset+(Xc_beltClamp_center_height+Xc_beltClamp_beltHole[0])/2)/(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2));



module H_x_Carriage(hasSupport = true, hasBeltConnector = true) {


	difference() {
		union(){
			// top bearing holder
			translate([-Xc_axis_dist/2, 0, 0])
				cylinder(r=Xc_lber_diam/2+Xc_genWallThickness, h=Xc_lber_length*2+Xc_genWallThickness, center=false);

			// lower bearing holder // elongetated
			translate([Xc_axis_dist/2, 0, 0]) {
				for (i=[-Xc_elongHole_addDia/2,Xc_elongHole_addDia/2])
				translate([i, 0, 0])
					cylinder(r=Xc_lber_diam/2+Xc_genWallThickness, h=Xc_lber_length*2+Xc_genWallThickness, center=false);
				translate([0, 0, Xc_zdir/2])
				cube(size=[Xc_elongHole_addDia, Xc_ydir, Xc_zdir], center=true);
			}

			// conector cube
			translate([0, 0, Xc_lber_length+Xc_genWallThickness/2])
				cube(size=[Xc_axis_dist, Xc_lber_diam+2*Xc_genWallThickness, Xc_lber_length*2+Xc_genWallThickness], center=true);

			if (hasBeltConnector) {
				union() {
					intersection() {
						translate([-Xc_axis_dist/2, 0, 0])
						rotate(a=90-Xc_belt_holder_angle,v=Z)
						rotate(a=-90,v=Y)
						linear_extrude(height=Xc_zdir)
							barbell(Xc_beltClamp_width/2,Xc_beltClamp_width/2,Xc_zdir*0.474,Xc_zdir*0.65,Xc_zdir+2*OS);

						linear_extrude(height=Xc_zdir)
						translate([-Xc_axis_dist/2, 0, 0])
						rotate(a=-Xc_belt_holder_angle,v=Z)
						rotate(a=-90,v=[0,0,1])
							barbell((Xc_lber_diam+Xc_genWallThickness*2)/2,Xc_beltClamp_width/2,Xc_belt_axisXc_ydir_dist*0.52,Xc_belt_axisXc_ydir_dist*0.37,Xc_belt_axisDist);
					}

					// place for tabel for conectors
					for (i=[0,Xc_zdir- Xc_beltClamp_depth])
					translate([-(Xc_axis_dist/2+Xc_belt_axisXc_zdir_offset), -(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2), 0]){//belt center
						translate([-Xc_beltClamp_width, -(Xc_beltClamp_width-Xc_beltClamp_depth)/2, i]) {
							cube(size=[Xc_beltClamp_width, Xc_beltClamp_width-Xc_beltClamp_depth,Xc_beltClamp_depth], center=false);
						}
						for (c=[-(Xc_beltClamp_width-Xc_beltClamp_depth)/2,(Xc_beltClamp_width-Xc_beltClamp_depth)/2])
						translate([-Xc_beltClamp_width-(Xc_beltClamp_center_height+Xc_beltClamp_beltHole[0])/2, c, i+Xc_beltClamp_depth/2])
						rotate(a=90,v=Y)
							cylinder(r=Xc_beltClamp_depth/2, h=Xc_beltClamp_width, center=false);
					}
				}
			}
		}
		union(){
			if (hasBeltConnector) {
				// top coutoff
				translate([-(Xc_axis_dist/2+Xc_belt_axisXc_zdir_offset), -(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2), 0]){ // center belt
					// tabel center coutout
					*translate([-Xc_beltClamp_width, -Xc_beltClamp_width/2, +Xc_beltClamp_depth]) {
						cube(size=[Xc_beltClamp_width, Xc_beltClamp_width, Xc_zdir-Xc_beltClamp_depth*2], center=false);
						translate([Xc_beltClamp_width/2, Xc_beltClamp_width, 0])
							roundEdge(_a=0,_r=Xc_beltClamp_width/2,_l=Xc_zdir-2*Xc_beltClamp_depth,_fn=100);
					}
					// tabel top coutout
					translate([-Xc_beltClamp_width-Xc_beltClamp_heigth, -Xc_beltClamp_width/2-OS, -OS]) {
						cube(size=[Xc_beltClamp_width, Xc_beltClamp_width+OS*2, Xc_zdir+OS*2], center=false);
						translate([Xc_beltClamp_width/8*7, Xc_beltClamp_width, 0])
							roundEdge(_a=0,_r=Xc_beltClamp_width/8,_l=Xc_zdir+2*OS,_fn=100);
					}

					//belt coutout
					for (i=[-OS,Xc_zdir- Xc_beltClamp_depth-OS])
					translate([-(Xc_belt_thickness+Xc_belt_tolerance[0]), -(Xc_belt_width+Xc_belt_tolerance[1])/2, i])
						cube(size=[Xc_belt_thickness+Xc_belt_tolerance[0], Xc_belt_width+Xc_belt_tolerance[1], Xc_beltClamp_depth+2*OS], center=false);

					translate([-Xc_beltClamp_width, -(Xc_belt_width+Xc_belt_tolerance[1])/2, Xc_beltClamp_depth])
						cube(size=[Xc_beltClamp_width*2, Xc_belt_width+Xc_belt_tolerance[1], Xc_zdir- Xc_beltClamp_depth*2], center=false);

				}

				translate([-(Xc_axis_dist/2+Xc_belt_axisXc_zdir_offset), -(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2), 0]){//belt center bottom
					for (i=[0,Xc_zdir- Xc_beltClamp_depth]) {

						for (c=[-(Xc_beltClamp_width-Xc_beltClamp_depth)/2,(Xc_beltClamp_width-Xc_beltClamp_depth)/2]){
							// belt fixiating screw holes
							translate([-Xc_beltClamp_width/2-Xc_beltClamp_beltHole[0], c, i+Xc_beltClamp_depth/2])
							rotate(a=90,v=Y)
								cylinder(r=m3_diameter/2, h=Xc_beltClamp_width+OS*2, center=false,$fn=12);
							// eleongeteated nuttraps
							translate([-Xc_beltClamp_beltHole[0]-Xc_beltClamp_center_height/4-m3_elongNtt_height/2, c, i+Xc_beltClamp_depth/2])
							rotate(a=90,v=Y)
								cylinder(r=m3_elongNtt_diameter/2, h=m3_elongNtt_height, center=false,$fn=6);

						}

						// belt tentener holes
						translate([-(Xc_beltClamp_center_height)/2-Xc_beltClamp_beltHole[0], 0, i-OS])
							cylinder(r=m3_diameter/2, h=Xc_beltClamp_depth+2*OS, center=false,$fn=12);
					}
					//belt tenter holes
					for (i=[Xc_beltClamp_depth- m3_nut_heigth, Xc_zdir-Xc_beltClamp_depth-OS])
					translate([-(Xc_beltClamp_center_height)/2-Xc_beltClamp_beltHole[0], 0, i])
					rotate(a=30,v=[0,0,1])
						cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth+OS, center=false,$fn=6);

					// elengeteated nuttraps
					for (i=[-OS,Xc_zdir-Xc_beltClamp_depth/2])
					for (c=[-(Xc_beltClamp_width-Xc_beltClamp_depth)/2,(Xc_beltClamp_width-Xc_beltClamp_depth)/2])// center screws
					translate([-Xc_beltClamp_beltHole[0]-Xc_beltClamp_center_height/4-m3_elongNtt_height/2, c- m3_elongNtt_wallDist/2, i])
						cube(size=[m3_elongNtt_height, m3_elongNtt_wallDist, Xc_beltClamp_depth], center=false);
				}


			}

			// slot
			translate([0, 0, Xc_zdir/2])
				cube(size=[Xc_axis_dist, Xc_slot_width, Xc_zdir+2*OS], center=true);

			//bearin coutout
			translate([-Xc_axis_dist/2, 0, -OS])
				difference() {
					cylinder(r=Xc_lber_diam/2, h=Xc_lber_length*2+Xc_genWallThickness+2*OS, center=false);
				 	*translate([0, 0, Xc_lber_length])
				 		_bearingStop();
				}
			translate([Xc_axis_dist/2, 0, -OS])
				difference() {
					union() {
						for (i=[-Xc_elongHole_addDia/2,Xc_elongHole_addDia/2])
						translate([i, 0, 0])
							cylinder(r=Xc_lber_diam/2, h=Xc_zdir+2*OS, center=false);
						translate([0, 0, Xc_zdir/2])
						cube(size=[Xc_elongHole_addDia, Xc_lber_diam, Xc_zdir+2*OS], center=true);
					}
				 	*translate([0, 0, Xc_lber_length/2])
				 		_bearingStop();
				}

			//material coutout
			for (i=[0,Xc_lber_length*2+Xc_genWallThickness]){
				translate([Xc_matCoutout_rounded_r, 0, i])
				scale([1, 1, Xc_matCoutout_scale])
				rotate(a=90,v=X)
					cylinder(r=Xc_matCoutout_rounded_r, h=Xc_lber_diam+2*Xc_genWallThickness +2*OS, center=true,$fn=48);
			}

			//notch coutout
			translate([0, Xc_ydir/2- Xc_notch_depth/2+OS, Xc_zdir/2]){
				cube(size=[Xc_notch_width, Xc_notch_depth, Xc_notch_lengt], center=true);
				for (i=[-Xc_notch_width/2,Xc_notch_width/2])
				translate([i-Xc_notch_depth/2-0.1, Xc_notch_depth/2, 0])
				rotate(a=-30,v=[0,0,1])
					triangle(l=Xc_notch_depth,h=Xc_notch_lengt+OS);
			}

			// screw holes
			for (i=[Xc_zdir/2- Xc_holes_dist/2,Xc_zdir/2+ Xc_holes_dist/2])
			translate([0, 0, i]) {
				rotate(a=90,v=X)
					cylinder(r=Xc_holes_diam/2, h=Xc_ydir+2*OS, center=true,$fn=24);
				translate([0, -Xc_ydir/2-OS, 0])
				rotate(a=-90,v=X)
				rotate(a=30,v=Z)
					cylinder(r=m4_nut_diameter/2, h=m4_nut_heigth, center=false,$fn=6);

			}
		}
	}

	if (hasSupport) {
		// lower coutout suport
		translate([Xc_supportDistance, 0, 0])
		assign (Xc_matCoutout_rounded_r= Xc_xdir/2+ Xc_elongHole_addDia- Xc_supportDistance) {
			intersection() {
				union() {
					for (i=[-Xc_ydir/2:Xc_genWallThickness*2: Xc_ydir/2])
					translate([Xc_matCoutout_rounded_r/2, i, Xc_matCoutout_rounded_r*Xc_matCoutout_scale/2])
						cube(size=[Xc_matCoutout_rounded_r, Xc_verticalSupportThickness, Xc_matCoutout_rounded_r*Xc_matCoutout_scale], center=true);
				}
				translate([Xc_matCoutout_rounded_r, 0, 0])
						scale([1, 1, Xc_matCoutout_scale])
						rotate(a=90,v=X)
							cylinder(r=Xc_matCoutout_rounded_r, h=Xc_lber_diam+2*Xc_genWallThickness +2*Xc_verticalSupportThickness+2*OS, center=true,$fn=48);
			}
			intersection() {
				translate([Xc_matCoutout_rounded_r/2, 0, Xc_matCoutout_rounded_r*Xc_matCoutout_scale/2])
					cube(size=[Xc_matCoutout_rounded_r, Xc_ydir+2*OS, Xc_matCoutout_rounded_r*Xc_matCoutout_scale], center=true);
				translate([Xc_matCoutout_rounded_r, 0, 0])
				scale([1, 1, Xc_matCoutout_scale])
				rotate(a=90,v=X)
				difference() {
					cylinder(r=Xc_matCoutout_rounded_r, h=Xc_lber_diam+2*Xc_genWallThickness +2*Xc_verticalSupportThickness, center=true,$fn=48);
					cylinder(r=Xc_matCoutout_rounded_r- Xc_horizontalSuportThickness/Xc_matCoutout_scale, h=Xc_lber_diam+2*Xc_genWallThickness +2*Xc_verticalSupportThickness+2*OS, center=true,$fn=48);
				}
			}

			// bottom plate for better sticking of the vertikal support
			translate([0, -Xc_lber_diam/2- Xc_genWallThickness, 0])
				cube(size=[Xc_matCoutout_rounded_r, Xc_lber_diam+2*Xc_genWallThickness, Xc_horizontalSuportThickness], center=false);
		}

		// top nuttrap for belt tentner support
		translate([-(Xc_axis_dist/2+Xc_belt_axisXc_zdir_offset), -(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2), 0]) {  // center belt
			translate([-(Xc_beltClamp_center_height)/2-Xc_beltClamp_beltHole[0], 0, Xc_zdir- Xc_beltClamp_depth]){
				translate([0, 0, m3_nut_heigth])
					cylinder(r=m3_nut_diameter/2 + OS, h=Xc_horizontalSuportThickness, center=false);

				cylinder(r=m3_nut_diameter*0.6, h=Xc_verticalSupportThickness, center=false);
			}
		}


	}
}

module _bearingStop() {
	difference() {
		cylinder(r=Xc_lber_diam/2+2*OS, h=Xc_genWallThickness, center=false);
		translate([0, 0, Xc_horizontalSuportThickness])
		cylinder(r=Xc_rod_diam/2, h=Xc_genWallThickness- Xc_horizontalSuportThickness+OS, center=false);
	}
}
//!union(){_bearingStop();}


if (Xc_mode == "inspect") {
	H_x_Carriage(hasSupport = false);

	translate([-(Xc_axis_dist/2+Xc_belt_axisXc_zdir_offset), -(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2), 0]){//belt center bottom
		for (i=[0,Xc_zdir- Xc_beltClamp_depth])
		translate([-Xc_beltClamp_width/2-Xc_beltClamp_beltHole[0]- Xc_belt_thickness, 0, i+Xc_beltClamp_depth/2])
		rotate(a=90,v=Y)
			carr_beltClamp();

		for (i=[[Xc_beltClamp_depth+1,0],[Xc_zdir-Xc_beltClamp_depth-1,180]])
		translate([-Xc_beltClamp_center_height, 0, i[0]])
		rotate(a=i[1],v=X)
		rotate(a=90,v=Z)
		translate([Xc_belt_width/2, 0, 0])//centerd
		rotate(a=-90,v=Y)
			yBeltClamp_beltProtector();
	}
}
module H_x_Carriage_print() {
	H_x_Carriage();
	for (i=[0, Xc_beltClamp_depth+1])
	translate([Xc_belt_width+i, -Xc_lber_diam*2-3, 0]){
		carr_beltClamp();
		translate([0,Xc_beltClamp_width/2+4.5 , 0])
		rotate(a=-90,v=Y)
		yBeltClamp_beltProtector();
	}
}
if (Xc_mode == "print") {
	H_x_Carriage_print();


}

/*------------------------------------assembly--------------------------------*/
include <basicMetalParts.scad>
//include <ToothedLinearBearing.scad>

module H_x_Carriage_assembly() {
	rotate(a=180,v=Z)
	translate([-Xc_xdir/2- Xc_genWallThickness, 0, -Xc_axis_dist/2])
	rotate(a=90,v=Y) {
		H_x_Carriage(hasSupport = false);

		translate([-(Xc_axis_dist/2+Xc_belt_axisXc_zdir_offset), -(Xc_belt_axisXc_ydir_dist+Xc_belt_width/2), 0]){//belt center bottom
			for (i=[0,Xc_zdir- Xc_beltClamp_depth])
			translate([-Xc_beltClamp_width/2-Xc_beltClamp_beltHole[0]- Xc_belt_thickness, 0, i+Xc_beltClamp_depth/2])
			rotate(a=90,v=Y)
				carr_beltClamp();

			for (i=[[Xc_beltClamp_depth+1,0],[Xc_zdir-Xc_beltClamp_depth-1,180]])
			translate([-Xc_beltClamp_center_height, 0, i[0]])
			rotate(a=i[1],v=X)
			rotate(a=90,v=Z)
			translate([Xc_belt_width/2, 0, 0])//centerd
			rotate(a=-90,v=Y)
				yBeltClamp_beltProtector();
		}
	}
}

if (Xc_mode == "assembly"){
	H_x_Carriage_assembly();
}



module triangle(l,h){
	translate(v=[2*l/3,0,0]) rotate (a=180, v=[0,0,1])
	cylinder(r=2*l/3,h=h,center=true,$fn=3);
}



module carr_beltClamp() {
	holeDist = Xc_beltClamp_width-Xc_beltClamp_depth;
	difference() {
		union(){
			translate([0, 0, Xc_genWallThickness/2])
			cube(size=[Xc_beltClamp_depth, Xc_beltClamp_width- Xc_beltClamp_depth, Xc_genWallThickness], center=true);
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, 0]) {
				cylinder(r=Xc_beltClamp_depth/2, h=Xc_genWallThickness, center=false,$fn=48);
			}

			for (i=[-Xc_beltClamp_depth/2+ Xc_belt_teethDist/4 : Xc_belt_teethDist: Xc_beltClamp_depth/2-  Xc_belt_teethDist/4])
			translate([i, -Xc_beltClamp_beltHole[1]/2, Xc_genWallThickness-OS])
				cube(size=[Xc_belt_teethDist/2, Xc_beltClamp_beltHole[1], Xc_belt_teethDepth], center=false);
		}
		union(){
			for (i=[-holeDist/2,holeDist/2])
			translate([0, i, -OS]) {
				cylinder(r=m3_diameter/2, h=Xc_genWallThickness+2*OS, center=false,$fn=12);
			}
		}
	}

}
//!beltClamp();


module yBeltClamp_beltProtector() {
	difference() {
		cylinder(r=m3_nut_diameter/2, h= Xc_belt_width, center=false,$fn=48);
		translate([-m3_nut_diameter/4, 0, (Xc_belt_width)/2])
			cube(size=[m3_nut_diameter/2+OS, m3_nut_diameter+2*OS, Xc_belt_width+2*OS], center=true);
		translate([0, 0, (Xc_belt_width)/2])
		rotate(a=90,v=Y)
			cylinder(r=m3_diameter/2, h=(m3_nut_diameter)/2-1, center=false,$fn=8);
	}
}