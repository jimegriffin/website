function [nodeToComponent, Conf_Set, prob_set, lograt, thresh] = find_cred_sets_MCMC3(samples, prob_level, M)

thresh = 1:size(samples, 2);
maxdepth = size(samples, 2);

n = size(samples, 1);
pdim = size(samples, 2);

x1 = cell(maxdepth, 1);
x2 = cell(maxdepth, 1);
Conf_Set = cell(maxdepth, 1);
prob_set = cell(maxdepth, 1);
nodeToComponent = cell(maxdepth, 1);
lograt = zeros(1, length(thresh));

x1{1, 1} = cell(pdim, 1);
for i = 1:size(x1{1, 1}, 1)
    x1{1, 1}{i, 1} = i;
    x2{1, 1}(i) = i;
end

nodeToComponent{1, 1} = zeros(1, pdim);
for i = 1:size(x1{1, 1}, 1)
    for j = 1:length(x1{1, 1}{i, 1})
        nodeToComponent{1, 1}(x1{1, 1}{i, 1}(j)) = i;
    end
end

[Conf_Set{1, 1}, prob_set{1, 1}, ~] = backwards_small2_old(nodeToComponent{1, 1}, samples, prob_level);

Conf_Set{1, 1}

storesize = 0;
storeDP = 0;
for i = 1:length(Conf_Set)
    storesize = storesize + log(size(Conf_Set{1, 1}{1, i}, 1));
    storeDP = storeDP + log(M) + gammaln(sum(nodeToComponent{1, 1} == i));
end
lograt(1) = storesize + storeDP;


check = 0;
count = 1;
while ( check == 0 )

    count = count + 1;

    [x1{count, 1}, x2{count, 1}] = find_uncorrelated2(samples, x1{count - 1, 1}, x2{count - 1, 1}, count);


    nodeToComponent{count, 1} = zeros(1, pdim);
    for i = 1:size(x1{count, 1}, 1)
        for j = 1:length(x1{count, 1}{i, 1})
            nodeToComponent{count, 1}(x1{count, 1}{i, 1}(j)) = i;
        end
    end


    [Conf_Set{count, 1}, prob_set{count, 1}, ~] = backwards_small2_old(nodeToComponent{count, 1}, samples, prob_level);

    storesize = 0;
    storeDP = 0;
    for i = 1:length(Conf_Set{count, 1})
        storesize = storesize + log(size(Conf_Set{count, 1}{1, i}, 1));
        storeDP = storeDP + log(M) + gammaln(sum(nodeToComponent{count, 1} == i));
    end
    lograt(count) = storesize + storeDP;

 %   'size'
  %  exp(storesize)
%    if (lograt(count) > 1 + min(lograt(1:count)))
%        check = 1;
%    elseif (count == length(thresh))
%        check = 1;
%    end
    if (count == length(thresh))
        check = 1;
    end

end

%'final'
%count
lograt = lograt(1:count);
thresh = thresh(1:count);
Conf_Set = Conf_Set(1:count, 1);
prob_set = prob_set(1:count, 1);
nodeToComponent = nodeToComponent(1:count, 1);




