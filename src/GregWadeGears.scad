// Wade's Extruder Gears using Parametric Involute Bevel and Spur Gears by GregFrost
// by Nicholas C. Lewis (A RepRap Breeding Program)
//
// It is licensed under the Creative Commons - GNU GPL license.
// © 2010 by Nicholas C. Lewis
// http://www.thingiverse.com/thing:4305

include <config.scad>
include <metric.scad>
include <units.scad>;
use <parametric_involute_gear_v5.0.scad>


gWg_mode = "-";
// gWg_mode = "printSmal"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
// gWg_mode = "printLarg"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
// gWg_mode = "printSet"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)

if (gWg_mode == "printSmal")
	WadesS_double_helix();


if (gWg_mode == "printLarg")
	WadeL_double_helix();


module gWg_printSet() {
	translate([46, 0, 0])
	WadesS_double_helix();
	WadeL_double_helix();
}
if (gWg_mode == "printSet") {
	gWg_printSet();
}




module WadeL_double_helix(){
	//Large WADE's Gear - Double Helix
	//rotate([0,0,-2])translate([0,0,0])color([ 100/255, 255/255, 200/255])import_stl("39t17p.stl");

	circles=5;
	teeth=47;
	pitch=268;
	twist=200;
	height=11;
	pressure_angle=30;

	translate([0, 0, height/2])
	difference(){
		union(){
		gear (number_of_teeth=teeth,
			circular_pitch=pitch,
			pressure_angle=pressure_angle,
			clearance = 0.2,
			gear_thickness =0,// height/2*0.5,
			rim_thickness = height/2,
			rim_width = 5,
			hub_thickness = height/2*1.5,
			hub_diameter = 25,
			bore_diameter = 8,
			circles=circles,
			twist = twist/teeth);
		mirror([0,0,1])
		gear (number_of_teeth=teeth,
			circular_pitch=pitch,
			pressure_angle=pressure_angle,
			clearance = 0.2,
			gear_thickness = height/2,
			rim_thickness = height/2,
			rim_width = 5,
			hub_thickness = height/2,
			hub_diameter=25,
			bore_diameter=8,
			circles=circles,
			twist=twist/teeth);
		}
		translate([0,0,height/2*1.5+OS])
		rotate([180,0,0])
			cylinder(r=m8_nut_diameter/2, h=m8_nut_heigth, center=false,$fn=6);
	}
}

module WadesS_double_helix(){
	//small WADE's Gear
	//rotate([180,0,-23.5])translate([-10,-10,-18])color([ 100/255, 255/255, 200/255])import_stl("wades_gear.stl");

	circles=0;
	teeth=9;
	pitch=268;
	twist=200;
	height=25;
	pressure_angle=30;

	translate([0, 0, height/4])
	difference(){
		union(){
		gear (number_of_teeth=teeth,
			circular_pitch=pitch,
			pressure_angle=pressure_angle,
			clearance = 0.2,
			gear_thickness =  height/4,
			rim_thickness = height/4,
			rim_width = 5,
			hub_thickness = height/2*1.2,
			hub_diameter = 16.5,
			bore_diameter = 5,
			circles=circles,
			twist = twist/teeth);
		mirror([0,0,1])
		gear (number_of_teeth=teeth,
			circular_pitch=pitch,
			pressure_angle=pressure_angle,
			clearance = 0.2,
			gear_thickness =  height/4*1.2,
			rim_thickness =  height/4,
			rim_width = 5,
			hub_thickness = height/4,
			hub_diameter=20,
			bore_diameter=5,
			circles=circles,
			twist=twist/teeth);
		}
		translate([0,0,11])
		rotate([0,90,-90])
			cylinder(r=m3_diameter/2,h=20);
		translate([0,-4 , 11])
		rotate(a=90,v=X)
		rotate(a=30,v=Z)
			cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);
		translate([-m3_nut_wallDist/2, -4-m3_nut_heigth, 11])
			cube(size=[m3_nut_wallDist, m3_nut_heigth, 20], center=false);
	}
}
