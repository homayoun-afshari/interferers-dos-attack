function cllbckClickUpME_middle(~,~)
global CNST;
global pllt;
global fgr;
global obj;

fgr.WindowButtonMotionFcn = @cllbckHoverCheck;
fgr.WindowButtonUpFcn = '';
cllbckHoverCheck('','');
if ~dmmyCheckBeingInsideCircle(fgr.UserData.CurrentIndex)
    dmmyTransition({obj(fgr.UserData.CurrentIndex).Handle.Margin obj(fgr.UserData.CurrentIndex).Handle.Arrow obj(fgr.UserData.CurrentIndex).Handle.Front},{'FaceColor' 'FaceColor' 'FaceColor'},{obj(fgr.UserData.CurrentIndex).Handle.Margin.FaceColor obj(fgr.UserData.CurrentIndex).Handle.Arrow.FaceColor obj(fgr.UserData.CurrentIndex).Handle.Front.FaceColor},{pllt.MeMargin pllt.MeMargin eval(['pllt.MeFront_' obj(fgr.UserData.CurrentIndex).Feature.Type])},CNST.TransitionFast,[true true]);
    funcAct(fgr.UserData.CurrentIndex,true);
    cllbckHoverCheck('','');
    fgr.UserData.CurrentIndex = '';
    fgr.UserData.PointerOffset = '';
    return;
end
funcFadeME(fgr.UserData.CurrentIndex,false);
cllbckHoverCheck('','');
fgr.UserData.CurrentIndex = '';
fgr.UserData.PointerOffset = '';
end

