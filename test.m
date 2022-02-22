% Clear the workspace and the screen
sca;
close all;
clear;

try
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    %setenv('PSYCH_ALLOW_DANGEROUS', '1')
    Screen('Preference', 'SkipSyncTests', 1);
    
    % Get the screen numbers
    screens = Screen('Screens');
    
    % Draw to the external screen if avaliable
    screenNumber = max(screens);
    
    % Define black and white
    white_color = WhiteIndex(screenNumber);
    black_color = BlackIndex(screenNumber);
    
    % Open an on screen window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, white_color);
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    % Get the centre coordinate of the window
    [xCenter, yCenter] = RectCenter(windowRect);
    
    %draw_fixation_cross(window, black_color, screenXpixels, screenYpixels)
    
    % Flip to the screen
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []);
    
    %% Get Kb response (left or right arrow)
    accepted_keys = ["LeftArrow" "RightArrow"];
    [key_pressed, rt] = get_keyboard_response(accepted_keys, StimulusOnsetTime, 2000)

catch
    %% Close PT screen
    sca;
    Priority(0);
    ShowCursor();
    psychrethrow(psychlasterror);
end
% Clear the screen
sca;