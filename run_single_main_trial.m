%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function uses the parameters and the current trial's data to display
% everything in the trial, including fixation cross, food items and
% borders, trial type symbols, get the response, save the data and provide
% feedback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data] = run_single_main_trial(window, CONFIG, curr_trial_data)
    [trial_start_timestamp, trial_start_onset]=Screen('Flip', window);

    %% Set fixation cross
    draw_fixation_cross(window, CONFIG.current_session_info.GREY_COLOR, CONFIG.current_session_info.SCREEN_X_PIXELS, CONFIG.current_session_info.SCREEN_Y_PIXELS)

    %% Stage 1 of the main trial - draw food images with borders
    draw_food_items_and_borders(window, CONFIG.current_session_info.SCREEN_X_PIXELS, CONFIG.current_session_info.SCREEN_Y_PIXELS, ...
                                curr_trial_data.item_1_id, curr_trial_data.item_2_id, ...
                                curr_trial_data.item_1_border_color)
    
    [food_items_and_borders_start_timestamp, food_items_and_borders_onset_time]=Screen('Flip', window);
    %removes items from screen
    [food_items_and_borders_end_timestamp, food_items_and_borders_outset_time]=Screen('Flip', window, food_items_and_borders_onset_time+CONFIG.exp_parameters.STAGE_2_TRIAL_IMAGES_TIME);

    %% Stage 2 of the main trial - draw black border boxes and trial type symbol
    draw_black_borders_and_trial_type(window, CONFIG.current_session_info.BLACK_COLOR, ...
                                                CONFIG.current_session_info.SCREEN_X_PIXELS, ...
                                                CONFIG.current_session_info.SCREEN_Y_PIXELS, ...
                                                curr_trial_data.trial_type)

    [response_start_timestamp, response_onset_time]=Screen('Flip', window);
    
    % Get Kb response (left or right arrow)
    accepted_keys = ["LeftArrow" "RightArrow"];
    [key_pressed, rt] = get_keyboard_response(accepted_keys, response_onset_time, CONFIG.exp_parameters.STAGE_2_TRIAL_TIME_LIMIT);
    
    % we save the timestamp after response but leave everything on screen
    % while performing below calculations; the next flip is executed in
    % 200ms for a good Epoch (idea from EEG experiment)
    timestamp_after_logged_response = GetSecs;
    
    %% add additional variables for the data output
    [selected_item, preference_response_consistent, acquired_points] = add_data_output_variables(rt, key_pressed, curr_trial_data, CONFIG);
    
    %wait up to 200ms after response to perform above calcs and only now flip
    %on my personal PC it seems to take 5ms on avg (quite consistent so
    %nothing to do with the ~7ms screen slack as is on my PC)
    [response_end_timestamp, response_outset_time]=Screen('Flip', window, timestamp_after_logged_response-CONFIG.current_session_info.screen_slack+0.2);

    %% show feedback
    draw_feedback(window, rt, acquired_points, CONFIG.exp_parameters.STAGE_2_TOO_QUICK_RESPONSE_THRESHOLD)
    [feedback_start_timestamp, feedback_onset_time]=Screen('Flip', window);
    [feedback_end_timestamp, feedback_outset_time]=Screen('Flip', window, GetSecs-CONFIG.current_session_info.screen_slack+CONFIG.exp_parameters.STAGE_2_FEEDBACK_DURATION);

    %% Save trial's data
    data = struct();
    %timing
    data.trial_start_timestamp = trial_start_timestamp;
    data.trial_start_onset = trial_start_onset;
    data.food_items_and_borders_start_timestamp = food_items_and_borders_start_timestamp;
    data.food_items_and_borders_onset_time = food_items_and_borders_onset_time;
    data.food_items_and_borders_end_timestamp = food_items_and_borders_end_timestamp;
    data.food_items_and_borders_outset_time = food_items_and_borders_outset_time;
    data.response_start_timestamp = response_start_timestamp;
    data.response_onset_time = response_onset_time;
    data.response_end_timestamp = response_end_timestamp;
    data.response_outset_time = response_outset_time;
    data.feedback_start_timestamp = feedback_start_timestamp;
    data.feedback_onset_time = feedback_onset_time;
    data.feedback_end_timestamp = feedback_end_timestamp;
    data.feedback_outset_time = feedback_outset_time;
    data.ITI = 0.8 + ((1.5-0.8).*rand);
    
    %response and response-related data
    data.key_pressed = key_pressed;
    data.rt = rt;
    data.selected_item = selected_item;
    data.preference_response_consistent = preference_response_consistent;
    data.acquired_points = acquired_points;

    %trial meta-data
    data.pt_trial = curr_trial_data.pt_trial;
    data.block = curr_trial_data.block;
    data.trial = curr_trial_data.trial;
    data.item_1_id = curr_trial_data.item_1_id;
    data.item_1_subjective_value = curr_trial_data.item_1_subjective_value;
    data.item_1_subjective_value_category = curr_trial_data.item_1_subjective_value_category;
    data.item_1_border_color = curr_trial_data.item_1_border_color;
    data.item_1_reward_prob = curr_trial_data.item_1_reward_prob;
    data.item_2_id = curr_trial_data.item_2_id;
    data.item_2_subjective_value = curr_trial_data.item_2_subjective_value;
    data.item_2_subjective_value_category = curr_trial_data.item_2_subjective_value_category;
    data.item_2_border_color = curr_trial_data.item_2_border_color;
    data.item_2_reward_prob = curr_trial_data.item_2_reward_prob;
    data.items_subjective_value_difference = curr_trial_data.items_subjective_value_difference;
    data.trial_type = curr_trial_data.trial_type;

    %% ITI
    %using untiltime instead of regular waitsecs so that I use some ot the
    %ITI's time to save the above data
    WaitSecs('UntilTime', feedback_onset_time+data.ITI-CONFIG.current_session_info.screen_slack)
    
end