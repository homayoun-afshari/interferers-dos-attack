function dmmySetPower(indx,power)
global CNST;
global obj;
global crcl;

crnt_pstn = [obj(indx).Handle.Back.XData(1) obj(indx).Handle.Back.YData(1)];
obj(indx).Feature.Power = power;
obj(indx).Handle.Slider.XData = crnt_pstn(1) + crcl(1,:)*obj(indx).Handle.Slider.UserData.Radius;
obj(indx).Handle.Slider.YData = crnt_pstn(2) + crcl(2,:)*obj(indx).Handle.Slider.UserData.Radius;
obj(indx).Handle.Slider.XData(ceil(power*CNST.CircleResolution)+3:CNST.CircleResolution+2) = [];
crdntn = dmmyRotate([0 obj(indx).Feature.ExtraHandleB.StartHook.UserData.Radius;0 0],0);
obj(indx).Feature.ExtraHandleB.StartHook.XData = crnt_pstn(1) + crdntn(1,:);
obj(indx).Feature.ExtraHandleB.StartHook.YData = crnt_pstn(2) + crdntn(2,:);
crdntn = dmmyRotate([0 obj(indx).Feature.ExtraHandleB.EndHook.UserData.Radius;0 0],power*2*pi);
obj(indx).Feature.ExtraHandleB.EndHook.XData = crnt_pstn(1) + crdntn(1,:);
obj(indx).Feature.ExtraHandleB.EndHook.YData = crnt_pstn(2) + crdntn(2,:);
obj(indx).Feature.ExtraHandleB.Text.String = sprintf('%.2f',power);
obj(indx).Feature.ExtraHandleB.Text.Position = [crnt_pstn 0];
end