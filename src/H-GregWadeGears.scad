/* H-GregWadeGear [gwg]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 *
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * derivative of the original desing by abdrumm for the PrintrBot
 */

include <config.scad>
include <metric.scad>
include <units.scad>
include <barbell.scad>
use <parametric_involute_gear_v5.0.scad>

/*------------------------------------general---------------------------------*/
gWg_mode = "-";
// gWg_mode = "printSmal"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
// gWg_mode = "printLarg"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
// gWg_mode = "printSet"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
// gWg_mode = "inspectLarg";


gWg_thinWallThickness         = 1;
gWg_genWallThickness          = 3;
gWg_strongWallThickness       = 9;


/*------------------------------------gear------------------------------------*/
gWg_g_height          = 10;
gWg_g_pitch           = 268;
gWg_g_twist           = 200;
gWg_g_pressureAngle   = 30;

/*------------------------------------Larg Gear-------------------------------*/
gWg_lg_teeth          = 47;
gWg_lg_rimWidth       = 5;
gWg_lg_braces         = 3; // amount of braces
/*------------------------------------Smal Gear-------------------------------*/
gWg_sg_teeth          = 9;
gWg_sg_hub_heigth     = 10;
gWg_sg_chamfer_height = 2;
gWg_sg_chamfer_angle  = 40;


/*------------------------------------hobel screw-----------------------------*/
gWg_hs_diameter       = m8_diameter;
gWg_hs_nut_diameter   = m8_nut_diameter;
gWg_hs_nut_heigth     = m8_nut_heigth;

gWg_hs_hub_diameter   = 25;


/*------------------------------------motor-----------------------------------*/
gWg_motor_shaftDiameter = c_motorShaft_diam;

gWg_motorScrew_diameter  = m3_diameter;
gWg_motorScrew_nut_diameter = m3_nut_diameter;
gWg_motorScrew_nut_heigth = m3_nut_heigth;
gWg_motorScrew_nut_wallDist = m3_nut_wallDist;





/******************************************************************************/
/*                                  INTERNAL                                  */
/******************************************************************************/
_gWg_zdirTopCloseOf_scale = (gWg_genWallThickness)/(gWg_hs_hub_diameter/2);



module double_helix(
  teeth=47,
  pitch=268,
  twist=200,
  height=11,
  pressure_angle=30,
  rim_width = 0.5,

  _outer_radius=36.8, // TODO
  chamfer_height = 2,
  chamfer_angle = 40,

  full = false
  ) {
  _interseccone_height = tan(chamfer_angle)*_outer_radius;
  intersection() {
    union() {
      translate([0, 0, chamfer_height])
        cylinder(r=_outer_radius, h=height -2*chamfer_height, center=false);

      for (i=[[180,chamfer_height],[0, height - chamfer_height]])
      translate([0, 0,i[1]])
      rotate(a=i[0],v=Y)
        cylinder(r=_outer_radius, r2=0, h=_interseccone_height, center=false);
    }
    translate([0, 0, height/2])
    union(){
      gear (number_of_teeth=teeth,
        circular_pitch=pitch,
        pressure_angle=pressure_angle,
        clearance = 0.2,
        gear_thickness = full ? height/2 : 0,// height/2*0.5,
        rim_thickness = height/2,
        rim_width = rim_width,
        hub_thickness = height/2*1.5,
        hub_diameter = 0,
        bore_diameter = 0,
        circles=0,
        twist = twist/teeth);
      mirror([0,0,1])
      gear (number_of_teeth=teeth,
        circular_pitch=pitch,
        pressure_angle=pressure_angle,
        clearance = 0.2,
        gear_thickness =full ? height/2 : 0,
        rim_thickness = height/2,
        rim_width = rim_width,
        hub_thickness = height/2,
        hub_diameter=0,
        bore_diameter=0,
        circles=0,
        twist=twist/teeth);
    }
  }
}
// double_helix();

module largGear() {
  //TODO
  _brace_length = 33.33 - gWg_lg_rimWidth; // distance center to the bottom of the gear teeth

  _cutout_scale = (gWg_genWallThickness)/_brace_length;

  _outerBarbell_radius = gWg_hs_hub_diameter/2*0.85;
  difference() {
    union(){
      double_helix(
        teeth=gWg_lg_teeth,
        pitch=gWg_g_pitch,
        twist=gWg_g_twist,
        height=gWg_g_height,
        pressure_angle=gWg_g_pressureAngle,
        rim_width = gWg_lg_rimWidth,
        _outer_radius=36.8, // TODO
        chamfer_height = 2,
        chamfer_angle = 40
        );

      //hub
      translate([0, 0, gWg_g_height - gWg_genWallThickness])
      scale([1, 1, _gWg_zdirTopCloseOf_scale])
        sphere(r=gWg_hs_hub_diameter/2);

      cylinder(r=gWg_hs_hub_diameter/2, h=gWg_g_height- gWg_genWallThickness, center=false);

      // brace
      intersection() {
        union() {
          difference() {
            cylinder(r=_brace_length, h=gWg_g_height, center=false);
            translate([0, 0, gWg_g_height])
            scale([1, 1, _cutout_scale])
              sphere(r=_brace_length);
          }
        }
        union() {
          for (i=[0:360/gWg_lg_braces:360])
          rotate(a=i,v=Z){
            difference() {
              linear_extrude(height=gWg_g_height)
                barbell (r1=gWg_hs_hub_diameter/2,r2=_outerBarbell_radius,r3=7,r4=7,separation=_brace_length);
              translate([_brace_length, 0, -OS])
                cylinder(r=_outerBarbell_radius/2, h=gWg_g_height+2*OS, center=false);
            }
          }
        }
      }

    }
    union(){
      // nuttrap
      translate([0, 0, gWg_g_height-gWg_hs_nut_heigth+OS])
        cylinder(r=gWg_hs_nut_diameter/2, h=gWg_hs_nut_heigth, center=false,$fn=6);

      // screwhole
      translate([0, 0, -OS])
        cylinder(r=gWg_hs_diameter/2, h=gWg_g_height+2*OS, center=false);
    }
  }

}
// largGear();

module smalGear() {
  _outer_radius = 8.3;

  _screwCenter_zdir = gWg_g_height+gWg_sg_hub_heigth - (gWg_thinWallThickness + gWg_motorScrew_nut_diameter/2);

  difference() {
    union(){
      double_helix(
        teeth=gWg_sg_teeth,
        pitch=gWg_g_pitch,
        twist=gWg_g_twist,
        height=gWg_g_height,
        pressure_angle=gWg_g_pressureAngle,
        rim_width = 2,
        _outer_radius=_outer_radius, // TODO
        chamfer_height = 2,
        chamfer_angle = 40,
        full=true
        );

      intersection() {
        translate([0, 0, gWg_g_height])
          cylinder(r=_outer_radius, h=gWg_sg_hub_heigth, center=false);

        union() {
          translate([0, 0, gWg_g_height+gWg_sg_chamfer_height])
          rotate(a=180,v=Y)
            cylinder(r1=_outer_radius, r2=0, h=tan(gWg_sg_chamfer_angle)*_outer_radius, center=false);
          translate([0, 0, gWg_g_height+gWg_sg_chamfer_height])
            cylinder(r=_outer_radius, h=gWg_sg_hub_heigth- gWg_sg_chamfer_height, center=false);
        }
      }

    }
    union(){
      //motor axis
      translate([0, 0, -OS])
        cylinder(r=gWg_motor_shaftDiameter/2, h=gWg_g_height+ gWg_sg_hub_heigth +2*OS, center=false);

      // fix screw
      translate([0, 0, _screwCenter_zdir])
      rotate(a=90,v=Y){
        cylinder(r=gWg_motorScrew_diameter/2, h=_outer_radius, center=false);

        translate([0, 0, gWg_motor_shaftDiameter/2+ gWg_thinWallThickness])
          cylinder(r=gWg_motorScrew_nut_diameter/2, h=gWg_motorScrew_nut_heigth, center=false,$fn=6);
      }
      translate([gWg_thinWallThickness+gWg_motor_shaftDiameter/2+gWg_motorScrew_nut_heigth/2, 0, _screwCenter_zdir])
        cube(size=[gWg_motorScrew_nut_heigth, gWg_motorScrew_nut_wallDist, gWg_sg_hub_heigth], center=true);


    }
  }

}
// smalGear();



if (gWg_mode == "printSmal")
  smalGear();


if (gWg_mode == "printLarg")
  largGear();


module gWg_printSet() {
  translate([46, 0, 0])
  smalGear();
  largGear();
}
if (gWg_mode == "printSet") {
  gWg_printSet();
}