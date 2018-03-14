% data arranged in numObservartions * numVars matrix
% params arranged in numParams*numVars cells
% right now I just assumed that the same type of distribution for each
% variable, which are indepedent from each other, but I will change that to
% be more flexible later
function llkd = log_likelihood(vars,spikes,params,distribution)

% query the number of variables in data
numVars = size(vars,2); % how many columns?

% Depending on function, compute log-likelihood
% 
% if uses bernoulli assumption, spks = 1 or 0 (discarded)
%     bernoulli_p = distribution(x_data, x_params); % This part should be flexibly changed.
%     x_llkd = spikes .* log(bernoulli_p) + (1 - spikes) .* log(1 - bernoulli_p);


%perhaps poisson is a better description?
lambda = distribution(vars,params);
% lambda is dependent on both x and y, here it is calculated by adding the x and y effect linearly,
% but it is also possible to introduce additional terms, by modifying the
% vars input, e.g. vars = [X,Y,XY,X./Y,X.^2] etc.

% An important point to note also is that if the distribution does not
% include a linear constant term, i.e. the \beta 0 term, e.g. Gaussian? Then perhaps that should
% be added in the distribution function, because we did not add it here.
% E.g. y = e.^x +b instead of y = e.^x. For linear/vonmises it is fine.

var_llkd = spikes.*(log(lambda))-lambda-log(factorial(spikes));
% Note: Firing Counts takes Poisson Distribution
% prob = (lambda^k*e-lambda)/factorial(k)

llkd = sum(var_llkd); % get the sum of llkd for that variable

end
