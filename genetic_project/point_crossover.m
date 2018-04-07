function children = point_crossover(parents, p_crossover)

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

% Initialize children to be clones of the parents
children = parents;

% Choose the crossover point
point_cross = randi(n_genes);

if point_cross == n_genes
    % No tail to swap so children = parents
    return
else
    % Chop off the tails of the parent chromosomes at the crossover point
    parent_1_tail = parents(1, point_cross + 1:end);
    parent_2_tail = parents(2, point_cross + 1:end);
    
    % Swap the tails and now we have two children chromosomes
    children(1,point_cross + 1:end) = parent_2_tail;
    children(2,point_cross + 1:end) = parent_1_tail;
    
end

end




