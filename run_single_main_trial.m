%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function uses the parameters and the current trial's data to display
% everything in the trial, including fixation cross, food items and
% borders, trial type symbols, get the response, save the data and provide
% feedback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data] = run_single_main_trial(window, exp_parameters, curr_trial_data)

    %% Set fixation cross
    draw_fixation_cross(window, exp_parameters.GREY_COLOR, exp_parameters.SCREEN_X_PIXELS, exp_parameters.SCREEN_Y_PIXELS)

    %% Stage 1 of the main trial - draw food images with borders
    draw_food_items_and_borders(window, exp_parameters.SCREEN_X_PIXELS, exp_parameters.SCREEN_Y_PIXELS, ...
                                curr_trial_data.item_1_id, curr_trial_data.item_2_id, ...
                                curr_trial_data.item_1_border_color)
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []);
    pause(exp_parameters.STAGE_2_TRIAL_IMAGES_TIME/1000)
    
    %% Stage 2 of the main trial - draw black border boxes and trial type symbol
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []); %removes previous items from screen
    
    draw_black_borders_and_trial_type(window, exp_parameters.BLACK_COLOR, exp_parameters.SCREEN_X_PIXELS, exp_parameters.SCREEN_Y_PIXELS, curr_trial_data.trial_type)

    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []);
    
    %% Get Kb response (left or right arrow)
    accepted_keys = ["LeftArrow" "RightArrow"];
    [key_pressed, rt] = get_keyboard_response(accepted_keys, StimulusOnsetTime, exp_parameters.STAGE_2_TRIAL_TIME_LIMIT);

    %% save data
    data = rand(10, 1);
    if ~isnan(rt)
        if key_pressed == "LeftArrow"
            curr_trial_data.selected_item = 1;
        else
            curr_trial_data.selected_item = 2;
        end

        curr_trial_data.preference_response_consistent = 0;
        if curr_trial_data.pt_trial == true
            curr_trial_data.preference_response_consistent = 1;
        end
        if (str2double(curr_trial_data.items_subjective_value_difference) > 0 && curr_trial_data.selected_item == 2) || (str2double(curr_trial_data.items_subjective_value_difference) < 0 && curr_trial_data.selected_item == 1)
            curr_trial_data.preference_response_consistent = 1;
        end

        if rt < exp_parameters.STAGE_2_TOO_QUICK_RESPONSE_THRESHOLD/1000
            acquired_points = 0;
        else
            acquired_points = get_acquired_points(curr_trial_data);
            exp_parameters.POINTS_COUNTER = exp_parameters.POINTS_COUNTER + acquired_points;
        end
    end

    %% show feedback
    if isnan(rt) %too slow
            %these must be colored red/green
            temp_show_text(window, exp_parameters, 'TOO SLOW!', exp_parameters.STAGE_2_FEEDBACK_DURATION) 
    elseif rt < exp_parameters.STAGE_2_TOO_QUICK_RESPONSE_THRESHOLD/1000 %too quick
        temp_show_text(window, exp_parameters, 'TOO QUICK!', exp_parameters.STAGE_2_FEEDBACK_DURATION)
    else %regular feedback
        if acquired_points > 0
            temp_show_text(window, exp_parameters, '+100 points!', exp_parameters.STAGE_2_FEEDBACK_DURATION)
        else
            temp_show_text(window, exp_parameters, '0 points!', exp_parameters.STAGE_2_FEEDBACK_DURATION)
        end
    end

    %% ITI
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []); %removes previous items from screen
    pause(round(randi([800 1500], 1)/1000, 2))
end