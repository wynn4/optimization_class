
function [xopt, fopt, exitflag] = fminun(obj, gradobj, x0, stoptol, algoflag)

% get function and gradient at starting point
[n,~] = size(x0); % get number of variables
f = obj(x0);
grad = gradobj(x0);
x = x0;

%set starting step length
alpha = 0.001;

if (algoflag == 1)     % steepest descent
    
    % get the static search direction
    s = srchsd(grad)
end

while (abs(grad(1,1)) > stoptol && abs(grad(2,1)) > stoptol)
    
    % take a step
    xnew = x + alpha*s;
    fnew = obj(xnew);
    
%     % did the objective function value decrease?
%     if (fnew < f)
%         % double alpha
%         alpha = alpha*2;
%     end
%     
%     % did we overshoot?
%     if(fnew > f)
%         alpha = (alpha + alpha_prev)/2;
%     end
    
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