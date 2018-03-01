clc
clear

f = [10; 20];
x = [2; 3];
S = [3, 4; 2, 5; 1, 2];

K = [2*x(1), (3*x(1) + x(2)); (3*x(1) + x(2)), 5*x(2)]

dkdx1 = [2, 3; 3, 0];
dkdx2 = [0, 1; 1, 5];

invK = inv(K);


u = invK*f

dsigma_dx1 = -S*invK*(dkdx1*u)

dsigma_dx2 = -S*invK*(dkdx2*u)