function cllbckClickUpBoard(~,~)
global HNTS;
global CNST;
global fgr;
global obj;
global me_count;

fgr.WindowButtonMotionFcn = @cllbckHoverCheck;
fgr.WindowButtonUpFcn = '';
cllbckHoverCheck('','');
if ~obj(dmmyGetIndex('chck')).Feature.Status
    if me_count == 1
        funcMakeObject(nan,'smlte','btn','','Start the Simulation',...
                true,true,...
                [CNST.FigureWidth/2 0.5*(CNST.FigureHeight-CNST.FigureWidth)],...
                [CNST.ObjectWidthLarge CNST.ObjectHeightMedium]);
        funcPopOutMessage(dmmyGetIndex('hnt'));
        funcAct(dmmyGetIndex('smlte'),true);
    end
else
    switch me_count
        case 1
            funcPopNewMessage(dmmyGetIndex('hnt'),HNTS{2});
        case 2
            funcPopNewMessage(dmmyGetIndex('hnt'),HNTS{3});
        case 3
            funcPopNewMessage(dmmyGetIndex('hnt'),HNTS{4});
        case 4
            funcMakeObject(nan,'smlte','btn','','Start the Simulation',...
                true,true,...
                [CNST.FigureWidth/2 0.5*(CNST.FigureHeight-CNST.FigureWidth)],...
                [CNST.ObjectWidthLarge CNST.ObjectHeightMedium]);
            funcPopOutMessage(dmmyGetIndex('hnt'));
            funcAct(dmmyGetIndex('smlte'),true);
    end
end
fgr.UserData.CurrentIndex = '';
fgr.UserData.PointerOffset = '';
end

