function [cuePath,cueTexture]=GetCues(subj,screenInfo,conf)

currPath=fileparts(mfilename('fullpath'));

subjInfo = getSubjInp(subj);

name=conf.cueFile;

for i=1:7
    cuePath{i}=[currPath '\Figures\'  num2str(name(i)) '.tif'];
end

if nargin > 1
    for i=1:7
        cue{i}=imread(cuePath{i},'TIFF');
        cueTexture(i)=Screen('MakeTexture',screenInfo.curWindow,cue{i});
    end
    
end