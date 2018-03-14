% get x,y and spikes
% To-do: introduce error catching to remove trials which are too long, i.e.
% end-of-trial stamp > 10 s 
% Find out what proportion of trials were like that, perhaps increasing the
% psth endoffset to 15 s could help?
% clear
% clc
% load ('../input_data/data_wrapped_Cindy.mat','mydata');
% data = mydata; clear mydata
function [Xpos,Ypos,spike]= get_xyspike(data,n)
%% Get vectors of Xpos,Ypos and spike for each trial
% using the timestamps, i.e. var 7, for each diamond disappearance
col = 7;  % data(unit).var{:,7} end-of-trial
binsize =0.01; % This info comes from the wrapping code
startoffset = 2/binsize;

for unit = n % which neuron
        lengthtrial= length(data(unit).var);
        endTrial = ceil([data(unit).var{:,col}]*1/binsize+startoffset);
        endTrial(endTrial>1200)=1200; % force the final cutoff of trial to be 1200 to avoid bug, and just ignore the period after that
        spike = cell2mat(arrayfun(@(i)data(unit).psth(i,startoffset:endTrial(i))',[1:lengthtrial]','UniformOutput',false));
        Xpos = cell2mat(arrayfun(@(i)data(unit).EyeX(i,startoffset:endTrial(i))',[1:lengthtrial]','UniformOutput',false));
        Ypos = cell2mat(arrayfun(@(i)data(unit).EyeY(i,startoffset:endTrial(i))',[1:lengthtrial]','UniformOutput',false));
end
end
