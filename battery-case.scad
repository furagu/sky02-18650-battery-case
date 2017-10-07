$fa = 5;
$fs = 0.5;

function D(d) =
    let(segment = d * tan($fa / 2))
    $fn > 0
    ? d / cos(180 / $fn)
    : segment > $fs
        ? d / cos($fa / 2)
        : sqrt(pow($fs / 2, 2) + pow(d / 2, 2)) * 2;

hatch_tolerance = 0.5;
cell_tolerance = 0.2;
tolerance = 0.1;

cell_d = 18.4 + cell_tolerance;
cell_h = 65.1 + cell_tolerance;

lead_wire_d = 2.5;
balance_wire_d = 1.7;

strap_w = 1.8 + tolerance;
strap_l = 22 + tolerance;

hatch_overlap_t = 1;
hatch_overlap_h = 3;

t = 1.5;

cap_h = 3;

difference(){
    main();

    // translate([-100, -200, -100])
    // cube([200, 200, 200]);
}

cell_distance = cell_d / 2 + t / 2;
strap_y = sqrt(pow(cell_d / 2 + t, 2) - pow(cell_distance - strap_l / 2, 2));
middle_cutout_w = cell_d * 0.7;

module main() {
    translate([0, 0, cap_h])
    difference() {
        tube(cell_h);

        for (x = [-cell_distance, cell_distance])
        translate([x, 0, -1])
        cylinder(d=D(cell_d), h=cell_h + 2);

        translate([-cell_d / 2, -middle_cutout_w / 2, -1])
        cube([cell_d, middle_cutout_w, cell_h + cell_tolerance + 2]);

        for (x = [-cell_distance, cell_distance])
        translate([x, 0, cell_h - hatch_overlap_h - hatch_tolerance])
        cylinder(d=D(cell_d) + hatch_overlap_t * 2 - tolerance / 2, h=hatch_overlap_h + hatch_tolerance + 1);

        translate([-cell_d / 2, -middle_cutout_w / 2 - hatch_overlap_t, cell_h - hatch_overlap_h - hatch_tolerance])
        cube([cell_d, middle_cutout_w + hatch_overlap_t * 2, hatch_overlap_h + 1]);
    }

    difference() {
        cap(cap_h);

        hull()
        for (x = [-cell_distance, cell_distance])
        translate([x, 0, cap_h - balance_wire_d])
        cylinder(d=middle_cutout_w, h=balance_wire_d + cell_tolerance + 1);
    }

%   for (x = [-cell_distance, cell_distance])
    translate([x, 0, cap_h])
    cylinder(d=cell_d, h=cell_h);


%   for (y = [strap_y, -strap_y - strap_w])
    translate([-strap_l / 2, y, cap_h])
    cube([strap_l, strap_w, cell_h]);

    translate([50, 0])
    difference() {
        union() {
            cap(cap_h);

            translate([0, 0, cap_h])
            tube(lead_wire_d);

            translate([0, 0, cap_h + lead_wire_d]) {
                for (x = [-cell_distance, cell_distance])
                translate([x, 0])
                cylinder(d=D(cell_d) + hatch_overlap_t * 2 - tolerance / 2, h=hatch_overlap_h);

                translate([-cell_d / 2, -middle_cutout_w / 2 - hatch_overlap_t])
                cube([cell_d, middle_cutout_w + hatch_overlap_t * 2, hatch_overlap_h]);
            }
        }

        for (x = [-cell_distance, cell_distance])
        translate([x, 0, cap_h + lead_wire_d])
        cylinder(d=D(cell_d), h=cell_h + 2);

        hull()
        for (x = [-cell_distance, cell_distance])
        translate([x, 0, cap_h - balance_wire_d])
        cylinder(d=middle_cutout_w, h=balance_wire_d + lead_wire_d + hatch_overlap_h + 1);

        translate([cell_distance, 0, cap_h - balance_wire_d + lead_wire_d / 2])
        rotate([0, 90, 0])
        hull()
        for (x = [0, -10], y = [lead_wire_d / 2, -lead_wire_d / 2])
        translate([x, y])
        cylinder(d=lead_wire_d, h=cell_d);
    }
}

module tube(h) {
    difference() {
        hull()
        for (x = [-cell_distance, cell_distance])
        translate([x, 0])
        resize([0, (strap_y + strap_w) * 2, 0], auto=[false, true, false])
        cylinder(d=cell_d + t * 2, h=h);

        for (y = [strap_y, -strap_y - strap_w - 1])
        translate([-strap_l / 2, y, -1])
        cube([strap_l, strap_w + 1, h + 2]);
    }
}

module cap(h) {
    difference() {
        hull()
        for (x = [-cell_distance, cell_distance])
        translate([x, 0])
        resize([0, (strap_y + strap_w) * 2, 0], auto=[false, true, false])
        cylinder(d1=cell_d + t * 2 - h * 2, d2=cell_d + t * 2, h=h);

        for (y = [strap_y, -strap_y - strap_w - 1])
        translate([-strap_l / 2, y, -1])
        cube([strap_l, strap_w + 1, h + 2]);
    }
}
