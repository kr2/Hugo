NOT ALL PARTS ARE TESTED


At the moment the config.scad and metric.scad file aren’t implemented consistently. So if you want to change something look in the scad file of the corresponding part and if the desired setting already depends on the config.scad or metric.scad check the appropriate.

Brief
=====
This is Hugo. Named after Hugo de Vries how introduced the term "mutation".

First of I would like to thank jsturm how started this project in the first place and did almost the entire testing of the parts. The entire design is done in OpenSCAD and all files are hosted on https://github.com/kr2/Hugo.

It is a derivative of the original Printrbot by abdrumm, but all parts are redesigned and improved.

Some Improvements are:
- The main parts are tested ;)
- Nut traps everywhere
- Optional cross braces
- centered y belt
- Carriage with 3 bearings
- Belt tensioner for x and y Belts
- Additional base in y direction

Instructions
============
There is an H-assembly.scad, which is not perfect but shows an complete setup of the Printer.

So there are several Prebuilt stl files to discover and to put your own assembly together or you build your own via OpenSCAD.

In general if you print H-set1.stl and H-set2.stl you should have all mandatory parts to build the Printer. If you also print H-set3.stl you should be able to setup the entire printer as shown in H-assembly.scad. The H-set7_PLA.stl contains all necessary linear bearings plus some extra, in case some come out in bad quality. This bearings should be printed in PLA because it is harder then ABS.
