
# PLL_FINAL - Top-level port cleanup
# Keep only the 38 external schematic ports

# Safety: preview changes first
set dry_run 0

set valid_ports {
    VDD_TEST VDD VSS
    UP_INPUT DN_INPUT F_IN ITAIL
    VCTRL_IN LF_OFFCHIP
    S1 S2 S3 S4 S5 S6 S7
    D0 D1 D2 D3 D4 D5 D6 D7 D8 D9 D10
    D12 D13 D14 D15
    PRE_SCALAR UP_OUT DN_OUT DIV_OUT
    OUT OUTB OUT1
}

# Read current ports before modifying anything
set current_ports {}

for {set i [port first]} {$i >= 0} {set i [port $i next]} {
    lappend current_ports [port $i name]
}

# Identify extra ports
set extra_ports {}

foreach p $current_ports {
    if {$p ni $valid_ports} {
        lappend extra_ports $p
    }
}

puts "--------------------------------"
puts "PLL port cleanup"
puts "Current ports: [llength $current_ports]"
puts "Expected ports: [llength $valid_ports]"
puts "Extra ports: [llength $extra_ports]"
puts "--------------------------------"

foreach p $extra_ports {
    if {$dry_run} {
        puts "WOULD REMOVE: $p"
    } else {
        port $p remove
        puts "REMOVED: $p"
    }
}

if {$dry_run} {
    puts "DRY RUN: No changes made"
} else {
    puts "Port cleanup completed"
    puts "Review the layout and run save"
}

