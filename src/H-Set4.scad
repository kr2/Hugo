/* H-Set4
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 *
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */
include <units.scad>

include <GregsWade_v4.scad>
include <GregsWadebits.scad>


//$fn= 24 * 4;

%cube(size=[150, 150, 1], center=true);

translate([-20, 0, 0])
  gegsWade_print();

translate([-20, -15, 0])
rotate(a=10,v=[0,0,1])
  gWb_printSet();