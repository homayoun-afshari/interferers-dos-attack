function cllbckClickDownInput(src,~)
global obj;

if ~obj(src.UserData.Index).Active || ~all([obj(obj(src.UserData.Index).Parent).Active])
    return;
end

obj(src.UserData.Index).Handle.Text.Editing = 'on';
obj(src.UserData.Index).Feature.ExtraHandleB.Line.Visible = 'on';
obj(src.UserData.Index).Active = false;
end