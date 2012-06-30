/* H-Set4
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 *
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <GregsWade_v4.scad>
include <GregWadeGears.scad>


//$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);

translate([-25, 5, 0])
  gegsWade_print();

translate([-15, -33, 0])
rotate(a=30,v=[0,0,1])
  gWg_printSet();