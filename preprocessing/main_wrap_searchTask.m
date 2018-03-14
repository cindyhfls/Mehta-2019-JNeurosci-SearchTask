% main_wrap_searchTask
% 2018-02-08
% Cindy Jiaxin Tu

% initialize and load data
clear
clc
close all
dataDir = '../input_data/search_task_towrap';
dirInfo = dir(dataDir);
temp ={dirInfo(:).name};
MAT_Files=temp(contains(temp,'S.mat'));

%% parameters and pre-allocate
mydata = struct('var',[],'psth',[],'EyeX',[],'EyeY',[],'EyePupil',[],'FileName',[]);
binsize =0.01; % all in seconds
startoffset = 10;
endoffset = 10;

for i = 1:length(MAT_Files)
    FullfileName = fullfile(dataDir,MAT_Files{i}); % i
    load(FullfileName);
    
    % preallocate
    data = struct('var',[],'psth',[],'EyeX',[],'EyeY',[],'EyePupil',[],'FileName',[]);
    %% extract variables
    [var,strobesforpsth]= extractVarsSearchTask(Strobed);
    
    % get variables:
    % 1. fixation position
    % 2. masksOpened (last one is choice)
    % 3. opened mask reward size
    % 4. nstimuli on offer
    % 5. mask centers x,y
    % 6. DiamondDisappearTimeStamp(in s)
    % 7. All FixationReacquiredTimeStamps (in s)
    % strobesforpsth = vector of t0(fixation dot first complete)
    
    % N.B.
    % Theoretically,
    % temp = Strobed(Strobed(:,2)==4020,1);
    % produces the same results as the strobesforpsth
    % but just in case in some trials the fixation was reacquired after timeout
    % use strobesforpsth (which finds the first center fixation complete
    % Timestamp to avoid this bug
    %% Extract PSTH and Eye Data
    count = 0;
    for letter =['a','b','c','d','e']
        if exist(['SPK01',letter],'var') % exist as a variable
            eval(['SPK= SPK01',letter,';'])
            count = count+1;
        else
            break
        end
        data(count).var = var;
        tic
        data(count).psth= extractPSTHgeneric(SPK,strobesforpsth,startoffset,endoffset,binsize);
        toc
        disp('psth extracted');
        %% Extract Eye Data After Removing the Blinks
        tic
        EyeData = RemoveBlinksScript(FP14,FP15,FP16,FP15_ts,1); % 1 for filter on
        toc
        disp('eye data cleaned');
        % [Time,x,y,pupil]
        % disp('Press any key to continue and close the figures');
        % pause
        % close all
        %% Now Wrap Eye Data!
        [X,Y,Pupil]= extractEyegeneric(EyeData,strobesforpsth,startoffset,endoffset,binsize);
        toc
        disp('eye data extracted');
        data(count).EyeX = X;
        data(count).EyeY = Y;
        data(count).EyePupil = Pupil;
        data(count).FileName = MAT_Files{i};
    end
    temp =length(mydata);
    mydata(temp+1:temp+length(data))=data;
    toc
    disp([num2str(i),' data wrapped']);
end
mydata(1) = []; % remove the first empty row
save('../input_data/data_wrapped_Cindy.mat','mydata');
disp('save data to file');