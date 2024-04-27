function funcPopNewMessage(indx,txt)
global CNST;
global pllt;
global obj;

dmmyTransition({obj(indx).Handle.Text obj(indx).Handle.Text},{'Position' 'Color'},{obj(indx).Handle.Text.Position pllt.MessageText},{obj(indx).Handle.Text.Position+[CNST.DistanceSmall 0 0] pllt.MessageBack},CNST.TransitionSlow,[true true]);

obj(indx).Handle.Text.String = txt;

dmmyTransition({obj(indx).Handle.Text obj(indx).Handle.Text},{'Position' 'Color'},{obj(indx).Handle.Text.Position pllt.MessageBack},{obj(indx).Handle.Text.Position-[CNST.DistanceSmall 0 0] pllt.MessageText},CNST.TransitionSlow,[true true]);
end