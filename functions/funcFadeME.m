function funcFadeME(indx,drctn)
global CNST;
global pllt;
global obj;

ttl = numel(indx);
hndl_name = fieldnames(obj(indx(1)).Handle);
ttl_h = numel(hndl_name);

for o = 1:ttl
    if isnan(drctn(o))
        drctn(o) = ~obj(indx(o)).Visible;
    end
    for h = 1:ttl_h
        obj(indx(o)).Handle.(hndl_name{h}).Visible = 'on';
    end
    obj(indx(o)).Visible = true;
    obj(indx(o)).Active = false;
end

hndl = cell(1,ttl*ttl_h);
prprty = cell(1,ttl*ttl_h);
sts1 = cell(1,ttl*ttl_h);
sts2 = cell(1,ttl*ttl_h);
for o = 1:ttl
    hndl{5*o-4} = obj(indx(o)).Handle.Margin;
    hndl{5*o-3} = obj(indx(o)).Handle.Arrow;
    hndl{5*o-2} = obj(indx(o)).Handle.Back;
    hndl{5*o-1} = obj(indx(o)).Handle.Slider;
    hndl{5*o} = obj(indx(o)).Handle.Front;
    prprty{5*o-4} = 'FaceColor';
    prprty{5*o-3} = 'FaceColor';
    prprty{5*o-2} = 'FaceColor';
    prprty{5*o-1} = 'FaceColor';
    prprty{5*o} = 'FaceColor';
    sts1{5*o-4} = drctn(o)*pllt.BoardBackground + ~drctn(o)*pllt.MeMargin;
    sts1{5*o-3} = drctn(o)*pllt.BoardBackground + ~drctn(o)*pllt.MeMargin;
    sts1{5*o-2} = drctn(o)*pllt.BoardBackground + ~drctn(o)*pllt.MeBack;
    sts1{5*o-1} = drctn(o)*pllt.BoardBackground + ~drctn(o)*pllt.MeSlider;
	sts1{5*o} = drctn(o)*pllt.BoardBackground + ~drctn(o)*eval(['pllt.MeFront_' obj(indx(o)).Feature.Type]);
    sts2{5*o-4} = ~drctn(o)*pllt.BoardBackground + drctn(o)*pllt.MeMargin;
    sts2{5*o-3} = ~drctn(o)*pllt.BoardBackground + drctn(o)*pllt.MeMargin;
    sts2{5*o-2} = ~drctn(o)*pllt.BoardBackground + drctn(o)*pllt.MeBack;
    sts2{5*o-1} = ~drctn(o)*pllt.BoardBackground + drctn(o)*pllt.MeSlider;
	sts2{5*o} = ~drctn(o)*pllt.BoardBackground + drctn(o)*eval(['pllt.MeFront_' obj(indx(o)).Feature.Type]);
end
dmmyTransition(hndl,prprty,sts1,sts2,CNST.TransitionNormal,[true true]);

for o = 1:ttl
    if drctn(o)
        for h = 1:ttl_h
            obj(indx(o)).Handle.(hndl_name{h}).Visible = 'on';
        end
        obj(indx(o)).Visible = true;
        obj(indx(o)).Active = true;
    else
        for h = 1:ttl_h
            obj(indx(o)).Handle.(hndl_name{h}).Visible = 'off';
        end
        obj(indx(o)).Visible = false;
        obj(indx(o)).Active = false;
    end
end
end