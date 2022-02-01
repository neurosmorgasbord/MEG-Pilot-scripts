%% Square coordinates - for PTB Script
function [stim_coordinates] = stimulus_pos(stim_size, center)

stim_coordinates = [center(1)-stim_size, center(2)-stim_size,...
        center(1)+stim_size, center(2)+stim_size];
end