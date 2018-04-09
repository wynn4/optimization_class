function avg_fitness = compute_average_fitness(generation)

[rows, ~] = size(generation);

fit_vals = zeros(rows, 1);

for i=1:rows
    fit_vals(i) = compute_fitness(generation(i,:));
end

avg_fitness = sum(fit_vals)/rows;
end