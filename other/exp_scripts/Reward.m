function Rewarding = Reward(resKey,Trial)

conf= Config;
probT= 0;

% figure out which key was pressed?
% figure out which cue has been selected?
% what is the prob associated with that cue?

if resKey == conf.keyRes(1)
    probT=conf.odds(Trial(1)); %probabliity.
elseif resKey == conf.keyRes(3)
     probT=conf.odds(Trial(2)); %probabliity.
else 
    resKey = 0;
end
        

if rand(1)<probT
    %reward 
    Rewarding =1;
else
    %no reward
    Rewarding =0;
end