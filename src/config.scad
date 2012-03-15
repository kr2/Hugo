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

c_x_axis_dist = 34.72 - 9.34;

/*-----------------------------------y axis-----------------------------------*/
c_y_axis_length = 225; // usable lenth. If your extruder nozzel exit is not center to the H-Xtruder-Mount.scad you have to add the offset here.
c_y_axis_smoothRod_diam = 8;

/*-----------------------------------z axis-----------------------------------*/
c_z_axis_length = 235; // usable lenth. If the nozzel of the extruder exids the lower edge of the H-X-Carriage.scad than you have to add the overcut here.
c_z_axis_smoothRod_diam = 8;

c_z_axis_rodsDist = ((45.45+30.56)/2+1)-(9.69+1); // distance between threded rod and smooth rod



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
c_zAxis_lber_diam   = c_lber_diam;

/******************************************************************************/ 
/*                                    BELT                                    */
/******************************************************************************/
c_belt_thickness      = 2.5;
c_belt_width          = 6;
c_belt_teethDist      = 5;
c_belt_teethDepth     = 1.5;

/*-----------------------------------x axis-----------------------------------*/
c_xAxis_belt_thickness      = c_belt_thickness;
c_xAxis_belt_width          = c_belt_width;
c_xAxis_belt_teethDist      = c_belt_teethDist;
c_xAxis_belt_teethDepth     = c_belt_teethDepth;

c_xAxis_beltCenter_xAxisDist     = 30;
c_xAxis_beltCenter_motorScrewHoleDist     = 20;


c_belt_topOffset      = 14.6;  // from top plate to the top edge of the belt
c_belt_tolerance      = [2,1]; //w,t


/******************************************************************************/ 
/*                                  motor                                     */
/******************************************************************************/
c_motorShaft_diam            = 5; // motor axis diameter
c_motorShaft_length          = 25; // motor axis length from pilot
c_motorPilot_diam            = 27.5; // motor pilot diameter
c_motorScrewHole_diam        = 3.2; // motor screw holde diameter
c_motorScrewHoles_centerDist = 43.841/2; // motor holes distance from axis center

/*-----------------------------------x axis-----------------------------------*/
c_xAxis_motorShaft_diam            = c_motorShaft_diam;
c_xAxis_motorShaft_length          = c_motorShaft_length;
c_xAxis_motorPilot_diam            = c_motorPilot_diam ;
c_xAxis_motorScrewHole_diam        = c_motorScrewHole_diam ;
c_xAxis_motorScrewHoles_centerDist = c_motorScrewHoles_centerDist;

/*-----------------------------------y axis-----------------------------------*/
c_yAxis_motorShaft_diam            = c_motorShaft_diam;
c_yAxis_motorShaft_length          = c_motorShaft_length;
c_yAxis_motorPilot_diam            = c_motorPilot_diam ;
c_yAxis_motorScrewHole_diam        = c_motorScrewHole_diam ;
c_yAxis_motorScrewHoles_centerDist = c_motorScrewHoles_centerDist;

/*-----------------------------------z axis-----------------------------------*/
c_zAxis_motorShaft_diam            = c_motorShaft_diam;
c_zAxis_motorShaft_length          = c_motorShaft_length;
c_zAxis_motorPilot_diam            = c_motorPilot_diam ;
c_zAxis_motorScrewHole_diam        = c_motorScrewHole_diam ;
c_zAxis_motorScrewHoles_centerDist = c_motorScrewHoles_centerDist;