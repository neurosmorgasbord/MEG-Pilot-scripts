%% Text mask version
%% Set up
% Clear the workspace and the screen
sca;
close all;
clear;
Screen('Preference', 'SkipSyncTests', 1);
HideCursor();
%% Subj details 
participant_ID = input('Please enter your initials ', 's'); % gets participant initials

% load subject's preference from their id.
% set session id.

% no need.
% participant_age = input('Please enter your age '); % gets pp age
% participant_gender = input('Please enter your gender ', 's'); % gets pp gender

% Default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get screen numbers
try
screens = Screen('Screens');

% To draw we select the maximum of these numbers (i.e., external monitor)
screenNumber = max(screens);

% Define black and white (white will be 1 and black 0). This is because
% luminace values are generally defined between 0 and 1.
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Get color grey
grey = white / 2;

% Open an on screen window and color it grey. This function returns a
% number that identifies the window we have opened "window" and a vector
% "windowRect".
% "windowRect" is a vector of numbers: the first is the X coordinate
% representing the far left of our screen, the second the Y coordinate
% representing the top of our screen,
% the third the X coordinate representing
% the far right of our screen and finally the Y coordinate representing the
% bottom of our screen.
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

rect = Screen('Rect', window); % gets same info a windowRect

% Get the size of the on screen window in pixels, these are the last two
% numbers in "windowRect" and "rect"
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels.
% xCenter = screenXpixels / 2
% yCenter = screenYpixels / 2
[center(1), center(2)] = RectCenter(windowRect);

% Query the inter-frame-interval. This refers to the minimum possible time
% between drawing to the screen
ifi = Screen('GetFlipInterval', window);

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(window);

% determine the refresh rate of the screen. The relationship between the two is: ifi = 1 / hertz
hertz = FrameRate(window);

% query the "nominal" refresh rate of our screen. This is the refresh rate as reported by the video card. 
% This is rounded to the nearest integer. In reality there can be small differences between "hertz" and "nominalHertz"
nominalHertz = Screen('NominalFrameRate', window);

% Get the pixel size. This is not the physical size of the pixels but the color depth of the pixel in bits
pixelSize = Screen('PixelSize', window);

% Queries the display size in mm as reported by the operating system.
[width, height] = Screen('DisplaySize', screenNumber);

% Get the maximum coded luminance level (this should be 1)
maxLum = Screen('ColorRange', window);

% Set up alpha
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Set squares size - 150 by 150 pix
squares_size = [0 0 200 200];
% Set squares X coordinates and number
squares_Xpos = [center(1)-(center(1)/4), center(1)+(center(1)/4)]; 
numsquares = length(squares_Xpos);
penWidthPix = 6;
%% Draw squares
all_Rects = nan(4,2);
for idx = 1:numsquares
    all_Rects(:,idx) = CenterRectOnPointd(squares_size, squares_Xpos(idx),center(2)) 
end
%% Set fixation cross
cross_size=Screen('TextSize', window, 100); %textsize goes BEFORE drawtext
Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);
%% Text masks - 1st round
% do not use absolute path, leading to problems.
baseDir=filepath(mfilename);

maskDir=fullfile(baseDir, 'text_masks');
% get the mask files ...
maskFiles=[];

%% load all images
%% generate texture for all images
[text_mask, ~, alphachannel] = imread(['text_mask' num2str(i) '.png']);
text_mask(:,:,4) = alphachannel;
mask_texture = Screen('MakeTexture', window, text_mask);

% cd('C:\Users\c2084061\OneDrive - Cardiff University\Desktop\MEG Pilot\Scripts\text_masks\')
% mask_dir = dir('C:\Users\c2084061\OneDrive - Cardiff University\Desktop\MEG Pilot\Scripts\text_masks\');
% mask_dir(1:2) = [];
N_mask = length(mask_dir);
mask_dur = 0.25/ifi;
wait_frame = ifi*3;
% 
num_frames = round(250/(1/60*1000)); % the number of frames we need to present
VBLTimestamp = GetSecs();

mask_texture(1)  =Screen('MakeTexture', window, text_mask); % XXXX
mask_texture(2)  =Screen('MakeTexture', window, text_mask); % OOOO


ResponseArray=[];
%% ----
%% Look for all trials
%% loop over curTrial=1:numTrial

% forward masking
for fr=1:num_frames
    % plot fixation
    Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);
    
    % plot masking (every x frames, change the mask)
    if mod(fr,3)==0
        % change mask id
        if maskid==1
            maskid=2;
        else
            maskid=1;
        end
    end
    Screen('DrawTextures', window, mask_texture(maskid),[], all_Rects);
    
    % maybe border
    Screen('FrameRect', window, [0 0 0], all_Rects, penWidthPix);
    
    %
    Screen('DrawingFinished', window);
    
    % flip
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, VBLTimestamp+FrameRate(window)/2);
end

% masked stimuli
% �� o r &&


% backward masking
% XXXX - OOOO


% show food items

% take responses

% ITI

ResponseArray(curTrial,:)=['stimulus onest time', 'id of the food item', 'action', 'time of action'];
%% ----



% add scalers? if yes, check https://peterscarfe.com/insertedCode/ScaleImageDemo.html
for j = 1:mask_dur % n times to show masks within 250ms
    for i=1:N_mask
        
        pause(wait_frame)
        Screen('DrawTextures', window, mask_texture,[], all_Rects);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, [],1)
        % Redraw everything before second flip
        Screen('FrameRect', window, [0 0 0], all_Rects, penWidthPix);
        Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, [])
    end
end

%% Reward vs No Reward Cue
%Get center of rects
[x1, y1] = RectCenter(all_Rects(:,1));
[x2, y2] = RectCenter(all_Rects(:,2));

Screen('FrameRect', window, [0 0 0], all_Rects, penWidthPix);
Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);
cue_size=Screen('TextSize', window, 100);
Screen('DrawText',window, '££',x1-cue_size/2,y1-cue_size/2, [0,0,0]); % position ££ in the center of both rects
Screen('DrawText',window, '&&',x2-cue_size/2,y2-cue_size/2, [0,0,0]);
[VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, [],1)
pause(0.25)

%% Text masks - 2nd round
for j = 1:mask_dur % n times to show masks within 250ms
    for i=1:N_mask
        [text_mask, ~, alphachannel] = imread(['text_mask' num2str(i) '.png']);
        text_mask(:,:,4) = alphachannel;
        mask_texture = Screen('MakeTexture', window, text_mask);
        pause(wait_frame)
        Screen('DrawTextures', window, mask_texture,[], all_Rects);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, [],1)
        %Redraw everything before second flip
        Screen('FrameRect', window, [0 0 0], all_Rects, penWidthPix);
        Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, [])
    end
end

%% Set up stimuli
cd('C:\Users\c2084061\OneDrive - Cardiff University\Desktop\MEG Pilot\Scripts\trial_stim'); 
trial_stim_dir = dir(pwd)
trial_stim_dir(1:2) = [];
stim_dur = 1.2;
stim_texts = {};


%% should use this.
% for k = 1:length(trial_stim_dir)
%     trial_stims = imread(trial_stim_dir{k});
%     texture = Screen('MakeTexture', window, trial_stims)
%     stim_texts{i} = texture;
% end



trial_stim1 = imread('0014.jpg');
trial_stim2 = imread('0028.jpg');
border_stim1 = addborder(trial_stim1,15,[0,0,0],'center');
border_stim2 = addborder(trial_stim2,15,[0,0,0],'center');
stim1_text = Screen('MakeTexture', window,border_stim1);
stim2_text = Screen('MakeTexture', window,border_stim2);
Screen('DrawTexture', window, stim1_text,[], all_Rects(:,1), [], [], 1);
Screen('DrawTexture', window, stim2_text, [], all_Rects(:,2), [], [], 1);
Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);
[VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, [])
pause(stim_dur)

%% Collect key press
left_pressed = 0;
right_pressed = 0;
tic;
while toc < 1.5
    [keyIsDown, keysecs, keyCode] = KbCheck;
    if keyCode(KbName('LeftArrow'))==1 
        response_time = keysecs; % records response time for each trial
        left_pressed = left_pressed+1;
        break
    end
    if keyCode(KbName('RightArrow'))==1
        response_time = keysecs; % records response time for each trial
        right_pressed = right_pressed+1;
    end
end

%% Save file
savedir=pwd;
save(sprintf('%s_data_Text_mask', participant_ID));
catch
%% Close PT screen
sca;
Priority(0);
ShowCursor();
psychrethrow(psychlasterror);
end
KbWait;
sca;