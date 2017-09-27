function RTPPanalysis_TrackingData(saveName)

%% About this script
%  Process tracking data from Real Time Place Preference experiment
%  Saves and plots data 
%  Original code written by Koji Toda, Ph.D.
%  12/26/2016
%  Modified by Erica Rodriguez and Vincent Prevosto
%  9/26/2017

%% Pre-process

%Parameters
saveFig    = 1;     % Save the figure? 0:NO, 1:YES
epochs     = 3;      % Number of the epochs in the data 1/2/3
smoothing  = 0;     % Smooth the data? 0:NO, 1:YES
fileFormat = 'pdf'; % figure output format 'pdf', 'jpeg', 'eps2', etc...
endTime    = 18000; % 30 FramePerSecond = 30Hz = 30datapoint / 1s, 18000 = 10 min
smoothRate = 1000;  % Smoothing Rate
maxX       = 200;   % Max of X position (pixel)
maxY       = 400;   % Max of Y position (pixel)

dataTag    = {'PRE', 'STIM', 'POST'};

% If no ouput filename provided 
if nargin == 0
    saveName = 'CPPresult';
end

%% Load and process the data
for dataType = 1:epochs
    fileName  = uigetfile('*.csv',sprintf('Select the %s file.', dataTag{dataType})); 
    switch dataTag{dataType}
        case 'PRE' % Pre-stimulation data
            CPPpre  = load(fileName);
            meanPre = mean(CPPpre(:,4));
            meanPref = meanPre;
        case 'STIM' % Stimulation data
            CPPstim = load(fileName);
            % Flip the PRE data?
            [~, wherePre]  = min(CPPpre(:,2));
            [~, whereStim] = min(CPPstim(:,2));
            flipPre        = CPPpre(wherePre,4);
            flipStim       = CPPstim(whereStim,4);
            %Flipped the stimulation side after the baseline???
            if flipPre ~= flipStim
                CPPpre(:,4)  = 1-CPPpre(:,4); % Flip
            end
            meanPre  = mean(CPPpre(:,4));
            meanStim = mean(CPPstim(:,4));
            meanPref = [meanPre, meanStim];
        case 'POST' % Ppost-stimulation data
            CPPpost  = load(fileName);
            meanPost = mean(CPPpost(:,4));
            meanPref = [meanPre, meanStim, meanPost];
    end
end

%% [optional] Smooth the data
if smoothing == 1
    for dataType = 1:epochs
        switch dataTag{dataType}
            case 'PRE'
                CPPpre(1:endTime,1)  = smooth(CPPpre(1:endTime,1),1/smoothRate);   % Smoothing for X axis data
                CPPpre(1:endTime,2)  = smooth(CPPpre(1:endTime,2),1/smoothRate);   % Smoothing for Y axis data
            case 'STIM'
                CPPstim(1:endTime,1)  = smooth(CPPstim(1:endTime,1),1/smoothRate);  % Smoothing for X axis data
                CPPstim(1:endTime,2)  = smooth(CPPstim(1:endTime,2),1/smoothRate);  % Smoothing for Y axis data
            case 'POST'
                CPPpost(1:endTime,1)  = smooth(CPPpost(1:endTime,1),1/smoothRate);  % Smoothing for X axis data
                CPPpost(1:endTime,2)  = smooth(CPPpost(1:endTime,2),1/smoothRate);  % Smoothing for Y axis data
        end
    end
end

%% Make tracking figure
% requires the gramm toolbox: https://github.com/piermorel/gramm
figure('NumberTitle','off','Name','Tracking data','Position',[520 530 900 560]); 
for dataType = 1:epochs
    switch dataTag{dataType}
        case 'PRE'
            data = CPPpre;
        case 'STIM'
            data = CPPstim;
        case 'POST'
            data = CPPpost;
    end
    trackFig(1,dataType)=gramm('X',data(:,1),'Y',data(:,2));
    trackFig(1,dataType).geom_line();
end
trackFig.set_title('Tracking data');
trackFig.set_names('x','X axis','y','Y axis');
trackFig.axe_property('XLim',[0 maxX],'YLim',[0 maxY]);
trackFig.draw();
% Save figure
fileName = horzcat(saveName,'Tracking_Figure');
if saveFig == 1
    saveas(gcf, fileName, fileFormat);
end

%% Save the data
% Combine the data
meanAll  = meanPref*100;
timeAll  = meanPref*endTime/30;
bothAll  = vertcat(meanAll,timeAll);

% write cvs file
csvwrite(saveName, bothAll);
clear

%% After the analysis
%clear;     %clear all the variable
%close all; %close all the figures

end