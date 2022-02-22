%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acquired the trials array for the pt trials. See README for details on
% this array.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pt_trials_array] = get_pt_trials_array(exp_parameters)
    
    %% initialize variables
    pt_trials_array_columns = ["pt_trial"; "block"; "trial"; "item_1_id"; "item_1_subjective_value"; "item_1_subjective_value_category"; "item_1_border_color"; "item_1_reward_prob"; "item_2_id"; "item_2_subjective_value"; "item_2_subjective_value_category"; "item_2_border_color"; "item_2_reward_prob"];
    pt_trials_array = struct();
    for trial_ind=1:exp_parameters.PT_TRIALS_N
        for col_ind=1:length(pt_trials_array_columns)
            pt_trials_array(trial_ind).(pt_trials_array_columns(col_ind)) = [];
        end
    end
 
    %% setting up trial-level variables -- always a single block
    colors = ["red" "blue"];
    reward_probs = ["0.9" "0.1"];
    reward_probs = reward_probs(:, randperm(size(reward_probs, 2)));
    reward_probs = struct('red', reward_probs(1), 'blue', reward_probs(2));
    trial_types = [repmat(["reward"], 7, 1); repmat(["preference"], 3, 1)];
    trial_types = trial_types(randperm(size(trial_types, 1)), :);
    for pt_trial_ind=1:exp_parameters.PT_TRIALS_N
        curr_trial_item_pair = randsample(exp_parameters.PRACTICE_FOOD_ITEMS, 2);
        curr_trial_border_colors = colors(:, randperm(size(colors, 2)));

        pt_trials_array(pt_trial_ind).pt_trial = true;
        pt_trials_array(pt_trial_ind).block = 1;
        pt_trials_array(pt_trial_ind).trial = pt_trial_ind;
        pt_trials_array(pt_trial_ind).item_1_id = curr_trial_item_pair(1);
        pt_trials_array(pt_trial_ind).item_1_subjective_value = "";
        pt_trials_array(pt_trial_ind).item_1_subjective_value_category = "";
        pt_trials_array(pt_trial_ind).item_1_border_color = curr_trial_border_colors(1);
        pt_trials_array(pt_trial_ind).item_1_reward_prob = reward_probs.(curr_trial_border_colors(1));
        pt_trials_array(pt_trial_ind).item_2_id = curr_trial_item_pair(2);
        pt_trials_array(pt_trial_ind).item_2_subjective_value = "";
        pt_trials_array(pt_trial_ind).item_2_subjective_value_category = "";
        pt_trials_array(pt_trial_ind).item_2_border_color = curr_trial_border_colors(2);
        pt_trials_array(pt_trial_ind).item_2_reward_prob = reward_probs.(curr_trial_border_colors(2));
        pt_trials_array(pt_trial_ind).items_subjective_value_difference = "";
        pt_trials_array(pt_trial_ind).trial_type = trial_types(pt_trial_ind, 1);

    end
end