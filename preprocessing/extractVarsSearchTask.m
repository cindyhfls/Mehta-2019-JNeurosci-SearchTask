% extract variables
function [var,strobesforpsth]= extractVarsSearchTask(Strobed)
% specify the start and end strobes for each trial
startIdx = find(Strobed(:,2)<2000);% Trial Start
endIdx = find(Strobed(:,2)==6400); % ITI

% find the total trial number for that neuron
if startIdx(1) == 1
    trialnum = length(endIdx);
else
    trialnum = length(endIdx)-1;
end

% preallocate memory for variables
strobesforpsth = cell(trialnum,1);
var = cell(trialnum,7);

% wrap variable Info
for i = 1:trialnum
    if startIdx(1)>endIdx(1)
        swithintrial = Strobed(startIdx(i):endIdx(i+1),2);
        twithintrial = Strobed(startIdx(i):endIdx(i+1),1);
    else
        swithintrial = Strobed(startIdx(i):endIdx(i),2);
        twithintrial = Strobed(startIdx(i):endIdx(i),1);
    end
    
    % center xy
    var{i,1} = swithintrial(swithintrial>=18000 & swithintrial<=19000)-18000;
    % masksopened(last one is choice)
    var{i,2} = swithintrial(swithintrial>=20000 & swithintrial<=20999)-20000;
    % opened mask reward size (last one is choice)
    var{i,3} = swithintrial(swithintrial>=10000 & swithintrial<=10999)-10000;
     % number of stimuli on screen
    var{i,4} = swithintrial(swithintrial>=9000 & swithintrial<=9010)-9000;
    % x,y positions of diamonds
    var{i,5} = [swithintrial(swithintrial>=14000 & swithintrial<=15999)-14000,...
        swithintrial(swithintrial>=16000 & swithintrial<=17999)-16000];
    
    % get important timestamps
    % Fixation complete (first time)
    t0 = twithintrial(find(swithintrial==4020,1));% find(X==z,1) returns only the first match
    % Diamond Disappear Timestamp
    t1 = twithintrial(swithintrial>=5100 & swithintrial<=5199);
    % flag for all fixation complete Timestamps (including reacquisition after timeout)
    t2 = twithintrial(swithintrial==4020);
    % break fixation on diamond viewing Timestamp (if any)
    t3 = twithintrial(swithintrial==5002);
    % fixation point appear Timestamp
    t4 = twithintrial(swithintrial==4000);
    % ITI Timestamp
    t5 = twithintrial(swithintrial==6400);
    
    % Now assign timestamp for diamond disappear-timestamp for first fixation
    % complete (in seconds)
    var{i,6}= t1-t0; % time from trial start to each fixation completes to open mask
    var{i,7}=var{i,6}(end);
    var{i,8}= t2-t0; % yime for trial start to each center fixation completes (just to check if there is timeout)
    var{i,9} =t3-t0;
    var{i,10} = t4-t0; % should be a negative number
    var{i,11} = t5-t0;
    
%     strobesforpsth(i) = t0;
%     strobesforpsth{i} = twithintrial(swithintrial==5004); % align to saccade onset
      strobesforpsth{i} = twithintrial(swithintrial==5000); % align to diamond fixation
      strobesforpsth{i}(1) = []; % remove the first diamond viewed
end
end