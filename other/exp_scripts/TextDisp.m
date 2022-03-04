function TextDisp(screenInfo,textString,fontsize,Yoffset,flip,ratio)

curWindow=screenInfo.curWindow;
Screen(screenInfo.curWindow,'TextSize',fontsize);
txtrect = Screen(curWindow,'TextBounds',textString);
txtwidth = txtrect(3)-txtrect(1);

if ~exist('ratio')
    ratio=0;
end

if ratio==0
Screen(curWindow,'DrawText',textString,(screenInfo.screenRect(3)-txtwidth)/2,screenInfo.screenRect(4)/2+Yoffset);
else
    Screen(curWindow,'DrawText',textString,(screenInfo.screenRect(3)-txtwidth)/2,screenInfo.screenRect(4)/2+Yoffset*screenInfo.screenRect(4));
end


if flip
    Screen(curWindow,'flip',0);
end
