
function [xopt, fopt, exitflag] = fminun(obj, gradobj, x0, stoptol, algoflag)

% get function and gradient at starting point
[n,~] = size(x0); % get number of variables
f = obj(x0);
grad = gradobj(x0);
x = x0;

%set starting step length
alpha0 = 0.5;

if (algoflag == 1)     % steepest descent
    s = srchsd(grad, 1);
elseif (algoflag == 2)    % conjugate gradient
    s = srchsd(grad, 0);  % don't normalize search dir.
elseif (algoflag == 3)
    s = 10;    % BFGS Quasi-Newton
else
    disp('Error: Valid values for algoflag are 1, 2, or 3.')
    return;
end

% initialize variables
alpha = alpha0;
num_iterations = 0;
max_iterations = 1e3;


% if n < 2 || n > 3
%     disp('Function Error: Number of variables must be either 2 or 3')
%     xopt = [];
%     fopt = [];
%     exitflag = 1;
%     return
% end

%% Steepest Descent
if algoflag == 1  % steepest descent
    while num_iterations < max_iterations
        
        % start going along the function in the direction of s
        xnew = x + alpha*s;
        
        % evaluate the function at xnew
        fnew = obj(xnew);
        
        % if we're making progress going in the s direction...
        if fnew < f
            
            % double alpha and then keep going
            alpha = alpha*2;
            
            % set f equal to fnew and go again
            f = fnew;
            
            % Here we know we've gone too far.  Now we can conduct a
            % line search, find the approprate alpha, and start working
            % in a new search direction.
        elseif fnew > f
            
            a1 = alpha/4;
            a2 = alpha/2;
            a3 = alpha;
            a4 = (a3 + a2)/2;
            
            % Now we need to pick the 3 points we will use
            % to bracket the minimum and perform the quadratic
            % line search.
            
            % evaluate the function at each
            f1 = obj(x + a1*s);
            f2 = obj(x + a2*s);
            f3 = obj(x + a3*s);
            f4 = obj(x + a4*s);
            
            % find the minimum point
            [~, idx] = min([f1, f2, f3, f4]);
            
            if idx == 2
                a1 = a1;
                a2 = a2;
                a3 = a4;
                
                f1 = f1;
                f2 = f2;
                f3 = f4;
                
            elseif idx == 4
                a1 = a2;
                a2 = a4;
                a3 = a3;
                
                f1 = f2;
                f2 = f4;
                f3 = f3;
                
            elseif idx == 1
                
                % in this case we need to go one more step back in the
                % past. we also need to compute these in reverse order.
                
                a3 = a2;
                a2 = a1;
                a1 = a1/2;
                
                
                f3 = f2;
                f2 = f1;
                f1 = obj(x + a1*s);
                
            else
                % this case shouldn't happen
                disp('Unexpected case: idx containing minimum value = 3')
            end
            
            % find the 'optimal' alpha using a quadratic line search
            a_star = qline_search(a1, f1, a2, f2, a3, f3);
            
            % set a new 'x' value using a_star and the current search dir
            x = x + a_star*s;
            
            % evaluate the gradient at this new 'x' location
            grad = gradobj(x);
            
            % find our new search direction to start going in
            s = srchsd(grad, 1);
            
            % reset alpha down to a small number
            alpha = alpha0;
            
            % increment the iteration count
            num_iterations = num_iterations + 1;
            
            % check to see if the gradient is close enough to zero
            % i.e. we're at the optimum.
            if norm(grad) < stoptol
                break
            end
            
        else
            % f isn't changing so we've reached an optimum?
            break
        end
        
        
    end
end

%% Conjugate Gradient
if algoflag == 2  % conjugate gradient
    first_time = 1;
    while num_iterations < max_iterations
        
        % start going along the function in the direction of s
        xnew = x + alpha*s;
        
        % evaluate the function at xnew
        fnew = obj(xnew);
        
        % if we're making progress going in the s direction...
        if fnew < f
            
            % double alpha and then keep going
            alpha = alpha*2;
            
            % set f equal to fnew and go again
            f = fnew;
            
            % Here we know we've gone too far.  Now we can conduct a
            % line search, find the approprate alpha, and start working
            % in a new search direction.
        elseif fnew > f
            
            a1 = alpha/4;
            a2 = alpha/2;
            a3 = alpha;
            a4 = (a3 + a2)/2;
            
            % Now we need to pick the 3 points we will use
            % to bracket the minimum and perform the quadratic
            % line search.
            
            % evaluate the function at each
            f1 = obj(x + a1*s);
            f2 = obj(x + a2*s);
            f3 = obj(x + a3*s);
            f4 = obj(x + a4*s);
            
            % find the minimum point
            [~, idx] = min([f1, f2, f3, f4]);
            
            if idx == 2
                a1 = a1;
                a2 = a2;
                a3 = a4;
                
                f1 = f1;
                f2 = f2;
                f3 = f4;
                
            elseif idx == 4
                a1 = a2;
                a2 = a4;
                a3 = a3;
                
                f1 = f2;
                f2 = f4;
                f3 = f3;
                
            elseif idx == 1
                
                % in this case we need to go one more step back in the
                % past. we also need to compute these in reverse order.
                
                a3 = a2;
                a2 = a1;
                a1 = a1/2;
                
                
                f3 = f2;
                f2 = f1;
                f1 = obj(x + a1*s);
                
            else
                % this case shouldn't happen
                disp('Unexpected case: idx containing minimum value = 3')
            end
            
            % find the 'optimal' alpha using a quadratic line search
            a_star = qline_search(a1, f1, a2, f2, a3, f3);
            
            % set a new 'x' value using a_star and the current search dir
            
            % if this is is the first step (aka we got here via steepest descent)
            if first_time == 1
                first_time = 0;
                
                x_plus = x + a_star*s;
                
                % evaluate the gradient at this new 'xplus' location
                grad_plus = gradobj(x_plus);
                
                % compute beta
                beta = (grad_plus'*grad_plus)/(grad'*grad);
                
                % our previous search dir
                s = srchsd(grad, 0);  % don't normalize this time
                
                % find our new conjugate gradient search direction to go in
                s_plus = -grad_plus + beta * s;
            else
                x_plus = x + a_star*s;
                
                % evaluate the gradient at this new 'xplus' location
                grad_plus = gradobj(x_plus);
                
                % compute beta
                beta = (grad_plus'*grad_plus)/(grad'*grad);
                
                % find our new conjugate gradient search direction to go in
                s_plus = -grad_plus + beta * s;
                
            end
            
            % reset alpha down to a small number
            alpha = alpha0;
            
            % re-assign variable names for the next loop
            x = x_plus;
            s = s_plus;
            grad = grad_plus;
            
            % increment the iteration count
            num_iterations = num_iterations + 1;
            
            % check to see if the gradient is close enough to zero
            % i.e. we're at the optimum.
            if norm(grad) < stoptol
                break
            end
            
        else
            % f isn't changing so we've reached an optimum?
            break
        end
        
        
    end
end

%%%%%%%%%%%%%%%%%
% function exit %
%%%%%%%%%%%%%%%%%

if num_iterations >= max_iterations
    max_iter_str = num2str(max_iterations);
    err_str = strcat('Failed to converge to an optimum after ', max_iter_str, ' iterations.');
    disp([newline, err_str])
end



num_iterations
xopt = x;
fopt = obj(x);
exitflag = 0;

end

% get steepest descent search direction as a column vector
function [s] = srchsd(grad, normalized)
if normalized == 1
    mag = sqrt(grad'*grad);
    s = -grad/mag;
else
    s = -grad;
end
end

% quadratic line search
function a_star = qline_search(a1, f1, a2, f2, a3, f3)

num = f1*(a2^2 - a3^2) + f2*(a3^2 - a1^2) + f3*(a1^2 - a2^2);
den = 2*(f1*(a2 - a3) + f2*(a3 - a1) + f3*(a1 -a2));

a_star = num/den;
end