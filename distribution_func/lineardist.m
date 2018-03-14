% linear distribution
% This function outputs the output value for the neuron firing based on its
% fitted distribution about the variables input in the equation
function output = lineardist(vars,params)
% each column of vars and params should match!
% number of parameters should be in proportion to the number of variables
numVars = size(vars,2); % each column is a variable
numParams = size(params,2); 
if numParams ~= numVars
        error('Input Error: The number of columns in parameter does not match with the number of columns of variables');
% elseif size(params,1) ~=2 % check rows of params
% %     Warning('Input Error: Too many/few parameters!')
end
params = params(1,:); % only take the first two parameters if more are provided

temp = arrayfun(@(n)params(n).* vars(:,n),1:numVars,'UniformOutput',false); % y = kx
output = sum(cell2mat(temp),2); 

end