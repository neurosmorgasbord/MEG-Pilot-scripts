%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adds a few data variables to make later data processing easier. Some of
% these are also used in execution of a single trial (e.g. acquired points
% is used to decide what feedback to show).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [selected_item, preference_response_consistent, acquired_points]=add_data_output_variables(rt, key_pressed, curr_trial_data, CONFIG)
    selected_item = nan;
    preference_response_consistent = nan;
    acquired_points = 0;
    if ~isnan(rt)
        %create a new variable for the key_pressed
        if key_pressed == "LeftArrow"
            selected_item = 1;
        else
            selected_item = 2;
        end
        %check if response is consistent based on preference
        preference_response_consistent = 0;
        if curr_trial_data.pt_trial == true
            preference_response_consistent = 1;
        end
        if (str2double(curr_trial_data.items_subjective_value_difference) > 0 && selected_item == 2) || (str2double(curr_trial_data.items_subjective_value_difference) < 0 && selected_item == 1)
            preference_response_consistent = 1;
        end
        %calculate acuiqred points and add to points counter
        if rt >= CONFIG.exp_parameters.STAGE_2_TOO_QUICK_RESPONSE_THRESHOLD
            acquired_points = get_acquired_points(curr_trial_data, selected_item, preference_response_consistent);
        end
    end
end
