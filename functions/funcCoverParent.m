function funcCoverParent(indx,vsbl)
global pllt;
global obj;

for o = 1:numel(indx)
    if isnan(vsbl(o))
        if obj(indx(o)).Visible
            obj(indx(o)).Handle.Cover.FaceColor = [pllt.Background 1];
            obj(indx(o)).Handle.Cover.Visible = 'on';
            obj(indx(o)).Visible = false;
            obj(indx(o)).Active = false;
        else
            obj(indx(o)).Handle.Cover.FaceColor = [pllt.Background 0];
            obj(indx(o)).Handle.Cover.Visible = 'off';
            obj(indx(o)).Visible = true;
            obj(indx(o)).Active = true;
        end
    else
        if vsbl(o)
            obj(indx(o)).Handle.Cover.FaceColor = [pllt.Background 0];
            obj(indx(o)).Handle.Cover.Visible = 'off';
            obj(indx(o)).Visible = true;
            obj(indx(o)).Active = true;
        else
            obj(indx(o)).Handle.Cover.FaceColor = [pllt.Background 1];
            obj(indx(o)).Handle.Cover.Visible = 'on';
            obj(indx(o)).Visible = false;
            obj(indx(o)).Active = false;
        end
    end
end
end