function obj_smlte()
global fgr;
global obj;

obj(dmmyGetIndex('me-01')).Feature.Power = obj(dmmyGetIndex('me-01')).Feature.Power*2;
fgr.CloseRequestFcn = @cllbckClose;
funcPopInMessage(dmmyGetIndex('hnt'),'Initialization is in order. Please Wait!');
funcCoverChild(dmmyGetIndex('smlte'),false);
indx = find(~strcmp({obj.Type},'grp'));
funcAct(indx,false(1,numel(indx)));
run('coreMainAlgorithm.m');
end

