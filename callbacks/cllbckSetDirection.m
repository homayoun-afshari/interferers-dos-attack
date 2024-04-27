function cllbckSetDirection(~,~)
global fgr;
global obj;
global arrw;

crnt_pstn = [obj(fgr.UserData.CurrentIndex).Handle.Back.XData(1) obj(fgr.UserData.CurrentIndex).Handle.Back.YData(1)];
obj(fgr.UserData.CurrentIndex).Feature.Direction = dmmyGetAngle(obj(obj(fgr.UserData.CurrentIndex).Parent(1)).Handle.Axes.CurrentPoint(1,1:2)-[obj(fgr.UserData.CurrentIndex).Handle.Back.XData(1) obj(fgr.UserData.CurrentIndex).Handle.Back.YData(1)],false);
crdntn = dmmyRotate([obj(fgr.UserData.CurrentIndex).Handle.Arrow.UserData.Distance+arrw(1,:)*(obj(fgr.UserData.CurrentIndex).Handle.Arrow.UserData.Height);arrw(2,:)*obj(fgr.UserData.CurrentIndex).Handle.Arrow.UserData.Base],obj(fgr.UserData.CurrentIndex).Feature.Direction);
obj(fgr.UserData.CurrentIndex).Handle.Arrow.XData = crnt_pstn(1) + crdntn(1,:);
obj(fgr.UserData.CurrentIndex).Handle.Arrow.YData = crnt_pstn(2) + crdntn(2,:);
end