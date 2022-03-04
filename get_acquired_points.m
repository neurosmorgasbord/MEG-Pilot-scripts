%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A function to get the acquired points based on the reward probability.
% E.g. if reward probability is 0.6, there is 60% chance to win 100 points.
% There is probably a better way to do it in Matlab, but this is how the
% logic is devised in JS.
% The way it works is essentially an array (pool_to_draw_from) - 
% if odds of winning = 0.54,
% then the array contains 54 instances of the 'points'
% and 0.46 instances of 0; then it is shuffled
% deciding whether the PP won is by drawing a random element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [acquired_points] = get_acquired_points(trial_data, selected_item, preference_response_consistent)
    points_to_win = 100;
    if trial_data.trial_type == "preference"
        if preference_response_consistent == 1
            odds_of_winning = 1;
        else
            odds_of_winning = 0;
        end
    elseif trial_data.trial_type == "reward"
        if selected_item == 1
            odds_of_winning = str2double(trial_data.item_1_reward_prob);
        elseif selected_item == 2
            odds_of_winning = str2double(trial_data.item_2_reward_prob);
        end
    else
        disp("Odds of winning undefined.")
    end
    
    acquired_points = 0;
    if odds_of_winning > 0
        pool_to_draw_from = [repmat(points_to_win, round(odds_of_winning*100), 1); zeros(round((1-odds_of_winning)*100), 1)];
        acquired_points = randsample(pool_to_draw_from, 1);
    end
end