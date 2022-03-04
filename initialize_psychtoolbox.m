%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize psychtoolbox window and generate the current_session_info that
% is going to be appended to the CONFIG object.
% NB: the window object is saved in a separate variable for ease of use.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [current_session_info, window] = initialize_psychtoolbox(current_session_info)
    %% Get monitor parameters
    % Get screen numbers
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers (i.e., external monitor)
    screenNumber = max(screens);
    
    % Define black and white (white will be 1 and black 0). This is because
    % luminace values are generally defined between 0 and 1.
    current_session_info.WHITE_COLOR = WhiteIndex(screenNumber);
    current_session_info.BLACK_COLOR = BlackIndex(screenNumber);
    
    % Get color grey
    current_session_info.GREY_COLOR = current_session_info.WHITE_COLOR / 2;
    
    % Open an on screen window and color it grey. This function returns a
    % number that identifies the window we have opened "window" and a vector
    % "windowRect".
    % "windowRect" is a vector of numbers: the first is the X coordinate
    % representing the far left of our screen, the second the Y coordinate
    % representing the top of our screen,
    % the third the X coordinate representing
    % the far right of our screen and finally the Y coordinate representing the
    % bottom of our screen.
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, current_session_info.WHITE_COLOR);
    HideCursor;
    rect = Screen('Rect', window); % gets same info a windowRect
    
    % Get the size of the on screen window in pixels, these are the last two
    % numbers in "windowRect" and "rect"
    [current_session_info.SCREEN_X_PIXELS, current_session_info.SCREEN_Y_PIXELS] = Screen('WindowSize', window);
    
    % Get the centre coordinate of the window in pixels.
    % xCenter = screenXpixels / 2
    % yCenter = screenYpixels / 2
    %[xCenter, yCenter] = RectCenter(windowRect);
    
    % Query the inter-frame-interval. This refers to the minimum possible time
    % between drawing to the screen
    current_session_info.IFI = Screen('GetFlipInterval', window);
    
    % Retreive the maximum priority number
    topPriorityLevel = MaxPriority(window);
    
    % determine the refresh rate of the screen. The relationship between the two is: ifi = 1 / hertz
    % same as monRefresh in exp_scripts
    current_session_info.hertz = FrameRate(window);
    
    % query the "nominal" refresh rate of our screen. This is the refresh rate as reported by the video card. 
    % This is rounded to the nearest integer. In reality there can be small differences between "hertz" and "nominalHertz"
    nominalHertz = Screen('NominalFrameRate', window);

    % Calculate monitor frame duration (not sure how it relates to the
    % above)
    current_session_info.frame_duration = 1000/current_session_info.hertz;

    % Calculate screen slack
    current_session_info.screen_slack = current_session_info.frame_duration/2/1000;
    
    % Get the pixel size. This is not the physical size of the pixels but the color depth of the pixel in bits
    pixelSize = Screen('PixelSize', window);
    
    % Queries the display size in mm as reported by the operating system.
    [width, height] = Screen('DisplaySize', screenNumber);
    
    % Get the maximum coded luminance level (this should be 1)
    maxLum = Screen('ColorRange', window);
    
    % Set up alpha
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Set up default text styling
    Screen(window, 'TextFont', 'Calibri');
    Screen(window, 'TextSize', 32);
    Screen(window, 'TextColor', 255);
end