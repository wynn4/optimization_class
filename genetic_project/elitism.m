function next_generation = elitism(generation, new_generation)

[rows, cols] = size(generation);

% memory allocation
next_generation = zeros(rows, cols);

% the composite generation is the old and new_generation stacked on top of
% each other
comp_gen = vertcat(generation, new_generation);

% vector to hold the fitnesses of each chromosome
comp_fitness = zeros(2*rows, 1);

for i=1:2*rows
    % evaluate the fitness of each chromosome (design) and store it in our
    % vector
    comp_fitness(i) = compute_fitness(comp_gen(i,:));
end

% sort the comp_fitness vector in descending order (greatest ---> smallest)
% and get the indexes
[~, index] = sort(comp_fitness, 'descend');

% add the best chromosomes (designs) to the next generation
for i=1:rows
    
    % value of mIndex is the index from comp_gen corresponding to one of
    % the top 10 best (most fit) desings
    mIndex = index(i);
    % fill out the next_generation by grabbing the mIndex-th row from the
    % composite generation
    next_generation(i,:) = comp_gen(mIndex,:);
    
end



end