include <nuts_and_bolts.scad>;
include <units.scad>;

$fn=50;

diameterBearingHole = 15;
depthBearingHole    = 24;

axisDistance        = 25;

notchInnerWidth     = 5.4;
notchDepth          = 1.2;

boltTolerance       = 0.05;
boltDistance        = 18;
boldDiameter        = 4;

distanceClamp       = 2;
lengthClamp         = 30;
thicknesClamp       = 4.5;
centerOffsetClamp   = 15;
suportlengthClamp   = 5;
cutFreeLengtClamp   = 22.5;
cutFreeOffsetClamp  = 1.8;
cutFreeWidthClamp   = 2;

holeDiameterClamp   = 4;
holeOffsetClamp     = 16.3;
holeToleranceClamp  = 0.5;
holeDistanceClamp   = 13.3;

generalWallThickness = 2.5;  // min thickness of all walls

module xCarriage(){
	gWt = generalWallThickness;
	dBH = diameterBearingHole;
	depthBH = depthBearingHole;
	ad = axisDistance;
	bd = boltDistance;
	bdia = boldDiameter;
	bT = boltTolerance;
	
	nIW = notchInnerWidth ;
	nD = notchDepth;
	
	sLC = suportlengthClamp;
	cFC = cutFreeLengtClamp;
	cFWC = cutFreeWidthClamp;
	cFOC = cutFreeOffsetClamp;
	
	dC= distanceClamp;
	lC= lengthClamp;
	
	hDC= holeDiameterClamp ;
	tC = thicknesClamp;
	hTC = holeToleranceClamp;
	hOC = holeOffsetClamp;
	cdC = holeDistanceClamp;
	wC =  depthBH+gWt;
	cOC = centerOffsetClamp-tC/2;
	
	ox = dBH+2*gWt;
	oy = depthBH+gWt;
	
	coz = dC+tC*2;
	
	translate([0,0,oy/2]) rotate(a = 90, v = X)
	difference(){
		union(){
			cube(size = [ox,oy,ad], center = true);
			translate([0,0,ad/2]) rotate(a = 90, v = X)
				cylinder(h = oy, r = ox/2, center = true);
			translate([0,0,-ad/2]) rotate(a = 90, v = X)
				cylinder(h = oy, r = ox/2, center = true);
			
			translate([-ox/2-lC/2,0,cOC])	{
				cube(size = [lC,wC,tC], center = true);
				translate([0,0,-dC-tC])
					cube(size = [lC,wC,tC], center = true);
			}
			translate([-ox/2-sLC,-oy/2,cOC-coz+tC/2])
				cube(size = [gWt+sLC,oy,coz], center = false);
			
			translate([-ox/2-lC-tC,-oy/2,cOC-coz+tC/2+tC+OS])
				cube(size = [tC,oy,dC+tC-OS], center = false);
				
			
		}
		union(){
			translate([0,gWt+OS,ad/2]) rotate(a = 90, v = X){
				cylinder(h = oy, r = dBH/2, center = true);
				cylinder(h = oy+2*gWt+OS*2+OS, r = dBH/2-gWt, center = true);
			}	
			translate([0,gWt+OS,-ad/2]) rotate(a = 90, v = X){
				cylinder(h = oy, r = dBH/2, center = true);
				cylinder(h = oy+2*gWt+OS*2+OS, r = dBH/2-gWt, center = true);
			}	
			
			cube(size = [gWt*2,oy+2*OS,ad], center = true);
			
			translate([-ox/2+METRIC_NUT_THICKNESS[bdia]-OS,bd/2,0]) rotate(a = 90, v = Y) rotate(a = 30, v = Z)
				boltHole(size= bdia, length= ox + 2* gWt,tolerance=bT, proj=-1);
			translate([-ox/2+METRIC_NUT_THICKNESS[bdia]-OS,-bd/2,0]) rotate(a = 90, v = Y) rotate(a = 30, v = Z)
				boltHole(size= bdia, length= ox + 2* gWt,tolerance=bT, proj=-1);
				
			translate([-ox/2-lC+hOC,cdC/2,cOC+tC-coz]) 
				boltHole(size= hDC, length= ox + 2* gWt,tolerance=hTC, proj=-1);
			translate([-ox/2-lC+hOC,-cdC/2,cOC+tC-coz]) 
				boltHole(size= hDC, length= ox + 2* gWt,tolerance=hTC, proj=-1);
				
			translate([-ox/2-lC+cFC/2+cFOC,0,cOC-dC/2-tC/2]){
				difference() {
					cube(size = [cFC,cFWC,coz+2*OS], center = true);
					for (i=[-1:1]) 
					translate([cFC/4*i, 0, 0]) 
						cube(size = [1,cFWC,coz+2*OS], center = true);
				}
			}
				
			translate([ox/2-nD/2+OS,0,0])
				cube(size = [nD+OS,oy+2*OS,nIW], center = true);
			
			translate([ox/2-nD+OS,0,nIW/2]) rotate(a = 90, v = X)
				triangle(nD+OS,oy+2*OS);
			translate([ox/2-nD+OS,0,-nIW/2]) rotate(a = 90, v = X)
				triangle(nD+OS,oy+2*OS);
		}
	}
}
xCarriage();


module triangle(l,h){
	translate(v=[2*l/3,0,0]) rotate (a=180, v=[0,0,1])
	cylinder(r=2*l/3,h=h,center=true,$fn=3);
}

