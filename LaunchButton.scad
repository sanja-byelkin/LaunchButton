SIDE= 20;
BUTTON_H=5;
BUTTON_S=6;
BUTTON_PRESS=5;
BUTTON_SL= 3.5;
BUTTON_SH= 4;
BUTTON_PLATFORM=10;
BUTTON_GAP=5;
BUTTON_B=1;
B_HOLDER_H=1;
B_HOLDER_L=4;
B_HOLDER_LB=1;
B_HOLDER_W=2;
B_HOLDER_NUM=1;
B_HOLDER_A=90;
HEIGHT= B_HOLDER_H+B_HOLDER_L+BUTTON_H+BUTTON_B+BUTTON_GAP;
WALL= 1.5;
BARRIER= 1;
EAR=6;
EAR_H=5;
TOLLERANCE=0.3;
L_WALL=1.6;
L_LAYER=0.2;
BBOTTON_F=0;

// back, right, left, bottom, none
HOLE="bottom";
HOLE_S= 5;


$fn=100;

extern_side= SIDE + WALL*2 + BARRIER*2;
intern_side= SIDE - 2*TOLLERANCE;
barier_side= SIDE + BARRIER*2;
textern_side= extern_side +TOLLERANCE*2;

button_cyrcle= BUTTON_S * sqrt(2) + 2*TOLLERANCE;

parts_move= extern_side + 2*BARRIER + 2*WALL;

button_d= SIDE - 2*L_WALL;
button_s1= SIDE - 2*L_WALL - WALL;
button_s2= button_s1-2*L_WALL;


module cubic_barrier(h,l,r,cut)
{
    hh= sqrt(h*h/2);
    difference()
    {
        translate([0,0,h/2])
        rotate([0,45,0])
        cube([hh,l,hh], center= true);
        if (cut)
        {
            translate([(r? -hh : 0),-(l+1)/2,-1])
            cube([hh,l+1,h+2]);
        }
    }
}

module limit_w_barrier(w,l,h1,h2,r)
{
    translate([-w/2,-l/2,0])
    cube([w,l,h1+h2]);
    translate([(r?w/2:-w/2),0,h1])
    cubic_barrier(h=h2,l=l,r=r, cut=false);
}


module ears (d1, d2, w, num)
{
    union()
    {
        intersection(){
            union() {
                for (s=[0:num-1])
                    rotate((180/num)*s)
                    square([(d1+1)*2, w], center= true);
            }
            circle(d= d1);
        };
        circle(d= d2);
    };
};


module rails(d1, d2, w, num, h, a)
{
    linear_extrude(height=h, center= true, convexity=num+1)
    rotate(a)
    ears(d1, d2, w, num);
};

module button_holder()
{
    d1= button_s1;
    difference()
    {
        union()
        {
            translate([-(intern_side + 2*BARRIER)/2, -(intern_side/2 + 2*BARRIER), 0])
            cube([intern_side+2*BARRIER, intern_side + 2*BARRIER + WALL, WALL], center=false);
            translate([0,0,B_HOLDER_H/2 + WALL - 0.01])
            rails(d1= button_s1, d2= button_cyrcle + 2*L_WALL, w= B_HOLDER_W + 2*L_WALL+2*TOLLERANCE, num=B_HOLDER_NUM, h= B_HOLDER_H, a=B_HOLDER_A);
        }
        translate([0,0,(B_HOLDER_H + WALL)/2 + 0.01])
        rails(d1= button_s2, d2= button_cyrcle, w= B_HOLDER_W+2*TOLLERANCE, num=B_HOLDER_NUM, h= B_HOLDER_H + WALL + 1, a=B_HOLDER_A);
    }
}


module ear(d,h,w,lw)
{
    rotate([90,0,0])
    translate([0,0,-lw/2])
    union()
    {
        linear_extrude(height=lw)
        {
            circle(d=d);
            translate([-d/2, 0])
            square([d,h], center= false);
        }
        sphere(r=w*2/3);
    }
}


module sl_wall(d,l,w)
{
    rotate([90,0,0])
    translate([d-l/2,0,-w/2])
    linear_extrude(height=w)
    union()
    {
        intersection()
        {
            circle(d=d*2);
            translate([-d,0])
            square([d*2,d], center= false);
        }
        square([l-d,d], center= false);
    }
}

// Big Button
cylinder(d= button_d, h= EAR_H/2);
translate([0,0,(B_HOLDER_H + WALL + BBOTTON_F + 0.01)/2 + EAR_H/2 - 0.01])
rails(d1= button_s2 - TOLLERANCE*2, d2= button_cyrcle - TOLLERANCE*2, w= B_HOLDER_W, num=B_HOLDER_NUM, h= B_HOLDER_H + WALL + BBOTTON_F + 0.01, a=B_HOLDER_A);
translate([0, 0,EAR_H/2 + B_HOLDER_H + WALL + BBOTTON_F - 0.01])
cylinder(d=BUTTON_PRESS, h= B_HOLDER_L + TOLLERANCE +
(BUTTON_H - BUTTON_SH) + 0.01, center=false);
translate([0,0,EAR_H/2 + B_HOLDER_H + WALL + BBOTTON_F - 0.01])
difference()
{
    union()
    {
        translate([0,0,(B_HOLDER_L - 1)/2])
        rails(d1= button_s2 - TOLLERANCE*2, d2= button_cyrcle - TOLLERANCE*2, w= B_HOLDER_W, num=B_HOLDER_NUM, h= B_HOLDER_L - B_HOLDER_LB, a=B_HOLDER_A);
        translate([0,0,B_HOLDER_L - B_HOLDER_LB])
        intersection()
        {
            translate([0,0,B_HOLDER_LB/2])
            rails(d1= button_s2 - TOLLERANCE*2 +B_HOLDER_LB, d2= button_cyrcle - TOLLERANCE*2, w= B_HOLDER_W, num=B_HOLDER_NUM, h= B_HOLDER_LB, a=B_HOLDER_A);
            union()
            {
                cylinder(d1= button_s2 - TOLLERANCE*2, d2=button_s2 - TOLLERANCE*2 + B_HOLDER_LB, h=B_HOLDER_LB/2);
                translate([0,0,B_HOLDER_LB/2])
                cylinder(d2= button_s2 - TOLLERANCE*2, d1=button_s2 - TOLLERANCE*2 + B_HOLDER_LB, h=B_HOLDER_LB/2);
            }
        }
    }
    translate([0,0,-0.01])
    cylinder(d= button_s2 - TOLLERANCE*2 - 2, h= B_HOLDER_L + 0.02);
}
// Top
translate([0, parts_move, (EAR_H/2+BBOTTON_F)*0])
union()
{
    button_holder();
    translate([-(intern_side/2 - L_WALL/2), 0, EAR_H + WALL])
    rotate([0,180,90])
    ear(d= EAR, h= EAR_H + WALL, w= WALL, lw= L_WALL);
    translate([(intern_side/2 - L_WALL/2), 0, EAR_H + WALL])
    rotate([0,180,-90])
    ear(d= EAR, h= EAR_H + WALL, w= WALL, lw= L_WALL);
}

//Lid
translate([-parts_move,0,L_WALL])
rotate([0,180,0])
union()
{
    difference()
    {
        translate([-textern_side/2, -extern_side/2, 0])
        cube([textern_side, extern_side, L_WALL], center=false);
        translate([-SIDE/2, -SIDE/2, -L_LAYER])
        cube([SIDE, SIDE, L_WALL], center=false);
    }

    translate([(textern_side/2 + L_WALL/2 -0.01),-extern_side/2 + EAR_H,-(EAR_H+TOLLERANCE)])
    rotate(90)
    ear(EAR,EAR_H+L_WALL+TOLLERANCE,WALL,L_WALL);

    translate([-(textern_side/2 + L_WALL/2 -0.01),-extern_side/2 + EAR_H,-(EAR_H+TOLLERANCE)])
    rotate(-90)
    ear(EAR,EAR_H+L_WALL+TOLLERANCE,WALL,L_WALL);
}

// Box
translate([parts_move, 0, 0])
difference()
{
    union()
    {
        difference()
        {
            translate([-extern_side/2, -extern_side/2, 0])
            cube([extern_side, extern_side, HEIGHT + WALL*2], center=false);
            translate([-SIDE/2,-SIDE/2, WALL])
            cube([SIDE, SIDE, HEIGHT + 2*WALL], center=false);
            translate([-barier_side/2, -barier_side/2, HEIGHT + WALL])
            cube([barier_side, barier_side + 2*WALL, 2*WALL], center=false);
        }
        
        translate([-BUTTON_PLATFORM/2, -BUTTON_SL/2, WALL -0.01])
        cube([BUTTON_PLATFORM, BUTTON_SL, BUTTON_GAP +0.01], center= false);
        translate([-BUTTON_SL/2, -BUTTON_PLATFORM/2, WALL -0.01])
        cube([BUTTON_SL, BUTTON_PLATFORM, BUTTON_GAP +0.01], center= false);
        
        // real botton cage
        barier= (BUTTON_PLATFORM-BUTTON_S)/2 - TOLLERANCE;
        
        translate([(BUTTON_PLATFORM/2 - barier/2), 0, WALL + BUTTON_GAP - 0.01])
        limit_w_barrier(l=BUTTON_SL,w=barier,h1=BUTTON_SH + 0.01,h2=BUTTON_B,r=false);

        translate([-(BUTTON_PLATFORM/2 - barier/2), 0, WALL + BUTTON_GAP - 0.01])
        limit_w_barrier(l=BUTTON_SL,w=barier,h1=BUTTON_SH + 0.01,h2=BUTTON_B,r=true);
        
        translate([0, (BUTTON_PLATFORM/2 - barier/2), WALL + BUTTON_GAP - 0.01])
        rotate(90)
        limit_w_barrier(l=BUTTON_SL,w=barier,h1=BUTTON_SH + 0.01,h2=BUTTON_B,r=false);
        
        translate([0, -(BUTTON_PLATFORM/2 - barier/2), WALL + BUTTON_GAP - 0.01])
        rotate(90)
        limit_w_barrier(l=BUTTON_SL,w=barier,h1=BUTTON_SH + 0.01,h2=BUTTON_B,r=true);
        
        // Lid guides
        translate([WALL/2+barier_side/2,0,-0.01])
        rotate(90)
        translate([0,0,HEIGHT+WALL*2])
        sl_wall(d= EAR_H, l= extern_side, w= WALL);
        
        translate([-(WALL/2+barier_side/2),0,-0.01])
        rotate(90)
        translate([0,0,HEIGHT+WALL*2])
        sl_wall(d= EAR_H, l= extern_side, w= WALL);
    }
    //external
    translate([extern_side/2,-(extern_side/2 - EAR_H),HEIGHT+WALL*2])
    sphere(r=WALL*2/3);
    translate([-extern_side/2,-(extern_side/2 - EAR_H),HEIGHT+WALL*2])
    sphere(r=WALL*2/3);
    //internal
    translate([SIDE/2,0,HEIGHT+WALL-EAR_H])
    sphere(r=WALL*2/3);
    translate([-SIDE/2,0,HEIGHT+WALL-EAR_H])
    sphere(r=WALL*2/3);
    
    if (HOLE == "back")
    {
        translate([0, -extern_side/2 + (WALL+BARRIER)/2 +0.01,sqrt(HOLE_S*HOLE_S*2)/2+WALL])
        rotate([90,0,0])
        rotate([0,0,45])
        cube([HOLE_S, HOLE_S, WALL+BARRIER+0.03], center=true);
    }
    else if (HOLE == "right")
    {
        rotate(270)
        translate([0, -extern_side/2 + (WALL+BARRIER)/2 +0.01,sqrt(HOLE_S*HOLE_S*2)/2+WALL])
        rotate([90,0,0])
        rotate([0,0,45])
        cube([HOLE_S, HOLE_S, WALL+BARRIER+0.03], center=true);
    }
    else if (HOLE == "left")
    {
        rotate(90)
        translate([0, -extern_side/2 + (WALL+BARRIER)/2 +0.01,sqrt(HOLE_S*HOLE_S*2)/2+WALL])
        rotate([90,0,0])
        rotate([0,0,45])
        cube([HOLE_S, HOLE_S, WALL+BARRIER+0.03], center=true);
    }
    else if (HOLE == "bottom")
    {
        translate([0, HOLE_S/2 - SIDE/2,WALL/2-0.01])
        cube([HOLE_S, HOLE_S, WALL+0.03], center=true);
        translate([0, -(HOLE_S/2 - SIDE/2),WALL/2-0.01])
        cube([HOLE_S, HOLE_S, WALL+0.03], center=true);
        translate([HOLE_S/2 - SIDE/2, 0, WALL/2-0.01])
        cube([HOLE_S, HOLE_S, WALL+0.03], center=true);
        translate([-(HOLE_S/2 - SIDE/2), 0,WALL/2-0.01])
        cube([HOLE_S, HOLE_S, WALL+0.03], center=true);
    }
}
