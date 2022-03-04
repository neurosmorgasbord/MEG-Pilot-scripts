function subjInfo= getSubjInp(subj,init)
% get subject detail/folders
% init=1  initialize subject folder
originalDir=pwd;
mfile = mfilename('fullpath');
mdir = [fileparts(mfile) '\'];

if nargin < 2
    init=0;
end

if nargin < 1
    subj=['newsubj' num2str(floor(rand*10000))];
end

d=mdir;
cd(d);
cd ..
base=[pwd '\'];
cd(mdir);
conf=Config;


if ~exist([base 'Subjects\' subj '.mat']) || init
    stimOrder = conf.cueFile;
    rng 'shuffle';
    ShufFile=[Shuffle(stimOrder(1:6)) 7];
    ShufFile2=[ShufFile(3) ShufFile(5) ShufFile(1) ShufFile(6) ShufFile(2) ShufFile(4) ShufFile(7)];

    prompt= {'Name:' 'Block'};
    defaultanswer = {subj,'1'};
    expParams = strvcat(getAnswer('Subject details',prompt,defaultanswer));
    if isempty(expParams)
        disp('Terminated by user.');
        return;
    end
    
    name=strtrim(expParams(strmatch('Name:',prompt),:));
    
  
   
    datafolder=[base 'data\' subj '\'];
    resultfolder=[datafolder 'result\'];
 
    
    if ~exist(datafolder,'dir')
        mkdir(datafolder);
        mkdir([datafolder 'result']);
    end
    
     
    save([base 'Subjects\' name '.mat'],'name','datafolder','resultfolder','ShufFile','ShufFile2');
else
    subjInfo=load([base 'Subjects\' subj '.mat']);
end

    subjInfo=load([base 'Subjects\' subj '.mat']);
    subjInfo.datafolder=[base 'data\' subj '\'];
    subjInfo.resultfolder=[subjInfo.datafolder 'result\'];
    
cd(originalDir);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ans = getAnswer(title,ques,guess)
n = inputdlg(ques,title,1,guess);
ans = n;