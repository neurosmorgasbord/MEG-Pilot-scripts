%% myfunc
function [] = draw_fixation_cross(window, color, screenXpixels, screenYpixels)
    %NP: screen drawtext was breaking for me so I found a different way to
    %present a fixation cross from here https://peterscarfe.com/insertedCode/FixationCrossDemo.html
    
    %--old fixation cross
    %cross_size=Screen('TextSize', window, 100); %textsize goes BEFORE drawtext
    %Screen('DrawText', window, '+', center(1)-cross_size, center(2)-cross_size,[0,0,0]);
    
    %--new fixation cross
    % Here we set the size of the arms of our fixation cross
    fixCrossDimPix = 40;
    % Now we set the coordinates (these are all relative to zero we will let
    % the drawing routine center the cross in the center of our monitor for us)
    xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
    yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
    allCoords = [xCoords; yCoords];
    % Set the line width for our fixation cross
    lineWidthPix = 4;
    % Draw the fixation cross in white, set it to the center of our screen and
    % set good quality antialiasing
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, color, [screenXpixels/2 screenYpixels/2], 2);

end