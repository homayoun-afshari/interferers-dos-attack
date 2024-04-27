function funcFloatParent(indx,drctn,ofst)
global CNST;
global pllt;
global obj;

if ~iscell(ofst)
    ofst = {ofst};
end

ttl = numel(indx);

for o = 1:ttl
    if isnan(drctn(o))
        drctn(o) = ~obj(indx(o)).Visible;
    end
    obj(indx(o)).Handle.Cover.Visible = 'on';
    obj(indx(o)).Visible = false;
    obj(indx(o)).Active = false;
    ofst{o} = ofst{o}./[CNST.FigureWidth CNST.FigureHeight];
end

hndl = cell(1,2*ttl);
prprty = cell(1,2*ttl);
sts1 = cell(1,2*ttl);
sts2 = cell(1,2*ttl);
for o = 1:ttl
    hndl{2*o-1} = obj(indx(o)).Handle.Axes;
    hndl{2*o} = obj(indx(o)).Handle.Cover;
    prprty{2*o-1} = 'Position';
    prprty{2*o} = 'FaceColor';
    sts1{2*o-1} = obj(indx(o)).Handle.Axes.Position + drctn(o)*[-ofst{o} 0 0];
    sts1{2*o} = [pllt.Background drctn(o)];
    sts2{2*o-1} = obj(indx(o)).Handle.Axes.Position + ~drctn(o)*[ofst{o} 0 0];
    sts2{2*o} = [pllt.Background ~drctn(o)];
end
dmmyTransition(hndl,prprty,sts1,sts2,CNST.TransitionSlow,[true true]);

for o = 1:ttl
    if ~drctn(o)
        obj(indx(o)).Handle.Axes.Position = obj(indx(o)).Handle.Axes.Position + [-ofst{o} 0 0];
        continue;
    end
    obj(indx(o)).Handle.Cover.Visible = 'off';
    obj(indx(o)).Visible = true;
    obj(indx(o)).Active = true;
end
end