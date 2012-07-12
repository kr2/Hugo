/* config [c]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <metric.scad>

/* --------- REFERENCE ----------
Standard Printrbot dimensions.
- T5 Belt
- T5/10 Pulleys
*/
//include <config/pb_standard.scad>


/*
Changes:
- T2.5 belt
- T2.5/20 Pulley
*/
//include <config/Hugo_standard.scad>


/*
Changes:
- 12 mm Z-Axis
- T2.5 belt
- T2.5/12 Pulley
- Printvoule: 300x300x300 mm
- x Axis rod dist increased (from 25.38 mm to 32)
*/
//include <config/Hugo+.scad>


/*
Changes:
- HTD 3M belt
- 3M/12 Pulley
- x Axis rod dist increased (from 25.38 mm to 32)
*/
include <config/Hugo_improved.scad>