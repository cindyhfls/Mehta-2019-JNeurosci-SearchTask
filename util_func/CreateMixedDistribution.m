% distribution Names
distributionName = {'vonmises','gaussian'};
numVars = size(vars,2);
distribution = cell(numVars,1);
for n = 1:numVars
eval(['mydistribution = @(var_data,var_params)',distributionName{n},'(var_data, var_params)']);
distribution{n,1} = mydistribution;
end

% calculate the total number of parameters needed:
% uniform: 1
% linear: 2
% gaussian: 4
% vonmises: 4
numTotalParams = 0;
for n = 1:numVars
switch distributionName{n}
    case 'uniform'
        numTotalParams = numTotalParams+1;
    case 'linear'
        numTotalParams = numTotalParams+2;
    case {'gaussian','vonmises'}
        numTotalParams = numTotalParams+4;
end
end

allx0 = NaN(numTotalParams,1);alllb = NaN(numTotalParams,1);allub = NaN(numTotalParams,1);
for n= 1:numVars
[x0,lb,ub] = get_initial_params(distributionName{n},spkc);
allx0
end