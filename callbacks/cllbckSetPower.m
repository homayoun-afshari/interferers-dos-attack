function cllbckSetPower(~,~)
global CNST;
global fgr;
global obj;

power = dmmyGetAngle(obj(obj(fgr.UserData.CurrentIndex).Parent(1)).Handle.Axes.CurrentPoint(1,1:2)-[obj(fgr.UserData.CurrentIndex).Handle.Back.XData(1) obj(fgr.UserData.CurrentIndex).Handle.Back.YData(1)],false)/2/pi;
if strcmp(obj(fgr.UserData.CurrentIndex).Feature.Type,'scatterer') && (power>(1-CNST.MeScattererMinAttenuation)*obj(dmmyGetIndex('me-01')).Feature.Power)
    power = (1-CNST.MeScattererMinAttenuation)*obj(dmmyGetIndex('me-01')).Feature.Power;
end
dmmySetPower(fgr.UserData.CurrentIndex,power);
if strcmp(obj(fgr.UserData.CurrentIndex).Feature.Type,'transmitter')
    indx_me = find(strcmp({obj.Type},'me'));
    indx_scatterer = nan(1,numel(indx_me));
    for k = 1:numel(indx_me)
        if strcmp(obj(indx_me(k)).Feature.Type,'scatterer')
            indx_scatterer(k) = indx_me(k);
        end
    end
    indx_scatterer(isnan(indx_scatterer)) = [];
    for k = 1:numel(indx_scatterer)
        dmmySetPower(indx_scatterer(k),power*fgr.UserData.OldPowerRatios(k));
    end
end
end