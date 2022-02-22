function [curr_trial_item_pair] = get_two_random_items_ordered_by_congruency(selected_items_based_on_stage_1_ratings, congruency_type, item_1_reward_prob, item_2_reward_prob)
    curr_trial_item_pair = [];

    unordered_items = randsample([selected_items_based_on_stage_1_ratings.item_id], 2);
    %make sure that subjective values are not equal
    while selected_items_based_on_stage_1_ratings(strcmp([selected_items_based_on_stage_1_ratings.item_id], unordered_items(1))).stage_1_rating == selected_items_based_on_stage_1_ratings(strcmp([selected_items_based_on_stage_1_ratings.item_id], unordered_items(2))).stage_1_rating
        unordered_items = randsample([selected_items_based_on_stage_1_ratings.item_id], 2);
    end

    unordered_item_1_subj_value = selected_items_based_on_stage_1_ratings(strcmp([selected_items_based_on_stage_1_ratings.item_id], unordered_items(1))).stage_1_rating;
    unordered_item_2_subj_value = selected_items_based_on_stage_1_ratings(strcmp([selected_items_based_on_stage_1_ratings.item_id], unordered_items(2))).stage_1_rating;
    %this logic can probably be shortened but this way is clearer
    if congruency_type == "congruent"
        if str2double(item_1_reward_prob) < str2double(item_2_reward_prob)
            if unordered_item_1_subj_value < unordered_item_2_subj_value
                curr_trial_item_pair = unordered_items;
            elseif unordered_item_1_subj_value > unordered_item_2_subj_value
                curr_trial_item_pair = flip(unordered_items);
            end
        elseif str2double(item_1_reward_prob) > str2double(item_2_reward_prob)
            if unordered_item_1_subj_value < unordered_item_2_subj_value
                curr_trial_item_pair = flip(unordered_items);
            elseif unordered_item_1_subj_value > unordered_item_2_subj_value
                curr_trial_item_pair = unordered_items;
            end
        end
    elseif congruency_type == "incongruent"
        if str2double(item_1_reward_prob) < str2double(item_2_reward_prob)
            if unordered_item_1_subj_value < unordered_item_2_subj_value
                curr_trial_item_pair = flip(unordered_items);
            elseif unordered_item_1_subj_value > unordered_item_2_subj_value
                curr_trial_item_pair = unordered_items;
            end
        elseif str2double(item_1_reward_prob) > str2double(item_2_reward_prob)
            if unordered_item_1_subj_value < unordered_item_2_subj_value
                curr_trial_item_pair = unordered_items;
            elseif unordered_item_1_subj_value > unordered_item_2_subj_value
                curr_trial_item_pair = flip(unordered_items);
            end
        end
    end
end