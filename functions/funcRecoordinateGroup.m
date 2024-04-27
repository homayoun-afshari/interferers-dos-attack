function funcRecoordinateGroup(indx,pstn,size)
global CNST;
global obj;

if ~iscell(indx)
    pstn = {pstn};
    size = {size};
end

for o = 1:numel(indx)
    dflt_pstn = obj(indx(o)).Handle.Axes.Position(1:2).*[CNST.FigureWidth CNST.FigureHeight];
    dflt_size = obj(indx(o)).Handle.Axes.Position(3:4).*[CNST.FigureWidth CNST.FigureHeight];
    pstn{o}(isnan(pstn{o})) = dflt_pstn(isnan(pstn{o}));
    size{o}(isnan(size{o})) = dflt_size(isnan(size{o}));
    obj(indx(o)).Handle.Axes.Position = [pstn{o}./[CNST.FigureWidth CNST.FigureHeight] size{o}./[CNST.FigureWidth CNST.FigureHeight]];
    xlim(obj(indx(o)).Handle.Axes,[0 size{o}(1)]);
    ylim(obj(indx(o)).Handle.Axes,[0 size{o}(2)]);
    obj(indx(o)).Handle.Cover.Position = [0 0 size{o}]+[-1 -1 2 2]*CNST.DistanceSmall;
end
end