function cllbckClickDownME_hk(src,~)
global fgr;
global obj;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end

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
funcCoverChildExtra('B',src.UserData.Index,true);
funcActExtra('B',src.UserData.Index,false);
end