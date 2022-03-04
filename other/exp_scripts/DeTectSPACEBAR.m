function DeTectSPACEBAR
conf=Config;
is_true = 0;
while (is_true == 0)
    [keyIsDown,foo,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(conf.keySpace)
            is_true = 1;
            clear foo;
        elseif keyCode(conf.keyEscape)
            CloseExperiment;
            warning('ESC KEY DETECTED - experiment aborted!');
            return;
        end
    end
end