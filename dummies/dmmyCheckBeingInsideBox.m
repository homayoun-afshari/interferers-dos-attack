function out = dmmyCheckBeingInsideBox(indx)
global obj;

out = obj(indx).Handle.Back.Position(1)<=obj(obj(indx).Parent(1)).Handle.Axes.CurrentPoint(1,1) && obj(obj(indx).Parent(1)).Handle.Axes.CurrentPoint(1,1)<=obj(indx).Handle.Back.Position(1)+obj(indx).Handle.Back.Position(3) && obj(indx).Handle.Back.Position(2)<=obj(obj(indx).Parent(1)).Handle.Axes.CurrentPoint(1,2) && obj(obj(indx).Parent(1)).Handle.Axes.CurrentPoint(1,2)<=obj(indx).Handle.Back.Position(2)+obj(indx).Handle.Back.Position(4);
end