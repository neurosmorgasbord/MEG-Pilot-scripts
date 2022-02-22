function display_text(window, textString, fontsize, Yoffset, ratio, color)

    window_rect = Screen('Rect', window); % gets same info a windowRect
    Screen(window, 'TextSize', fontsize);
    txtrect = Screen(window, 'TextBounds', textString);
    txtwidth = txtrect(3)-txtrect(1);

    %Screen(window, 'DrawText', textString);
    
    if ~exist('ratio')
        ratio=0;
    end
    
    if ratio==0
        Screen(window, 'DrawText', textString, (window_rect(3)-txtwidth)/2, window_rect(4)/2+Yoffset, color);
    else
        Screen(window, 'DrawText', textString,(window_rect(3)-txtwidth)/2, window_rect(4)/2+Yoffset*window_rect(4), color);
    end
    
end
