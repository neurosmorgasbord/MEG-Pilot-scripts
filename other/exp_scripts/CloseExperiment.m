function CloseExperiment
% closeExperiment
% closes the screen, returns priority to zero, starts the update process,
% and shows the cursor.

Priority(0);
Screen('CloseAll');
% ListenChar(0);
ShowCursor; % Show cursor again, if it has been disabled.