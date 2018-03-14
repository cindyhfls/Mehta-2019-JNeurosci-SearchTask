% cosine distribution for angular
function output = cosine(vars,params)
numVars = size(vars,2); % each column is a variable
numParams = size(params,2); 
if numParams ~= numVars % check columns of params
    error('Input Error: The number of columns in parameter does not match with the number of columns of variables');
end
params = params(1:2,:); % only take the first four parameters if more are provided

myfun = @(x,a,theta)a * cos(x-theta); % original gaussian function with scaling factor

temp = arrayfun(@(n)myfun(vars(:,n),params(1,n),params(2,n)),1:numVars,'UniformOutput',false);
output = sum(cell2mat(temp),2); 

end