addpath 'utils'

close all

samples = load('samples.txt');



close all

M = 2;
prob_level = 0.5;
% probability level for Cartesian credible set
threshold = 0.04;
% threshold for screening PIPs

AllVarNames = {'S', 'PH', 'IFP', 'NLP', 'NGP', 'NGL', 'NS', 'MHG'};

[thresh, lograt, nodeToComponent, Conf_Set, prob_set, VarNames] = find_CCS(samples, AllVarNames, prob_level, threshold, M);
% thresh = the value of the algorithmic parameter eta
% lograt = the value of the ease-of-understanding penalized criterion
% nodeToComponent = a vector whose i-th entry is the block for the i-th
% variable
% Conf_Set = a cell whose i-th entry is a matrix containing the block
% credible set for the i-th block (each row is a sub-model)
% prob_set = a cell whose i-th entry is a vector giving the marginal PIP
% for each sub-model in the i-th block


figure(1)
plot(thresh, lograt);


figure(2)
totalrows = plots_CCS(nodeToComponent, 1:size(samples, 2), Conf_Set, prob_set, VarNames, 13);



