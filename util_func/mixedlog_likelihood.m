function llkd = mixedlog_likelihood(vars,spikes, params, distributionName,partitioncoef,varargin)

lambda = mixed_distribution(vars,params,distributionName,partitioncoef); 
% discarded the neglambda function

var_llkd = spikes.*(log(lambda))-lambda-log(factorial(spikes));

% Note: Firing Counts takes Poisson Distribution
% prob = (lambda^k*e-lambda)/factorial(k)

llkd = sum(var_llkd); % get the sum of llkd for that variable
end