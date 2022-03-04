%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generic function to get a keyboard response.
% Accepted keys is a 1d vector of KbNames of the permissible keys
% Response start time is used to measure the rt, as desired
% The final argument gives a time limit to wait for the response (defaults
% to no time limit
% NB: Escape is used as a key to end the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [key_pressed, rt] = get_keyboard_response(accepted_keys, response_start_time, time_limit_s)
    % default to no time limit
    if ~exist('time_limit_s', 'var')
        time_limit_s = Inf;
    end
    % add escape as an accepted key in case experiment is to be aborted
    accepted_keys = [accepted_keys "ESCAPE"];
    %defining the keyPressed variable from the start
    %which makes it clear what our loop-stopping condition will be
    %the key_pressed var is initialized as a space as if it was empty;
    %matlab interprets it as a 0x0 empty char array while if there is a space
    %then it is simply a character class;
    %as long as a space key is not provided as a valid keyboard press
    %in the list within the while loop, then this is fine
    key_pressed = "none";
    stop_time = GetSecs + time_limit_s;
    while (not(ismember(key_pressed, accepted_keys))) && (GetSecs < stop_time)
        if key_pressed == "ESCAPE"
            sca;
            Priority(0);
            ShowCursor();
            warning('ESCAPE KEY DETECTED - experiment aborted!');
        end
        %note that keycode is a a 256-element logical vector where one 
        %element represents one key; 
        %if a key is pressed, its corresponding element is set to true
        %[secs, keyCode, deltaSecs] = KbWait();
        [keyIsDown, secs, keyCode] = KbCheck;
        %translate the 256-element logical vector to a proper key name
        key_pressed = KbName(find(keyCode));
        rt = secs - response_start_time;
        %not 100% sure why but if no key is pressed the empty thing is now
        %a class double but we need it as a string for the ismember
        %function above
        if class(key_pressed) == "double"
            key_pressed = num2str(key_pressed);
        end
    end

    %if time limit has elapsed (i.e. no valid key response is provided)
    %then set the results to nan
    if not(ismember(num2str(key_pressed), accepted_keys))
        key_pressed = nan;
        rt = nan;
    end

end
