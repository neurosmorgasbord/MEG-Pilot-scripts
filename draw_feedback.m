%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw the feedback text on the screen at the end of each trial.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function []=draw_feedback(window, rt, acquired_points, too_quick_response_threshold)
    font_size = 70;
    if isnan(rt) %too slow
        display_text(window, 'TOO SLOW!', font_size, 0, 0, [1 0 0]);
    elseif rt < too_quick_response_threshold %too quick
        display_text(window, 'TOO QUICK!', font_size, 0, 0, [1 0 0]);
    else %regular feedback
        if acquired_points > 0
            display_text(window, '+100 points!', font_size, 0, 0, [0 1 0]);
        else
            display_text(window, '0 points!', font_size, 0, 0, [1 0 0]);
        end
    end
end