function funcPopOutMessage(indx)
global CNST;
global pllt;
global obj;

dmmyTransition({obj(indx).Handle.IconBack obj(indx).Handle.IconText obj(indx).Handle.Text obj(indx).Handle.Text},{'FaceColor' 'Color' 'Position' 'Color'},{pllt.MessageIconBack pllt.MessageIconText obj(indx).Handle.Text.Position pllt.MessageText},{pllt.MessageBack pllt.MessageBack obj(indx).Handle.Text.Position+[CNST.DistanceSmall 0 0] pllt.MessageBack},CNST.TransitionSlow,[true true]);
obj(indx).Handle.IconBack.Visible = 'off';
obj(indx).Handle.IconText.Visible = 'off';
obj(indx).Handle.Text.Visible = 'off';
obj(indx).Handle.Text.Position = obj(indx).Handle.Text.Position + [-CNST.DistanceSmall 0 0];
obj(indx).Handle.IconBack.FaceColor = pllt.MessageIconBack;
obj(indx).Handle.IconText.Color = pllt.MessageIconText;
obj(indx).Handle.Text.Color = pllt.MessageText;

dmmyTransition(obj(indx).Handle.Back,'FaceColor',[pllt.MessageBack 1],[pllt.MessageBack 0],CNST.TransitionNormal,[true true]);
obj(indx).Handle.Back.Visible = 'off';
obj(indx).Handle.Back.FaceColor = [pllt.MessageBack 1];
obj(indx).Visible = false;
obj(indx).Active = false;
end