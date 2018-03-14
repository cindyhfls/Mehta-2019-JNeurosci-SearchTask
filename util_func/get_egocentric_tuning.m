% Regression for Current and Future Diamond Position
% Saccade direction coding
% Egocentric
% epoch = 961:1000;
% neuron = 1;
% Find out trials which have >1 masks opened
% and get all the diamonds except for the last one
function [deltatheta,spkc] = get_egocentric_tuning(data,neuron,epoch)
% numDiamondEachTrial = cell(neuron,1);
% for neuron = 1:length(data)
Diamonds = {data(neuron).vars.masksOpened};
numDiamondEachTrial = arrayfun(@(i)length(Diamonds{i}),[1:length(Diamonds)]');


[X,Y,spkc,theta] = get_xyspike_priyanka(data,neuron,epoch);

A = numDiamondEachTrial;
deltatheta = cell(length(A),1);
for i=1:length(A)
    deltaX = diff(X(sum(A(1:i-1))+1:sum(A(1:i))));
    deltaY = diff(Y(sum(A(1:i-1))+1:sum(A(1:i))));
    deltatheta{i} = [theta(sum(A(1:i-1))+1);atan2(deltaY,deltaX)];
% deltatheta{i} = atan2(deltaY,deltaX);
    % the first one is the first diamond from the fixation
end
deltatheta = cell2mat(deltatheta);
end

% figure;bar(numMultipleDiamondTrials);hold on
% hline = refline(0,mean(numMultipleDiamondTrials));
% hline.LineStyle = '--';
% title('Number of Trials where the monkey looks at >1 diamond');