i = 1;
f = @(vars)vonmises(vars,fakeparams(i,:)');
figure;
fplot(f,[-pi,pi])