function parse_and_display_design(design)

motor_code = design(1);
switch motor_code
    case 1
        motor_str = "KDE7208XF-135";
    case 2
        motor_str = "KDE6213XF-185";
    case 3
        motor_str = "KDE5215XF-220";
    case 4
        motor_str = "KDE5215XF-330";
    otherwise
        disp("Error");
        return
end
        
prop_code = design(2);
switch prop_code
    case 1
        prop_str = "KDE 30.5 inch diameter";
    case 2
        prop_str = "KDE 27.5 inch diameter";
    case 3
        prop_str = "KDE 24.5 inch diameter";
    case 4
        prop_str = "KDE 21.5 inch diameter";
    case 5
        prop_str = "KDE 18.5 inch diameter";
    case 6
        prop_str = "KDE 15.5 inch diameter";
    otherwise
        disp("Error");
        return
end

n_blades_code = design(3);
switch n_blades_code
    case 1
        blades_str = " dual-blade prop";
    case 2
        blades_str = " triple-blade prop";
    otherwise
        disp("Error");
        return
end

n_cells_code = design(4);
switch n_cells_code
    case 1
        n_cells_str = "4S 14.8V";
    case 2
        n_cells_str = "6S 22.2V";
    case 3
        n_cells_str = "8S 29.6V";
    case 4
        n_cells_str = "10S 37.0V";
    case 5
        n_cells_str = "12S 44.4V";
    otherwise
        disp("Error");
        return
end

n_motors_code = design(5);
switch n_motors_code
    case 1
        n_motors_str = "4 motors (quadcopter)";
    case 2
        n_motors_str = "6 motors (hexcopter)";
    case 3
        n_motors_str = "8 motors (octocopter)";
    otherwise
        disp("Error");
        return
end

bat_cap_code = design(6);
switch bat_cap_code
    case 1
        bat_cap_str = " 23,000 mAh";
    case 2
        bat_cap_str = " 22,000 mAh";
    case 3
        bat_cap_str = " 17,000 mAh";
    case 4
        bat_cap_str = " 16,000 mAh";
    otherwise
        disp("Error");
        return
end

disp("Optimal Design Specifications:")
disp("motor: " + motor_str)
disp("propeller: " + prop_str + blades_str)
disp("motor configuration: " + n_motors_str)
disp("battery: " + n_cells_str + bat_cap_str + " LiPo")


end