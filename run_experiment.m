%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script starts the entire experiment. The logic is set up so that
%first we initialize the experiment parameters (number of trials, image
%names etc) as well as psychtoolbox setup. The core of the logic is that we
%create a structured array for practice and test trials with rows equal to
%the number of practice/test trials and each fieldname (or column) denoting
%a variable we need to create the trials (border colors, item ids etc).
%Using the experiment parameters and the strcutured array, we can run a
%single trial inside a loop to show each individual trial and save its
%data. View each function for an explanation of what it does.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

    %% show intro instructions
    temp_show_text(window, exp_parameters, 'Intro instructions go here.')

    pause(0.1); %find a better way to wait until key is released

    %% show consent form
    temp_show_text(window, exp_parameters, 'Consent form goes here.')

    pause(0.1); %find a better way to wait until key is released
    
    %% Run practice trials
    pt_trials_array = get_pt_trials_array(exp_parameters);
    for pt_block_ind = 1:exp_parameters.PT_BLOCKS
        for pt_trial_ind = 1:exp_parameters.PT_TRIALS_PER_BLOCK
            current_pt_trial_number = ((pt_block_ind-1)*exp_parameters.PT_TRIALS_PER_BLOCK) + pt_trial_ind;
            trial_data = run_single_main_trial(window, exp_parameters, pt_trials_array(current_pt_trial_number));
        end
    end
    
    %% Show instructions between pt and test trials
    temp_show_text(window, exp_parameters, 'Instructions between pt and test trials go here.')

    %% Run main trials
    test_trials_array = get_test_trials_array(exp_parameters);
    % we need a double loop to run the trials in order to show an 
    % interblock screen after each block
    for test_block_ind = 1:exp_parameters.TEST_BLOCKS
        for test_trial_ind = 1:exp_parameters.TEST_TRIALS_PER_BLOCK
            % because the test trial ind is refreshed for each block, we
            % calculate the true trial number here
            current_test_trial_number = ((test_block_ind-1)*exp_parameters.TEST_TRIALS_PER_BLOCK) + test_trial_ind;
            trial_data = run_single_main_trial(window, exp_parameters, pt_trials_array(current_pt_trial_number));  
            
        end
        % show interblock screen in a similar manner as instructions
        % use exp_parameters to show relevant info (e.g. POINTS_COUNTER)
        temp_show_text(window, exp_parameters, 'Interblock instructions go here.')
    end

    %% Show debrief
    temp_show_text(window, exp_parameters, 'Debrief form goes here.')

catch
    %% Close PT screen
    sca;
    Priority(0);
    ShowCursor();
    psychrethrow(psychlasterror);
end
sca;