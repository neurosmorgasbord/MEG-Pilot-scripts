function screenInfo = Start(monWidth, viewDist, curScreen)
% screenInfo = openExperiment(monWidth, viewDist, curScreen)
% Arguments:
%	monWidth ... viewing width of monitor (cm)
%	viewDist     ... distance from the center of the subject's eyes to
%	the monitor (cm)
%   curScreen         ... screen number for experiment
%                         default is 0.
% Sets the random number generator, opens the screen, gets the refresh
% rate, determines the center and ppd 

% 1. SEED RANDOM NUMBER GENERATOR
screenInfo.rseed = [];

% ---------------
% open the screen
% ---------------

% make sure we are using openGL
AssertOpenGL;

curScreen = max(Screen('Screens'));
% added to make stuff behave itself in os x with multiple monitors

% Set the background to the background value.
screenInfo.bckgnd = 1;

[screenInfo.curWindow, screenInfo.screenRect] = Screen('OpenWindow', curScreen, screenInfo.bckgnd,[],32, 2);
screenInfo.dontclear = 0; % 1 gives incremental drawing (does not clear buffer after flip)

%get the refresh rate of the screen
spf =Screen('GetFlipInterval', screenInfo.curWindow);      % seconds per frame
screenInfo.monRefresh = 1/spf;                              % frames per second
screenInfo.frameDur = 1000/screenInfo.monRefresh;               

screenInfo.center = [screenInfo.screenRect(3) screenInfo.screenRect(4)]/2;   	% coordinates of screen center (pixels)

% screenInfo.ppd = pi * screenInfo.screenRect(3) / atan(monWidth/viewDist/2) / 360;    % pixels per degree

Screen(screenInfo.curWindow,'TextFont','Calibri');
Screen(screenInfo.curWindow,'TextSize',32);
Screen(screenInfo.curWindow,'TextColor',255);


HideCursor
end
