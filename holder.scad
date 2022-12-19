$fn=70;
bottom_hook_h = 29;
side_y = 39;
side_x = 86;
side_x_ofs = 13;
side_length = 21;
overhang = 6;
move = 6;
E = 2.2;
body_h = 7.5;
phone_hei = 12;

bridge_size = 14;
center = [0, 0];
side = [0, bridge_size];

module round_box_corner(r, ln, wd, topOpen){
    difference(){
        translate([-r, -r, 0]) cube([r, r, ln]);
        translate([0, 0, -1]) cylinder(ln+2, r-wd, r-wd);
        rotate([0, 0, topOpen]) translate([-r-1, 0, -1]) cube([r*2+2, r+1, ln+2]);
        translate([0, -r-1, -1]) cube([r+1, r*2, ln+2]);
    };
}

module round_corner(r, ln, wd, topOpen){
    difference(){
        cylinder(ln, r, r);
        translate([0, 0, -1]) cylinder(ln+2, r-wd, r-wd);
        rotate([0, 0, topOpen]) translate([-r-1, 0, -1]) cube([r*2+2, r+1, ln+2]);
        translate([0, -r-1, -1]) cube([r+1, r*2, ln+2]);
    };
}

module hook(ln, he, r, mid, topOpen){
    rotate([90, 0, 0])
    translate([0, r, 0])
    round_box_corner(r, ln, he, 0);
    
    translate([-r, -ln, r]) cube([he, ln, mid]);
    
    rotate([90, 90, 0])
    translate([-r - mid, 0, 0])
    round_corner(r, ln, he, topOpen);
    
    rotate([90, 90, 0])
    translate([-r - mid, 0, 0])
    rotate([0, 0, topOpen]) {
        translate([-r+he/2, 0, 0]) cylinder(ln, r=he/2);
    }
}

module rcube(v){
    translate([-v[0], -v[1], 0]) cube(v);
}

module side_hook() {
    translate([side_x+move-side_x_ofs, side_y+move, 3]){
        translate([0, -1, 0]) 
        hull(){
            rcube([1, 1, 4]);
            translate([-20, 0, 0]) cube([1, 1, 4]);
            translate([-20+4, -10+4, 0]) cylinder(4, r=4);
            translate([-4, -10+4, 0]) cylinder(4, r=4);
        };
        
        translate([0, -2.5, 0]) 
        difference(){
            translate([0, -4.5, 0]) 
            rotate([0, 0, -90])
            hook(20, 4, 9, 6, 35);
            
            translate([-21, -5.5, 4]) cube([22, 6, 6]);
        };
        
        ofs = 2;
        hole = 2.1;
        translate([-3,0,0])
        difference(){
            x = -side_length-7;
            hull() {
                translate([-7, -7, 0]) 
                cylinder(4, r=hole+ofs+0.2);
                translate([x, x, 0]) 
                cylinder(4, r=hole+ofs+0.2);
            };
            translate([x, x, -1]) cylinder(6, r=hole);
            translate([x, x, 2]) cylinder(3, r=hole*2.5);
        }
    }
}

module bridge(){
    ofs = 2;
    hole = 2;
    cy = 6;
    cx = bottom_hook_h + 16 + (move-overhang)*E;
    x = side_x+move - side_length-10 - side_x_ofs;
    y = side_y+move-side_length-7;
    {
        hull() {
            translate([cx, cy, 5]) cylinder(2, r=hole+ofs);
            translate([x, y, 5]) cylinder(2, r=hole+ofs);
        };
        translate([cx, cy, 3]) cylinder(2, r=hole);
        translate([x, y, 3]) cylinder(2, r=hole);
    }

    echo(sqrt((cx - x)^2 + (cy - y)^2));
}

module bottom_hook() { 
    hull(){
        translate([4, 0, 0]) cube([1, 1, 4]);
        translate([19, 0, 0]) cube([1, 1, 4]);
        translate([19, 9, 0]) cube([1, 1, 4]);
        translate([4, 24, 0]) cube([1, 1, 4]);
    };

    translate([4, 25, 0])
    hook(15, 4, 9, 6, 35);

    translate([20, 0, 0])
    difference(){
        ofs = 2;
        hole = 2.1;
        rad = hole + ofs;
        hull(){
            translate([0, 0, 0]) cube([1,1,4]);
            translate([0, 9, 0]) cube([1,1,4]);
            translate([bottom_hook_h-1, 0, 0]) cube([1,1,4]);
            translate([bottom_hook_h-rad, 10-rad, 0]) cylinder(r=rad,h=4);
        }
        translate([bottom_hook_h-hole-ofs, 10-hole-ofs, -1])
        cylinder(r=hole,h=5);
        
        translate([20, -1, 2]) cube([10, 16, 3]);
    }
    
    hook_ln = 24;
    translate([bottom_hook_h+10, 0, 0])
    difference(){
        hull(){
            cube([1, 1.6, 2]);
            translate([hook_ln+2, 0, 2-0.2]) cube([1, 1.6, 0.2]);
            translate([hook_ln+0.2, 0, 0]) cube([1, 1.6, 1]);
        };
    }
    difference(){
        translate([bottom_hook_h+hook_ln+10, 0, 2]) cylinder(1.9, r=1.5);
        translate([bottom_hook_h+hook_ln+8, -4, 1]) cube([4, 4, 4]);
    }
}

module body(){
    difference(){
        hull(){
            r = 12;
            translate([3,0,0]) cube([1,1,body_h]);
            translate([95-1,0,0]) cube([1,1,body_h]);
            translate([95-r,24,0]) cylinder(body_h, r=r);
            translate([r*1.5+3,15,0]) cylinder(body_h, r=r*1.5);
        };
        
        translate([-10, -20, -1])
        cube([110, 20, 10]);
        
        translate([side_x+overhang-side_x_ofs-3, side_y+overhang, 3])
        hull() {
            translate([-7, -7, 0]) cylinder(body_h, r=4.5);
            translate([-40, -40, 0]) cylinder(body_h, r=4.5);
        };
        
        translate([-3, -0.5, 3]) cube([94, 11, body_h]);
        rotate([0, 0, 45]) translate([-2, -9.5, 3]) cube([23.5, 46, body_h]);
        
        translate([bottom_hook_h+15, 0, 3]) cube([8, 18, body_h]);
        
        translate([bottom_hook_h, 10, 3])
        rotate([0, 0, -64.5])
        cube([8, 17, body_h]);
        
        translate([side_x-side_x_ofs, side_y-1, 3])
        hull(){
            translate([16, 10, 0]) rcube([1, 1, body_h]);
            translate([-20.5, 9, 0]) cube([1, 1, body_h]);
            translate([-20+3.5, -10+3.5, 0]) cylinder(body_h, r=4);
            translate([-3.5, -10+3.5, 0]) cylinder(body_h, r=4);
        }

        translate([30, 22, -1]) cylinder(7, r=7);
        translate([74, 20, -1]) cylinder(7, r=7);
    }
    hook_x = 80;
    difference(){
        translate([hook_x, 0, 3]) cylinder(body_h-3, r=2);
        translate([hook_x+5, 0, 0]) rcube([10, 5, 10]);
    }
    
    translate([28, 22, body_h]) cylinder(0.5, r=4);
    translate([80, 22, body_h]) cylinder(0.5, r=4);
}

module body_top(){
    body_h = 1;
    difference(){
        hull(){
            r = 12;
            translate([3,0,0]) cube([1,1,body_h]);
            translate([95-1,0,0]) cube([1,1,body_h]);
            translate([95-r,24,0]) cylinder(body_h, r=r);
            translate([r*1.5+3,15,0]) cylinder(body_h, r=r*1.5);
        };
        translate([28, 22, 0.5]) cylinder(1, r=4.1);
        translate([80, 22, 0.5]) cylinder(1, r=4.1);
    }
}

module phone() { 
    color("#00ff00")
    body();
    
    *color("#00aa00")
    translate([0, 0, body_h])
    body_top();

    color("#ffff00")
    translate([(move-overhang)*E, 0, 3])
    bottom_hook();
    
    color("#0000ff")
    side_hook();

    color("#ff00ff")
    bridge();
    
    color("red")
    {
        translate([side_x-overhang*E, side_y, body_h+1]) cube(2, true);
        translate([-overhang*E, side_y, body_h+1]) cube(2, true);
        translate([side_x-overhang*E, side_y, body_h+1+phone_hei]) cube(2, true);
        translate([-overhang*E, side_y, body_h+1+phone_hei]) cube(2, true);
    }
}

union(){
    mirror([0,1,0]) phone();
    phone();
};
