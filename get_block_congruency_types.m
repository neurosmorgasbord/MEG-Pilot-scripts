%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inner workings of this function remain a bit of a black box but it is
% needed in order to ensure that the first iteration of 0.2-0.8
% reward probs is congruent and the second is incongruent (rather than 2
% congruent and 2 incongruent). I think it also works for more than 2
% iterations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [block_congruency_type] = get_block_congruency_types(reward_probabilities_order)
    TEST_BLOCKS = 4;
    REWARD_PROBABILITIES = [["0.2" "0.8"]; ["0.4" "0.6"]];
    REWARD_PROBABILITIES_ITERATIONS = TEST_BLOCKS/length(REWARD_PROBABILITIES); %i.e. number of times to repeat each reward prob pair

    block_congruency_type = strings(TEST_BLOCKS, 1);
    for unique_reward_prob_ind=1:length(REWARD_PROBABILITIES)
        congruencies_for_current_reward_prob = repmat(["congruent" "incongruent"], 1, REWARD_PROBABILITIES_ITERATIONS/2);
        congruencies_for_current_reward_prob = congruencies_for_current_reward_prob(randperm(length(congruencies_for_current_reward_prob)));
        current_unique_reward_congurnecy_running_index = 1;
        for row_ind=1:length(reward_probabilities_order)
            if reward_probabilities_order(row_ind, :) == REWARD_PROBABILITIES(unique_reward_prob_ind, :)
                congruency = congruencies_for_current_reward_prob(current_unique_reward_congurnecy_running_index);
                block_congruency_type(row_ind) = congruency;
                current_unique_reward_congurnecy_running_index = current_unique_reward_congurnecy_running_index + 1;
            end
        end
    end
end