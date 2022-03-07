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
function []=run_experiment(subject_id, pt_block, blocks, filename)
    % Clear the workspace and the screen
    %sca;
    %close all;
    %clear;
    Screen('Preference', 'SkipSyncTests', 1);

    % Default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    %in case no values are provided when calling, we set some default ones
    %during testing
    if ~exist('subject_id', 'var') || isempty(subject_id)
        subject_id = datestr(now, 'yyyymmdd-HHMMSS');
    end
    if ~exist('pt_block', 'var') || isempty(pt_block)
        pt_block = 0;
    end
    if ~exist('blocks', 'var') || isempty(blocks)
        display('vleze2')
        blocks = [1, 2];
    end
    if ~exist('filename', 'var') || isempty(filename)
        % Uncomment the first line to test with real data, otherwise random
        % data will be generated
        %filename = '5ac78faa68b65b00018d72a1_MAIN_complete_finisher_2022-02-16_16h45.55.104_Pie_value.csv';
        filename = 'a';
    end

    if max(blocks) > 4
        %error('Blocks cannot exceed for. Entered blocks were ' string(blocks))
    end

    try
        CONFIG = struct();
        CONFIG.exp_parameters = [];
        CONFIG.pt_trials_aray = [];
        CONFIG.test_trials_array = [];
        CONFIG.current_session_info = [];

        if exist(['subjects_CONFIG_files/' subject_id '.mat'], 'file')
            warning(['NOTICE: There is already a CONFIG file for ' subject_id '!'])
            load(['subjects_CONFIG_files/' subject_id '.mat'], 'CONFIG')
        else
            %get stage 1 ratings
            if exist(filename, 'file') == 2
                selected_items_based_on_stage_1_ratings = get_selected_items_based_on_stage_1_ratings(filename);
            else
                warning('Participant filename with stage 1 ratings not found! Generating random ratings. Start over and correct participant id and/or filename.')
                r = input('Do you want to continue with random data (enter y if this is testing)? (Y/N): ', 's');
                if lower(r) == 'n'
                    return;
                end
                %this gets random ratings during testing
                selected_items_based_on_stage_1_ratings = get_selected_items_based_on_stage_1_ratings();
            end
              
            %make DATA directory
            mkdir(['subjects_DATA_files/' subject_id])

            %set up exp paramters and trials arrays
            CONFIG.exp_parameters = get_exp_parameters();
            CONFIG.pt_trials_array = get_pt_trials_array(CONFIG.exp_parameters);
            CONFIG.test_trials_array = get_test_trials_array(CONFIG.exp_parameters, selected_items_based_on_stage_1_ratings);
            save(['subjects_CONFIG_files/' subject_id '.mat'], 'CONFIG')
        end

        CONFIG.current_session_info.RUN_PT_BLOCK = pt_block;
        CONFIG.current_session_info.RUN_TEST_BLOCKS = blocks;
        %check if those blocks are already run
        for block=CONFIG.current_session_info.RUN_TEST_BLOCKS
            if exist(['subjects_DATA_files/' subject_id '/' subject_id '_block_' num2str(block) '.mat'], 'file')
                warning(['Data for block ' num2str(block) ' already exists!']);
                response=input('Do you Really want to Continue and Overwrite the data file? (Y/N): ','s');
                if lower(response) == 'n'
                    return;
                end
            end
        end

        %this can be optimized so that we dont carry lots of data around
        %e.g. save after each block 
        DATA = struct();
        DATA.pt_trials = struct();
        DATA.test_trials = struct();

        %although window is relevant only for current_session_info it is
        %saved in a separate variable as it is a fundamental object, needed
        %for many operations
        [CONFIG.current_session_info, window] = initialize_psychtoolbox(CONFIG.current_session_info); 
    
        %% show practice trials if requested
        if CONFIG.current_session_info.RUN_PT_BLOCK == 1
            
            display_text(window, 'Press SPACE when ready to start with a few practice trials.', 50, -10, 0, CONFIG.current_session_info.BLACK_COLOR);
            Screen('Flip', window);
            get_keyboard_response(["space"], [], Inf);
            KbReleaseWait;
            Screen('Flip', window);
            
            % Run practice trials
            for pt_trial_ind = 1:CONFIG.exp_parameters.PT_TRIALS_N
                DATA.pt_trials(pt_trial_ind).trial_data = run_single_main_trial(window, CONFIG, CONFIG.pt_trials_array(pt_trial_ind));
            end
        end
        
        %% Show instructions between pt and test trials
        %line1 = 'Practice trials over.';
        line2 = 'Press SPACE when ready to start with the test trials.';
        %display_text(window, line1, 50, -40, 0, CONFIG.current_session_info.BLACK_COLOR);
        display_text(window, line2, 50, 0, 0, CONFIG.current_session_info.BLACK_COLOR);
        Screen('Flip', window);
        get_keyboard_response(["space"], [], Inf);
        KbReleaseWait;
        Screen('Flip', window);

        %% Run main trials
        % we need a double loop to run the trials in order to show an 
        % interblock screen after each block
        for test_block_ind = CONFIG.current_session_info.RUN_TEST_BLOCKS
            for test_trial_ind = 1:CONFIG.exp_parameters.TEST_TRIALS_PER_BLOCK
                % because the test trial ind is refreshed for each block, we
                % calculate the true trial number here
                current_test_trial_number = ((test_block_ind-1)*CONFIG.exp_parameters.TEST_TRIALS_PER_BLOCK) + test_trial_ind;
                trial_data = run_single_main_trial(window, CONFIG, CONFIG.test_trials_array(current_test_trial_number));
                %append the trial's data to the DATA object
                DATA.test_trials(current_test_trial_number).trial_data = trial_data;
                %accumulate points counter
                CONFIG.exp_parameters.POINTS_COUNTER = CONFIG.exp_parameters.POINTS_COUNTER + trial_data.acquired_points;
            end
            %save the data after each block
            %optionally here we can also reset the DATA object to reduce
            %CPU and memory load from carry/writing to the bigger object on
            %each trial but it's not that large of an object to make a
            %difference
            save(['subjects_DATA_files/' subject_id '/' subject_id '_block_' num2str(test_block_ind) '.mat'], 'DATA')
            % show interblock screen only if it's not the final block;
            % otherwise go to debrief
            if test_block_ind ~= CONFIG.exp_parameters.TEST_BLOCKS
                line1 = ['Great job! So far you have earned ' num2str(CONFIG.exp_parameters.POINTS_COUNTER) ' points.'];
                line2 = ['This is the end of block ' num2str(test_block_ind) '. There are ' num2str(max(CONFIG.current_session_info.RUN_TEST_BLOCKS)-test_block_ind) ' blocks remaining.'];
                line3 = 'Press SPACE to continue.';
                display_text(window, line1, 50, -80, 0, CONFIG.current_session_info.BLACK_COLOR);
                display_text(window, line2, 50, 0, 0, CONFIG.current_session_info.BLACK_COLOR);
                display_text(window, line3, 50, 80, 0, CONFIG.current_session_info.BLACK_COLOR);
                Screen('Flip', window);
                get_keyboard_response(["space"], [], Inf);
                KbReleaseWait;
                Screen('Flip', window);
            end
        end
    
        %% Show debrief
        line1 = 'This is the end of the current session!';
        line2 = ['You have earned ' num2str(CONFIG.exp_parameters.POINTS_COUNTER) ' points.'];
        line3 = 'Press SPACE to exit.';
        display_text(window, line1, 50, -80, 0, CONFIG.current_session_info.BLACK_COLOR);
        display_text(window, line2, 50, 0, 0, CONFIG.current_session_info.BLACK_COLOR);
        display_text(window, line3, 50, 80, 0, CONFIG.current_session_info.BLACK_COLOR);
        Screen('Flip', window);
        get_keyboard_response(["space"], [], Inf);
        KbReleaseWait;
        Screen('Flip', window);
    
    catch
        %% Close PT screen
        sca;
        Priority(0);
        ShowCursor();
        psychrethrow(psychlasterror);
    end
    sca;
end