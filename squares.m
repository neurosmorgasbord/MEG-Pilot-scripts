Screen('Preference', 'SkipSyncTests', 1); 
[w1, rect] = Screen('OpenWindow',0);
[center(1), center(2)] = RectCenter(rect);
%% Show squares
square1_size = 100; 
square2_size = 100; 

square1_coordinates = stimulus_pos(square1_size,[650,540]);
Screen('FrameRect', w1, [0 0 0], square1_coordinates,3);
square2_coordinates = stimulus_pos(square2_size,[1270,540]);
Screen('FrameRect', w1, [0 0 0], square2_coordinates,3);

%% Fixation cross
Screen('TextSize', w1, 70); %textsize goes BEFORE drawtext
Screen('DrawText', w1, '+', center(1), center(2),[0,0,0]);

Screen('Flip', w1);
WaitSecs(3)
Screen('Close', w1)