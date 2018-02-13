function [xopt, fopt, exitflag, output] = fov_optimizer()

    % ------------Starting point and bounds------------
    % design variables: height, focal length, sensor size, target size
    x0 = [1.1, 0.0015, 301, 0.26];  % starting point
    ub = [100, 0.015, 2000, 5.0];  % upper bound
    lb = [1, 0.001, 300, 0.25];  % lower bound

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Objective and Non-linear Constraints------------
    function [f, c, ceq] = objcon(x)
        
        % set objective/constraints here
        
        % design variables (things we'll adjust to find optimum)
        h = x(1);  % approach height or distance to target (m)
        fl = x(2);  % camera focal lenght (m)
        ss_pix = x(3);  % sensor size (width of square pixel array in pixels)
        ts = x(4); % target_size (width of square target) (m)
        
        % other analysis variables (constants that the optimization won't touch)
        ss_physical = 1/3;  % physical sensor size in inches (diagonal)
        min_target_pixels = 800;  % minimum number of pixels that can
                                  % represent the target and still have
                                  % the target's features be
                                  % distinguishable.
        F_safe = 2;  % safety factor min_target_pixels;
        
        % analysis functions
        ss_w = ss_physical * sqrt(2)/2;  % physical sensor width (inches)
        ss_w = ss_w * 0.0254;  % convert sensor width to meters
        v = 2 * atan(ss_w/(2*fl));  % angular field of view of the camera
        fov_w = 2 * (h * tan(v/2));  % width of rectangular region camera can see
        fov_h = fov_w;  % height of rectangular region camera can see
        
        u_target = (fl/h) * (ts/2);  % projection of the target onto the image plane (meters)
        v_target = u_target;  % same as above since target is square (meters)
        pix_size = ss_w/ss_pix;  % pixel size (meters)
        target_area_pix = (2 * u_target/pix_size) * (2 * v_target/pix_size);  % area of target in pixels
        
        % rate at which images can be processed is directly proportional to
        % the area (in pixels) of the sensor
        tpp = 8.0539e-8;  % time it takes to process each pixel (found from experimentation)
        t_proc = tpp * ss_pix^2;  % time to process the image
        rate_proc = 1/t_proc;  % rate at which images can be processed
        
        
        
        % what we're optimizing
        fov = fov_w * fov_h  % area in square meters that camera can see
        
        
        
        % objective function (what we're trying to optimize)
        f = -fov;  % maximize Field-of-view (m^2)
        
        % inequality constraints (c<=0)
        c = zeros(7,1);
        c(1) = fl - 0.025;  % focal length <= 25 mm
        c(2) = -fl + 0.0012;  % focal length >= 1.2 mm
        c(3) = -rate_proc + 10;  % image processing rate >= 10 hz
        c(4) = ts - 1.5;  % target size (width) <= 1.5 meters
        c(5) = -ts + 0.3;  % target size (width) >= 0.3 meters
        c(6) = -target_area_pix + F_safe * min_target_pixels;  % target's area in pixels >= safety_factor * 800
        c(7) = h - 30;  % height <= 30 meters
        
        % equality constraints (ceq=0)
        ceq = [];  % empty when we have none

    end

    % ------------Call fmincon------------
    options = optimoptions(@fmincon, 'display', 'iter-detailed');
    options.StepTolerance = 1e-20;
    [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);
    
    
    % ------------Separate obj/con (do not change)------------
    function [f] = obj(x)
            [f, ~, ~] = objcon(x);
    end
    function [c, ceq] = con(x)
            [~, c, ceq] = objcon(x);
    end
end