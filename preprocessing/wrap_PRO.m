% Tyler's wrap function
function output = wrap_PRO()

clearvars i k directory_name fileIndex fileName files output_data
%analysis options
lb_time = 10; % number of seconds to analyze before given trial event
ub_time = 10; % number of seconds to analyze after given trial event
bin_factor = 10; % in 10 ms bins? 

% function should take in: file dir (data)
directory_name = uigetdir; % pull up window to go to folder for data
files = dir(directory_name);

fileIndex = find(~[files.isdir]); % find all the files in the folder

for k = 1:length(fileIndex)
%% Wrap pupil data

    clearvars idx diff_idx corr_cond corr_cond_idx corr_idx vars pupilStart pupilChoice pupilFeedback

fileName = files(fileIndex(k)).name;

% load the files one at a time
load(fileName);

corr_cond_lo = 1;
corr_cond_hi = 0;
corr_idx_lo = 1;
corr_idx_hi = 0;
for m = 1:length(FP15_ts)
% find trials w/ #events not equal to (29, 30, or 31)
if m ~= length(FP15_ts)
    idx = find((Strobed(:,2) == 6010)&((Strobed(:,1)>=FP15_ts(m,1))&(Strobed(:,1)<=FP15_ts(m+1,1))));
elseif m == length(FP15_ts)
    idx = find((Strobed(:,2) == 6010)&((Strobed(:,1)>=FP15_ts(m,1))));
end
if ~isempty(idx)
if isempty(find(Strobed(1:idx(1,1),2)==6020,1,'last'))
    idx = idx(2:end,1);
end

diff_idx = (idx(2:end)-idx(1:(end-1)));
corr_cond_hi = corr_cond_hi + length(diff_idx);
corr_cond(corr_cond_lo:corr_cond_hi) = ((diff_idx >= 29) & (diff_idx <= 31));
corr_cond_idx = find(corr_cond(corr_cond_lo:corr_cond_hi));
corr_idx_hi = corr_idx_hi + length(corr_cond_idx);
corr_idx(corr_idx_lo:corr_idx_hi) = idx(corr_cond_idx,1); %#ok<*FNDSB> % the actual Strobed indices of trials to use for analysis
corr_cond_lo = corr_cond_lo + length(diff_idx);
corr_idx_lo = corr_idx_lo + length(corr_cond_idx);
end
end

corr_idx = corr_idx';
% [[[FIX THIS]]]  [[[FIX THIS]]]  [[[FIX THIS]]] (why??)
% if isempty(find(Strobed(1:corr_idx(corr_cond_lo,1),2)==6020,1,'last')) % make sure there's a trialStart before the first ITI detected
%     corr_idx(corr_cond_lo:corr_cond_hi) = corr_idx(2:end,1);
% end

% now have index of where all correct trials begin
% this is what you use for rest of analysis

% vars = NaN(length(correct_trials), # of vars)
global vars
vars = NaN(length(corr_idx),27);

% now create the vars matrix
% the columns are as follows:
% 1     Trial Number
% 2     Start Time
% 3     End Time
% 4     Duration
% 5     Offer1On Time
% 6     Offer1Off Time
% 7     Offer2On Time
% 8 	Offer2Off Time
% 9     Choice Start Time
% 10    Feedback Time
% 11	End Num Tokens
% 12	Begin Num Tokens
% 13	is_JackpotTrial
% 14	orderOfLeft
% 15	Choice Side
% 16	left_gamble
% 17	rght_gamble
% 18	leftTop_value
% 19	leftBot_value
% 20	rghtTop_value
% 21	rghtBot_value
% 22	Outcome
% 23	offer1_EV
% 24	offer2_EV
% 25    chosenOffer_EV
% 26    smallReward_size
% 27    largeReward_size
% 28    Delay Time (choice made)

% for the spike data (columns):
% 6-9 are start
% 10-13 are choice
% 14-17 are feedback
% 18-21 are offer1

for i = 1:length(corr_idx)
    vars(i,1) = Strobed((corr_idx(i,1)+1),2); % trial number -- always 1 down from ITI
    trialStart_idx = find(Strobed(1:corr_idx(i,1),2)==6020,1,'last'); % find the first 6020 before this trial's 6010
    vars(i,2) = Strobed(trialStart_idx,1); % trial start time -- the time at the above index
    vars(i,3) = Strobed((corr_idx(i,1)),1); % trial end time -- equal to start of ITI
    vars(i,4) = vars(i,3) - vars(i,2); % duration -- end time minus start time
        trialOffer1On_idx = find(Strobed(1:corr_idx(i,1),2)==6030,1,'last'); % find the last 6030 before this trial's 6010
    vars(i,5) = Strobed(trialOffer1On_idx,1); % trial offer1 on time -- the time at the above index
        trialOffer1Off_idx = find(Strobed(1:corr_idx(i,1),2)==6040,1,'last'); % find the last 6040 before this trial's 6010
    vars(i,6) = Strobed(trialOffer1Off_idx,1); % trial offer1 off time -- the time at the above index
        trialOffer2On_idx = find(Strobed(1:corr_idx(i,1),2)==6050,1,'last'); % find the last 6050 before this trial's 6010
    vars(i,7) = Strobed(trialOffer2On_idx,1); % trial offer2 on time -- the time at the above index
        trialOffer2Off_idx = find(Strobed(1:corr_idx(i,1),2)==6060,1,'last'); % find the last 6060 before this trial's 6010
    vars(i,8) = Strobed(trialOffer2Off_idx,1); % trial offer2 off time -- the time at the above index
        trialChoice_idx = find(Strobed(1:corr_idx(i,1),2)==6080,1,'last'); % find the last 6080 before this trial's 6010
    vars(i,9) = Strobed(trialChoice_idx,1); % trial choice time -- the time at the above index
        trialFeedback_idx = find(Strobed(1:corr_idx(i,1),2)==6100,1,'last'); % find the last 6100 before this trial's 6010
    vars(i,10) = Strobed(trialFeedback_idx,1); % trial feedback time -- the time at the above index
    vars(i,11) = Strobed((corr_idx(i,1)+8),2); % number of tokens at end of trial -- always 8 down from ITI
        if i==1
    vars(i,12) = 0; % for the first trial, the beginning number of tokens is zero...
        else
    vars(i,12) = vars((i-1),11); % number of tokens at beginning of trial = number of tokens at end of previous trial
        end
    vars(i,13) = Strobed((corr_idx(i,1)+13),2); % is_JackpotTrial -- always 13 down from ITI
    vars(i,14) = Strobed((corr_idx(i,1)+14),2); % orderOfLeft -- always 14 down from ITI
    vars(i,15) = Strobed((corr_idx(i,1)+15),2); % choice side -- always 15 down from ITI
    vars(i,16) = Strobed((corr_idx(i,1)+11),2)/100; % left gamble -- always 11 down from ITI
    vars(i,17) = Strobed((corr_idx(i,1)+12),2)/100; % right gamble -- always 12 down from ITI
        trialLeftTop_idx = corr_idx(i,1)+4; % index of left top gamble value -- always 4 down from ITI
        if Strobed(trialLeftTop_idx,2) < 7000 
    vars(i,18) = Strobed(trialLeftTop_idx,2); % if the gamble value is positive...
        else
    vars(i,18) = (Strobed(trialLeftTop_idx,2)-7000)*(-1); % if the gamble value is negative, this is the conversion
        end
        trialLeftBot_idx = corr_idx(i,1)+5; % index of left bottom gamble value -- always 5 down from ITI
        if Strobed(trialLeftBot_idx,2) < 7000
    vars(i,19) = Strobed(trialLeftBot_idx,2); % if the gamble value is positive...
        else
    vars(i,19) = (Strobed(trialLeftBot_idx,2)-7000)*(-1); % if the gamble value is negative, this is the conversion
        end
        trialRightTop_idx = corr_idx(i,1)+6; % index of right top gamble value -- always 6 down from ITI
        if Strobed(trialRightTop_idx,2) < 7000
    vars(i,20) = Strobed(trialRightTop_idx,2); % if the gamble value is positive...
        else
    vars(i,20) = (Strobed(trialRightTop_idx,2)-7000)*(-1); % if the gamble value is negative, this is the conversion
        end
        trialRightBot_idx = corr_idx(i,1)+7; % index of right bottom gamble value -- always 7 down from ITI
        if Strobed(trialRightBot_idx,2) < 7000
    vars(i,21) = Strobed(trialRightBot_idx,2); % if the gamble value is positive...
        else
    vars(i,21) = (Strobed(trialRightBot_idx,2)-7000)*(-1); % if the gamble value is negative, this is the conversion
        end
        trialOutcome_idx = corr_idx(i,1)+16; % index of trial outcome -- always 16 down from ITI
        if (Strobed(trialOutcome_idx,2) == 1) && (vars(i,15) == 1) % if outcome = top and choice side = left...
    vars(i,22) = vars(i,18); % then the outcome is equal to the left top gamble value
        elseif (Strobed(trialOutcome_idx,2) == 2) && (vars(i,15) == 1) % if outcome = bottom and choice side = left...
    vars(i,22) = vars(i,19); % then the outcome is equal to the left bottom gamble value
        elseif (Strobed(trialOutcome_idx,2) == 1) && (vars(i,15) == 2) % if outcome = top and choice side = right...
    vars(i,22) = vars(i,20); % then the outcome is equal to the right top gamble value
        elseif (Strobed(trialOutcome_idx,2) == 2) && (vars(i,15) == 2) % if outcome = bottom and choice side = right...
    vars(i,22) = vars(i,21); % then the outcome is equal to the right bottom gamble value
        end
        if vars(i,14) == 1 % if the left offer was presented first...
    vars(i,23) = (vars(i,18) * vars(i,16)) + (vars(i,19) * (1-vars(i,16))); % then offer 1 EV = EV of left top/bottom
    vars(i,24) = (vars(i,20) * vars(i,17)) + (vars(i,21) * (1-vars(i,17))); % and offer 2 EV = EV of right top/bottom
        else % or if the right offer was presented first, it's the same as above but with the sides switched;
    vars(i,23) = (vars(i,20) * vars(i,17)) + (vars(i,21) * (1-vars(i,17))); % so offer 1 EV = EV of right top/bottom
    vars(i,24) = (vars(i,18) * vars(i,16)) + (vars(i,19) * (1-vars(i,16))); % and offer 2 EV = EV of left top/bottom
        end
        if vars(i,15) == 1 % if the monkey chose the left offer...
    vars(i,25) = (vars(i,18) * vars(i,16)) + (vars(i,19) * (1-vars(i,16))); % then chosen offer EV = EV of left top/bottom
        elseif vars(i,15) ==2 % or if the monkey chose the right offer...
    vars(i,25) = (vars(i,20) * vars(i,17)) + (vars(i,21) * (1-vars(i,17))); % then chosen offer EV = EV of right top/bottom
        end
    vars(i,26) = Strobed((corr_idx(i,1)+2),2); % small reward size -- always 2 down from ITI
    vars(i,27) = Strobed((corr_idx(i,1)+3),2); % large reward size -- always 3 down from ITI
        pupilOffer1On_idx = round((vars(i,5)-FP15_ts)/FP15_ts_step);
    trialDelay_idx = find((Strobed(1:corr_idx(i,1),2)==6090),1,'last'); % find the last 6080 before this trial's 6010
    vars(i,28) = Strobed(trialDelay_idx,1); % trial choice time -- the time at the above index
end


% ^ can add quality control that all trial event time stamps must be beteween
% start/end time ^ 

% raw pupil size matrix x3 (start, choice, feedback aligned)
% save the full ones; 

pupilStart = [];
pupilChoice = [];
pupilFeedback = [];
pupilOffer1On = [];
pupilOffer2On = [];
for i = 1:length(corr_idx)
    for j = 1:length(FP15_ts)
    pupilStart_idx = round((vars(i,2)-FP15_ts(j,1))/FP15_ts_step);
    if (pupilStart_idx >= (lb_time * 1000)) && (length(FP15)-pupilStart_idx >= (ub_time * 1000))
        lower_bound = pupilStart_idx-(lb_time * 1000);
        upper_bound = pupilStart_idx+(ub_time * 1000);
        pupilStart(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = ...
            FP15(lower_bound:(bin_factor):upper_bound,1); %#ok<*AGROW>
    else
        pupilStart(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = NaN;
    end
    
    pupilChoice_idx = round((vars(i,9)-FP15_ts(j,1))/FP15_ts_step);
    if (pupilChoice_idx >= (lb_time * 1000)) && (length(FP15)-pupilChoice_idx >= (ub_time * 1000))
        lower_bound = pupilChoice_idx-(lb_time * 1000); % x1000 because converting to milliseconds
        upper_bound = pupilChoice_idx+(ub_time * 1000);
        pupilChoice(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = FP15(lower_bound:(bin_factor):upper_bound,1);
    else
        pupilChoice(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = NaN;
    end

    pupilFeedback_idx = round((vars(i,10)-FP15_ts(j,1))/FP15_ts_step);
    if (pupilFeedback_idx >= (lb_time * 1000)) && (length(FP15)-pupilFeedback_idx >= (ub_time * 1000))
        lower_bound = pupilFeedback_idx-(lb_time * 1000);
        upper_bound = pupilFeedback_idx+(ub_time * 1000);
        pupilFeedback(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = FP15(lower_bound:(bin_factor):upper_bound,1);
    else
        pupilFeedback(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = NaN;
    end
    
    pupilOffer1On_idx = round((vars(i,5)-FP15_ts(j,1))/FP15_ts_step);
    if (pupilOffer1On_idx >= (lb_time * 1000)) && (length(FP15)-pupilOffer1On_idx >= (ub_time * 1000))
        lower_bound = pupilOffer1On_idx-(lb_time * 1000);
        upper_bound = pupilOffer1On_idx+(ub_time * 1000);
        pupilOffer1On(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = FP15(lower_bound:(bin_factor):upper_bound,1);
    else
        pupilOffer1On(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = NaN;
    end

    pupilOffer2On_idx = round((vars(i,7)-FP15_ts(j,1))/FP15_ts_step);
    if (pupilOffer2On_idx >= (lb_time * 1000)) && (length(FP15)-pupilOffer2On_idx >= (ub_time * 1000))
        lower_bound = pupilOffer2On_idx-(lb_time * 1000);
        upper_bound = pupilOffer2On_idx+(ub_time * 1000);
        pupilOffer2On(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = FP15(lower_bound:(bin_factor):upper_bound,1);
    else
        pupilOffer2On(i,1:(((lb_time*1000)+(ub_time*1000))/bin_factor)+1) = NaN;
    end
    end
end

if k == 1 % create the output_data cell array on the first loop
    output_data = cell(1,6);
end
    
output_data{k,1} = vars;
output_data{k,2} = pupilStart;
output_data{k,3} = pupilChoice;
output_data{k,4} = pupilFeedback;
output_data{k,5} = pupilOffer1On;
output_data{k,6} = pupilOffer2On;

%% Wrap spike data



% output should be one cell array (.mat)
% comment inputs/outputs in code

% should there be a column for the name of the session?

% in later analysis, start with downsample

% put lower/upper bound times at beginning of function
% downsample already



% output_data = cell(#numfile, 1)
format compact
files_remaining = length(fileIndex)-k
end

% save three separate files for start, choice, and feedback respsectively
% for j = 1:length(output_data)
%     trialStartFile{j,1} = output_data{j,1};
%     trialStartFile{j,2} = output_data{j,2};
%     trialChoiceFile{j,1} = output_data{j,1};
%     trialChoiceFile{j,2} = output_data{j,3};
%     trialFeedbackFile{j,1} = output_data{j,1};
%     trialFeedbackFile{j,2} = output_data{j,4};
% end

[file,path] = uiputfile;
cd(path);
save(file,'output_data', '-v7.3');

% [file,path] = uiputfile;
% cd(path);
% save(file,'trialStartFile', '-v7.3');
% 
% [file,path] = uiputfile;
% cd(path);
% save(file,'trialChoiceFile', '-v7.3');
% 
% [file,path] = uiputfile;
% cd(path);
% save(file,'trialFeedbackFile', '-v7.3');

end

 

