% Get Grid Search For Better Start Point
numPoints = 10000;
fval = NaN(numPoints,1);
points = NaN(8,numPoints);
lb = 0;
ub = 50;
genx0 = @(num)normrnd(ub,100,num,1)+rand;
switch distributionName
    case 'gaussian'
        num_params = 8;
        for ct = 1:numPoints
            rng(ct,'twister');
            x0=genx0(num_params);
            fval(ct)=-log_likelihood(vars,spkc,reshape(x0,4,2),distribution);
            points(1:8,ct) = x0;
        end
end

%%


temp = imag(fval);

% [numPoints,num_params]=size(points);
% 
% fval = NaN(numPoints,1);
% for i=1:numPoints
%     thisparams = reshape(points(i,:),4,2);
%     fval(i) = obj(thisparams);
% end


figure;
subplot(2,2,1)
scatter(points(1,temp~=0),points(2,temp~=0),10,[0.5,0.5,0.5],'filled');hold on
scatter(points(1,temp==0),points(2,temp==0),10,fval(temp==0),'filled');colorbar
xlabel('param 1');ylabel('param 2');
subplot(2,2,2)
scatter(points(3,temp~=0),points(4,temp~=0),10,[0.5,0.5,0.5],'filled');hold on
scatter(points(3,temp==0),points(4,temp==0),10,fval(temp==0),'filled');colorbar
xlabel('param 3');ylabel('param 4');
subplot(2,2,3)
scatter(points(5,temp~=0),points(6,temp~=0),10,[0.5,0.5,0.5],'filled');hold on
scatter(points(5,temp==0),points(6,temp==0),10,fval(temp==0),'filled');colorbar
xlabel('param 5');ylabel('param 6');
subplot(2,2,4)
scatter(points(7,temp~=0),points(8,temp~=0),10,[0.5,0.5,0.5],'filled');hold on
scatter(points(7,temp==0),points(8,temp==0),10,fval(temp==0),'filled');colorbar
xlabel('param 7');ylabel('param 8');