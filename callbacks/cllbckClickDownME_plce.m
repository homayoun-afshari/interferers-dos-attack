function cllbckClickDownME_plce(src,~)
global CNST;
global pllt;
global fgr;
global obj;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end
switch fgr.SelectionType
    case 'normal'
        fgr.WindowButtonMotionFcn = @cllbckPlaceME;
        fgr.WindowButtonUpFcn = @cllbckClickUpME;
        fgr.UserData.CurrentIndex = src.UserData.Index;
        fgr.UserData.PointerOffset = obj(obj(src.UserData.Index).Parent(1)).Handle.Axes.CurrentPoint(1,1:2) - [obj(src.UserData.Index).Handle.Back.XData(1) obj(src.UserData.Index).Handle.Back.YData(1)];
    case 'extend'
        if strcmp(obj(src.UserData.Index).Feature.Type,'transmitter')
            return;
        end
        fgr.WindowButtonUpFcn = @cllbckClickUpME_middle;
        fgr.UserData.CurrentIndex = src.UserData.Index;
        funcAct(src.UserData.Index,false);
        dmmyTransition({obj(src.UserData.Index).Handle.Margin obj(src.UserData.Index).Handle.Arrow obj(src.UserData.Index).Handle.Front},{'FaceColor' 'FaceColor' 'FaceColor'},{obj(src.UserData.Index).Handle.Margin.FaceColor obj(src.UserData.Index).Handle.Arrow.FaceColor obj(src.UserData.Index).Handle.Front.FaceColor},{pllt.MeMargin_focused pllt.MeMargin_focused pllt.MeFront_focused},CNST.TransitionFast,[true true]);
    case 'alt'
        fgr.WindowButtonUpFcn = @cllbckClickUpME;
        crnt_pstn = [obj(src.UserData.Index).Handle.Back.XData(1) obj(src.UserData.Index).Handle.Back.YData(1)];
        crdntn = dmmyRotate([0 obj(src.UserData.Index).Feature.ExtraHandleB.StartHook.UserData.Radius;0 0],0);
        obj(src.UserData.Index).Feature.ExtraHandleB.StartHook.XData = crnt_pstn(1) + crdntn(1,:);
        obj(src.UserData.Index).Feature.ExtraHandleB.StartHook.YData = crnt_pstn(2) + crdntn(2,:);
        crdntn = dmmyRotate([0 obj(src.UserData.Index).Feature.ExtraHandleB.EndHook.UserData.Radius;0 0],obj(src.UserData.Index).Feature.Power*2*pi);
        obj(src.UserData.Index).Feature.ExtraHandleB.EndHook.XData = crnt_pstn(1) + crdntn(1,:);
        obj(src.UserData.Index).Feature.ExtraHandleB.EndHook.YData = crnt_pstn(2) + crdntn(2,:);
        obj(src.UserData.Index).Feature.ExtraHandleB.Text.String = sprintf('%.2f',obj(src.UserData.Index).Feature.Power);
        obj(src.UserData.Index).Feature.ExtraHandleB.Text.Position = [crnt_pstn 0];
        funcCoverChildExtra('B',src.UserData.Index,true);
        funcActExtra('B',src.UserData.Index,false);
end
end