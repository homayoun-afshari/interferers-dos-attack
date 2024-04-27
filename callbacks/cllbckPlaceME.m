function cllbckPlaceME(~,~)
global fgr;
global obj;

crnt_pstn = [obj(fgr.UserData.CurrentIndex).Handle.Back.XData(1) obj(fgr.UserData.CurrentIndex).Handle.Back.YData(1)];
next_pstn = dmmyKeepInside(fgr.UserData.CurrentIndex,obj(obj(fgr.UserData.CurrentIndex).Parent(1)).Handle.Axes.CurrentPoint(1,1:2)-fgr.UserData.PointerOffset);
hndl_name = fieldnames(obj(fgr.UserData.CurrentIndex).Handle);
for h = 1:numel(hndl_name)
    obj(fgr.UserData.CurrentIndex).Handle.(hndl_name{h}).XData = obj(fgr.UserData.CurrentIndex).Handle.(hndl_name{h}).XData - crnt_pstn(1) + next_pstn(1);
    obj(fgr.UserData.CurrentIndex).Handle.(hndl_name{h}).YData = obj(fgr.UserData.CurrentIndex).Handle.(hndl_name{h}).YData - crnt_pstn(2) + next_pstn(2);
end
end