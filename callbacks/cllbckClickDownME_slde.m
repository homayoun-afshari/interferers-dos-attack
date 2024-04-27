function cllbckClickDownME_slde(src,~)
global CNST;
global pllt;
global fgr;
global obj;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end
switch fgr.SelectionType
    case 'normal'
        fgr.WindowButtonMotionFcn = @cllbckSetPower;
        fgr.WindowButtonUpFcn = @cllbckClickUpME;
        fgr.UserData.CurrentIndex = src.UserData.Index;
        if strcmp(obj(src.UserData.Index).Feature.Type, 'transmitter')
            indx_me = find(strcmp({obj.Type},'me'));
            OldPowerRatios = nan(1,numel(indx_me));
            for k = 1:numel(indx_me)
                if strcmp(obj(indx_me(k)).Feature.Type,'scatterer')
                    OldPowerRatios(k) = obj(indx_me(k)).Feature.Power/obj(src.UserData.Index).Feature.Power;
                end
            end
            OldPowerRatios(isnan(OldPowerRatios)) = '';
            fgr.UserData.OldPowerRatios = OldPowerRatios;
        end
        cllbckSetPower('','');
        funcCoverChildExtra('B',src.UserData.Index,true);
        funcActExtra('B',src.UserData.Index,false);
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
        dmmySetPower(src.UserData.Index,obj(src.UserData.Index).Feature.Power);
        funcCoverChildExtra('B',src.UserData.Index,true);
        funcActExtra('B',src.UserData.Index,false);
end
end