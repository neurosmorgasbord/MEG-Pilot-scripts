%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acquired the trials array for the test trials. See README for details on
% this array.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [test_trials_array] = get_test_trials_array(exp_parameters)
    selected_items_based_on_stage_1_ratings = struct();
    for item_ind=1:length(exp_parameters.ALL_ITEMS)
        selected_items_based_on_stage_1_ratings(item_ind).item_id = exp_parameters.ALL_ITEMS(item_ind);
        selected_items_based_on_stage_1_ratings(item_ind).stage_1_rating = randi([1 100], 1);
    end

    %% initialize variables
    test_trials_array_columns = ["pt_trial"; "block"; "trial"; "item_1_id"; "item_1_subjective_value"; "item_1_subjective_value_category"; "item_1_border_color"; "item_1_reward_prob"; "item_2_id"; "item_2_subjective_value"; "item_2_subjective_value_category"; "item_2_border_color"; "item_2_reward_prob"];
    test_trials_array = struct();
    for trial_ind=1:exp_parameters.TEST_TRIALS_N
        for col_ind=1:length(test_trials_array_columns)
            test_trials_array(trial_ind).(test_trials_array_columns(col_ind)) = [];
        end
    end

    blocks_specifications_columns = ["block"; "reward_prob_lower"; "reward_prob_higher"; "correct_color"; "congruency_type"];
    blocks_specifications = struct();
    for block_ind=1:exp_parameters.TEST_BLOCKS
        for col_ind=1:length(blocks_specifications_columns)
            blocks_specifications(block_ind).(blocks_specifications_columns(col_ind)) = [];
        end
        blocks_specifications(block_ind).block = block_ind;
    end

    %% get the reward probs for each block
    reward_probabilities_order = [];
    for i=1:exp_parameters.REWARD_PROBABILITIES_ITERATIONS %shortcut as I know have only 2 combinations
        %use randperm to randomize rows of matrix, see https://www.mathworks.com/matlabcentral/answers/30345-swap-matrix-row-randomly#answer_38803
        curr_iteration_reward_probs = exp_parameters.REWARD_PROBABILITIES(randperm(size(exp_parameters.REWARD_PROBABILITIES, 1)), :);
        %making sure that the last reward probability of the previous iteration is not the same as the first in the next so that they change each block
        if size(reward_probabilities_order, 1) > 1
            while reward_probabilities_order(end, :) == curr_iteration_reward_probs(1, :)
                curr_iteration_reward_probs = exp_parameters.REWARD_PROBABILITIES(randperm(size(exp_parameters.REWARD_PROBABILITIES, 1)), :);
            end
        end
        reward_probabilities_order = [reward_probabilities_order; curr_iteration_reward_probs];
    end
    %add the reward probs to the block specifications
    %display(reward_probabilities_order(:, 1){:})
    reward_prob_lower = reward_probabilities_order(:, 1);
    reward_prob_higher = reward_probabilities_order(:, 2);
    [blocks_specifications.reward_prob_lower] = reward_prob_lower{:};
    [blocks_specifications.reward_prob_higher] = reward_prob_higher{:};

    %% get the correct color for each block
    correct_color_list_ordered = repmat(["red" "blue"], 1, exp_parameters.TEST_BLOCKS/2);
    %randomize order of red-blue for each block
    block_correct_color_list = correct_color_list_ordered(randperm(length(correct_color_list_ordered)));
    %add to block specs
    [blocks_specifications.correct_color] = block_correct_color_list{:};

    %% get the block congruency
    block_congruency_types = get_block_congruency_types(reward_probabilities_order);
    [blocks_specifications.congruency_type] = block_congruency_types{:};

    %% setting up block-level variables
    for block_ind=1:exp_parameters.TEST_BLOCKS
        %set up the color-red prob pair; structure array (e.g. red-0.2, blue-0.8)
        if blocks_specifications(block_ind).correct_color == "red"
            curr_block_color_reward_prob_pair.red = blocks_specifications(block_ind).reward_prob_higher;
            curr_block_color_reward_prob_pair.blue = blocks_specifications(block_ind).reward_prob_lower;
        else
            curr_block_color_reward_prob_pair.red = blocks_specifications(block_ind).reward_prob_lower;
            curr_block_color_reward_prob_pair.blue = blocks_specifications(block_ind).reward_prob_higher;
        end
        
        %set up a 1d array with trial types for the current block
        curr_block_trial_types = [repmat("reward", round(exp_parameters.TEST_TRIALS_PER_BLOCK*exp_parameters.REWARD_TO_PREF_TRIALS_RATIO), 1); repmat("preference", round(exp_parameters.TEST_TRIALS_PER_BLOCK-(exp_parameters.TEST_TRIALS_PER_BLOCK*exp_parameters.REWARD_TO_PREF_TRIALS_RATIO)), 1)];

        %set up correct colors for each item (col 1 is item 1 and col 2 is
        %item 2)
        curr_block_border_colors = repmat(["red" "blue"; "blue" "red"], exp_parameters.TEST_TRIALS_PER_BLOCK/2, 1);
        curr_block_border_colors = curr_block_border_colors(randperm(size(curr_block_border_colors, 1)), :); %shuffle row order

        %% setting up trial-level variabls
        for trial_ind_per_block=1:exp_parameters.TEST_TRIALS_PER_BLOCK
            %curr_trial_item_pair = ["item_1" "item_2"];
            curr_trial_item_pair = get_two_random_items_ordered_by_congruency(selected_items_based_on_stage_1_ratings, ...
                                                                                blocks_specifications(block_ind).congruency_type, ...
                                                                                curr_block_color_reward_prob_pair.(curr_block_border_colors(trial_ind_per_block, 1)), ...
                                                                                curr_block_color_reward_prob_pair.(curr_block_border_colors(trial_ind_per_block, 2)));
    
            item_1_subjective_value = selected_items_based_on_stage_1_ratings(strcmp([selected_items_based_on_stage_1_ratings.item_id], curr_trial_item_pair(1))).stage_1_rating;
            item_2_subjective_value = selected_items_based_on_stage_1_ratings(strcmp([selected_items_based_on_stage_1_ratings.item_id], curr_trial_item_pair(2))).stage_1_rating;
            test_trial_ind = ((block_ind-1)*exp_parameters.TEST_TRIALS_PER_BLOCK + trial_ind_per_block);
            test_trials_array(test_trial_ind).pt_trial = false;
            test_trials_array(test_trial_ind).block = block_ind;
            test_trials_array(test_trial_ind).trial = test_trial_ind;
            test_trials_array(test_trial_ind).item_1_id = curr_trial_item_pair(1);
            test_trials_array(test_trial_ind).item_1_subjective_value = item_1_subjective_value;
            test_trials_array(test_trial_ind).item_1_subjective_value_category = "";
            test_trials_array(test_trial_ind).item_1_border_color = curr_block_border_colors(trial_ind_per_block, 1);
            test_trials_array(test_trial_ind).item_1_reward_prob = curr_block_color_reward_prob_pair.(curr_block_border_colors(trial_ind_per_block, 1));
            test_trials_array(test_trial_ind).item_2_id = curr_trial_item_pair(2);
            test_trials_array(test_trial_ind).item_2_subjective_value = item_2_subjective_value;
            test_trials_array(test_trial_ind).item_2_subjective_value_category = "";
            test_trials_array(test_trial_ind).item_2_border_color = curr_block_border_colors(trial_ind_per_block, 2);
            test_trials_array(test_trial_ind).item_2_reward_prob = curr_block_color_reward_prob_pair.(curr_block_border_colors(trial_ind_per_block, 2));
            test_trials_array(test_trial_ind).items_subjective_value_difference = item_2_subjective_value - item_1_subjective_value;
            test_trials_array(test_trial_ind).trial_type = curr_block_trial_types(trial_ind_per_block);

        end
    end
end