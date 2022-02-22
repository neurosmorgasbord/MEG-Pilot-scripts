%% myfunc
function [data] = run_single_main_trial(window, screenXpixels, screenYpixels, grey_color, black_color, ...
                                    left_food_item_id, right_food_item_id, ...
                                    left_border_color, ...
                                    trial_type)
    %% Set fixation cross
    draw_fixation_cross(window, grey_color, screenXpixels, screenYpixels)

    %% Stage 1 of the main trial - draw food images with borders
    draw_food_items_and_borders(window, screenXpixels, screenYpixels, ...
                                left_food_item_id, right_food_item_id, ...
                                left_border_color)
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []);
    pause(1.2)
    
    %% Stage 2 of the main trial - draw black border boxes and trial type symbol
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []); %removes previous items from screen
    
    draw_black_borders_and_trial_type(window, black_color, screenXpixels, screenYpixels, trial_type)

    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []);
    
    %% Get Kb response (left or right arrow)
    accepted_keys = ["LeftArrow" "RightArrow"];
    [key_pressed, rt] = get_keyboard_response(accepted_keys, StimulusOnsetTime, 2000);

    %% show feedback
    
    %% return data
    data = rand(10, 1);

end