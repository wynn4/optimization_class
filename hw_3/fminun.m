
function [xopt, fopt, exitflag] = fminun(obj, gradobj, x0, stoptol, algoflag)

% get function and gradient at starting point
[n,~] = size(x0); % get number of variables
f = obj(x0);
grad = gradobj(x0);
x = x0;

% Set starting step length.
alpha0 = 0.2;

if (algoflag == 1)     % Steepest Descent
    
    % Get the static search direction.
    s = srchsd(grad)
end

% Set alpha to alpha0.
alpha = alpha0;

while (abs(grad(1,1)) > stoptol && abs(grad(2,1)) > stoptol)
    
    % Take a step.
    xnew = x + alpha*s;
    fnew = obj(xnew);
    
    % Did the objective function value decrease?
    if (fnew < f)
        
        % double alpha and keep going
        alpha = alpha*2;
        
    % Here we've gone to far. Time to setup a line search.
    elseif (fnew > f)
        a1 = alpha/4;
        a2 = alpha/2;
        a3 = alpha;
        a4 = (alpha + a2)/2;
        
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
        elseif idx == 4
            a1 = a2;
            a2 = a4;
            a3 = a3;
        else
            disp('Error')
        end
        
        
    else
    end
    
    x = xnew;
    f = fnew;
    grad = gradobj(xnew);
end

xopt = xnew;
fopt = fnew;
exitflag = 0;

end

% get steepest descent search direction as a column vector
function [s] = srchsd(grad)
mag = sqrt(grad'*grad);
s = -grad/mag;
end

% quadratic line search
function a_star = qline_search(a1, f1, a2, f2, a3, f3)

num = f1*(a2^2 - a3^2) + f2*(a3^2 - a1^2) + f3*(a1^2 - a2^2);
den = 2*(f1*(a2 - a3) + f2*(a3 - a1) + f3*(a1 -a2));

a_star = num/den;
end