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
c_x_axis_smoothRod_diam = 8;

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
/*                                  motor                                     */
/******************************************************************************/
c_motorShaft_diam = 5;
c_motorShaft_length = 25;