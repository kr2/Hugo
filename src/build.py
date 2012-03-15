srcDir = "./"
stlDestDir = "../build/"
gcodeDestDir = "../gcode/"

stl = True;
gcode = False;

files = [
	#"toothedLinearBearing.scad",
	#"RapSwitch.scad",
	#"H-set7_PLA.scad",
	#"H-set1.scad",
	#"H-Z-End.scad",
	"H-Y-supportFootEnd.scad"
	#"H-Y-beltDivert.scad",
	#"H-Y-beltClamp.scad",
	#"H-Y-BarEnd.scad",
	#"H-Xtruder-Mount.scad",
	#"H-X-End.scad",
	#"H-X-Carriage.scad",
	#"H-enstop-holder.scad",
	#"H-base.scad",
	#"H-assembly.scad",
	#"H-bar-clamp-cross.scad",
	#"H-bar-clamp.scad"
]

openScad = r"openscad"
skeinfoge = r'""C:/Users/KR2/Desktop/RepRap_new/PC_toolchain/Skeinforg_vielUneingeschraenkt/skeinforge_application/skeinforge.py""'

import os

#os.system("openscad -o temp.stl .\H-Y-supportFootEnd.scad")
#print "openscad -s temp.stl -D mode=\"print\" .\src/H-Y-supportFootEnd.scad"

def makeSTL():
	if not os.path.exists(stlDestDir):
		os.makedirs(stlDestDir)

	for _file in files:
		src = os.path.join(srcDir, _file)
		dest = os.path.splitext(_file)[0] + ".stl"
		print "START OpenSCAD: " + src
		os.system(openScad + " -o " + dest + " -D \'mode=\"print\"\' " + src)
		print openScad + " -o " + dest + " -D \'mode=\"print\"\' " + src
		print "DONE  OpenSCAD: " + dest
	print "Finished STL"

if stl:
	makeSTL()

def makeGcod():
	if not os.path.exists(gcodeDestDir):
		os.makedirs(gcodeDestDir)

	for _file in files:
		src = os.path.join(stlDestDir, _file)
		dest = os.path.join(gcodeDestDir, _file)
		print "START Skeinforge: " + src
		os.system(skeinfoge + " " + src + " " + dest)
		print "DONE  Skeinforge: " + dest
	print "Finished gcode"

if gcode:
	makeGcod()