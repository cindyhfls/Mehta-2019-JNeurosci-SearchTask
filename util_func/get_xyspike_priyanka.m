% Using Priyanka's already wrapped data, 
% get the X,Y position of diamonds, as well as spkc and MaskValue during
% the epoch of fixation in each trial

% For now the X,Y data are normalized to 0-1. [0,0] being upper left,
% [1,1] being lower right (The psychotoolbox Y starts from the top to
% bottom)
% 1-11 and 71-122 uses the screen 1600*900
% 12-70 uses a screen size of 1920*1080 instead
function [X,Y,spkc,Theta,MaskValue]= get_xyspike_priyanka(data,n,epoch)
L=arrayfun(@(i)length(data(n).vars(i).masksOpened),[1:length(data(n).vars)]'); % get the number of masks opened in each trial
%% Obtain Spike
spike = data(n).psth_alignedBarView(:,epoch); %CHANGE ME%
%% Obtain XY
tempfun = @(i)data(n).vars(i).maskCenters(data(n).vars(i).masksOpened,:);
MaskPos=cell2mat(arrayfun(tempfun,[1:length(L)]','UniformOutput',false));
%% Obtain Reward Values
tempfun = @(i)[data(n).vars(i).thisTrialRewards_ml(data(n).vars(i).masksOpened)]';
MaskValue=cell2mat(arrayfun(tempfun,[1:length(L)]','UniformOutput',false));
%% Calculate the mean firing count/rate and the XY positions
spkc = sum(spike,2);
% spkr = sum(spike,2)/(size(spike,2)/100);
X = MaskPos(:,1);
Y = MaskPos(:,2);
%% Normalize to 0-1
if n>=12 && n<=70
    X = X/1920;
    Y = Y/1080;
    Theta = atan2((1080*Y-540),(1920*X-960));
else
    X = X/1600;
    Y = Y/900;
    Theta = atan2((900*Y-450),(1600*X-800)); 
end
end