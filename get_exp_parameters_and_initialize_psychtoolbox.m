function [exp_parameters, window]=get_exp_parameters_and_initialize_psychtoolbox()
    exp_parameters = struct();

    exp_parameters.PT_TRIALS_N = 10;
    exp_parameters.PT_TRIALS_PER_BLOCK = 10;
    exp_parameters.PT_BLOCKS = exp_parameters.PT_TRIALS_N / exp_parameters.PT_TRIALS_PER_BLOCK;

    exp_parameters.TEST_TRIALS_N = 4;
    exp_parameters.TEST_TRIALS_PER_BLOCK = 2;
    exp_parameters.TEST_BLOCKS = exp_parameters.TEST_TRIALS_N / exp_parameters.TEST_TRIALS_PER_BLOCK;

    exp_parameters.REWARD_PROBABILITIES = [["0.2" "0.8"]; ["0.4" "0.6"]];
    exp_parameters.REWARD_PROBABILITIES_ITERATIONS = exp_parameters.TEST_BLOCKS/length(exp_parameters.REWARD_PROBABILITIES); %i.e. number of times to repeat each reward prob pair
    exp_parameters.REWARD_TO_PREF_TRIALS_RATIO = 0.5;

    exp_parameters.ALL_ITEMS = ["0014" "0028" "0041" "0070" "0080" "0116" "0162" "0187" "0189" "0199" "0249" "0277" "0286" "0287" "0308" "0310" "0313" "0319" "0360" "0365" "0380" "0399" "0400" "0421" "0422" "0459" "0460" "0467" "0468" "0496" "0504" "0507" "0515" "0569" "0571" "0614" "0626" "0755" "0801" "0820"];
    exp_parameters.PRACTICE_FOOD_ITEMS = ["0001" "0002" "0007" "0009" "0011" "0012" "0013" "0015" "0018" "0021" "0022" "0023" "0024" "0025" "0026" "0027" "0029" "0030" "0031" "0034"];
    exp_parameters.STAGE_2_TRIAL_IMAGES_TIME = 1200;
    exp_parameters.STAGE_2_TRIAL_TIME_LIMIT = 2000;
    exp_parameters.STAGE_2_FEEDBACK_DURATION = 1000;
    exp_parameters.STAGE_2_TOO_SLOW_FEEDBACK_DURATION = 750;
    exp_parameters.STAGE_2_TOO_QUICK_RESPONSE_THRESHOLD = 200;

    exp_parameters.POINTS_COUNTER = 0;
    exp_parameters.MAX_REWARD_AT_POINTS = 45000;
    exp_parameters.POINTS_THAT_GRANT_ONE_P = 450;

    %% Get monitor parameters
    % Get screen numbers
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers (i.e., external monitor)
    screenNumber = max(screens);
    
    % Define black and white (white will be 1 and black 0). This is because
    % luminace values are generally defined between 0 and 1.
    exp_parameters.WHITE_COLOR = WhiteIndex(screenNumber);
    exp_parameters.BLACK_COLOR = BlackIndex(screenNumber);
    
    % Get color grey
    exp_parameters.GREY_COLOR = exp_parameters.WHITE_COLOR / 2;
    
    % Open an on screen window and color it grey. This function returns a
    % number that identifies the window we have opened "window" and a vector
    % "windowRect".
    % "windowRect" is a vector of numbers: the first is the X coordinate
    % representing the far left of our screen, the second the Y coordinate
    % representing the top of our screen,
    % the third the X coordinate representing
    % the far right of our screen and finally the Y coordinate representing the
    % bottom of our screen.
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, exp_parameters.WHITE_COLOR);
    HideCursor;
    rect = Screen('Rect', window); % gets same info a windowRect
    
    % Get the size of the on screen window in pixels, these are the last two
    % numbers in "windowRect" and "rect"
    [exp_parameters.SCREEN_X_PIXELS, exp_parameters.SCREEN_Y_PIXELS] = Screen('WindowSize', window);
    
    % Get the centre coordinate of the window in pixels.
    % xCenter = screenXpixels / 2
    % yCenter = screenYpixels / 2
    %[xCenter, yCenter] = RectCenter(windowRect);
    
    % Query the inter-frame-interval. This refers to the minimum possible time
    % between drawing to the screen
    exp_parameters.IFI = Screen('GetFlipInterval', window);
    
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
end