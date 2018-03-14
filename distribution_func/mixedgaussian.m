% Gaussian Mixture Distribution (bivariate)
function y = mixedgaussian(xy, params,k,varargin)
% k = 1; k is the number of components/peaks
dim = size(xy,2); % dimension is the number of dimensions
mu = reshape(params(1:k*dim),k,dim); % k*d matrix, where k is the number of components(peaks)
% and d is 2 (2-D, xy space)
sigma = params(k*dim+1:k*dim+dim); % 1*d  matrix, limits 0-1 pooled covariance diagonal?
a = params((k+1)*dim+1);
b = params((k+1)*dim+2);
% p = params{5};% optional 1-by-k vector (sums to 1, or auto-normliazed) that states the mixing proportions
p = ones(1,k)/k; % use default p, for now
pd = gmdistribution(mu,sigma,p);

y = a*pdf(pd,xy)+b; % parameters a and b are scaling factors, 
% this is important if the output is the average count because pdf produces
% 0-1 values

end


%% some old plots to explore the effects of a and b in exploratory stage
% figure
% subplot(3,1,1)
% ezsurf(@(x,y)a*pdf(pd,[x y])+b,[-10 10],[-10 10])
% subplot(3,1,2)
% ezsurf(@(x,y)a*pdf(pd,[x y]),[-10 10],[-10 10])
% subplot(3,1,3)
% ezsurf(@(x,y)pdf(pd,[x y]),[-10 10],[-10 10])