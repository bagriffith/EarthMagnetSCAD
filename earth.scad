// Planet
earth_radius = 50;
continent_thickness = 1;

// Magnet
magnet_radius = 10;
magnet_length = 80;

eps = 0.2;

// Modified from the stereographic_extrude module by Justin Lin in dotSCAD
module stereographic_extrude(shadow_side_leng, thickness, convexity = 1) {
    half_side_length = shadow_side_leng / 2;
    outer_sphere_r = half_side_length / 3;

    x = 2 * outer_sphere_r;
    y = sqrt(2) * half_side_length;

    inner_sphere_r = outer_sphere_r * y / norm([x, y]);
    
    intersection() { 
        translate([0, 0, outer_sphere_r]) 
        difference() {
            sphere(outer_sphere_r);
            sphere((outer_sphere_r + inner_sphere_r) / 2);
            
            translate([0, 0, outer_sphere_r / 2]) 
            linear_extrude(outer_sphere_r) 
                circle(inner_sphere_r / 2);
        }
     
        linear_extrude(outer_sphere_r * 2, scale = thickness/(outer_sphere_r),
		               convexity = convexity) 
            children();
    }
}

difference() {
union() {

translate([0,0,eps])
intersection() {
    union() {
        sphere(r = 1.0*earth_radius, $fn=128);
		translate([0, 0, -earth_radius-continent_thickness])
		stereographic_extrude(6*(earth_radius+continent_thickness),
		                      2*continent_thickness, convexity = 10, $fn=64)
		scale(v=[-3.98*earth_radius/254, 3.98*earth_radius/254, 1])
		translate([0, 14, 0])
		// Fixed needs the axis layer manually removed. Future OpenSCAD import
		// versions with a layer option won't need this.
		import("Surface/stereographic-s-fixed.svg", center=true);
    };

    translate([0, 0, -earth_radius-eps])
    cube(size=[2*earth_radius, 2*earth_radius, 2*earth_radius],
            center=true);
};

translate([0,0,-eps])
intersection() {
    union() {
        sphere(r = 1.0*earth_radius, $fn=128);
		translate([0, 0, earth_radius+continent_thickness])
		scale(v=[1, 1, -1])
		stereographic_extrude(6*(earth_radius+continent_thickness),
		                      2*continent_thickness, convexity = 10, $fn=128)
		scale(v=[-3.98*earth_radius/254, -3.98*earth_radius/254, 1])
		translate([0, -19, 0])
		import("Surface/stereographic-n-fixed.svg", center=true);
    };

    translate([0, 0, earth_radius+eps])
    cube(size=[2*earth_radius, 2*earth_radius, 2*earth_radius],
            center=true);
};
};

// Magnet Slot
translate ([0,0,-magnet_length/2])
    cylinder (h = 2*earth_radius + 2*continent_thickness,
                r = magnet_radius, $fn=32);
}