function out = dmmyCheckBeingInsideCircle(indx)
global obj;

out = sum((obj(obj(indx).Parent(1)).Handle.Axes.CurrentPoint(1,1:2)-[obj(indx).Handle.Back.XData(1) obj(indx).Handle.Back.YData(1)]).^2) <= obj(indx).Handle.Back.UserData.Radius^2;
end