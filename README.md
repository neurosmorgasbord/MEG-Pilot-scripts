# Running
To run the experiment, open `run_experiment.m` and hit Run. This _should_ do it.

# Code structure
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
+ rt - in seconds (or nan) 
+ selected_item - 1 or 2 for left/right respectively (or nan)
+ key_pressed - LeftArrow or RightArrow (or nan)
+ preference_repsonse_consistent - whether the current choice corresponded to the choice based on stage 1 ratings (1/0/nan)
+ acquired_points - whether the PP won points 0/100/nan
+ ...

Using these two ideas, I simply loop through the object that holds all the data for the current participant and run a single trial using loops.

One more pattern is that I also use a seperate object to hold all of the experiment's parameters - this is also a structured array and can be found in the `get_exp_parameters_and_initialize_psychtoolbox.m` file. It contains values such as number of test trials, number of blocks, all item ids etc.

All files not mentioned here support the execution of the above two ideas, and hopefully their names and comments at the top should suffice to explain their function.