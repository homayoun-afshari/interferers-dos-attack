function pstn = dmmyKeepInside(indx,pstn)
global CNST;
global obj;
persistent lmt;
persistent orgn;
if isempty(lmt)
    lmt =  obj(obj(indx).Parent(2)).Handle.Back.Position + [0 0 obj(obj(indx).Parent(2)).Handle.Back.Position(1:2)] + [1 1 -1 -1]*(CNST.MeMarginRadius+CNST.DistanceLarge);
end
if isempty(orgn)
    indx = dmmyGetIndex('rcvr');
    orgn = [obj(indx).Handle.Back.XData(1) obj(indx).Handle.Back.YData(1)];
end

if pstn(1) < lmt(1)
    pstn(1) = lmt(1);
end
if pstn(1) > lmt(3)
    pstn(1) = lmt(3);
end
if pstn(2) < lmt(2)
    pstn(2) = lmt(2);
end
if pstn(2) > lmt(4)
    pstn(2) = lmt(4);
end
dstnc = sqrt(sum((pstn-orgn).^2));
if dstnc < CNST.ReceiverOuterRadius+CNST.MeMarginRadius+CNST.DistanceLarge
    pstn = (CNST.ReceiverOuterRadius+CNST.MeMarginRadius+CNST.DistanceLarge)*(pstn-orgn)/dstnc+orgn;
end
end