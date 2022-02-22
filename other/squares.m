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

% squares_coords= [[square1_coordinates(1,[1:2]); square1_coordinates(1,[3:4])];[square2_coordinates(1,[1:2]);...
%     square2_coordinates(1,[3:4])]];
squares_coords= [[square1_coordinates(1,[1:2]); square2_coordinates(1,[1:2])];[square1_coordinates(1,[3:4]);...
    square2_coordinates(1,[3:4])]];
%% Fixation cross
Screen('TextSize', w1, 70); %textsize goes BEFORE drawtext
Screen('DrawText', w1, '+', center(1), center(2),[0,0,0]);

%% White noise pattern
white_noise_img1 = imread('white_noise1.png');
white_noise1_text = Screen('MakeTexture', w1, white_noise_img1);
white_noise_img2 = imread('white_noise2.png');
white_noise2_text = Screen('MakeTexture', w1, white_noise_img2);
white_noises = [white_noise1_text,white_noise2_text];
Screen('DrawTextures',w1, white_noises,[], [squares_coords]);
Screen('Flip', w1)

WaitSecs(3)
Screen('Close', w1)