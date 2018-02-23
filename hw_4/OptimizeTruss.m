
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
    function [f, gradf, c, ceq, DC] = objcon(x)
        global nfun;
        
        % specify derivative method (1 == forward_diff, 2 == central_diff, 3 == complex_step)
        diff_method = 2;
        
        %get data for truss from Data.m file
        Data
        
        % insert areas (design variables) into correct matrix
        for i=1:nelem
            Elem(i,3) = x(i);
        end
        
        % store derivative data
        dwda = zeros(10,1);
        dsda = zeros(10,10);
        
        % compute forward-difference derivatives
        if diff_method == 1
            
            % set the step size
            delta_x = 1e-4;
            
            for i = 1:nelem
                % un-perturb the matrix before each loop
                pElem = Elem;
                
                % perturb the ith element
                pElem(i,3) = pElem(i,3) + delta_x;
                
                % compute weight and stress with the perturbed element
                [weight_perturb, stress_perturb] = Truss(ndof, nbc, nelem, E, dens, Node, force, bc, pElem);
                
                % compute weight and stress w/o the perturbation
                [weight_unper, stress_unper] = Truss(ndof, nbc, nelem, E, dens, Node, force, bc, Elem);
                
                % fill out the partial derivatives vectors
                dwda(i) = (weight_perturb - weight_unper)/delta_x;  % partial of weight wrt area
                
                dsda(i,:) = (stress_perturb - stress_unper)/delta_x;  % partial of stress wrt to area
                
            end
        end
        
        % compute central-difference derivatives
        if diff_method == 2
            
            % set the step size
            delta_x = 1e-4;
            
            for i = 1:nelem
                % un-perturb the matrix before each loop
                pElem_plus = Elem;
                pElem_minus = Elem;
                
                % perturb the ith element forward then backward
                pElem_plus(i,3) = pElem_plus(i,3) + delta_x;
                pElem_minus(i,3) = pElem_minus(i,3) - delta_x;
                
                % compute weight and stress with the perturbed element
                [weight_perturb_plus, stress_perturb_plus] = Truss(ndof, nbc, nelem, E, dens, Node, force, bc, pElem_plus);
                
                % compute weight and stress w/o the perturbation
                [weight_perturb_minus, stress_perturb_minus] = Truss(ndof, nbc, nelem, E, dens, Node, force, bc, pElem_minus);
                
                % fill out the partial derivatives vectors
                dwda(i) = (weight_perturb_plus - weight_perturb_minus)/(2*delta_x);
                
                dsda(i,:) = (stress_perturb_plus - stress_perturb_minus)/(2*delta_x);
                
            end
        end
        
        gradf = dwda;
        DC = dsda;

        % call Truss to get weight and stresses
        [weight,stress] = Truss(ndof, nbc, nelem, E, dens, Node, force, bc, Elem);

        %objective function
        f = weight; %minimize weight
        
        %inequality constraints (c<=0)
        c = zeros(10,1);         % create column vector
%         for i=1:10
%             if stress(i) < 0
%                 c(i) = -stress(i) -25000;
%             else
%                 c(i) = stress(i) - 25000;
%             end
%         end
        c(i) = abs(stress(i))-25000; % check stress both pos and neg
        
        %equality constraints (ceq=0)
        ceq = [];
        nfun = nfun + 1;

    end

    % ------------Separate obj/con (do not change)------------
    function [f, gradf] = obj(x) 
        [f, gradf, ~, ~, ~] = objcon(x);
    end
    function [c, ceq, DC, DCeq] = con(x) 
        [~, ~, c, ceq, DC] = objcon(x);
        DCeq = [];
    end