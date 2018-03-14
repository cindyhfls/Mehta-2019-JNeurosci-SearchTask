% This function outputs the initial_parameters x0, lower-bound lb and upperbound ub for
% fminsearchbnd, if using other optimization functions, you can just take
% x0

% The syntax is [x0,lb,ub] = get_initial_params(distributionName), where
% distribution name = 'linear','gaussian','vonmises' etc.
% More distribution needs to be added.

% REMEBER TO RESEED RANDOM BEFORE RUNNING THIS TO GET A DIFFERENT
% INITIALIZATION EACH TIME!!!
function [x0,lb,ub] = get_initial_params(distributionName,varargin)

if ~isempty(varargin)&& strcmp(distributionName,'mixedgaussian')
    k = varargin{1}; % specify the number of dimensions of variables
    dim = varargin{2};
    % for mixed gaussian
end

switch distributionName
    case 'vonmises'
        init_a = @() normrnd(0,0.5);
        init_kappa	= @() gamrnd(2, 1);
        init_theta	= @() rand*2*pi;
        x0 = [init_a(), init_kappa(), init_theta()];
        lb = [0, 0, -pi]; % param1 param2 param3 param4
        ub = [Inf Inf, pi]; % param1 param2 param3 param4
    case 'lineardist'
        init_k =  @()rand;
        %         init_b = @() rand+0.5*maxcount;
        x0 = [init_k()];
        lb = [-Inf];
        ub = [Inf];
    case 'gaussian'
        init_a = @() rand;
        %         init_b = @() rand;
        init_mu = @()randn;
        init_sigma = @() randn;
        x0 = [init_a(),init_mu(),init_sigma()];
        lb = [-Inf,-Inf,-Inf];
        ub = [Inf,Inf,Inf];
    case 'uniform'
        %         init_b = @() rand*meancount;
        %         x0 = init_b();
        %         lb = -Inf;
        %         ub = Inf;
        x0 = []; lb = -Inf; ub = Inf;
    case 'cosine'
        init_a = @()randn;
        init_theta = @()randn;
        x0 = [init_a(),init_theta()];
        lb = [-Inf,-pi];
        ub = [Inf,pi];
    case 'mixedgaussian'
        %  k = 1;
        %         dim = 2;  % 2 component
        init_mu = @()rand(1,k.*dim); % k*d matrix, where k is the number of components(peaks)
        % and d is 2 (2-D, xy space)
        init_sigma = @()rand(1,dim); % d-by-d-by-k  matrix, limits 0-1
        %       init_p = @()rand;% optional 1-by-k vector (sums to 1, or auto-normliazed) that states the mixing proportions
        init_a = @()rand;
        init_b = @()rand; % k*d matrix, where k is the number of components(peaks)
        % and d is 2 (2-D, xy space)
        x0 = [init_mu(),init_sigma(),init_a(),init_b()];
        lb = [zeros(1,(k+1)*dim),-Inf,-Inf];
        ub = [ones(1,(k+1)*dim),Inf,Inf];
end

end