% General code for extract psth
% 2018.02.13
% Jiaxin Tu
% NOT FINISHED!!!
% SYNTAX:
% function [X,Y,Pupil]= extractEyegeneric(EyeData,strobesforpsth);
% function [X,Y,Pupil]= extractEyegeneric(EyeData,strobesforpsth,startoffset,endoffset,binsize)
% startoffset and endoffset in seconds
% binsize in seconds, e.g. 0.01 stands for 10 ms
function [X,Y,Pupil]= extractEyegeneric(EyeData,strobesforpsth,varargin)
EyeTimeStamp = EyeData(:,1);

trialnum = length(strobesforpsth);
if isempty(varargin)
    varargin=cell(1,3);
end

if isempty(varargin{1})
    startoffset = 5; % 1 s before start
else
    startoffset = varargin{1};
end
if isempty(varargin{2})
    endoffset = 5; % 5 s after start
else
    endoffset = varargin{2};
end
if isempty(varargin{3})
    binsize = 0.01; % s which is 10ms
else
    binsize = varargin{3};
end


% preallocate memory

% EyeX = EyeData(:,2);
% EyeY =EyeData(:,3);
% EyePupil = EyeData(:,4);

X = NaN(trialnum,(startoffset+endoffset)*1/binsize);
Y =  NaN(trialnum,(startoffset+endoffset)*1/binsize);
Pupil =  NaN(trialnum,(startoffset+endoffset)*1/binsize);

count = 1;
for i=1:trialnum
    startat= strobesforpsth{i}-startoffset;
    stopat = strobesforpsth{i}+endoffset;
    if ~isempty(startat)&& numel(startat)==1
        temp = EyeData(EyeTimeStamp>startat&EyeTimeStamp<stopat,:);
        l = length(temp(5:10:end,:));
        if l/100<startoffset+endoffset && startoffset<0
            warning('Startoffset is too low!');
            warning(['Trial ',num2str(i),' was too short!']);
            X(count,end-l+1:end) = temp(5:10:end,2); % downsample, take the 5th value in every 10
            Y(count,end-l+1:end) = temp(5:10:end,3);
            Pupil(count,end-l+1:end)= temp(5:10:end,4);
        else
            if l/100<startoffset+endoffset % detect too short last trial, which is less of a problem
                warning(['Trial ',num2str(i),' was too short!']);
            end
            X(count,1:l) = temp(5:10:end,2); % downsample, take the 5th value in every 10
            Y(count,1:l) = temp(5:10:end,3);
            Pupil(count,1:l) = temp(5:10:end,4);
        end
        count = count+1;
    elseif ~isempty(startat)&& numel(startat)>1
        for k = 1:length(startat)
            tempstart = startat(k);
            tempstop = stopat(k);
            temp = EyeData(EyeTimeStamp>tempstart&EyeTimeStamp<tempstop,:);
            l = length(temp(5:10:end,:));
            if l/100<startoffset+endoffset && startoffset<0
                warning('Startoffset is too low!');
                warning(['Trial ',num2str(i),' was too short!']);
                X(count,end-l+1:end) = temp(5:10:end,2); % downsample, take the 5th value in every 10
                Y(count,end-l+1:end) = temp(5:10:end,3);
                Pupil(count,end-l+1:end)= temp(5:10:end,4);
            else
                if l/100<startoffset+endoffset % detect too short last trial, which is less of a problem
                    warning(['Trial ',num2str(i),' was too short!']);
                end
                X(count,1:l) = temp(5:10:end,2); % downsample, take the 5th value in every 10
                Y(count,1:l) = temp(5:10:end,3);
                Pupil(count,1:l) = temp(5:10:end,4);
            end
            count = count+1;
        end
    end
end

end