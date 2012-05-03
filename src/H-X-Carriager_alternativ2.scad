/* H-X-Carriage_alternativ [Xc]
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
use <teardrop.scad>
include <text.scad>

/*------------------------------------general---------------------------------*/
Xc_mode = "-";
//Xc_mode = "printSet"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
//Xc_mode = "print Carriage"; $fn=24*4;
//Xc_mode = "print Beltarm"; $fn=24*4;
//Xc_mode = "inspect";
//Xc_mode = "assembly";

Xc_thinWallThickness         = 1.5;
Xc_genWallThickness          = 4;
Xc_strongWallThickness       = 5;

Xc_horizontalSuportThickness = 0.35;
Xc_verticalSupportThickness  = 1.35;
Xc_verticalSupportInterval   = 5;

Xc_supportDistance           = 0.2; // suport distance for coutout


Xc_axis_dist                 = c_x_axis_dist;

/*------------------------------------linear bearings-------------------------*/
Xc_lber_length               = c_xAxis_lber_length + 0.2; //+ 0.2 to conteract print errors
Xc_lber_diam                 = c_xAxis_lber_diam;


Xc_lber_coverRate            = 0.7; // percentage of plasic cover vs lber diam

/*------------------------------------notch-----------------------------------*/
// connecot notch to the xtruder holder
Xc_notch_width               = 5.4 + 0.5;
Xc_notch_depth               = 1.2;
Xc_notch_lengt               = 24 + 2.5 + 1.5;

/*------------------------------------xtruder carriag holes-------------------*/
Xc_holes_diam                = m3_diameter;
Xc_nut_diam                  = m3_nut_diameter;
Xc_nut_heigth                = m3_nut_heigth;
Xc_nut_wallDist              = m3_nut_wallDist;
Xc_holes_dist                = 18;

/*------------------------------------rod-------------------------------------*/
Xc_rod_diam                  = c_x_axis_smoothRod_diam;

/*------------------------------------zip ties--------------------------------*/
Xc_zipTies_width             = 4;
Xc_zipTies_thickness         = 3;

/*------------------------------------belt------------------------------------*/
Xc_belt_thickness            = c_xAxis_belt_thickness;
Xc_belt_width                = c_xAxis_belt_width;
Xc_belt_teethDist            = c_xAxis_belt_teethDist;
Xc_belt_teethDepth           = c_xAxis_belt_teethDepth;
Xc_belt_tolerance            = [1,2,1]; //[t,w,-1]

Xc_belt_axisXc_ydir_dist     = c_xAxis_beltCenter_xAxisDist; // distece between center x axis and center of the  belt
Xc_belt_axisXc_zdir_offset   = c_xAxis_beltTop_topxAxisDist; // distece between center of the top x axis and smooth side of the belt in z dir

//screws
Xc_belt_hole_diam            = m3_diameter;
Xc_belt_nut_diam             = m3_nut_diameter;
Xc_belt_nut_heigth           = m3_nut_heigth;
Xc_belt_nut_wallDist         = m3_nut_wallDist;

Xc_beltClamp_thickness       = 10;


/******************************************************************************/
/*                                  internal                                  */
/******************************************************************************/
_Xc_firstBearing_alt = Xc_lber_diam/2 + Xc_genWallThickness;

_Xc_xdir = Xc_lber_length*2+2*Xc_genWallThickness + Xc_thinWallThickness;
_Xc_zdir = Xc_lber_diam+2*Xc_genWallThickness + Xc_axis_dist;
_Xc_ydir = Xc_lber_diam + 2*Xc_genWallThickness;

_Xc_coutout_r = _Xc_zdir- Xc_lber_diam - Xc_genWallThickness - Xc_strongWallThickness;
_Xc_coutout_xdirScale = ((_Xc_xdir - Xc_lber_length - 2*Xc_genWallThickness -Xc_thinWallThickness)/2)/_Xc_coutout_r;


//belt
_Xc_beltcon_heigth = Xc_thinWallThickness + Xc_belt_nut_wallDist + Xc_thinWallThickness; // from to belt
_Xc_beltcon_thickness = Xc_beltClamp_thickness;
_Xc_beltcon_minWidth = Xc_belt_width + Xc_belt_tolerance[1] + 4*Xc_thinWallThickness + 2*Xc_belt_hole_diam;

_Xc_belt_hole_dist =  Xc_belt_width + Xc_belt_tolerance[1] + Xc_belt_hole_diam + 2*Xc_thinWallThickness;
_Xc_belthole_size = [_Xc_beltcon_thickness+2*OS, Xc_belt_width+Xc_belt_tolerance[1],Xc_belt_thickness+Xc_belt_tolerance[0] ];

_Xc_beltcon_overallHeight = _Xc_beltcon_heigth + _Xc_belthole_size[2] +Xc_thinWallThickness;



_Xc_connector_length = _Xc_xdir- _Xc_beltcon_thickness*2;
_Xc_connector_thickness = _Xc_beltcon_thickness/2 - Xc_belt_hole_diam/2;
_Xc_connector_strength = 6;
_Xc_connector_bend = 5;

_Xc_lber_cutoff_diam = Xc_lber_diam -  Xc_lber_diam * Xc_lber_coverRate;

//calc
_Xc_connecotr_r = triangle_area3Points([0,0],[_Xc_connector_length,0],[_Xc_connector_length/2,_Xc_connector_bend]);
module H_x_Carriage(hasSupport = false) {
	difference() {
		union(){
			for (i=[_Xc_firstBearing_alt,_Xc_firstBearing_alt+Xc_axis_dist])
			translate([-_Xc_xdir/2, 0, i])
				teardropFlat (r=Xc_lber_diam/2 + Xc_genWallThickness,h=_Xc_xdir,top_and_bottom=true);

			//center block
			translate([0, 0, _Xc_zdir/2])
				cube(size=[_Xc_xdir, _Xc_ydir, Xc_axis_dist], center=true);



		}
		union(){
			// bearing holes
			translate([-Xc_lber_length/2, 0, _Xc_firstBearing_alt])
			rotate(a=180,v=X)
				teardrop (r=Xc_lber_diam/2,h=Xc_lber_length,top_and_bottom=true);

			for (i=[0,1])
			rotate(a=180 * i,v=Z)
			translate([_Xc_xdir/2 - Xc_genWallThickness, 0, _Xc_firstBearing_alt+Xc_axis_dist])
			rotate(a=180,v=Z)
			rotate(a=180,v=X)
				teardrop (r=Xc_lber_diam/2,h=Xc_lber_length,top_and_bottom=true);

			//ziptie cutout
			for (i=[[0,0,_Xc_firstBearing_alt],
				    [Xc_thinWallThickness/2 + Xc_lber_length/2, 0, _Xc_firstBearing_alt + Xc_axis_dist],
					[-(Xc_thinWallThickness/2 + Xc_lber_length/2), 0, _Xc_firstBearing_alt + Xc_axis_dist]
				   ])
			translate(i)
			rotate(a=90,v=Y)
			rotate_extrude(convexity = 10)
			translate([ Xc_lber_diam/2 + Xc_thinWallThickness,0, 0])
			rotate(a=-90,v=Z)
				polygon(points=[[-Xc_zipTies_width/2,0],[Xc_zipTies_width/2,0],[Xc_zipTies_width,Xc_zipTies_thickness],[-Xc_zipTies_width,Xc_zipTies_thickness],[-Xc_zipTies_width/2,0]]);

			//axis cutout
			for (i=[_Xc_firstBearing_alt,_Xc_firstBearing_alt+Xc_axis_dist])
			translate([-_Xc_xdir/2-OS, 0, i])
			rotate(a=180,v=X)
				teardrop (r=Xc_rod_diam/2 * 1.2,h=_Xc_xdir+2*OS,top_and_bottom=true);


			//topbottom coutoff
			for (i=[(_Xc_lber_cutoff_diam + Xc_genWallThickness)/2-OS,_Xc_zdir-(_Xc_lber_cutoff_diam + Xc_genWallThickness)/2+OS])
			translate([0, 0, i])
				cube(size=[_Xc_xdir+2*OS, _Xc_ydir+2*OS, _Xc_lber_cutoff_diam+Xc_genWallThickness+OS], center=true);

			// connector screws
			for (i=[-Xc_holes_dist/2,Xc_holes_dist/2]){
				translate([i, 0, _Xc_zdir/2])
				rotate(a=90,v=X)
					cylinder(r=Xc_holes_diam/2, h=_Xc_ydir+2*OS, center=true);

				//nuttraps
				*translate([i, -_Xc_ydir/2-OS, _Xc_zdir/2])
				rotate(a=-90,v=X)
					cylinder(r=Xc_nut_diam/2, h=Xc_nut_heigth+OS, center=false,$fn=6);
			}

		//notch coutout
		translate([0,( _Xc_ydir/2- Xc_notch_depth/2+OS), _Xc_zdir/2])
		rotate(a=90,v=Y) {
			cube(size=[Xc_notch_width, Xc_notch_depth, Xc_notch_lengt], center=true);
			for (i=[-Xc_notch_width/2,Xc_notch_width/2])
				translate([i-Xc_notch_depth/2-0.1, Xc_notch_depth/2, 0])
				rotate(a=-30,v=[0,0,1])
					triangle(l=Xc_notch_depth,h=Xc_notch_lengt+OS);
			}
		}



		//round coutouts
		for (i=[-1,1])
		translate([i*_Xc_xdir/2, 0,0])
		scale([_Xc_coutout_xdirScale, 1, 1])
		rotate(a=90,v=X)
			cylinder(r=_Xc_coutout_r, h=_Xc_ydir+2*OS, center=true);


		if (Xc_mode != "inspect") {
			//logo
			*rotate(a=180,v=Z)
			translate([0, 0, _Xc_zdir-txt_z + OS])
				txt_hugo();
		}
	}
}


/******************************************************************************/
/*                                  belt                                      */
/******************************************************************************/
_Xc_beltarm_elongetatedHole_len = c_x_axis_dist * 0.4;

_Xc_beltarm_connPlat_size = [Xc_holes_dist + Xc_nut_diam + Xc_genWallThickness*2, Xc_strongWallThickness,  _Xc_beltarm_elongetatedHole_len + _Xc_beltcon_heigth + 1.5*Xc_genWallThickness];
module _beltArm() {

	translate([0, -_Xc_beltarm_connPlat_size[1]/2 - _Xc_ydir/2, -(_Xc_beltarm_elongetatedHole_len )])
	difference() {
		union(){
			translate([0, 0, _Xc_beltarm_connPlat_size[2]/2 - 1.5*Xc_genWallThickness])
				cube(size=_Xc_beltarm_connPlat_size, center=true);

		}
		union(){
			// screw
			for (i=[-1,1])
			translate([Xc_holes_dist/2*i, 0, 0]) {
				translate([0, 0, _Xc_beltarm_elongetatedHole_len/2-OS])
					cube(size=[Xc_holes_diam, _Xc_beltarm_connPlat_size[1]+2*OS, _Xc_beltarm_elongetatedHole_len+OS], center=true);

				for (j=[0,1]) {
					translate([0,0, j*_Xc_beltarm_elongetatedHole_len])
					rotate(a=30,v=Y)
					rotate(a=-90,v=X)
						cylinder(r=Xc_holes_diam/2, h=_Xc_beltarm_connPlat_size[1]+2*OS, center=true);

					translate([0, -_Xc_beltarm_connPlat_size[1]/2 - OS, j*_Xc_beltarm_elongetatedHole_len])
					rotate(a=30,v=Y)
					rotate(a=-90,v=X)
						cylinder(r=Xc_nut_diam/2, h=Xc_nut_heigth, center=false,$fn=6);
				}

				translate([0, -_Xc_beltarm_connPlat_size[1]/2 + Xc_nut_heigth/2 - OS , _Xc_beltarm_elongetatedHole_len/2-OS])
					cube(size=[Xc_nut_wallDist, Xc_nut_heigth, _Xc_beltarm_elongetatedHole_len], center=true);
			}

			translate([0, 0, -1.5*Xc_genWallThickness]) {
				for (x=[[-1,0],[1,90]])
				translate([x[0]*_Xc_beltarm_connPlat_size[0]/2, -_Xc_beltarm_connPlat_size[1]/2, 0])
					roundEdge(_a=x[1],_r=_Xc_beltarm_connPlat_size[1]/4,_l=_Xc_beltarm_connPlat_size[2],_fn=24);

				for (x=[[-1,0],[1,90]])
				translate([x[0]*_Xc_beltarm_connPlat_size[0]/2, _Xc_beltarm_connPlat_size[1]/2, 0])
				rotate(a=90,v=X)
					roundEdge(_a=x[1],_r=Xc_genWallThickness,_l=_Xc_beltarm_connPlat_size[2],_fn=24);
			}
		}
	}

	// belt clamps
	for (i=[[1,0],[-1,1]])
	translate([i[0]*(_Xc_xdir/2 - _Xc_beltcon_thickness/2 - OS), -Xc_belt_axisXc_ydir_dist, 0])
	mirror([i[1], 0, 0])
		_beltConnrector();

	//connector
	// to improve
	intersection() {
		translate([0, - Xc_belt_axisXc_ydir_dist , 0])
			cube(size=[_Xc_connector_length, _Xc_beltcon_minWidth*2 , _Xc_zdir], center=true);
		for (i=[[-1,1],[1,0]])
		translate([0, -Xc_belt_axisXc_ydir_dist  - i[0]*_Xc_connecotr_r +_Xc_beltcon_minWidth/2 + _Xc_connector_thickness/2 + _Xc_connector_bend- _Xc_connector_thickness - (_Xc_beltcon_minWidth) + i[1]*(_Xc_beltcon_minWidth- _Xc_connector_bend - _Xc_connector_thickness/2 - 0.2), - (_Xc_beltcon_overallHeight - _Xc_beltcon_heigth)])
		difference() {
			cylinder(r=_Xc_connecotr_r, h=_Xc_beltcon_overallHeight, center=false);
			translate([0, 0, -OS])
			cylinder(r=_Xc_connecotr_r-_Xc_connector_thickness , h=_Xc_beltcon_overallHeight+2*OS, center=false,$fn=24*16);
		}
	}

	*translate([0, -Xc_belt_axisXc_ydir_dist  +_Xc_beltcon_minWidth/2 + _Xc_connector_thickness/2 -_Xc_connector_thickness/2 , - (_Xc_beltcon_overallHeight - _Xc_beltcon_heigth) + _Xc_beltcon_overallHeight/2])
		cube(size=[_Xc_connector_length, _Xc_connector_thickness, _Xc_beltcon_overallHeight], center=true);

	difference() {
		union(){
			rotate(a=180,v=Z)
			translate([-Xc_strongWallThickness/2, _Xc_ydir/2,  - (_Xc_beltcon_overallHeight - _Xc_beltcon_heigth)])
				cube(size=[Xc_strongWallThickness, Xc_belt_axisXc_ydir_dist  + _Xc_beltcon_minWidth/2 + _Xc_beltcon_thickness/2- _Xc_ydir/2  - _Xc_connector_bend- _Xc_connector_thickness/2, _Xc_beltcon_overallHeight], center=false);
		}
		union(){
			// belt loop through hole
			translate([0, -Xc_belt_axisXc_ydir_dist,- _Xc_belthole_size[2]/2])
				cube(size=_Xc_belthole_size, center=true);
		}
	}


}
//!_beltArm();

module _beltConnrector() {
	difference() {
			union(){
				translate([0,0, -_Xc_belthole_size[2]-Xc_thinWallThickness]) {
					translate([-_Xc_beltcon_thickness/2, -_Xc_belt_hole_dist/2,0])
						cube(size=[_Xc_beltcon_thickness, _Xc_belt_hole_dist, _Xc_beltcon_overallHeight], center=false);

					translate([-_Xc_beltcon_thickness/2, -_Xc_belt_hole_dist/2 - _Xc_beltcon_thickness/2,0])
						cube(size=[_Xc_beltcon_thickness/2, _Xc_belt_hole_dist + _Xc_beltcon_thickness, _Xc_beltcon_overallHeight], center=false);

					for (i=[-1,1])
					translate([0, i * _Xc_belt_hole_dist/2, 0])
						cylinder(r=_Xc_beltcon_thickness/2, h=_Xc_beltcon_overallHeight, center=false);
				}
			}
			union(){
				// fixiating screw holes
				for (i=[-1,1])
				translate([0, _Xc_belt_hole_dist/2*i, 0]) {
					difference() {
						cylinder(r=Xc_belt_hole_diam/2, h=_Xc_beltcon_heigth*4, center=true);

						translate([0, 0, Xc_thinWallThickness- Xc_horizontalSuportThickness])
							cylinder(r=Xc_belt_nut_diam/2, h=Xc_belt_nut_heigth + Xc_horizontalSuportThickness, center=false,$fn=6);
					}

					assign (Xc_belt_nut_diam = m3_elongNtt_diameter,
							Xc_belt_nut_wallDist = m3_elongNtt_wallDist,
							Xc_belt_nut_heigth = m3_elongNtt_height
					        ) {
						//nuttraps
						translate([0, 0, Xc_thinWallThickness])
							cylinder(r=Xc_belt_nut_diam/2, h=Xc_belt_nut_heigth, center=false,$fn=6);

						translate([_Xc_beltcon_thickness/2, 0, Xc_thinWallThickness + Xc_belt_nut_heigth/2])
							cube(size=[_Xc_beltcon_thickness, Xc_belt_nut_wallDist, Xc_belt_nut_heigth], center=true);
					}
				}

				// belt loop through hole
				translate([0, 0,- _Xc_belthole_size[2]/2])
					cube(size=_Xc_belthole_size, center=true);

				// belt tentener screw hole
				translate([0, 0,Xc_thinWallThickness+ Xc_belt_nut_wallDist/2]) {
					rotate(a=90,v=Y)
					cylinder(r=Xc_belt_hole_diam/2, h=_Xc_beltcon_thickness+2*OS, center=true);

					//nuttrap
					translate([-_Xc_beltcon_thickness/2 + Xc_belt_nut_heigth/2 - OS, 0, 0])
					rotate(a=30,v=X)
					rotate(a=90,v=Y)
						cylinder(r=Xc_belt_nut_diam/2, h=Xc_belt_nut_heigth + OS, center=true,$fn=6);
				}

				// top coutoff
				translate([-_Xc_beltcon_thickness, -_Xc_beltcon_minWidth, _Xc_beltcon_heigth])
					cube(size=[_Xc_beltcon_thickness*2,_Xc_beltcon_minWidth*2 , _Xc_beltcon_heigth], center=false);
			}
		}
}
//!_beltConnrector();

module carr_beltClamp() {
	holeDist = _Xc_belt_hole_dist;
	assign (Xc_genWallThickness = 3) {
		difference() {
			union(){
				translate([0, 0, Xc_genWallThickness/2])
				cube(size=[_Xc_beltcon_thickness, holeDist, Xc_genWallThickness], center=true);
				for (i=[-holeDist/2,holeDist/2])
				translate([0, i, 0]) {
					cylinder(r=_Xc_beltcon_thickness/2, h=Xc_genWallThickness, center=false,$fn=48);
				}

				for (i=[-_Xc_beltcon_thickness/2 + Xc_belt_teethDist/4 : Xc_belt_teethDist: _Xc_beltcon_thickness/2])
				translate([i, -(Xc_belt_width+Xc_belt_tolerance[1])/2, Xc_genWallThickness-OS])
					cube(size=[Xc_belt_teethDist/2, Xc_belt_width+Xc_belt_tolerance[1], Xc_belt_teethDepth], center=false);
			}
			union(){
				for (i=[-holeDist/2,holeDist/2])
				translate([0, i, -OS]) {
					cylinder(r=m3_diameter/2, h=Xc_genWallThickness+2*OS, center=false,$fn=12);
				}
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


if (Xc_mode == "inspect") {
	 H_x_Carriage();
	translate([0, 0, _Xc_firstBearing_alt + Xc_axis_dist + Xc_belt_axisXc_zdir_offset])
		_beltArm();
}
module H_x_Carriage_print() {
	rotate(a=180,v=X)
	translate([0, -_Xc_ydir/2 - 1, -_Xc_zdir+ Xc_genWallThickness + _Xc_lber_cutoff_diam])
		H_x_Carriage();

	mirror([0, 0, 1])
	translate([0, _Xc_ydir/2-1, -_Xc_beltcon_heigth])
		_beltArm();

	for (i=[1,-1])
	translate([i*_Xc_xdir*0.4 + 3, -3, 0])
	rotate(a=-90,v=Y)
		yBeltClamp_beltProtector();

	for (i=[-1,1])
	translate([i*(_Xc_connector_length/2 + _Xc_beltcon_thickness*1.5 + 1), -Xc_belt_axisXc_ydir_dist + _Xc_beltcon_minWidth * 0.5, 0])
		carr_beltClamp();

}
if (Xc_mode == "printSet") {
	H_x_Carriage_print();
}
if (Xc_mode == "print Carriage") {
	rotate(a=180,v=X)
	translate([0, 0, -_Xc_zdir + Xc_genWallThickness + _Xc_lber_cutoff_diam])
		H_x_Carriage();
}
if (Xc_mode == "print Beltarm") {
	mirror([0, 0, 1])
	translate([0, Xc_belt_axisXc_ydir_dist, -_Xc_beltcon_heigth])
		_beltArm();
	for (i=[-1,1])
	translate([(_Xc_connector_length/2 + _Xc_beltcon_thickness*1.5 + 1)*i, 0, 0])
		carr_beltClamp();
	for (i=[1,-1])
	translate([i*_Xc_connector_length/4 + 3 , 0, 0])
	rotate(a=-90,v=Y)
		yBeltClamp_beltProtector();
}



/*------------------------------------assembly--------------------------------*/
include <basicMetalParts.scad>
//include <ToothedLinearBearing.scad>

module H_x_Carriage_assembly() {
	rotate(a=180,v=Z)
	translate([0, 0, -_Xc_firstBearing_alt- Xc_axis_dist]) {
		 H_x_Carriage();
		 translate([0, 0, _Xc_firstBearing_alt + Xc_axis_dist + Xc_belt_axisXc_zdir_offset])
			_beltArm();
	}
}

if (Xc_mode == "assembly"){
	H_x_Carriage_assembly();
}




module triangle(l,h){
	translate(v=[2*l/3,0,0]) rotate (a=180, v=[0,0,1])
	cylinder(r=2*l/3,h=h,center=true,$fn=3);
}


