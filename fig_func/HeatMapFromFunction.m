% ezcontour/fcontour and ezsurf/fsurf,ezsurfc 
% These functions can generate contour/heat map in 2D/3D which can be
% compared to the imagesc and surf values

% plot the final lambda values? This should be comparable to the mean
% firing counts in the heat map

% the x,y values are symbolic, so they are automatically set according to
% their limits

% lambda = @(x,y) distribution(x,fit_params(:,1))+ distribution(y,fit_params(:,2));
function HeatMapFromFunction(data,result)
distribution = result.distribution{:};
epoch = result.epoch;
n = result.neuron;
% [X,Y,spkc,MaskValue]= get_xyspike_priyanka(data,n,epoch);
% vars = [X,Y];
fit_params = result.fit_params;
lambda = @(vars) distribution(vars,fit_params);

figure;
subplot(2,1,1)
fcontour(lambda,[0,1,0,1]);
subplot(2,1,2)
fsurf(lambda,[0,1,0,1]);
end
% fcontour(@(x,y) pdf(lambda,[x y]), [0 1 0,1]);
% contour plotting
% fcountour/ezcontour(fun,domain)
% 
% % fsurf
% fun = @(x,y) sin(x)+cos(y);
% fsurf(fun,[xmin xmax ymin ymax])
% fsurf(@(x,y) pdf(GMModel,[x y]), [0 1 0,1])

% parametrized surface plot
% this is really helpful, because x and y values can be separatedly
% specified as functions of u and v.
% r = @(u,v) 2 + sin(7.*u + 5.*v);
% funx = @(u,v) r(u,v).*cos(u).*sin(v);
% funy = @(u,v) r(u,v).*sin(u).*sin(v);
% funz = @(u,v) r(u,v).*cos(v);
% fsurf(funx,funy,funz,[0 2*pi 0 pi]) 
% camlight