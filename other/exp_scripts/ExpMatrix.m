function ShuffleMatrix=ExpMatrix (screenInfo,subj,cue)

%Create the Matrix with the stimuli
M = [1 7; 1 7; 7 2; 7 2; 7 1; 7 1; 2 7; 2 7; 7 3; 7 4; 3 7; 4 7; 6 7; 5 7; 7 6; 7 5; ...
        1 2; 1 2; 1 2; 1 2; 2 1; 2 1; 2 1; 2 1; 3 4; 3 4; 3 4; 3 4; 6 5; 6 5; 6 5; 6 5; ...
        1 2; 1 2; 1 2; 1 2; 2 1; 2 1; 2 1; 2 1; 4 3; 4 3; 4 3; 4 3; 5 6; 5 6; 5 6; 5 6; ...
        3 5; 3 5; 3 5; 3 5; 5 3; 5 3; 5 3; 5 3; 2 5; 1 5; 2 6; 1 6; 1 3; 1 4; 2 3; 2 4; ...
        4 6; 4 6; 4 6; 4 6; 6 4; 6 4; 6 4; 6 4; 6 1; 5 2; 5 1; 6 2; 4 2; 4 1; 3 2; 3 1];

%Shuffle the Matrix
ShuffleMatrix = [M(randperm(size(M,1)),:) ; M(randperm(size(M,1)),:)];

end
   