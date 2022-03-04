% Waits a given duration while checking for key presses of button
% box responses, depending on location. The respkey is either a
% button box code or a keyboard code. If waitdur is inf, we wait
% for an infinite duration. ScanObj is only needed if location is 2.
% Returns the raw response time (GetSecs) only, or NaN if no resp.
% 26/8/2010 Updated to support multiple response options
% Use: [resptime,respcode] = logResp(waitdur,location,respkey,ScanObj)

function [resptime,respcode] = LogResp(waituntil,location,respkey,esckey,ScanObj,nowait)
keyisdown=0;
keyisdown_old=0;
% This is not the most economical solution, but it is the fastest.
switch location
    case {2,3} % pc
        while GetSecs < waituntil && ~(nowait && keyisdown_old)
            [keyisdown, secs, keyCode] = KbCheck;
            if keyisdown && keyisdown_old==0
                if sum(keyCode(respkey))
                    resptime=secs;
                    respcode=respkey(keyCode(respkey)==1);
                    respcode=respcode(1);
                    keyisdown_old=1;
                elseif keyCode(esckey)
                    Screen('CloseAll');
                    CloseExperiment;
                    error('ESC KEY DETECTED - experiment aborted!');
                end
            end
        end
    case 1 % scanner
        while (GetSecs < waituntil) && ~(nowait && keyisdown)
            keyCode=30-bitand(30,invoke(ScanObj,'GetResponse'));
            hit = find(keyCode==respkey, 1);
            if ~isempty(hit)
                resp = GetSecs;
                % Only log if first response
                if ~exist('resptime','var')
                    resptime = resp;
                    respcode = keyCode;
                end
            end
            % Check for esc key
            [keyisdown, secs, keyCode] = KbCheck;
            if keyisdown
                k = find(keyCode);
                k = k(1);
                if k == esckey
                    Screen('CloseAll');
                    closeExperiment;
                    error('ESC KEY DETECTED - experiment aborted!');
                end
            end
        end
end

% If no response, return nan
if ~exist('resptime','var')
    resptime = NaN;
    respcode = 0;
end
