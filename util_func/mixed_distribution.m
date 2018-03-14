% mixed_distribution([X,Y,Z...],[paramsX,paramsY,paramsZ],{distribution1,distribution2,distribution3});
% Remember to put the mydists as a cell input;
% This is not including mixed_gaussian
function lambda = mixed_distribution(vars,params,mydists,partitioncoef)

for i = 1:length(mydists)
eval(['distribution{i} = @(var_data,var_params)',mydists{i},'(var_data, var_params);']); %%% CHANGE ME %%%
end

% I should make the params input here a long vector and then reshape into
% the shape I want. This is a pain in the ass so I will do it later

numObs = size(vars,1);
% Input check:
numVars = size(vars,2);
% numParams = size(params,2);
% numParams = numel(params);
numDistribution = length(mydists);

if numVars ~= numDistribution
    if numDistribution == 1 % if there is only one input for distribution
        mydists = repmat(mydists,1,numVars); % use the same distribution for all the variables
        numDistribution = numVars;
    else
        error('Input Error: Number of distributions too many/too few');
    end
end

temp = NaN(numObs,numDistribution); % preallocate
for n = 1:numDistribution
    thisdistribution = mydists{n};
    psel = partitioncoef(n)+1:partitioncoef(n+1)+partitioncoef(n); % parse the parameters for each distribution
    % partitioncoef = [0,4,2] means the first distribution has four
    % parameters and the second has 2.
    if strcmp(thisdistribution,'uniform') % don't calculate for uniform
        temp(:,n) = 0;
    else
    temp(:,n) = distribution{n}(vars(:,n),params(psel)); % get output from each distribution
    end
end

b = params(end); % the last one is b

lambda = nansum(temp,2)+ones(size(temp,1),1).*b; % add constant term
% E.g. lambda = vonmises(X)+linear(Y)+gaussian(Velocity)+ b
end

