function [key_pressed, rt] = get_keyboard_response(accepted_keys, response_start_time, time_limit_ms)

    %defining the keyPressed variable from the start
    %which makes it clear what our loop-stopping condition will be
    %the key_pressed var is initialized as a space as if it was empty;
    %matlab interprets it as a 0x0 empty char array while if there is a space
    %then it is simply a character class;
    %as long as a space key is not provided as a valid keyboard press
    %in the list within the while loop, then this is fine
    key_pressed = ' ';
    stop_time = GetSecs + (time_limit_ms/1000);
    while (not(ismember(num2str(key_pressed), accepted_keys))) && (GetSecs < stop_time)
        %note that keycode is a a 256-element logical vector where one 
        %element represents one key; 
        %if a key is pressed, its corresponding element is set to true
        %[secs, keyCode, deltaSecs] = KbWait();
        [keyIsDown, secs, keyCode] = KbCheck;
        %translate the 256-element logical vector to a proper key name
        key_pressed = KbName(find(keyCode));
        rt = secs - response_start_time;
    end

    %if time limit has elapsed (i.e. no valid key response is provided)
    %then set the results to nan
    if not(ismember(num2str(key_pressed), accepted_keys))
        key_pressed = nan;
        rt = nan;
    end

end