function [nodeToComponent, Conf_Set, prob_set, set_size, Corr1, Cov1] = find_cred_sets_MCMC2(samples, thresh, prob_level)

Cov1 = cov(samples);
Corr1 = corr(samples);
Corr1(isnan(Corr1)) = 0;

mat1 = (Corr1 > thresh) .* Corr1;

G2 = graph(mat1, 'omitselfloops','lower');
nodeToComponent = conncomp(G2);

[Conf_Set, prob_set, set_size] = backwards_small2_old(nodeToComponent, samples, prob_level);
