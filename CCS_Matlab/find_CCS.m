function [thresh, lograt, nodeToComponent, Conf_Set, prob_set, VarNames] = find_CCS(samples, VarNames, prob_level, threshold, M)

type = 2;
% type = 1 is thresholded correlation matrix
% type = 2 is likelihood ratio score

%pdim = size(samples, 2);

[samples, VarNames, ~] = screened(samples, VarNames, threshold);

if ( type == 1)
    thresh = linspace(0.95, 0.01, 199);
    storesize = zeros(1, length(thresh));
    storeDP = zeros(1, length(thresh));
    lograt = zeros(1, length(thresh));

    check = 0;
    count = 0;
    while ( check == 0 )

        count = count + 1;
        [nodeToComponent, Conf_Set, prob_set, set_size, Corr1, Cov1] = find_cred_sets_MCMC2(samples, thresh(count), prob_level);

        for i = 1:length(Conf_Set)
            storesize(count) = storesize(count) + log(size(Conf_Set{1, i}, 1));
            storeDP(count) = storeDP(count) + log(M) + gammaln(sum(nodeToComponent == i));
      %      storeDP(count) = 0;
        end
        lograt(count) = storesize(count) + storeDP(count);

        if (lograt(count) > 1 + min(lograt(1:count)))
            check = 1;
        elseif (count == length(thresh))
            check = 1;
        end
    end
    lograt = lograt(1:count);
    thresh = thresh(1:count);

    m1 = min(lograt);
    count = find(lograt == m1, 1, 'first');

    [nodeToComponent, Conf_Set, prob_set, set_size, Corr1, Cov1] = find_cred_sets_MCMC2(samples, thresh(count), prob_level);
elseif ( type == 2 )
    [nodeToComponent, Conf_Set, prob_set, lograt, thresh] = find_cred_sets_MCMC3(samples, prob_level, M);

    lograt

    m1 = min(lograt);

    m1

    count = find(lograt == m1, 1, 'first');
%    count = find(lograt == m1, 1, 'last');

    count

    Conf_Set = Conf_Set{count, 1};
    prob_set = prob_set{count, 1};
    nodeToComponent = nodeToComponent{count, 1};
end


check = zeros(1, length(Conf_Set));
for i = 1:length(Conf_Set)
    check2 = zeros(1, size(Conf_Set{1, i}, 2));
    for j = 1:size(Conf_Set{1, i}, 2)
        if ( sum(Conf_Set{1, i}(:, j)) == 0 )
            check2(j) = 1;
        end
    end
    Conf_Set{1, i}(:, check2 == 1) = [];
    if ( sum(check2) > 0 )
        pos = find(nodeToComponent == i);
        nodeToComponent(pos(check2 == 1)) = [];
        VarNames(pos(check2 == 1)) = [];
    end
    if ( isempty(Conf_Set{1, i}) == 1 )
        check(i) = 1;
    end
end
Conf_Set(check == 1) = [];
prob_set(check == 1) = [];
for j = 1:max(nodeToComponent)
    nodeToComponent(nodeToComponent == j) = sum(1 - check(1:j));
end

