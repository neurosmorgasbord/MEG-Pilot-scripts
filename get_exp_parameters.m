%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize experiment-specific paramters (number of trials etc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [exp_parameters]=get_exp_parameters()
    exp_parameters = struct();

    exp_parameters.PT_TRIALS_N = 2;
    %exp_parameters.PT_TRIALS_PER_BLOCK = 10;
    %exp_parameters.PT_BLOCKS = exp_parameters.PT_TRIALS_N / exp_parameters.PT_TRIALS_PER_BLOCK;

    exp_parameters.TEST_TRIALS_N = 8;
    exp_parameters.TEST_TRIALS_PER_BLOCK = 2;
    exp_parameters.TEST_BLOCKS = exp_parameters.TEST_TRIALS_N / exp_parameters.TEST_TRIALS_PER_BLOCK;

    exp_parameters.REWARD_PROBABILITIES = [["0.2" "0.8"]; ["0.4" "0.6"]];
    exp_parameters.REWARD_PROBABILITIES_ITERATIONS = exp_parameters.TEST_BLOCKS/length(exp_parameters.REWARD_PROBABILITIES); %i.e. number of times to repeat each reward prob pair
    exp_parameters.REWARD_TO_PREF_TRIALS_RATIO = 0.5;

    exp_parameters.ALL_ITEMS = ["0014" "0028" "0041" "0070" "0080" "0116" "0162" "0187" "0189" "0199" "0249" "0277" "0286" "0287" "0308" "0310" "0313" "0319" "0360" "0365" "0380" "0399" "0400" "0421" "0422" "0459" "0460" "0467" "0468" "0496" "0504" "0507" "0515" "0569" "0571" "0614" "0626" "0755" "0801" "0820"];
    exp_parameters.PRACTICE_FOOD_ITEMS = ["0001" "0002" "0007" "0009" "0011" "0012" "0013" "0015" "0018" "0021" "0022" "0023" "0024" "0025" "0026" "0027" "0029" "0030" "0031" "0034"];
    exp_parameters.STAGE_2_TRIAL_IMAGES_TIME = 1.2;
    exp_parameters.STAGE_2_TRIAL_TIME_LIMIT = 2;
    exp_parameters.STAGE_2_FEEDBACK_DURATION = 1;
    exp_parameters.STAGE_2_TOO_QUICK_RESPONSE_THRESHOLD = 0.2;

    exp_parameters.POINTS_COUNTER = 0;
    exp_parameters.MAX_REWARD_AT_POINTS = 45000;
    exp_parameters.POINTS_THAT_GRANT_ONE_P = 450;
end