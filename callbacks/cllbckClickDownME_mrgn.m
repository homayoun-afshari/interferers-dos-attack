function cllbckClickDownME_mrgn(src,~)
global CNST;
global pllt;
global fgr;
global obj;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end
switch fgr.SelectionType
    case 'normal'
        fgr.WindowButtonMotionFcn = @cllbckSetDirection;
        fgr.WindowButtonUpFcn = @cllbckClickUpME;
        fgr.UserData.CurrentIndex = src.UserData.Index;
        cllbckSetDirection('','');
%         funcCoverChildExtra('A',src.UserData.Index,true);
%         funcActExtra('A',src.UserData.Index,false);
    case 'extend'
        if strcmp(obj(src.UserData.Index).Feature.Type, 'transmitter')
            return;
        end
        fgr.WindowButtonUpFcn = @cllbckClickUpME_middle;
        fgr.UserData.CurrentIndex = src.UserData.Index;
        funcAct(src.UserData.Index,false);
        dmmyTransition({obj(src.UserData.Index).Handle.Margin obj(src.UserData.Index).Handle.Arrow obj(src.UserData.Index).Handle.Front},{'FaceColor' 'FaceColor' 'FaceColor'},{obj(src.UserData.Index).Handle.Margin.FaceColor obj(src.UserData.Index).Handle.Arrow.FaceColor obj(src.UserData.Index).Handle.Front.FaceColor},{pllt.MeMargin_focused pllt.MeMargin_focused pllt.MeFront_focused},CNST.TransitionFast,[true true]);
    case 'alt'
        fgr.WindowButtonUpFcn = @cllbckClickUpME;
        crntpstn = [obj(src.UserData.Index).Handle.Back.XData(1) obj(src.UserData.Index).Handle.Back.YData(1)];
        power = obj(src.UserData.Index).Feature.Power;
        crdntn = dmmyRotate([0 obj(src.UserData.Index).Feature.ExtraHandleB.StartHook.UserData.Radius;0 0],0);
        obj(src.UserData.Index).Feature.ExtraHandleB.StartHook.XData = crntpstn(1) + crdntn(1,:);
        obj(src.UserData.Index).Feature.ExtraHandleB.StartHook.YData = crntpstn(2) + crdntn(2,:);
        crdntn = dmmyRotate([0 obj(src.UserData.Index).Feature.ExtraHandleB.EndHook.UserData.Radius;0 0],power*2*pi);
        obj(src.UserData.Index).Feature.ExtraHandleB.EndHook.XData = crntpstn(1) + crdntn(1,:);
        obj(src.UserData.Index).Feature.ExtraHandleB.EndHook.YData = crntpstn(2) + crdntn(2,:);
        obj(src.UserData.Index).Feature.ExtraHandleB.Text.String = sprintf('%.2f',power);
        obj(src.UserData.Index).Feature.ExtraHandleB.Text.Position = [crntpstn 0];
        funcCoverChildExtra('B',src.UserData.Index,true);
        funcActExtra('B',src.UserData.Index,false);
end
end