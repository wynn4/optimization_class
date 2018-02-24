
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
    
%     options = optimoptions(options, 'MaxFunctionEvaluations', 1);
%     [xopt, fopt, exitflag, output, lambda, grad, hessian] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);
    
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
        % c = zeros(10,1);         % create column vector
        % for i=1:10
            % c(i) = (abs(stress(i))-25000)/1000; % check stress both pos and neg (scale by dividing by 1000)         
        % end
        
        c = zeros(20,1);
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
        
        % compute central difference objective derivatives
        
        delta_x = 1e-4;                    % set the step size
        gradf = zeros(length(x),1);        % initialize gradient vector
        
        % perturb each element of x and compute the partial derivatives
        for i = 1:length(x)
            x_p = x;                             % reset x_p
            x_m = x;
            x_p(i) = x_p(i) + delta_x;           % perturb x_p
            x_m(i) = x_m(i) - delta_x;
            [f_p, ~, ~] = objcon(x_p);           % compute objective at perturbed x
            [f_m, ~, ~] = objcon(x_m);           % compute objective at perturbed x
            gradf(i) = (f_p - f_m)/(2*delta_x);  % compute central diff derivative
        end
        
        % myobjgrad = gradf
    end
    
    function [c, ceq, DC, DCeq] = con(x) 
        [~, c, ceq] = objcon(x);
        
        % compute central difference constraint derivatives
        
        delta_x = 1e-4;                    % set the step size
        DC = zeros(length(c),length(x));             % initialize gradient vector
        
        % perturb each element of x and compute the partial derivatives
        for i = 1:length(x)
            x_p = x;                             % reset x_p
            x_m = x;
            x_p(i) = x_p(i) + delta_x;           % perturb x_p
            x_m(i) = x_m(i) - delta_x;
            [~, c_p, ~] = objcon(x_p);           % compute constraint at perturbed x
            [~, c_m, ~] = objcon(x_m);           % compute constraint at perturbed x
            DC(:,i) = (c_p - c_m)/(2*delta_x);   % compute forward diff derivative
            DCeq = [];
        end
        DC = DC';
        % mycongrad = DC
    end
    
  % gradients after first evaluation  
  
  % from fmincon's gradient solver
%   grad =
% 
%   36.000000000378563
%   36.000000000378563
%   36.000000000378563
%   36.000000000378563
%   36.000000000378563
%   36.000000000378563
%   50.911688244951051
%   50.911688244951051
%   50.911688244951051
%   50.911688244951051

  % from the gradient I computed
%   myobjgrad =
% 
%   36.000000000058208
%   36.000000000058208
%   36.000000000058208
%   36.000000000058208
%   36.000000000058208
%   36.000000000058208
%   50.911688244923425
%   50.911688244923425
%   50.911688244923425
%   50.911688244923425
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    