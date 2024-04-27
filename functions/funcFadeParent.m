function funcFadeParent(indx,drctn)
global CNST;
global pllt;
global obj;

ttl = numel(indx);

for o = 1:ttl
    if isnan(drctn(o))
        drctn(o) = ~obj(indx(o)).Visible;
    end
    obj(indx(o)).Handle.Cover.Visible = 'on';
    obj(indx(o)).Visible = false;
    obj(indx(o)).Active = false;
end

hndl = cell(1,ttl);
prprty = cell(1,ttl);
sts1 = cell(1,ttl);
sts2 = cell(1,ttl);
for o = 1:ttl
    hndl{o} = obj(indx(o)).Handle.Cover;
    prprty{o} = 'FaceColor';
    sts1{o} = [pllt.Background drctn(o)];
    sts2{o} = [pllt.Background ~drctn(o)];
end
dmmyTransition(hndl,prprty,sts1,sts2,CNST.TransitionSlow,[true true]);

for o = 1:ttl
    if ~drctn(o)
        continue;
    end
    obj(indx(o)).Handle.Cover.Visible = 'off';
    obj(indx(o)).Visible = true;
    obj(indx(o)).Active = true;
end
end