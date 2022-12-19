use <spiral_extrude.scad>;
$fn=50;

spiral_extrude(Radius=1, EndRadius=20, Pitch=9.5, Height=0, StepsPerRev=80, Starts=1){
    scale([1,3,1])
    square(1,1);
}

module half_tube(r1, r2, h) {
    difference(){
        cylinder(h, r1, r1);
        translate([0, 0, -1]) cylinder(h+2, r2, r2);
        translate([-r1-1, 0, -1]) cube([r1*2+2, r1+1, h+2]);
    }
}

module flat_spring(r1, r2, h, w, num, holder_w, holder_hole){
    translate([r1, 0, 0])
    for (i = [0:num]) {
        translate([i*(r1*2-(r1-r2)), w*(i%2), 0]) 
        mirror([0, i%2, 0]) 
        half_tube(r1, r2, h);

        if ( i<num ) {
            translate([i*(r1*2-(r1-r2))+r1-(r1-r2), 0, 0]) cube([r1-r2, w, h]);
        }
    }
    translate([0, 0, 0]) cube([r1-r2, w/2-holder_w/2+1, h]);
    translate([(r1-r2)/2, w/2, 0])
    difference(){
        cylinder(h, r=holder_w/2);
        translate([0,0,-1]) cylinder(h+2, r=holder_hole/2);
    }

    translate([(num+1)*(r1*2-(r1-r2)), 0, 0]) cube([r1-r2, (w-holder_w)/2+1, h]);
    translate([(num+1)*(r1*2-(r1-r2)) + (r1-r2)/2, w/2, 0])
    difference(){
        cylinder(h, r=holder_w/2);
        translate([0,0,-1]) cylinder(h+2, r=holder_hole/2);
    }
}

translate([0, 25, 0])
flat_spring(r1=6, r2=4, h=3, w=6, num=4, holder_w=5, holder_hole=2.5);
