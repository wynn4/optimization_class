% program to find displacements and stresses in a truss us FEM
clear;
clc

%get data for truss from Data.m file
Data

x = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5];

delta_x = 0.0001;

% insert areas (design variables) into correct matrix
for it=1:nelem
    x(1) = x(1) + delta_x*i;
    Elem(it,3) = x(it);
end

[weight,stress] = Truss(ndof, nbc, nelem, E, dens, Node, force, bc, Elem);
stress
weight

