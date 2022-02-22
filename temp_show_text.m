%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is just a temporary function until the proper one for displaying
% insturctions is ready.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function []=temp_show_text(window, exp_parameters, text, time_limit_ms)
    if ~exist('time_limit_ms', 'var')
        time_limit_ms = Inf;
    end
    %display_text is a custom function, modified by a version from JZ
    %it uses DrawText, but DrawFormattedText can also be used
    %it'd be good to dispaly multi-line text that is centered in the screen
    %and fits
    %NB: display_text function calls flip within it, but if this is changed
    %then we need to flip
    display_text(window, strcat(text, ' Press Enter to continue.'), 30, 0, 0, exp_parameters.BLACK_COLOR);
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos]=Screen('Flip', window, []);
    
    %here we need to wait for keyboard response (or a mouse click) and
    %record the rt
    %bonus points if we find a way to have previous/next buttons/keyboard
    %so that participants can go back and forther to remember the
    %instructions
    %maybe look into the get_keyboard_response function for inspiration
    accepted_keys = ["Return"];
    [key_pressed, rt] = get_keyboard_response(accepted_keys, StimulusOnsetTime, time_limit_ms);
end