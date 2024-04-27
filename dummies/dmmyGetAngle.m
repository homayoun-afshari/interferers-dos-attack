function out = dmmyGetAngle(crdntn,dgree)
out = mod(atan(crdntn(:,2)./crdntn(:,1))+pi*(crdntn(:,1)<0),2*pi);
if dgree
    out = out*180/pi;
end
end