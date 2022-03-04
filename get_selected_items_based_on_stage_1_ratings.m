%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function used to get the stage 1 ratings provided a filename. THe
% filename is one generated from jsPsych but can be adapted.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [selected_items_based_on_stage_1_ratings]=get_selected_items_based_on_stage_1_ratings(filename)
    if exist('filename', 'var') && ~isempty(filename)
        mytable = readtable(filename);
        filtered_table = mytable(strcmp(mytable.trial_name, 'stage_1_trial'), ["block", "stage_1_trial_item_id", "stage_1_trial_slider_rating"]);
    
        %format item ids
        for i=1:size(filtered_table, 1)
            filtered_table{i, 'stage_1_trial_item_id_formatted'} = sprintf("%04d", filtered_table{i, 'stage_1_trial_item_id'});
        end
        filtered_table = removevars(filtered_table, {'stage_1_trial_item_id'});
    
        %get summary stats
        selected_items_based_on_stage_1_ratings = groupsummary(filtered_table, ["stage_1_trial_item_id_formatted"], "mean");
        selected_items_based_on_stage_1_ratings = removevars(selected_items_based_on_stage_1_ratings, {'GroupCount', 'mean_block'});
    else
        %generate dummy data
        exp_parameters = get_exp_parameters();
        random_ratings = round(rand(length(exp_parameters.ALL_ITEMS), 1)*100, 2);
        selected_items_based_on_stage_1_ratings = table(exp_parameters.ALL_ITEMS', random_ratings, 'VariableNames', {'stage_1_trial_item_id_formatted', 'mean_stage_1_trial_slider_rating'});
    end

    %modify col names
    selected_items_based_on_stage_1_ratings.Properties.VariableNames = {'item_id', 'stage_1_rating'};
    %NB: we need this as a structured array for the get_test_trials_array.m
    %so we convert it here
    selected_items_based_on_stage_1_ratings = table2struct(selected_items_based_on_stage_1_ratings);
end
