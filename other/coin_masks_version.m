%% Version with coin masks
%% Set up
% Clear the workspace and the screen
sca;
close all;
clear;
Screen('Preference', 'SkipSyncTests', 1);

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

% Set squares size
square1_size = 150; 
square2_size = 150; 

%% Draw squares
square1_coordinates = stimulus_pos(square1_size,[center(1)-(center(1)/4),center(2)]);
Screen('FrameRect', window, [0 0 0], square1_coordinates,3);
square2_coordinates = stimulus_pos(square2_size,[center(1)+(center(1)/4),center(2)]);
Screen('FrameRect', window, [0 0 0], square2_coordinates,3);

squares_coords = [square1_coordinates,square2_coordinates];
squares_reshaped = reshape(squares_coords,[4,2]); % square coords for drawing textures inside them

%% Set fixation cross
cross_size=Screen('TextSize', window, 100); %textsize goes BEFORE drawtext
Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);

%% Coins
coin_dir = cd('C:\Users\c2084061\OneDrive - Cardiff University\Desktop\MEG Pilot\Scripts\coin_stim');
[scrambled_coin, ~, alphachannel] = imread('scrambled_coin_mask.png');
scrambled_coin(:,:,4) = alphachannel;
scrambled_coin_text = Screen('MakeTexture', window, scrambled_coin);
Screen('DrawTextures', window, scrambled_coin_text,[], squares_reshaped);
Screen('Flip',window)
catch
%% Close PT screen
sca;
Priority(0);
ShowCursor();
psychrethrow(psychlasterror);
end
KbWait;
sca;