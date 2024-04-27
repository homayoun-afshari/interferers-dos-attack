function funcCoverChildExtra(cat,indx,vsbl)
global obj;

for o = 1:numel(indx)
    hndl_name = fieldnames(obj(indx(o)).Feature.(['ExtraHandle' cat(o)]));
    if isnan(vsbl(o))
        if obj(indx(o)).Feature.(['ExtraVisible' cat(o)])
            for h = 1:numel(hndl_name)
                obj(indx(o)).Feature.(['ExtraHandle' cat(o)]).(hndl_name{h}).Visible = 'off';
            end
            obj(indx(o)).Feature.(['ExtraVisible' cat(o)]) = false;
            obj(indx(o)).Feature.(['ExtraActive' cat(o)]) = false;
        else
            for h = 1:numel(hndl_name)
                obj(indx(o)).Feature.(['ExtraHandle' cat(o)]).(hndl_name{h}).Visible = 'on';
            end
            obj(indx(o)).Feature.(['ExtraVisible' cat(o)]) = true;
            obj(indx(o)).Feature.(['ExtraActive' cat(o)]) = true;
        end
    else
        if vsbl(o)
            for h = 1:numel(hndl_name)
                obj(indx(o)).Feature.(['ExtraHandle' cat(o)]).(hndl_name{h}).Visible = 'on';
            end
            obj(indx(o)).Feature.(['ExtraVisible' cat(o)]) = true;
            obj(indx(o)).Feature.(['ExtraActive' cat(o)]) = true;
        else
            for h = 1:numel(hndl_name)
                obj(indx(o)).Feature.(['ExtraHandle' cat(o)]).(hndl_name{h}).Visible = 'off';
            end
            obj(indx(o)).Feature.(['ExtraVisible' cat(o)]) = false;
            obj(indx(o)).Feature.(['ExtraActive' cat(o)]) = false;
        end
    end
end
end