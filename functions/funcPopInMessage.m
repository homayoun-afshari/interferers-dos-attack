function funcPopInMessage(indx,txt)
global CNST;
global pllt;
global obj;

obj(indx).Handle.Back.FaceColor = [pllt.MessageBack 0];
obj(indx).Handle.Back.Visible = 'on';
obj(indx).Visible = true;
obj(indx).Active = true;
dmmyTransition(obj(indx).Handle.Back,'FaceColor',[pllt.MessageBack 0],[pllt.MessageBack 1],CNST.TransitionNormal,[true true]);

obj(indx).Handle.Text.String = txt;

obj(indx).Handle.IconBack.FaceColor = pllt.MessageBack;
obj(indx).Handle.IconText.Color = pllt.MessageBack;
obj(indx).Handle.Text.Color = pllt.MessageBack;
obj(indx).Handle.IconBack.Visible = 'on';
obj(indx).Handle.IconText.Visible = 'on';
obj(indx).Handle.Text.Visible = 'on';
dmmyTransition({obj(indx).Handle.IconBack obj(indx).Handle.IconText obj(indx).Handle.Text obj(indx).Handle.Text},{'FaceColor' 'Color' 'Position' 'Color'},{pllt.MessageBack pllt.MessageBack obj(indx).Handle.Text.Position+[CNST.DistanceSmall 0 0] pllt.MessageBack},{pllt.MessageIconBack pllt.MessageIconText obj(indx).Handle.Text.Position pllt.MessageText},CNST.TransitionSlow,[true true]);
end