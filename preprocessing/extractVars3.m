function [vars strobesFromVars]= extractVars3(Strobed)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% this code is for stagops 32 data

tempData=Strobed(:,2);
trialIndx=find(tempData<2000); % Trial Number
totalStart= length(trialIndx);
% varsNum=diff(trialIndx);
% min(varsNum)
% max(varsNum)

trialEnd=find(tempData==6400); %CHANGE ME% 6400 ITI
totalEnd=length(trialEnd);

%% fixation and lost of fixation were causing the difference in strobed vars
% find(varsNum==69)
% trialIndx(477)
% tempData(ans-70:ans+70)

%%
varMat=[];
nextPSTHstrobe=[];
errorStartIndx=[];
% for i=1:size(trialEnd)
for i=1:totalStart
   endIndx=find(trialEnd-trialIndx(i)==14); % only wrap complete trials?
   % there are 15 var strobes in stagops32 task
   if ~isempty(endIndx)
       varMat(end+1,:)=tempData(trialIndx(i):trialEnd(endIndx));
       nextPSTHstrobe(end+1,1)=trialIndx(i)+15;
       % there are 15 var strobes in stagops32 task
   else
       errorStartIndx(end+1)=i;
   end
end


trlNum=size(varMat,1);

vars(:,1)=1:trlNum; % trial num
vars(:,2)=varMat(:,1); % cumulative trial num
vars(:,3)=(varMat(:,3)-3000)/100; % prob of left gamble
vars(:,4)=(varMat(:,4)-3300)/100; % prob of right gamble
for j=1:trlNum
    temp=num2str(varMat(j,6));
    vars(j,5)=str2num(temp(3)); % left=1/right=2 gamble appears first
    clear temp
end

for k=1:trlNum
    temp=num2str(varMat(k,7));
    if str2num(temp(3))==3 % due to a un-necessary step in michael's code
        vars(k,6)=0;
    else
        vars(k,6)=str2num(temp(3)); % left gamble rwd magnitude: 0=large 1=huge 2=medium/safe
    end
    
    if str2num(temp(4))==3
        vars(k,7)=0;
    else
        vars(k,7)=str2num(temp(4)); % right gamble rwd magnitude
    end
    clear temp
end

vars(:,8)=varMat(:,8)-8000; % choice: 1=Left 2=Right
vars(:,9)=varMat(:,9)-10000; % outcome 0:Safe 1:Lose 2:Win

strobesFromVars=nextPSTHstrobe(1:end-1);

end

