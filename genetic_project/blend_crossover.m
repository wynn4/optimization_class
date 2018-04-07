function children = blend_crossover(parents, p_crossover)

[n_parents, n_genes] = size(parents);

% Pick a random value between 0 and 1
val = rand(1);

% Determine whether or not crossover takes place
if val <= p_crossover
    % Perform blend crossover
else
    % No crossover occurs and the children are clones of the parents
    children = parents;
    return
end

% Initialize matrix to hold children
children = zeros(n_parents, n_genes);

for i=1:n_genes
    
    % Pick a random value between 0 and 1
    r = rand(1);
    
    % Perform the blend crossover
    children(1,i) = r*parents(1,i) + (1-r)*parents(2,i);
    children(2,i) = (1-r)*parents(1,i) + r*parents(2,i);
    
    % Since each gene of the children chromosomes (designs) must be an
    % integer value in order to be valid, we round to the closest integer
    children(1,i) = round(children(1,i));
    children(2,i) = round(children(2,i));
    
    % And since each gene has a valid range of values, we saturate the
    % values to their max or min
    switch i
        case 1
            children(1,i) = saturate(children(1,i), 4, 1);
            children(2,i) = saturate(children(2,i), 4, 1);
        case 2
            children(1,i) = saturate(children(1,i), 6, 1);
            children(2,i) = saturate(children(2,i), 6, 1);
        case 3
            children(1,i) = saturate(children(1,i), 2, 1);
            children(2,i) = saturate(children(2,i), 2, 1);
        case 4
            children(1,i) = saturate(children(1,i), 5, 1);
            children(2,i) = saturate(children(2,i), 5, 1);
        case 5
            children(1,i) = saturate(children(1,i), 3, 1);
            children(2,i) = saturate(children(2,i), 3, 1);
        case 6
            children(1,i) = saturate(children(1,i), 4, 1);
            children(2,i) = saturate(children(2,i), 4, 1);
        otherwise
            disp("Error. Number of genes does not match number of cases.")
            return
    end
    
end

end

function rval = saturate(val, max, min)

if val > max
    rval = max;
elseif val < min
    rval = min;
else
    rval = val;
end


end




