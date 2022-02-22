%% Value cue version
%% Set up
% Clear the workspace and the screen
sca;
close all;
clear;
Screen('Preference', 'SkipSyncTests', 1);

%% Subj details
%%participant_ID = input('Please enter your initials ', 's'); % gets participant initials
%%participant_age = input('Please enter your age '); % gets pp age
%%participant_gender = input('Please enter your gender ', 's'); % gets pp gender

% Default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

try
    [exp_parameters, window] = get_exp_parameters_and_initialize_psychtoolbox();

    %% show instructions
    show_instructions(window, exp_parameters)

    %% Run main trials
    stage_2_curr_pp_trials = get_stage_2_curr_pp_trials(exp_parameters);
    % we need a double loop to run the trials in order to show an 
    % interblock screen after each block
    for test_block_ind = 1:exp_parameters.TEST_BLOCKS
        for test_trial_ind = 1:exp_parameters.TEST_TRIALS_PER_BLOCK
            % because the test trial ind is refreshed for each block, we
            % calculate the true trial number here
            current_trial_number = ((test_block_ind-1)*exp_parameters.TEST_TRIALS_PER_BLOCK) + test_trial_ind;
            trial_data = run_single_main_trial(window, exp_parameters.SCREEN_X_PIXELS, exp_parameters.SCREEN_Y_PIXELS, exp_parameters.GREY_COLOR, exp_parameters.BLACK_COLOR, ...
                                        stage_2_curr_pp_trials(current_trial_number).item_1_id, ...
                                        stage_2_curr_pp_trials(current_trial_number).item_2_id, ...
                                        stage_2_curr_pp_trials(current_trial_number).item_1_border_color, ...
                                        stage_2_curr_pp_trials(current_trial_number).trial_type);
            
            
        end
        % show interblock screen in a similar manner as instructions
        show_instructions(window, exp_parameters)
    end
    

catch
    %% Close PT screen
    sca;
    Priority(0);
    ShowCursor();
    psychrethrow(psychlasterror);
end
sca;