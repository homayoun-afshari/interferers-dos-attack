function cllbckClickUpButton(~,~)
global CNST;
global pllt;
global fgr;
global obj;

fgr.WindowButtonMotionFcn = @cllbckHoverCheck;
fgr.WindowButtonUpFcn = '';
cllbckHoverCheck('','');
if ~dmmyCheckBeingInsideBox(fgr.UserData.CurrentIndex) 
    dmmyTransition({obj(fgr.UserData.CurrentIndex).Handle.Back},{'FaceColor'},{obj(fgr.UserData.CurrentIndex).Handle.Back.FaceColor},{pllt.ButtonBackground},CNST.TransitionFast,[true true]);
    funcAct(fgr.UserData.CurrentIndex,true);
    cllbckHoverCheck('','');
    fgr.UserData.CurrentIndex = '';
    return;
end
dmmyTransition({obj(fgr.UserData.CurrentIndex).Handle.Back},{'FaceColor'},{obj(fgr.UserData.CurrentIndex).Handle.Back.FaceColor},{pllt.ButtonBackground},CNST.TransitionFast,[true true]);
cllbckHoverCheck('','');
temp = fgr.UserData.CurrentIndex;
fgr.UserData.CurrentIndex = '';
feval(obj(temp).Feature.Function);
end

