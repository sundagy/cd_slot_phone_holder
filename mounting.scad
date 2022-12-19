use <oSCAD_mods/sweep.scad>
use <NopSCADlib/utils/bezier.scad>

$fn=20;

cd_w = 121.5;
cd_h1 = 3.5;
cd_h2 = 3.5;
cd_h3 = 4.6;
cd_depth = 45;
cd_corner_r = 10;
cd_r = 50;
cd_hole_ofs = 15;

brim_r = 520;
brim_h = 5;
brim_d = 4;

neck_ofs = 13;
neck_w = 63;
neck_h = 60;
neck_fwd = 38;
neck_rot = -1;

module tongh_base(){
    hull(){
        translate([0, 0, 0]) cube([1, 1, cd_h2]);
        translate([cd_corner_r, cd_depth-cd_corner_r, 0]) cylinder(cd_h1, r=cd_corner_r);
        translate([cd_w-cd_corner_r, cd_depth-cd_corner_r, 0]) cylinder(cd_h1, r=cd_corner_r);
        translate([cd_w-1, 0, 0]) cube([1, 1, cd_h2]);
        translate([cd_w/2-5, 0, cd_h3-1]) cube([10, 10, 1]);
    };
};


module tongh(){
    difference(){
        tongh_base();
        translate([cd_w/2, cd_depth+cd_r-cd_hole_ofs, -1]) cylinder(cd_h3+2, r=cd_r);
        translate([cd_w/2, brim_r, 0])
        difference($fn=180){
            translate([0,0,-1]) cylinder(cd_h3+2, r=brim_r+10);
            translate([0,0,-2]) cylinder(cd_h3+4, r=brim_r-brim_d);
        };
        translate([-10, -10, -3.5]) rotate([0,45,0]) cube([10, 80, 10]);
        translate([-10, -10, 7]) rotate([0,45,0]) cube([10, 80, 10]);
        translate([cd_w+6, 0, 0]){
            translate([-10, -10, -3.5]) rotate([0,45,0]) cube([10, 80, 10]);
            translate([-10, -10, 7]) rotate([0,45,0]) cube([10, 80, 10]);
        }
    };
    
    minkowski(){
        translate([0,brim_d/2+0.1,0])
        intersection(){
            scale([1,1,1.2]) tongh_base();
            translate([cd_w/2, brim_r, 0])
            difference($fn=180){
                translate([0,0,-1]) cylinder(cd_h3+2, r=brim_r);
                translate([0,0,-2]) cylinder(cd_h3+4, r=brim_r-0.01);
            };
        };
        difference(){
            scale([0.4,1,1]) sphere(brim_d/2+1, $fn=18);
            translate([-5, -5, -10]) cube([10, 10, 10]);
        }
    }
}

function add_v(v, add) = [for(i = [0 : len(v)-1]) v[i] + add];

module rog(wid=0){
    nc = -neck_w/2;
    p = [
    
        [0,-20,9],
        [0,-10,3],
        
        [0,2,1.5], 
        [0,2,1.5], 
        
        [nc/2,0,3], 
        [nc,  8,0], 
        [nc+3,-5,0], 
        [nc+3,-5,0], 
        [nc+3,-5,0], 
        [nc,-30,0], 
        [nc-10,-35,45], 
        [-10,-neck_fwd,neck_h-45], 
        [0,-neck_fwd-1,neck_h-30], 
        [0,-neck_fwd-1,neck_h-30], 
        [0,-neck_fwd-9.5,neck_h-15],
        [0,-neck_fwd-15.5,neck_h-5],
        [0,-neck_fwd-18.4,neck_h],
        [0,-neck_fwd-24.3,neck_h+10],
    ];
    n = $fn*3;
    path = bezier_path(p, n);
    thinkness = add_v(bezier_path([3,7,3,3,10,10,2,2,4,5,5,5], n), wid);

    *color("red") show_path(path);
    *color("blue") show_path(p);
    sweep(path, circle_points(1), sz_path=thinkness);
}

module rog_center(wid=0){
 nc = -neck_w/2;
    p = [
        [0,1,1.5], 
        [0,-30,5], 
        
        [0,-neck_fwd,neck_h-42], 
        [0,-neck_fwd-2,neck_h-30], 
        [0,-neck_fwd-9.5,neck_h-15],
        [0,-neck_fwd-15.5,neck_h-5],
        [0,-neck_fwd-18.4,neck_h],
        [0,-neck_fwd-24.3,neck_h+10],
    ];
    n = $fn*2;
    path = bezier_path(p, n);
    thinkness = add_v(bezier_path([5,5,2,4,5,5,5,5], n), wid);

    sweep(path, circle_points(1), sz_path=thinkness);
    *color("blue") show_path(p);
    *color("red") show_path(path);
}

module roga(wid = 0){
    difference(){
        translate([neck_w/2 + neck_ofs, 0, 1.75])
        rotate([0,0,neck_rot])
        union() {
            rog(wid);
            mirror([1,0,0]) rog(wid);
            rog_center(wid);
        };
        translate([-100, -50,-10]) cube([200, 100, 10]);
    }
}

module neck(){
    roga(0.2);
    if($fn > 60){
        hull(){
            intersection(){
                roga(0.2);
                translate([neck_w/2 + neck_ofs, 0, 4]) cube([13,14,20], center=true);
            }
        }
    }
}

module head(){
    difference(){
        translate([neck_w/2 + neck_ofs - 1, -neck_fwd - 24, neck_h+11])
        {
            sphere(1);
            rotate([0, -90, 90])
            rotate([0,-15,0])
            translate([-10-23,0,5])
            union(){
                err = 0.1;
                translate([-22,0,8]){
                    translate([30, 22, -1]) cylinder(7, r=7-err);
                    translate([74, 20, -1]) cylinder(7, r=7-err);
                    translate([30, -22, -1]) cylinder(7, r=7-err);
                    translate([74, -20, -1]) cylinder(7, r=7-err);
                }
                hull(){
                    translate([-22,0,1]){
                        translate([30, 22, 6]) cylinder(1, r=7);
                        translate([74, 20, 6]) cylinder(1, r=7);
                        translate([30, -22, 6]) cylinder(1, r=7);
                        translate([74, -20, 6]) cylinder(1, r=7);
                    };
                    translate([24,0,-9])
                    rotate([0, -15, 0])
                    {
                        translate([0, 0, 0]) sphere(10);
                        translate([12, 0, 0]) sphere(10);
                    }
                };
            };
        }
        roga(0.3);
    }
}

head();
tongh();
neck();
