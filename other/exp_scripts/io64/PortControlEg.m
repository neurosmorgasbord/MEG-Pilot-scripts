lptwirte(888,val)% where 888 is LPT2 and Val is value - simple but you will need to get the mex

%% all this below can be done with io64
%e.g.
PortioObj = io32; %create the port object
status = io32(PortioObj); % gives you the values of the port
address = hex2dec('378');% give it the port address (378 is standard for parrale port LPT1), see system info.
% io32(PortioObj,address,TMSintValueTrig)%set the inensity
TMSintValueTrig=33;% give the port a value
TMSintdisp = dec2bin(TMSintValueTrig);% just for show to get pins actually sent to the TMS
resetTrigger = 2;% Because the 128 is not there there the 8th pin will go from I to O discharging the TMS. NB this state pulse should only last about a ms or less
TMStrigger = 0;
WaitSecs(1); % so it has time to rech the prescribed intentisity
io32(PortioObj,address,resetTrigger) % rests the port
WaitSecs(1);%
io32(PortioObj,address,TMStrigger)% Triggers the TMS

% or another version (probably the best onbe to use)
ParPortObj.ioObj = io64;
ParPortObj.status = io64(ParPortObj.ioObj);% port status
ParPortObj.address = hex2dec('378'); %NB this is the port address which we get from the system information another might be 'CCD8' or '279'
io64(ParPortObj.ioObj,ParPortObj.address,ValueStart);% Set start value (this is the one you have in your code where you want to send the trigger)

% get the io64 mex from
% http://apps.usd.edu/coglab/psyc770/IO64.html

tim1 = GetSecs;
io64( object, address ); %the parallel port address should be D050 (53328) or D040 (53312)
tim2 = GetSecs;