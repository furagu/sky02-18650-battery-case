$fa = 5;
$fs = 0.5;

function D(d) =
    let(segment = d * tan($fa / 2))
    $fn > 0
    ? d / cos(180 / $fn)
    : segment > $fs
        ? d / cos($fa / 2)
        : sqrt(pow($fs / 2, 2) + pow(d / 2, 2)) * 2;


cell_d = 18.4;
cell_h = 65.1;

lead_wire_d = 2.5;
balance_wire_d = 1.7;

strap_w = 1.8;
strap_l = 22;

cell_tolerance = 0.2;
hatch_tolerance = 0.1;

butt_h = 3;

t = 2;

difference(){
    main();

    // translate([-100, 0, -100])
    // cube([200, 200, 200]);
}

module main() {
    cell_offset = (cell_d + t) / 2;

    difference() {
        union() {
            hull() {
                for (x = [-cell_offset, cell_offset]) {
                    translate([x, 0])
                    cylinder(d=cell_d + t * 2 + cell_tolerance * 2, h=cell_h);
                }
            }

            hull() {
                for (x = [-cell_offset, cell_offset]) {
                    translate([x, 0, -butt_h])
                    cylinder(d1=cell_d + t * 2 + cell_tolerance * 2 - butt_h * 2, d2=cell_d + t * 2 + cell_tolerance * 2, h=butt_h);
                }
            }
        }

        hull() {
            for (x = [-cell_offset, cell_offset]) {
                translate([x, 0, -balance_wire_d - cell_tolerance])
                cylinder(d=cell_d / 2, h=balance_wire_d + cell_tolerance + 1);
            }
        }

        for (x = [-cell_offset, cell_offset]) {
            translate([x, 0])
            cylinder(d=D(cell_d + cell_tolerance * 2), h=cell_h + 2);
        }

        middle_cutout_w = cell_d * 0.7;

        translate([-cell_d / 2, -middle_cutout_w / 2])
        cube([cell_d, middle_cutout_w, cell_h + 2]);

        strap_cutout_y = cell_d / 2 + t + cell_tolerance - 0.2;

        for (y = [strap_cutout_y, -strap_cutout_y]) {
            translate([-strap_l / 2, -strap_w / 2 + y, -1])
            cube([strap_l, strap_w, cell_h + 2]);
        }
    }
}
