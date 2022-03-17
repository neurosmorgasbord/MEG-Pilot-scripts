function [selected_items_based_on_stage_1_ratings]=temp_selected_ratings_from_R(filename)
    table = readtable(filename);

    %format item ids
    for i=1:size(table, 1)
        table{i, 'item_id'} = sprintf("%04d", table{i, 'item_id_from_R'});
    end
    table = removevars(table, {'item_id_from_R'});

    selected_items_based_on_stage_1_ratings = table2struct(table);
end
