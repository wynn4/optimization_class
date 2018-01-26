function [xopt, fopt, exitflag, output] = mill_optimization()

    % ------------Starting point and bounds------------
    % design variables: x0 = [D, V, d]
    x0 = [0.3, 10.0, 0.001];   % starting point
    ub = [1.0, 1000, 0.01];  % upper bound
    lb = [0.1, 0.5, 0.0005];  % lower bound

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Objective and Non-linear Constraints------------
    function [f, c, ceq] = objcon(x)
        
        % set objective/constraints here
        
        % design variables (things we'll adjust to find optimum)
        D = x(1);  % internal pipe dia. (ft)
        V = x(2);  % avg flow velocity (ft/sec)
        d = x(3);  % avg limestone particle size after grinding (ft)
        
        % other analysis variables (constants that the optimization won't touch)
        % L = 15;  % pipe length (miles)
        L = 15*5280;  % pipe length (ft)
        W = 12.67;  % flowrate of limestone (lbm/sec)
        als = 0.01;  % avg lump size of limestone before grinding (ft)
        
        gamma = 168.5;  % limestone density (lb_m/ft^3)
        rho_w = 62.4;  % water density (lb_m/ft^3)
        g = 32.17;  % gravity (ft/s^2)
        g_c = 32.17;  % conversion factor
        mu = 7.392e-4;  % water viscosity (lb_m/ft-sec)
        S = gamma/rho_w;  % specific gravity of the limestone
        
        
        % analysis functions
        Q = 0.25*pi*(D^2)*V;  % flow rate of the slurry (volumetric)
        Q_l = W/gamma;  % flow rate of limestone (volumetric)
        Q_w = Q - Q_l
        c_slur = Q_l/Q
        % c_w = (c_slur*gamma)/((1-c_slur)*rho_w + c_slur*gamma);  % consentration of solid by weight in the slurry
        % rho = 1/(c_w/gamma + (1 - c_w)/rho_w);  % density of the slurry (lb_m/ft^3)
        rho = rho_w + c_slur*(gamma - rho_w)
        
        P_g = 218*W*((1/sqrt(d)) - (1/sqrt(als)));  % power for grinding (ft-lbf/sec)
        
        R_w = rho_w*V*D/mu;
        if R_w <= 10e5
            f_w = 0.3164/(R_w^0.25);
        else
            f_w = 0.0032 + 0.221*(R_w^-0.237);
        end
        
        Cd_Rp_term = 4*g*rho_w*(d^3)*((gamma - rho_w)/(3*(mu^2)));
        C_d = cd_lookup(Cd_Rp_term);
        
        fric = f_w*((rho_w/rho)+150*c_slur*(rho_w/rho)*(g*D*(S-1)/((V^2)*sqrt(C_d)))^1.5)
        
        delta_p = (fric*rho*L*(V^2))/(D*2*g_c);
        
        P_f = delta_p*Q;
        
        total_power = (P_g + P_f)/550
        
        grinder_hp = P_g/550
        pump_hp = P_f/550
        
        V_c = ((40*g*c_slur*(S-1)*D)/(sqrt(C_d)))^0.5
        
        % COST STUFF
        initial_cost = 300*(P_g/550) + 200*(P_f/550);
        hrs_per_year = 8*300;  % 8 hrs per day, 300 days per year
        yearly_operating_cost = 0.07*(P_g/550)*hrs_per_year + 0.05*(P_f/550)*hrs_per_year;
        ir = 0.07;
        n = 7;  % number of years
        
        P = yearly_operating_cost*(((1 + ir)^n - 1)/(ir*(1 + ir)^n));
        
        total_cost = initial_cost + P
        
        diam_const = D - 0.5
        vel_const = -V + 1.1*V_c
        cos_const = c_slur - 0.4
        
        % objective function (what we're trying to optimize)
        f = total_cost;  % minimize total cost
        
        % inequality constraints (c<=0)
        c = zeros(3,1);
        c(1) = D - 0.5;       % D <= 0.5
        c(2) = -V + 1.1*V_c;  % V >= 1.1*V_c
        c(3) = c_slur - 0.4;  % c_slur <= 0.4
        
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