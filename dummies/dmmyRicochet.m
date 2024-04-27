function drctn = dmmyRicochet(indx,pstn,drctn)
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

alpha = nan;
if pstn(1) < lmt(1)
    alpha = pi/2;
end
if pstn(1) > lmt(3)
    alpha = pi/2;
end
if pstn(2) < lmt(2)
    alpha = 0;
end
if pstn(2) > lmt(4)
    alpha = 0;
end
dstnc = sqrt(sum((pstn-orgn).^2));
if dstnc < CNST.ReceiverOuterRadius+CNST.MeMarginRadius+CNST.DistanceLarge
    alpha = dmmyGetAngle(pstn-orgn,false) + pi/2;
end
if ~isnan(alpha)
    drctn = mod(2*alpha-drctn,2*pi);
end
end