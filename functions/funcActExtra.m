function funcActExtra(cat,indx,actv)
global obj;

for o = 1:numel(indx)
    if isnan(actv(o))
        obj(indx(o)).Feature.(['ExtraActive' cat(o)]) = ~obj(indx(o)).Feature.(['ExtraActive' cat(o)]);
    else
        obj(indx(o)).Feature.(['ExtraActive' cat(o)]) = actv(o);
    end
end
end