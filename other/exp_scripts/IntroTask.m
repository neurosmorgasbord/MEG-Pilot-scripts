function IntroTask(screenInfo,subj)

%Introduction Screen

TextDisp(screenInfo,'Two or One Figures will be displayed on the Screen',35,-0.1,0,1);
TextDisp(screenInfo,'Each Figures has a fixed Reward probability',35,0,0,1);
TextDisp(screenInfo,'Use the Button Box to make a decision',35,0.2,0,1);


Screen('Flip',screenInfo.curWindow,0);

DeTectSPACEBAR;





