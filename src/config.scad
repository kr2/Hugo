/* config [c]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

/******************************************************************************/ 
/*                              Main configuration                            */
/******************************************************************************/

/*-----------------------------------x axis-----------------------------------*/
c_x_axis_length = 225; // usable lenth. If you use an extruder which is longer then the H-Xtruder-Mount.scad you have to add this overcut here.
c_x_axis_smoothRod_diam = 8.1;

c_x_axis_dist = 35;

/*-----------------------------------y axis-----------------------------------*/
c_y_axis_length = 225; // usable lenth. If your extruder nozzel exit is not center to the H-Xtruder-Mount.scad you have to add the offset here.
c_y_axis_smoothRod_diam = 8;

/*-----------------------------------z axis-----------------------------------*/
c_z_axis_length = 235; // usable lenth. If the nozzel of the extruder exids the lower edge of the H-X-Carriage.scad than you have to add the overcut here.
c_z_axis_smoothRod_diam = 12.2;

c_z_axis_rodsDist = 32; // distance between threded rod and smooth rod

/******************************************************************************/ 
/*                                  linear Bearings                           */
/******************************************************************************/
c_lber_length       = 24.2;
c_lber_diam         = 15.3;

/*-----------------------------------x axis-----------------------------------*/
c_xAxis_lber_length = c_lber_length;
c_xAxis_lber_diam   = c_lber_diam;
/*----------------------------------y axis------------------------------------*/
c_yAxis_lber_length = c_lber_length;
c_yAxis_lber_diam   = c_lber_diam;
/*----------------------------------z axis------------------------------------*/
c_zAxis_lber_length = c_lber_length;
c_zAxis_lber_diam   = 12 + c_lber_diam-8;

/******************************************************************************/ 
/*                                    BELT                                    */
/******************************************************************************/
c_belt_thickness      = 1.3;
c_belt_width          = 6;
c_belt_teethDist      = 2.5;
c_belt_teethDepth     = 0.7;

/*-----------------------------------x axis-----------------------------------*/
//belt
c_xAxis_belt_thickness      = c_belt_thickness;
c_xAxis_belt_width          = c_belt_width;
c_xAxis_belt_teethDist      = c_belt_teethDist;
c_xAxis_belt_teethDepth     = c_belt_teethDepth;

// pully
c_xAxis_pully_diam = 9-c_xAxis_belt_thickness*2; // innes (in the teeth molde) diameter of the pully

// diviater
c_xAxis_bearingDiviater_diam = 26; // diameter of the diviater (so the diameter of the centerpoint to the teeth top of the belt) 

// distances
c_xAxis_beltCenter_xAxisDist     = 38;
c_xAxis_beltCenter_motorScrewHoleDist     = 12;
//c_xAxis_beltTop_topxAxisDist = -8; // distece between center of the top x axis and toothed side of the belt in z dir
c_xAxis_beltTop_topxAxisDist = -(c_x_axis_dist/2)+c_xAxis_pully_diam/2; // distece between center of the top x axis and toothed side of the belt in z dir

/*-----------------------------------y axis-----------------------------------*/
c_yAxis_belt_thickness      = c_belt_thickness;
c_yAxis_belt_width          = c_belt_width;
c_yAxis_belt_teethDist      = c_belt_teethDist;
c_yAxis_belt_teethDepth     = c_belt_teethDepth;

/******************************************************************************/ 
/*                                  support                                   */
/******************************************************************************/
c_xDirSupp_thredRod_altitude    = [8.266,45.497];
c_xDirSupp_thredRod_zAxisDist   = 38.95-8.5;

/******************************************************************************/ 
/*                                  motor                                     */
/******************************************************************************/
c_motorShaft_diam            = 5; // motor axis diameter
c_motorShaft_length          = 25; // motor axis length from pilot
c_motorPilot_diam            = 27.5; // motor pilot diameter
c_motorScrewHole_diam        = 3.2; // motor screw holde diameter
c_motorScrewHoles_centerDist = 43.841/2; // motor holes distance from axis center
c_motor_sideLength           = 42; // length of the motor side (rectangular motor)

/*-----------------------------------x axis-----------------------------------*/
c_xAxis_motorShaft_diam            = c_motorShaft_diam;
c_xAxis_motorShaft_length          = c_motorShaft_length;
c_xAxis_motorPilot_diam            = c_motorPilot_diam ;
c_xAxis_motorScrewHole_diam        = c_motorScrewHole_diam ;
c_xAxis_motorScrewHoles_centerDist = c_motorScrewHoles_centerDist;
c_xAxis_motor_sideLength           = c_motor_sideLength;

/*-----------------------------------y axis-----------------------------------*/
c_yAxis_motorShaft_diam            = c_motorShaft_diam;
c_yAxis_motorShaft_length          = c_motorShaft_length;
c_yAxis_motorPilot_diam            = c_motorPilot_diam ;
c_yAxis_motorScrewHole_diam        = c_motorScrewHole_diam ;
c_yAxis_motorScrewHoles_centerDist = c_motorScrewHoles_centerDist;
c_yAxis_motor_sideLength           = c_motor_sideLength;

/*-----------------------------------z axis-----------------------------------*/
c_zAxis_motorShaft_diam            = c_motorShaft_diam;
c_zAxis_motorShaft_length          = c_motorShaft_length;
c_zAxis_motorPilot_diam            = c_motorPilot_diam ;
c_zAxis_motorScrewHole_diam        = c_motorScrewHole_diam ;
c_zAxis_motorScrewHoles_centerDist = c_motorScrewHoles_centerDist;
c_zAxis_motor_sideLength           = c_motor_sideLength;