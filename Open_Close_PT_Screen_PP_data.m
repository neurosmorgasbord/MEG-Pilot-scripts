%% Psychtoolbox Book Tutorial
clear all % clears all workspace variables
close all % closes all figures

participant_ID = input('Please enter your initials ', 's'); % gets participant initials
participant_age = input('Please enter your age '); % gets pp age
participant_gender = input('Please enter your gender ', 's'); % gets pp gender

% Set up PT screen
[w1, rect] = Screen('OpenWindow',0,0); % opens PT screen, w1 is the window, rect gives the screen coordinates
[center(1), center(2)] = RectCenter(rect); % gets the x and y coordinates for the center of the screen (1 is x, 2 is y)
Priority(MaxPriority(w1)); % the PT screen is given priority over all other background activity
HideCursor(); % hides mouse cursor

% Close PT screen
Screen('Close', w1)
Priority(0);
ShowCursor();