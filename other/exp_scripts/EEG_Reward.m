function EEG_Reward(subj,blocks)

Screen('Preference', 'SkipSyncTests',1);

scriptStart = GetSecs;

if nargin < 2   
    error('Insufficient parameters');
end

if ~ischar(subj)
    error('The 1st parameter, Subject id, must be a char String!');
end

%Experiment Parameters 
conf=Config;

%Get subject detail/folders
subjInfo=getSubjInp(subj);

if blocks < 3
    conf.cueFile = subjInfo.ShufFile;
else
    conf.cueFile = subjInfo.ShufFile2;
end

respKeys=GetRespKeys(subj,conf);

%Check if you Overwriting an existing file 
if exist([subjInfo.resultfolder subj '_EEG_Reward_' num2str(blocks) '.mat'],'file')
    warning(['EEG_Reward' num2str(blocks) '.mat exists!']);
    cont=input('Do you Really want to Continue and Overwrite the old file? (Y/N)','s');
    if cont~='y'
        return;
    end
end

%Set the Screen
screenInfo = Start(conf.exp.monWidth,conf.exp.viewDist,0);
screenInfo.slack = screenInfo.frameDur/2/1000;
curWindow=screenInfo.curWindow;
Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

FixCross = [screenInfo.center(1)-2,screenInfo.center(2)-40,screenInfo.center(1)+2,screenInfo.center(2)+40;screenInfo.center(1)-40,screenInfo.center(2)-2,screenInfo.center(1)+40,screenInfo.center(2)+2];

%Get Trial Number
trialNum=conf.sesInfo.trialNum;

%Create an empty Array
ResponseArray=nan(trialNum,18);

% ResponseArray(i,3) --     Fixation Onset 
% ResponseArray(i,5) --     Cue Onset
% ResponseArray(i,6) --     Trial onset time
% ResponseArray(i,9) --     RT
% ResponseArray(i,10)--     Keyboard Response(37=Left Key;39=Right Key)// Button Box Response(55=Left Button;48=Right Button) 
% ResponseArray(i,15)--     ITI duration
% ResponseArray(i,16)--     Left Cue
% ResponseArray(i,17)--     Right Cue
% ResponseArray(i,18)--     Reward


%Handling cues
[cuePath,cue]=GetCues(subj,screenInfo,conf);
cueLen=300;
cueX=[0.4*screenInfo.screenRect(3)+35 0.6*screenInfo.screenRect(3)-40]'-cueLen./2;
cueY=[0.5*screenInfo.screenRect(4) 0.5*screenInfo.screenRect(4)]'-cueLen./2;
cueConfirmFormat=[cueX,cueY,cueX+cueLen,cueY+cueLen]';

%Matrix function
ShuffleMatrix = ExpMatrix(screenInfo,subj,cue);

%Check if length of the experimental Matrix equal to trial number
if length(ShuffleMatrix)~= trialNum
    CloseExperiment;
    error('Number of trial not equal to Experimental Matrix');
end


% Configure ports (LPT1 in this case) to send codes to aquistion PC
% object = io64; %creates an io64 interface object and returns a 64-bit handle to its location
% status = io64( object ); %value should be 0

%                   %
% TASK Introduction %
%                   %

%Instruction
IntroTask(screenInfo,subj)
WaitSecs(.5);

%Show each payoff
Screen('DrawTextures',curWindow,cue(1),[],[575 100 775 300]);
Screen('DrawTextures',curWindow,cue(3),[],[575 450 775 650]);
Screen('DrawTextures',curWindow,cue(5),[],[575 800 775 1000]);
Screen('DrawTextures',curWindow,cue(2),[],[1150 100 1350 300]);
Screen('DrawTextures',curWindow,cue(4),[],[1150 450 1350 650]);
Screen('DrawTextures',curWindow,cue(6),[],[1150 800 1350 1000]);

TextDisp(screenInfo,'100% probability payoff',33,-350,0);
TextDisp(screenInfo,'80% probability payoff',33,0,0);
TextDisp(screenInfo,'20% probability payoff',33,350,0);

Screen('Flip', curWindow, 0);

%Wait until subject press 
DeTectSPACEBAR;

%Wait until subject is ready
WaitSecs(.5);
TextDisp(screenInfo,'Ready to start',45,0,1);
% TextDisp(screenInfo,'Please press the SPACE bar',33,+80,1);

%Wait until subject press 
DeTectSPACEBAR;

Screen('Flip',curWindow,0);
Screen('Flip',curWindow,GetSecs+2);

%Hide Cursor and set few parameters
HideCursor;
resKey=0;
respTime=0;
Score = 0;
PartOne = (floor(trialNum/4) + 1);
PartTwo = ((floor(trialNum/4)*2) + 1);
PartThree = ((floor(trialNum/4)*3) + 1);
experimentStart = GetSecs;

%Exp Loop
for i = 1:trialNum 

    if i == PartOne && i~=1 || i == PartTwo || i == PartThree 
        WaitSecs(1);
        TextDisp(screenInfo,'Please take a rest',45,0,0);
        Screen('Flip', curWindow,0);
        DeTectSPACEBAR;
        WaitSecs(.5);
        %Show each payoff
        Screen('DrawTextures',curWindow,cue(1),[],[575 100 775 300]);
        Screen('DrawTextures',curWindow,cue(3),[],[575 450 775 650]);
        Screen('DrawTextures',curWindow,cue(5),[],[575 800 775 1000]);
        Screen('DrawTextures',curWindow,cue(2),[],[1150 100 1350 300]);
        Screen('DrawTextures',curWindow,cue(4),[],[1150 450 1350 650]);
        Screen('DrawTextures',curWindow,cue(6),[],[1150 800 1350 1000]);

        TextDisp(screenInfo,'100% probability payoff',33,-350,0);
        TextDisp(screenInfo,'80% probability payoff',33,0,0);
        TextDisp(screenInfo,'20% probability payoff',33,350,0);
        Screen('Flip', curWindow, 0);
        % wait until subject press 
        DeTectSPACEBAR;
        
        Screen('Flip',curWindow,0);
        WaitSecs(3);
    end
    
    %setting
    ResponseArray(i,1)=i;
    Trial = ShuffleMatrix(i,:);
    Screen('FillRect', screenInfo.curWindow, [255 255 255], FixCross');
    TextDisp(screenInfo,num2str(Score),35, 200,0);
    resKey=0;        
    % Trial Cue Record
    ResponseArray(i,16)= Trial(1);
    ResponseArray(i,17)= Trial(2);
    
    %Detect all buttons are released.
           
    ResponseArray(i,6)=GetSecs; % trial On Time
    
    %Show fixation cross
    [ResponseArray(i,2), ResponseArray(i,3)]=Screen('Flip',curWindow,0);

    %Show Cue
    Screen('DrawTextures',curWindow,cue(Trial),[],cueConfirmFormat);
    TextDisp(screenInfo,num2str(Score),35, 200,0);
%     io64( object, 888, 0 ); %reset trigger
    [ResponseArray(i,4), ResponseArray(i,5)]=Screen('Flip',curWindow,ResponseArray(i,3)+conf.sesInfo.fixTime-screenInfo.slack,0);    
%     io64( object, 888, 1 ); %send trigger

    %Wait for the Response
    if resKey==0
        [respTime,resKey] = LogResp(ResponseArray(i,5)+conf.sesInfo.maxRT,2,conf.keyRes([1 3]),conf.keyEscape,nan,2);
    end
    tempTime = GetSecs;
    %Get Reaction Times
    ResponseArray(i,9)=respTime-ResponseArray(i,5);
    %Get The Key
    ResponseArray(i,10)=resKey;
    
    %Reward
    Rewarding = Reward(resKey,Trial);
    ResponseArray(i,18)= Rewarding;
    if Rewarding ==1 && ResponseArray(i,9)>0.1       % rewarding
        Score = Score + 10;
    end
    

    % no response / too fast / rewarded / no rewarded
    %If subject doesn't answer
    if isnan(respTime)
        TextDisp(screenInfo,'Too Slow',48,0,0);
        TargetWAITETIME = 1.5;
    %If subject is too fast    
    elseif ResponseArray(i,9)<0.1
        TextDisp(screenInfo,'Too Fast',48,0,0);
        TargetWAITETIME = 1.5;
    else
        TargetWAITETIME = 0.8;
        %Display rewarding
        if Rewarding ==1
            TextDisp(screenInfo,'10 points ',45,0,0);
            TextDisp(screenInfo,num2str(Score),35, 200,0); 
        else
            %nothing
            TargetWAITETIME = 0.8;
            TextDisp(screenInfo,num2str(Score),35, 200,0); 
        end
    end

    %Add 200ms after Response for a good Epoch
%     io64( object, 888, 0 ); %reset trigger
    [ResponseArray(i,11), ResponseArray(i,12)]=Screen('Flip',curWindow,tempTime+0.2-screenInfo.slack);
%     io64( object, 888, 2 ); %send trigger

    %Offset the Feedback
    TextDisp(screenInfo,num2str(Score),35, 200,0);     
    [ResponseArray(i,13), ResponseArray(i,14)]=Screen('Flip',curWindow,GetSecs+TargetWAITETIME-screenInfo.slack);
    
    %Get the ITI 
    ResponseArray(i,15)=conf.sesInfo.ITIrange(1) + (conf.sesInfo.ITIrange(2)-conf.sesInfo.ITIrange(1)).*rand;
    %Saving
    save([subjInfo.resultfolder subj '_EEG_Reward_' num2str(blocks) '.mat'],'subj','blocks','ResponseArray');
    
    %Wait ITI
    WaitSecs('UntilTime',ResponseArray(i,14)+ResponseArray(i,15)-screenInfo.slack);  
end

experimentDur = GetSecs-experimentStart;

CloseExperiment;