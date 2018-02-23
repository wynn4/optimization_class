
    % ------------Starting point and bounds------------
    %design variables
    x0 = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5]; %starting point (all areas = 5 in^2)
    lb = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]; %lower bound
    ub = [20, 20, 20, 20, 20, 20, 20, 20, 20, 20]; %upper bound
    global nfun;
    nfun = 0;

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    
    % ------------Call fmincon------------
    tic;
    options = optimoptions(@fmincon,'display','iter-detailed','Diagnostics','on');
    options = optimoptions(options, 'SpecifyObjectiveGradient', true, 'SpecifyConstraintGradient', true,...
        'FiniteDifferenceType', 'central', 'CheckGradients', false);
    [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);
    eltime = toc;
    eltime
    xopt    %design variables at the minimum
    fopt    %objective function value at the minumum
    [f, c, ceq] = objcon(xopt);
    c
    nfun

    % ------------Objective and Non-linear Constraints------------
    function [f, c, ceq] = objcon(x)
        global nfun;
        
        %get data for truss from Data.m file
        Data
        
        % insert areas (design variables) into correct matrix
        for i=1:nelem
            Elem(i,3) = x(i);
        end

        % call Truss to get weight and stresses
        [weight,stress] = Truss(ndof, nbc, nelem, E, dens, Node, force, bc, Elem);

        %objective function
        f = weight; %minimize weight
        
        %inequality constraints (c<=0)
        c = zeros(10,1);         % create column vector
        for i=1:10
            c(i) = abs(stress(i))-25000; % check stress both pos and neg         
        end
        
        %equality constraints (ceq=0)
        ceq = [];
        nfun = nfun + 1;

    end

    % ------------Separate obj/con (do not change)------------
    function [f, gradf] = obj(x) 
        [f, ~, ~] = objcon(x);
        
        % compute forward difference objective derivatives
        
        delta_x = 1e-4;                    % set the step size
        gradf = zeros(length(x),1);        % initialize gradient vector
        
        % perturb each element of x and compute the partial derivatives
        for i = 1:length(x)
            x_p = x;                       % reset x_p                    
            x_p(i) = x_p(i) + delta_x;     % perturb x_p
            [f_p, ~, ~] = objcon(x_p);     % compute objective at perturbed x
            gradf(i) = (f_p - f)/delta_x;  % compute forward diff derivative
        end
    end
    
    function [c, ceq, DC, DCeq] = con(x) 
        [~, c, ceq] = objcon(x);
        
        % compute forward difference constraint derivatives
        
        delta_x = 1e-4;                    % set the step size
        DC = zeros(length(x));             % initialize gradient vector
        
        % perturb each element of x and compute the partial derivatives
        for i = 1:length(x)
            x_p = x;                       % reset x_p                    
            x_p(i) = x_p(i) + delta_x;     % perturb x_p
            [~, c_p, ~] = objcon(x_p);     % compute constraint at perturbed x
            DC(i,:) = (c_p - c)/delta_x;   % compute forward diff derivative
            DCeq = [];
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    