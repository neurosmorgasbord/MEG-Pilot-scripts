%% myfunc
function [] = draw_black_borders_and_trial_type(window, black_color, screenXpixels, screenYpixels, trial_type)

    % Pen width for the frames
    BORDER_WIDTH = 5;
    
    % get trial type texture
    if trial_type == "preference"
        trial_type_img = imread('trial_stim/pref_icon.png');
    elseif trial_type == "reward"
        trial_type_img = imread('trial_stim/reward_icon.png');
    end
    trial_type_texture = Screen('MakeTexture', window, trial_type_img);
    image_width = screenXpixels*0.1;
    image_height = image_width;
    base_rect = [0 0 image_width image_height];
    dst_rect = CenterRectOnPointd(base_rect, screenXpixels/2, screenYpixels/2);
    
    % Make a base rectangle as a container (same as for the images
    container_rectangle_width = screenXpixels*0.35;
    container_rectangle_height = container_rectangle_width/4*3; % preserving 4:3 ratio
    
    % Get the coordinates (left-top-right-bottom) for the containers
    % same pattern as for the images
    center_pos_of_containers = [screenXpixels*0.25 screenXpixels*0.75];
    containers_coords = zeros(4, 2);
    for i = 1:2
        containers_coords(:, i) = CenterRectOnPointd([0 0 container_rectangle_width container_rectangle_height], center_pos_of_containers(i), screenYpixels/2);
    end
    
    % Draw everything to the screen
    % drawtextures takes only a single texture so needs to be called twice
    Screen('FrameRect', window, black_color, containers_coords, BORDER_WIDTH);
    Screen('DrawTextures', window, trial_type_texture, [], dst_rect);

end