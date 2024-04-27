function funcAct(indx,actv)
global obj;

for o = 1:numel(indx)
    if isnan(actv(o))
        obj(indx(o)).Active = ~obj(indx(o)).Active;
    else
        obj(indx(o)).Active = actv(o);
    end
end
end