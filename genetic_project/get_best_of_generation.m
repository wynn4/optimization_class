function best_design = get_best_of_generation(generation)

[rows, ~] = size(generation);


% vector to hold the fitnesses of each chromosome
fitnesses = zeros(rows, 1);

for i=1:rows
    % evaluate the fitness of each chromosome (design) and store it in our
    % vector
    fitnesses(i) = compute_fitness(generation(i,:));
end

% sort the fitnesses vector in descending order (greatest ---> smallest)
% and get the indexes
[~, index] = sort(fitnesses, 'descend');

% the best index is the first one since they're sorted in descending order
bestIndex = index(1);

best_design = generation(bestIndex,:);


end