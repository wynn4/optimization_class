function [xopt, fopt, exitflag, output] = spring_design()

    % ------------Starting point and bounds------------
    % design variables: d D n hf
    x0 = [0.015, 0.5, 10.0, 1.5];   % starting point
    ub = [0.2, 1.0, 50.0, 10.0];  % upper bound
    lb = [0.01, 0.1, 1.0, 1.0];  % lower bound

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Objective and Non-linear Constraints------------
    function [f, c, ceq] = objcon(x)
        
        % set objective/constraints here
        
        % design variables (things we'll adjust to find optimum)
        d = x(1);  % wire dia (in)
        D = x(2);  % coil dia (in)
        n = x(3);  % num coils
        hf = x(4); % free height (no load) (in)
        
        % other analysis variables (constants that the optimization won't touch)
        h0 = 1.0;           % preloaded height (in)
        delta0 = 0.4;       % deflection (in)
        hdef = h0 - delta0; % deflected spring height (in)
        G = 12e6;
        Q = 150e3;
        w = 0.18;
        Se = 45e3;
        Sf = 1.5;
        
        % delta_x = 0.4;  % not sure if this is right??
        delta_x = (hf - h0);  % maybe this instead???
        
        % analysis functions
        k = G*d^4/(8*D^3*n);
        F = k*delta_x;
        K = ((4*D-d)/(4*(D-d)))+0.62*(d/D);
        % Tau = (8*F*D/pi*d^3)*K;
        hs = n*d;
        F_min = k*(hf - h0);
        % F_max = F_min + delta0*k;
        F_max = k*(hf - (h0 - delta0));
        F_hs = k*(hf - hs);
        Tau_min = 8*F_min*D*K/(pi*(d^3));
        Tau_max = 8*F_max*D*K/(pi*(d^3));
        Tau_m = (Tau_max + Tau_min)/2;
        Tau_a = (Tau_max - Tau_min)/2;
        Tau_hs = 8*F_hs*D*K/(pi*(d^3));
        Sy = 0.44*(Q/d^w);
        
        % objective function (what we're trying to optimize)
        f = -F;  % maximize Force
        
        % inequality constraints (c<=0)
        c = zeros(5,1);
        c(1) = Tau_hs - Sy;
        c(2) = Tau_a - Se/Sf;
        c(3) = Tau_a + Tau_m - Sy/Sf;
        c(4) = (D/d) - 16;
        c(5) = -(D/d) + 4;
        c(6) = d - 0.2;
        c(7) = -d + 0.01;
        c(8) = D + d - 0.75;
        c(9) = -hdef + hs + 0.05;
        
        % equality constraints (ceq=0)
        ceq = [];  % empty when we have none

    end

    % ------------Call fmincon------------
    options = optimoptions(@fmincon, 'display', 'iter-detailed');
    [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);
    
    
    % ------------Separate obj/con (do not change)------------
    function [f] = obj(x)
            [f, ~, ~] = objcon(x);
    end
    function [c, ceq] = con(x)
            [~, c, ceq] = objcon(x);
    end
end