function cllbckClickUpME(~,~)
global fgr;

fgr.WindowButtonMotionFcn = @cllbckHoverCheck;
fgr.WindowButtonUpFcn = '';
fgr.UserData.CurrentIndex = '';
fgr.UserData.PointerOffset = '';
fgr.UserData.OldPowerRatios = '';
end

