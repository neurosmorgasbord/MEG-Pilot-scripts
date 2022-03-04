function seq=MakeSeq(ntrials,elem,fold)

if mod(ntrials,length(elem)*fold)~=0
    warning('cannot make a fully counterbalanced design!!');
end

seq=[];
for k=1:fold
    seq_band = sortrows([randperm(ntrials/fold)' repmat(elem, floor(ntrials/fold/length(elem)),1)]);
    seq_band = seq_band(:,2);
    stimok = 0;
    while ~stimok
        i = 1;
        ncount = 0;
        nnokey = 0;
        nother = 0;
        % loop through set to find sequences of 4 times no key or 4 times any key
        while i<=ntrials/fold-1 && ncount <3
            if seq_band(i+1) == seq_band(i)
                ncount = ncount +1;
            else
                ncount = 0;
            end
            i = i +1;
        end
        if i >= ntrials/fold && seq_band(end-1)~=seq_band(end) && (sum(seq_band(1:3)-seq_band(1))~=0)
            stimok = 1;
        else
            seq_band = sortrows( [randperm(ntrials/fold)' repmat(elem, floor(ntrials/fold/length(elem)),1)]);
            seq_band = seq_band(:,2);
        end
    end
    seq=[seq;seq_band];
end