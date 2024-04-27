function cllbckClickDownButton(src,~)
global CNST;
global pllt;
global fgr;
global obj;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end

fgr.WindowButtonMotionFcn = '';
fgr.WindowButtonUpFcn = @cllbckClickUpButton;
fgr.UserData.CurrentIndex = src.UserData.Index;
funcAct(src.UserData.Index,false);
dmmyTransition({obj(src.UserData.Index).Handle.Back},{'FaceColor'},{obj(src.UserData.Index).Handle.Back.FaceColor},{pllt.ButtonBackground_focused},CNST.TransitionFast,[true true]);
end