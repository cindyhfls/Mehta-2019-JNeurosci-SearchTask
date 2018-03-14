% DailyNeuralDataOrganize
DataDir = '../input_data/search_task_wrapped'


% alining at starting time
close all
clear
clc

% load data
load(fullfile(DataDir,'J170425.ST14.1S.mat'));

cellNum=999; % waiting to be processed

%%

SPK=SPK01a;
% SPK=SPK01b; % chanel 01 cell b
% SPK=SPK01c;
% SPK=SPK01d;

% SPK=SPK02a;
% SPK=SPK02b;

% SPK=SPK_FILT_WB01a;
% SPK=SPK_FILT_WB01b;
% SPK=SPK_FILT_WB01c;
% SPK=WB01a;
% SPK=WB01b;

% totalStarts=sum(Strobed(:,2)==8001)
% 
% findStarts=find(Strobed(:,2)==8001)
% 
% % double check the sequence
% a=find(Strobed(:,2)==6020);
% b=find(Strobed(:,2)==6090);
% c=b-a;
% d=sum(~find(c==-11))
%% get psth of one cell out of one day, one session

% memo for all the strobes:

% task
% 4001 1st opt appears
% 4002 1st opt disappears
% 4003 2st opt appears
% 4035 2st opt disappears
% 4004 Fixation dot appears
% 4005 3rd op appears
% 4006 3rd op disappears
% 4007 choice onset "go signal"
% 4008 feedback
% 4009 ITI
% 4051 firstly looked at option 1... 4052 firstly looked option 2
% 4061 fixation 
% 4062 fixation lost
% 4073 fixed on right

% other vars

%	1 - 2000: trial numbers
%	8201 - 8203 : Number of options

%	30XX: gamble prob for left XX = prob*100 
%	33XX: gamble prob for right XX = prob*100 
%	35XX: gamble prob for center XX = prob*100

%	12ABC: Option order, ABC=(order(1)*100)+( order(2)*10 )+ order(3) 1:Left 2:Right 3:Center

%	13ABC: ABC=(notBlueOps(1)*100)+(notBlueOps(2)*10)+notBlueOps(3) 
%   notBlueOps ABC [position] corresponds to A=left B=right C=central
%   the value on each [notBlueOps ABC position]   
%   2:safe gamble, medium reward
%   1 && gamble win: Green, huge reward 
%   0 && gamble win: Blue, large reward
%   gamble not win: nothing


%	8001 - 8003 : Choice 1:Left 2:Right 3:Center 
%	10001 - 10003: Gamble outcome 0:Safe 1:Lose 2:Win

%   reward size: medium=150ul, large=180ul, huge=210ul, +10500
%   --> medium=10650, large=10680, huge= 10710

%   chance3op=0 no third option
%	7000, 7200, 7400: chance3op*100+7000, chance of a third option, of safe (grey), large (blue) huge (green)
%	20000 - 20004: Location of three options. Not used.


%%%%% FOR SEARCH TASK %%%%%%%

startStrobe=4020; %fixation complete
%%
strobeName(:,1)=Strobed(:,2);

temp=find(strobeName>12999 & strobeName<14000);
theCpltEnd=temp(end);
clear temp;

temp=find(strobeName==startStrobe);
theCpltBeginning=temp(1);
clear temp;

temp=Strobed(theCpltBeginning:theCpltEnd,:);

%% get vars of one cell out of one day, one session

% vars = extractVars2(Strobed);
[vars,strobesFromVars]= extractVars3(Strobed);

%%

% [psth,meanTrialDuration] = extractPSTH( Strobed,SPK,startStrobe,0.01);
[psth,meanTrialDuration] = extractPSTH3(Strobed,SPK,startStrobe,0.01,strobesFromVars);
%%
% close all

%% variable names && task Structure

names = {'TrialNum';'CumulativeTrialNum';'LeftProb';'RightProb';...
    'LorRAppearedFirst';'LeftRwdMag';'RightRwdMag';...
    'Choice'; 'GambleOutcome'; 'Aligned at 1st opt on'};

% 1op on; 1op off; 2op on; 2op off; fixation; choice; feedback; ITI
timeLine=[0.4; 0.6; 0.4; 0.6; 0.1; 0.2; 0.25; 1.2];



% organize data

neuron.psth=psth;
neuron.vars=vars;
neuron.names=names;
neuron.timeLine=timeLine;
neuron.estTrlDuration=sum(timeLine);
neuron.meanTrlDuration=meanTrialDuration;

totalTrialNum=size(vars,1)

% save(['J.StagOps32_lessTrls' 'Cell' num2str(cellNum) '.mat'], 'neuron')


