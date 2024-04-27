function funcCoverChild(indx,vsbl)
global obj;

for o = 1:numel(indx)
    hndl_name = fieldnames(obj(indx(o)).Handle);
    if isnan(vsbl(o))
        if obj(indx(o)).Visible
            for h = 1:numel(hndl_name)
                obj(indx(o)).Handle.(hndl_name{h}).Visible = 'off';
            end
            obj(indx(o)).Visible = false;
            obj(indx(o)).Active = false;
        else
            for h = 1:numel(hndl_name)
                obj(indx(o)).Handle.(hndl_name{h}).Visible = 'on';
            end
            obj(indx(o)).Visible = true;
            obj(indx(o)).Active = true;
        end
    else
        if vsbl(o)
            for h = 1:numel(hndl_name)
                obj(indx(o)).Handle.(hndl_name{h}).Visible = 'on';
            end
            obj(indx(o)).Visible = true;
            obj(indx(o)).Active = true;
        else
            for h = 1:numel(hndl_name)
                obj(indx(o)).Handle.(hndl_name{h}).Visible = 'off';
            end
            obj(indx(o)).Visible = false;
            obj(indx(o)).Active = false;
        end
    end
end
end