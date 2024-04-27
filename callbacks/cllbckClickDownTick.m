function cllbckClickDownTick(src,~)
global CNST;
global pllt;
global fgr;
global obj;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end

fgr.WindowButtonMotionFcn = '';
fgr.WindowButtonUpFcn = @cllbckClickUpTick;
fgr.UserData.CurrentIndex = src.UserData.Index;
dmmyTransition({obj(src.UserData.Index).Handle.Back},{'FaceColor'},{obj(src.UserData.Index).Handle.Back.FaceColor},{pllt.TickBackground_focused},CNST.TransitionFast,[true true]);
end