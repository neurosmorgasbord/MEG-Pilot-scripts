# Running
To run the experiment, open `run_experiment.m`. The function takes 4 input arguments
+ subject_id - the id of the subject
+ pt_block - 1/0; whether a single practice block is to be displayed
+ blocks - vector of integers denoting which blocks to be run (up to 4)
+ filename - the filename where the PP's stage 1 ratings are held

During testing, to run the script simply provide empty arguments - `run_experiment([], [], [], [])`. This will use default values. These are set as follows:
+ subject_id - timestamp of the current date/hour
+ pt_block - 0
+ blocks - [1 2]
+ filename - `a` but this can be set to a real stage 1 ratings file, see lines 37-38

# Code structure - running the trials
There are two central ideas behind the code:
1) running a single trial
2) creating an object that holds all data needed to run a single trial

Running a single trial is done using `run_single_main_trial.m` function. It takes care of everything, including drawing a fixation cross, drawing the food items and the colored borders, drawing the trial type, getting a response and saving all of the data. The output of running a single trial is a [structured array](https://www.mathworks.com/help/matlab/ref/struct.html).

The data need to run a single trial is created once for practice trials (`get_pt_trials_array.m`) and once for test trials (`get_test_trials_array.m`). The output of these functions is a structured array with columns:
+ pt_trial - true/false (or 1/0)
+ block - block index
+ trial - trial index
+ item_1_id - left item id
+ item_1_subjective_value - left item subjective value, from 1 to 100
+ item_1_subjective_value_category - left item subjective value category, less_prefferred or more_preferred
+ item_1_border_color - left item border color (red/blue)
+ item_1_reward_prob - left item reward probability (given from the experiment's possible reward probabilities)
+ item_2_id
+ item_2_subjective_value
+ item_2_subjective_value_category
+ item_2_border_color
+ item_2_reward_prob
+ items_subjective_value_difference - difference between subjective value or right minus left item
+ trial_type - current trial's type - either congruent or incongruent

Additional data saved once the trial is run:
+ *TIMESTAMPS - timestamps for almost everything that appears/clears are saved. See `run_single_main_trial.m` for details.
+ rt - in seconds (or nan) 
+ selected_item - 1 or 2 for left/right respectively (or nan)
+ key_pressed - LeftArrow or RightArrow (or nan)
+ preference_repsonse_consistent - whether the current choice corresponded to the choice based on stage 1 ratings (1/0/nan)
+ acquired_points - whether the PP won points 0/100/nan

Using these two ideas, I simply loop through the object that holds all the data for the current participant and run a single trial using loops.

# Code structure - `CONFIG` and `DATA` objects
There are two core objects that facilitate the running of the experiment as described above.

The `CONFIG` object is a structured array. It contains four structured sub-arrays: 
+ `CONFIG.exp_parameters` - structured array with experiment-specific parameters. In this case these include trial number, time limits etc. See `get_exp_parameters.m`.
+ `CONFIG.current_session_info` - structured array with session-specific parameters. These include window-related parameters, inter frame difference, screen slack etc. NB: This also contains information whether to run the practice block in this session and which blocks to run in the current session. See `initialize_psychtoolbox.m` for details.
+ `CONFIG.pt_trials_array` - structured array that contains the data needed to run the practice trials - see above.
+ `CONFIG.test_trials_array` - structured array that contains the data needed to run the test trial - see above.

The `CONFIG` object is generated once for each unique subject id. From there on if the same subject id is used, the already generated `CONFIG` object will be loaded. NB: This does not include the `current_session_info` sub-array - this is generated every time the script is run.

The `CONFIG` objects are saved in the `subjects_CONFIG_files` folder with the subject id as the file name.

The `DATA` object contains two structured sub-arrays: `DATA.pt_trials` and `DATA.test_trials`. Each of those structured sub-arrays has an index equal to the trial number and a `trial_data` field. The `trial_data` field contains a structured array that contains all of the data for a single trial - see above what data are saved. For instance, if you want to access the reaction time from test trial 25 use: `DATA.test_trials(25).trial_data.rt`.

The `DATA` object is saved after each block, such that a single subject will have up to 4 files. The 4 files are saved in a subfolder of `subjects_DATA_files`, named with the subject id. The file name of each file is `{subject id}_block_{block}`. NB: Slightly awkwardly at the moment if blocks 1 and 2 are run the saved `DATA` files will contain overlapping data as the `DATA` object is not reset after each run. This is awkward as it might lead to overlapping data in the savd objects but I prefer to have 2 lines more hassle during data processing than to risk resetting the `DATA` object (unless this is necessary for improving cpu/memory load).

# Other notes
+ ...

---
All files not mentioned here support the execution of the above two ideas, and hopefully their names and comments at the top should suffice to explain their function.