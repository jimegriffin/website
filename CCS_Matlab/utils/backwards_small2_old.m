function [Conf_Set, prob, set_size] = backwards_small2_old(nodeToComponent, samples, prob_level)


numbofcliques = max(nodeToComponent);
sizeofcliques = zeros(1, numbofcliques);

Conf_Set = cell(1, numbofcliques);
min1 = zeros(1, numbofcliques);
min_pos = zeros(1, numbofcliques);
prob = cell(1, numbofcliques);
total_prob = ones(1, numbofcliques);


for i = 1:numbofcliques
    sizeofcliques(i) = sum(nodeToComponent == i);
    Conf_Set{1, i} = unique(samples(:, nodeToComponent == i), 'rows');
    prob{1, i} = zeros(size(Conf_Set{1, i}, 1), 1);
    [~, b1] = ismember(samples(:, nodeToComponent == i), Conf_Set{1, i}, 'rows');
    prob{1, i} = histcounts(b1, 1:(max(b1)+1))' / size(samples, 1);

    [x1, x2] = sort(prob{1, i}, 'descend');
    prob{1, i} = x1;
    Conf_Set{1, i} = Conf_Set{1, i}(x2, :);

    [min1(i), min_pos(i)] = min(prob{1, i});
end


check1 = 0;
while ( check1 == 0 )

    oldConf_Set = Conf_Set;
    oldprob = prob;

    score = zeros(1, length(Conf_Set));
    for i = 1:length(Conf_Set)
        if ( size(prob{1, i}, 1) > 1 )
            score(i) = (min1(i)) / sum(prob{1, i}) / (1 / size(prob{1, i}, 1));
        else
            score(i) = inf;
        end
    end

    [~, m2] = min(score);
    total_prob(m2) = total_prob(m2) - min1(m2);
    Conf_Set{1, m2}(min_pos(m2), :) = [];
    prob{1, m2}(min_pos(m2), :) = [];
    if ( size(prob{1, m2}, 1) > 1)
        [min1(m2), min_pos(m2)] = min(prob{1, m2});
    else
        min1(m2) = 1;
    end

    set_size = prod(total_prob);

    check1 = (set_size < prob_level) + (sum(min1 == 1) == numbofcliques);
end

if ( set_size < prob_level )
    Conf_Set = oldConf_Set;
    prob = oldprob;
end

