
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
        'FiniteDifferenceType', 'central', 'CheckGradients', true);
    
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
        c = zeros(20,1);         % create column vector
%         for i=1:10
%             c(i) = abs(stress(i))-25000; % check stress both pos and neg         
%         end
        % 20 separate constraints
        for i=1:10
            c(2*i-1) = (stress(i) - 25000)/1000;  % add constraints and divide by 1000 to provide scaling
            c(2*i) = (-stress(i) - 25000)/1000;
        end
        
        %equality constraints (ceq=0)
        ceq = [];
        nfun = nfun + 1;

    end

    % ------------Separate obj/con (do not change)------------
    function [f, gradf] = obj(x) 
        [f, ~, ~] = objcon(x);
        
        % compute the partial objective derivatives via complex step
        
        delta_x = 1e-4;                    % set the step size
        gradf = zeros(length(x),1);        % initialize gradient vector
        for it = 1:length(x)
            x_p = x;
            x_p(it) = x_p(it) + delta_x*i;
            [f_p, ~, ~] = objcon(x_p);
            gradf(it) = imag(f_p)/delta_x;
        end
    end
    function [c, ceq, DC, DCeq] = con(x) 
        [~, c, ceq] = objcon(x);
        
        % compute the partial constraint derivatives via complex step
        
        delta_x = 1e-4;                    % set the step size
        DC = zeros(length(c),length(x));        % initialize gradient vector
        for it = 1:length(x)
            x_p = x;
            x_p(it) = x_p(it) + delta_x*i;
            [~, c_p, ~] = objcon(x_p);
            DC(:, it) = imag(c_p)/delta_x;
        end
        DC = DC';
        DCeq = [];
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    