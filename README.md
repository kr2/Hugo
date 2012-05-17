NOT ALL PARTS ARE TESTED


At the moment the config.scad and metric.scad file aren't implemented consistently. So if you want to change something look in the scad file of the corresponding part and if the desired setting already depends on the config.scad or metric.scad check the appropriate.

It is always recommend to check the stl files before printing. If you have problems slicing the stl fils with Slic3r try fixing them with http://cloud.netfabb.com/ (for Skeinforge the files should work out of the box).

Wiki: http://reprap.org/wiki/Hugo

Brief
=====
This is Hugo. Named after Hugo de Vries who introduced the term "mutation".

First of I would like to thank Joachim (jsturm) who started this project in the first place and did almost the entire testing of the parts. The entire design is done in OpenSCAD and all files are hosted on https://github.com/kr2/Hugo.

It is a derivative of the original Printrbot by abdrumm, but all parts are redesigned and improved.

Some Improvements are:

-   The main parts are tested ;)
-   Nut traps everywhere
-   Optional cross braces
-   Centered y belt
-   Carriage with 3 bearings
-   Belt tensioner for x and y Belts
-   Additional base in y direction

Instructions
============
There is a H-assembly.scad, which is not perfect but shows a complete setup of the Printer.
To view this  H-assembly.scad I recommend to use the actual developer release of OpenScad e.g. http://www.onewheelweb.com/static/openscad/OpenSCAD-2012.02.19-Installer.exe and to set the value for "Turn off render at ... elements" [edit->Preferences] to a higher value (I use 200000).

So there are several prebuilt stl files to discover and to put your own assembly together or you build your own via OpenSCAD.

In general if you print H-set1.stl and H-set2.stl you should have all mandatory parts to build the Printer. If you also print H-set3.stl you should be able to setup the entire printer similar to the one shown in H-assembly.scad. It is recommend to use LMXXUU or igus linear Bearings but the H-set7_PLA.scad contains printable linear bearings. This bearings should be printed in PLA because it is harder then ABS.


Sources
=======
Bar clamp:
Bar clamp by Josef Průša
https://github.com/prusajr/PrusaMendel

Bearing Guide:
Bearing Guide by GregFrost
https://github.com/GregFrost/PrusaMendel

Also some modules and metric files from the two above.

Extruder:
Greg's Wade reloaded - Guidler, Tilt Screws, Fishbone Gears by jonaskuehling
http://www.thingiverse.com/thing:18379

Printrbot:
THE Printrbot by abdrumm
http://www.thingiverse.com/thing:16990

Thanks to all of them.
(If I missed someone I am sorry, plz contact me.)