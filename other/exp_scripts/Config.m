function conf=Config

conf.keyEscape = KbName('esc');
conf.keySpace = KbName('space');
conf.keyReturn = KbName('return');

conf.exp.cueSize=3; % in deg

conf.exp.fixSize=[0.25 0.04]; % length, width
conf.exp.fixColor=[150 150 150];

% conf.keyRes=[KbName('Left')  KbName('space') KbName('Right')]; % With KeyBord
conf.keyRes=[KbName('7&')  KbName('space') KbName('8*')]; % With Button Box

%     %conf at office
%     conf.exp.monWidth=37.5;   % monitor width in cm.
%     conf.exp.viewDist=60;   % viewing distant in cm.
    
    % conf at home
    conf.exp.monWidth=51;%18.5;%51;   % monitor width in cm.
    conf.exp.viewDist=60;   % viewing distant in cm.

%     conf at testing room
%     conf.exp.monWidth=32.5;   % monitor width in cm.
%     conf.exp.viewDist=48.5;   % viewing distant in cm.

% conf.exp.monWidth=26.8;   % monitor width in cm.
% conf.exp.viewDist=91.3;   % viewing distant in cm.
    
conf.sesInfo.fixTime=0.5;
conf.sesInfo.maxRT=2;
conf.sesInfo.ITIrange=[1.05 1.150];
conf.sesInfo.trialNum=160;

conf.exp.cueSize=2;

File=[1,2,3,4,5,6,7];

conf.cueFile=File;
conf.odds=[1,1,.8,.8,.2,.2,0];