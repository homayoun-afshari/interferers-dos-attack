function cllbckClickDownWindow(~,~)
global obj;

indx_inpt = find(strcmp({obj.Type},'inpt'));
for o = 1:numel(indx_inpt)
    if ~obj(obj(indx_inpt(o)).Parent(1)).Active || ~obj(indx_inpt(o)).Visible
        continue;
    end
    funcAct(indx_inpt(o),true);
    obj(indx_inpt(o)).Handle.Text.Editing = 'off';
    obj(indx_inpt(o)).Feature.ExtraHandleB.Line.Visible = 'off';
end
indx_me = find(strcmp({obj.Type},'me'));
for o = 1:numel(indx_me)
    if ~all([obj(obj(indx_me(o)).Parent).Active]) || ~obj(indx_me(o)).Visible
        continue;
    end
    funcCoverChildExtra('B',indx_me(o),false);
end
end