function cllbckClickDownBoard(src,~)
global CNST;
global pllt;
global fgr;
global obj;
global me_count;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end

me_count = me_count + 1;
name = sprintf('me-%02u',me_count);
funcMakeObject([nan nan],name,'me','','',...
    false,false,...
    obj(obj(src.UserData.Index).Parent(1)).Handle.Axes.CurrentPoint(1,1:2),...
    [nan nan]);
indx = dmmyGetIndex(name);
if me_count == 1
    obj(indx).Handle.Front.FaceColor = pllt.MeFront_transmitter;
    obj(indx).Feature.Type = 'transmitter';
    obj(indx).Feature.Velocity = (rand()+0.5)*eval(obj(dmmyGetIndex('avg_vlcty')).Handle.Text.String)*5*CNST.FigureWidth/18/eval(obj(dmmyGetIndex('cvrge')).Handle.Text.String);
    dmmySetPower(indx,unifrnd(0,1));
elseif strcmp(fgr.SelectionType, 'alt')
    obj(indx).Handle.Front.FaceColor = pllt.MeFront_scatterer;
    obj(indx).Feature.Type = 'scatterer';
    obj(indx).Feature.Velocity = (1-CNST.MeScattererStationary)*(rand()+0.5)*eval(obj(dmmyGetIndex('avg_vlcty')).Handle.Text.String)*5*CNST.FigureWidth/18/eval(obj(dmmyGetIndex('cvrge')).Handle.Text.String);
    dmmySetPower(indx,unifrnd(0,(1-CNST.MeScattererMinAttenuation)*obj(dmmyGetIndex('me-01')).Feature.Power));
else
    obj(indx).Feature.Type = 'interferer';
    obj(indx).Feature.Velocity = (rand()+0.5)*eval(obj(dmmyGetIndex('avg_vlcty')).Handle.Text.String)*5*CNST.FigureWidth/18/eval(obj(dmmyGetIndex('cvrge')).Handle.Text.String);
    dmmySetPower(indx,unifrnd(0,1));
end

fgr.WindowButtonMotionFcn = @cllbckPlaceME;
fgr.WindowButtonUpFcn = @cllbckClickUpBoard;
fgr.UserData.CurrentIndex = indx;
fgr.UserData.PointerOffset = [0 0];
cllbckPlaceME();
funcFadeME(indx,true);
end

