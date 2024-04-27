function cllbckHoverCheck(~,~)
global fgr;
global obj;

for o = 1:numel(obj)
    if ~obj(o).Visible || isempty(obj(o).Pointer)
        continue;
    end
    if obj(obj(o).Parent(1)).Active && obj(o).Active && dmmyCheckBeingInsideBox(o)
        fgr.Pointer = obj(o).Pointer;
        return;
    end
end
fgr.Pointer = 'arrow';
end