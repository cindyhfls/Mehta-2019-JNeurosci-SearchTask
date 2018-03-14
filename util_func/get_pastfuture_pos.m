% Get Previous and Future Position

function [X,Y,spkc,theta] = get_pastfuture_pos(data,neuron,epoch,pastfuture)
% Find out trials which have >1 masks opened

% numDiamondEachTrial = cell(neuron,1);
% for neuron = 1:length(data)

Diamonds = {data(neuron).vars.masksOpened};
numDiamondEachTrial = arrayfun(@(i)length(Diamonds{i}),[1:length(Diamonds)]');


[X,Y,spkc,theta] = get_xyspike_priyanka(data,neuron,epoch);

A = numDiamondEachTrial;

switch pastfuture
    case 'past'
        spkcp = [spkc(2:end);NaN];
        theta(end) = NaN;
        % use the spkc for 2nd to last diamond to fit the position of the previous
        % diamond
        
        for i = 1:length(A)
            X(sum(A(1:i-1))+1) = NaN; % the first value to be NaN
            Y(sum(A(1:i-1))+1) = NaN;
            theta(sum(A(1:i-1))+1) = NaN;
            spkcp(sum(A(1:i-1))+1) = NaN;
        end
        spkc = spkcp(~isnan(spkcp)); % assign for output
        theta = theta(~isnan(spkcp));
    case 'future'
        spkcf = [NaN;spkc(1:end-1)];
        theta(1) = NaN;
        % use the spkc for 1st to end-1 diamond to fit the position of the
        % future diamond
        for i = 1:length(A)
            X(sum(A(1:i))) = NaN; % the first value to be NaN
            Y(sum(A(1:i))) = NaN;
            theta(sum(A(1:i))) = NaN;
            spkcf(sum(A(1:i))) = NaN;
        end
        spkc = spkcf(~isnan(spkcf)); % assign for output
        theta = theta(~isnan(spkcf));
end
end
