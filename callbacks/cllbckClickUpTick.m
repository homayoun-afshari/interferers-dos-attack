function cllbckClickUpTick(~,~)
global CNST;
global pllt;
global fgr;
global obj;

fgr.WindowButtonMotionFcn = @cllbckHoverCheck;
fgr.WindowButtonUpFcn = '';
cllbckHoverCheck('','');
if ~dmmyCheckBeingInsideBox(fgr.UserData.CurrentIndex) 
    dmmyTransition({obj(fgr.UserData.CurrentIndex).Handle.Back},{'FaceColor'},{obj(fgr.UserData.CurrentIndex).Handle.Back.FaceColor},{pllt.TickBackground},CNST.TransitionFast,[true true]);
    cllbckHoverCheck('','');
    fgr.UserData.CurrentIndex = '';
    return;
end
dmmyTransition({obj(fgr.UserData.CurrentIndex).Handle.Back},{'FaceColor'},{obj(fgr.UserData.CurrentIndex).Handle.Back.FaceColor},{pllt.TickBackground},CNST.TransitionFast,[true true]);
if obj(fgr.UserData.CurrentIndex).Feature.Status
    obj(fgr.UserData.CurrentIndex).Handle.Front.Visible = 'off';
    obj(fgr.UserData.CurrentIndex).Feature.Status = false;
else
    obj(fgr.UserData.CurrentIndex).Handle.Front.Visible = 'on';
    obj(fgr.UserData.CurrentIndex).Feature.Status = true;
end
cllbckHoverCheck('','');
fgr.UserData.CurrentIndex = '';
end

