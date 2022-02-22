%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw the food items and the red/blue borders. Here the argument names
% deviate ever so slightly from the ones in the trial data object. In the
% trial data object, they are named item_1_id (here = left_food_item_id),
% item_2_id (here = right_food_item_id) and item_1_border_color (here =
% left_border_color). This can be fixed soon. Only left border color is
% provided as the other one can be inferred.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = draw_food_items_and_borders(window, screenXpixels, screenYpixels, ...
    left_food_item_id, right_food_item_id, ...
    left_border_color)

    % Pen width for the frames
    BORDER_WIDTH = 5;
    % need to offset the images' width and height
    % e.g. if image container has a border penwidth of 5, then the width/height
    % need to be 10px (2x) smaller so that the border is visible
    OFFSET_IMG_DIMENSION = BORDER_WIDTH*2;
    % Set the colors
    if left_border_color == "red"
        %red; blue by col
        BORDER_COLORS = [1 0
                         0 0
                         0 1];
    else
        %blue; red by col
        BORDER_COLORS = [0 1
                         0 0
                         1 0];
    end
    
    % get food item textures
    food_item_left = imread(strcat('food_items/', left_food_item_id, '.jpg'));
    food_item_left_texture = Screen('MakeTexture', window, food_item_left);
    food_item_right = imread(strcat('food_items/', right_food_item_id, '.jpg'));
    food_item_right_texture = Screen('MakeTexture', window, food_item_right);
    
    % Make a base rectangle for the images as a container
    container_rectangle_width = screenXpixels*0.35;
    container_rectangle_height = container_rectangle_width/4*3; % preserving 4:3 ratio
    
    % Get the coordinates (left-top-right-bottom) for both the containers and
    % the images
    center_pos_of_containers = [screenXpixels*0.25 screenXpixels*0.75];
    containers_coords = zeros(4, 2);
    images_coords = zeros(4, 2);
    for i = 1:2
        containers_coords(:, i) = CenterRectOnPointd([0 0 container_rectangle_width container_rectangle_height], center_pos_of_containers(i), screenYpixels/2);
        images_coords(:, i) = CenterRectOnPointd([0 0 container_rectangle_width-OFFSET_IMG_DIMENSION container_rectangle_height-OFFSET_IMG_DIMENSION], ...
            center_pos_of_containers(i), screenYpixels/2);
    end
    
    % Draw everything to the screen
    % drawtextures takes only a single texture so needs to be called twice
    Screen('FrameRect', window, BORDER_COLORS, containers_coords, BORDER_WIDTH);
    Screen('DrawTextures', window, food_item_left_texture, [], images_coords(:, 1));
    Screen('DrawTextures', window, food_item_right_texture, [], images_coords(:, 2));

end