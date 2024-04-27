function funcMakeObject(prnt,name,type,dscrptn,txt,vsbl,actv,pstn,size)
global CNST;
global pllt;
global fgr;
global obj;
global crcl;
global arrw;
persistent px2pt;
if isempty(px2pt)
    px2pt = 72/get(0,'ScreenPixelsPerInch');
end

indx = numel(obj) + 1;
switch type
    case 'grp' %anchor point: bottom-left
        dflt_prnt = 0;
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = [];
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Axes','','Cover','');
        obj(indx).Feature = [];
        dflt_pstn = [0 0];
        dflt_size = [CNST.FigureWidth CNST.FigureHeight];
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        size(isnan(size)) = dflt_size(isnan(size));
        obj(indx).Handle.Axes = axes(fgr,'Units','normal','Position',[pstn./[CNST.FigureWidth CNST.FigureHeight] size./[CNST.FigureWidth CNST.FigureHeight]],...
            'Clipping','off');
        hold(obj(indx).Handle.Axes,'on');
        axis(obj(indx).Handle.Axes,'off');
        xlim(obj(indx).Handle.Axes,[0 size(1)]);
        ylim(obj(indx).Handle.Axes,[0 size(2)]);
        obj(indx).Handle.Cover = rectangle(obj(indx).Handle.Axes,'Position',[0 0 size]+[-1 -1 2 2]*CNST.DistanceSmall,...
            'FaceColor',[pllt.Background ~vsbl],'EdgeColor','none',...
            'Visible','off');
        uistack(obj(indx).Handle.Cover,'top');
        if ~vsbl
            obj(indx).Handle.Cover.Visible = 'on';
        end
    case 'tick' %anchor point: middle-center
        dflt_prnt = dmmyGetIndex('cntrl');
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = 'hand';
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Description','','Back','','Front','');
        obj(indx).Feature = struct('Status',true);
        dflt_pstn = [CNST.FigureWidth/2 CNST.FigureHeight/2];
        dflt_size = [CNST.ObjectHeightTiny CNST.ObjectHeightTiny];
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        size(isnan(size)) = dflt_size(isnan(size));
        obj(indx).Handle.Description = text(obj(obj(indx).Parent(1)).Handle.Axes,pstn(1)+size(1)/2+CNST.DistanceSmall/2,pstn(2),dscrptn,...
            'HorizontalAlignment','center','VerticalAlignment','middle',...
            'FontName',CNST.FontName,'FontSize',CNST.FontSizeSmall,'FontWeight',CNST.FontWeightNormal,...
            'Color',pllt.TickDescription,...
            'ButtonDownFcn',@cllbckClickDownTick,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        obj(indx).Handle.Back = rectangle(obj(obj(indx).Parent(1)).Handle.Axes,'Position',[obj(indx).Handle.Description.Position(1)-obj(indx).Handle.Description.Extent(3)/2-size(1)-CNST.DistanceSmall pstn(2)-size(2)/2 size],...
            'FaceColor',pllt.TickBackground,'EdgeColor',pllt.TickEdge,'LineWidth',CNST.LineWidthTiny*px2pt,...
            'ButtonDownFcn',@cllbckClickDownTick,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        obj(indx).Handle.Back.Curvature = 2*CNST.CurvatureSmall/min(obj(indx).Handle.Back.Position(3:4));
        obj(indx).Handle.Front = rectangle(obj(obj(indx).Parent(1)).Handle.Axes,'Position',obj(indx).Handle.Back.Position+[1 1 -2 -2]*CNST.DistanceSmall,...
            'FaceColor',pllt.TickFront,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownTick,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        obj(indx).Handle.Front.Curvature = 2*CNST.CurvatureSmall/min(obj(indx).Handle.Front.Position(3:4));
        hndl_name = flip(fieldnames(obj(indx).Handle));
        for h = 1:numel(hndl_name)
            uistack(obj(indx).Handle.(hndl_name{h}),'bottom');
        end
        if vsbl
            for h = 1:numel(hndl_name)
                obj(indx).Handle.(hndl_name{h}).Visible = 'on';
            end
        end
    case 'btn' %anchor point: middle-center
        dflt_prnt = dmmyGetIndex('cntrl');
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = 'hand';
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Back','','Text','');
        obj(indx).Feature = struct('Function',['obj_' obj(indx).Name]);
        dflt_pstn = [CNST.FigureWidth/2 CNST.FigureHeight/2];
        dflt_size = [CNST.ObjectWidthLarge CNST.ObjectHeightMedium];
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        size(isnan(size)) = dflt_size(isnan(size));
        obj(indx).Handle.Back = rectangle(obj(obj(indx).Parent(1)).Handle.Axes,'Position',[pstn(1)-size(1)/2 pstn(2)-size(2)/2 size],...
            'FaceColor',pllt.ButtonBackground,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownButton,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        obj(indx).Handle.Back.Curvature = 2*CNST.CurvatureMedium/min(obj(indx).Handle.Back.Position(3:4));
        obj(indx).Handle.Text = text(obj(obj(indx).Parent(1)).Handle.Axes,pstn(1),pstn(2),txt,...
            'HorizontalAlignment','center','VerticalAlignment','middle',...
            'FontName',CNST.FontName,'FontSize',CNST.FontSizeMedium,'FontWeight',CNST.FontWeightBold,...
            'Color',pllt.ButtonText,...
            'ButtonDownFcn',@cllbckClickDownButton,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        hndl_name = flip(fieldnames(obj(indx).Handle));
        for h = 1:numel(hndl_name)
            uistack(obj(indx).Handle.(hndl_name{h}),'bottom');
        end
        if vsbl
            for h = 1:numel(hndl_name)
                obj(indx).Handle.(hndl_name{h}).Visible = 'on';
            end
        end
    case 'msg' %anchor point: bottom-left
        dflt_prnt = dmmyGetIndex('cntrl');
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = [];
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Back','','IconBack','','IconText','','Text','');
        obj(indx).Feature = [];
        dflt_pstn = [1 1]*CNST.DistanceSmall;
        dflt_size = [obj(obj(indx).Parent(1)).Handle.Axes.XLim(2) obj(obj(indx).Parent(1)).Handle.Axes.YLim(2)]+[-2 -2]*CNST.DistanceSmall;
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        size(isnan(size)) = dflt_size(isnan(size));
        obj(indx).Handle.Back = rectangle(obj(obj(indx).Parent(1)).Handle.Axes,'Position',[pstn size],...
            'FaceColor',pllt.MessageBack,'EdgeColor','none',...
            'Visible','off');
        temp = CNST.ObjectHeightLarge;
        if temp > obj(indx).Handle.Back.Position(4)-2*CNST.DistanceSmall
            temp = obj(indx).Handle.Back.Position(4)-2*CNST.DistanceSmall;
        end
        obj(indx).Handle.IconBack = rectangle(obj(obj(indx).Parent(1)).Handle.Axes,'Position',[obj(indx).Handle.Back.Position(1)+CNST.DistanceSmall obj(indx).Handle.Back.Position(2)+obj(indx).Handle.Back.Position(4)/2-temp/2 CNST.ObjectHeightLarge temp],...
            'FaceColor',pllt.MessageIconBack,'EdgeColor','none',...
            'Visible','off');
        obj(indx).Handle.IconBack.Curvature = 2*CNST.CurvatureMedium/min(obj(indx).Handle.IconBack.Position(3:4));
        obj(indx).Handle.IconText = text(obj(obj(indx).Parent(1)).Handle.Axes,obj(indx).Handle.IconBack.Position(1)+CNST.ObjectHeightLarge/2,obj(indx).Handle.IconBack.Position(2)+temp/2,dscrptn,...
            'HorizontalAlignment','center','VerticalAlignment','middle',...
            'FontName',CNST.FontName,'FontSize',CNST.FontSizeLarge,'FontWeight',CNST.FontWeightBold,...
            'Color',pllt.MessageIconText,...
            'Visible','off');
        obj(indx).Handle.Text = text(obj(obj(indx).Parent(1)).Handle.Axes,obj(indx).Handle.IconBack.Position(1)+obj(indx).Handle.IconBack.Position(3)+CNST.DistanceSmall,obj(indx).Handle.Back.Position(2)+obj(indx).Handle.Back.Position(4)/2,txt,...
            'HorizontalAlignment','left','VerticalAlignment','middle',...
            'FontName',CNST.FontName,'FontSize',CNST.FontSizeSmall,'FontWeight',CNST.FontWeightNormal,...
            'Color',pllt.MessageText,...
            'Visible','off');
        hndl_name = fieldnames(obj(indx).Handle);
        for h = 1:numel(hndl_name)
            uistack(obj(indx).Handle.(hndl_name{h}),'top');
        end
        uistack(obj(obj(indx).Parent(1)).Handle.Cover,'top');
        if vsbl
            for h = 1:numel(hndl_name)
                obj(indx).Handle.(hndl_name{h}).Visible = 'on';
            end
        end
    case 'inpt' %anchor point: middle-center
        dflt_prnt = dmmyGetIndex('intrctn');
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = 'ibeam';
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Description','','Back','','Text','');
        obj(indx).Feature = struct('ExtraHandleB',struct('Line',''));
        dflt_pstn = [CNST.FigureWidth/2 CNST.FigureHeight/2];
        dflt_size = [CNST.ObjectWidthLarge CNST.ObjectHeightSmall];
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        size(isnan(size)) = dflt_size(isnan(size));
        obj(indx).Handle.Description = text(obj(obj(indx).Parent(1)).Handle.Axes,pstn(1)-size(1)/2-CNST.DistanceSmall,pstn(2),[dscrptn ':'],...
            'HorizontalAlignment','right','VerticalAlignment','middle',...
            'FontName',CNST.FontName,'FontSize',CNST.FontSizeSmall,'FontWeight',CNST.FontWeightNormal,...
            'Color',pllt.InputDescription,...
            'Visible','off');
        obj(indx).Handle.Back = rectangle(obj(obj(indx).Parent(1)).Handle.Axes,'Position',[pstn(1)-size(1)/2 pstn(2)-size(2)/2 size],...
            'FaceColor',pllt.InputBackground,'EdgeColor',pllt.InputEdge,'LineWidth',CNST.LineWidthTiny*px2pt,...
            'ButtonDownFcn',@cllbckClickDownInput,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        obj(indx).Handle.Back.Curvature = 2*CNST.CurvatureSmall/min(obj(indx).Handle.Back.Position(3:4));
        obj(indx).Handle.Text = text(obj(obj(indx).Parent(1)).Handle.Axes,pstn(1)-size(1)/2+CNST.DistanceSmall,pstn(2),txt,...
            'Background',pllt.InputBackground,...
            'HorizontalAlignment','left','VerticalAlignment','middle',...
            'FontName',CNST.FontName,'FontSize',CNST.FontSizeTiny,'FontWeight',CNST.FontWeightNormal,...
            'Color',pllt.InputText,...
            'ButtonDownFcn',@cllbckClickDownInput,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        obj(indx).Feature.ExtraHandleB.Line = plot(obj(obj(indx).Parent(1)).Handle.Axes,pstn(1)+[-1 1]*(size(1)/2-CNST.DistanceSmall),pstn(2)-size(2)/2+[1 1]*CNST.DistanceSmall,...
            'Color',pllt.InputLine,'LineWidth',CNST.LineWidthMedium*px2pt,...
            'Marker','o','MarkerFaceColor',pllt.InputLine,'MarkerEdgeColor','none','MarkerSize',CNST.LineWidthMedium*px2pt,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        hndl_name = flip(fieldnames(obj(indx).Handle));
        for h = 1:numel(hndl_name)
            uistack(obj(indx).Handle.(hndl_name{h}),'bottom');
        end
        if vsbl
            for h = 1:numel(hndl_name)
                obj(indx).Handle.(hndl_name{h}).Visible = 'on';
            end
        end
    case 'brd' %anchor point: bottom-left
        dflt_prnt = dmmyGetIndex('intrctn');
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = 'crosshair';
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Back','');
        obj(indx).Feature = [];
        dflt_pstn = [1 1]*CNST.DistanceSmall;
        dflt_size = [obj(obj(indx).Parent(1)).Handle.Axes.XLim(2) obj(obj(indx).Parent(1)).Handle.Axes.YLim(2)] + [-2 -2]*CNST.DistanceSmall;
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        size(isnan(size)) = dflt_size(isnan(size));
        obj(indx).Handle.Back = rectangle(obj(obj(indx).Parent(1)).Handle.Axes,'Position',[pstn size],...
            'FaceColor',pllt.BoardBackground,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownBoard,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        hndl_name = flip(fieldnames(obj(indx).Handle));
        for h = 1:numel(hndl_name)
            uistack(obj(indx).Handle.(hndl_name{h}),'bottom');
        end
        if vsbl
            for h = 1:numel(hndl_name)
                obj(indx).Handle.(hndl_name{h}).Visible = 'on';
            end
        end
    case 'rcvr' %anchor point: middle-right
        dflt_prnt = [dmmyGetIndex('intrctn') dmmyGetIndex('wrld')];
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = [];
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Margin','','Back','','Front','');
        obj(indx).Feature = struct('ExtraHandleB',struct('EstimationCurve','','BeamformingCurve',''));
        dflt_pstn = obj(obj(indx).Parent(2)).Handle.Back.Position(1:2) + [1 0]*obj(obj(indx).Parent(2)).Handle.Back.Position(3) + [0 0.5]*obj(obj(indx).Parent(2)).Handle.Back.Position(4);
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        obj(indx).Handle.Margin = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.ReceiverMargin,'EdgeColor','none',...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.ReceiverMarginRadius));
        obj(indx).Handle.Margin.XData = pstn(1) + [0 crcl(1,ceil(CNST.CircleResolution/4)+2:floor(3*CNST.CircleResolution/4)+2)*obj(indx).Handle.Margin.UserData.Radius];
        obj(indx).Handle.Margin.YData = pstn(2) + [0 crcl(2,ceil(CNST.CircleResolution/4)+2:floor(3*CNST.CircleResolution/4)+2)*obj(indx).Handle.Margin.UserData.Radius];
        obj(indx).Handle.Back = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.ReceiverBack,'EdgeColor','none',...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.ReceiverOuterRadius));
        obj(indx).Handle.Back.XData = pstn(1) + [0 crcl(1,ceil(CNST.CircleResolution/4)+2:floor(3*CNST.CircleResolution/4)+2)*obj(indx).Handle.Back.UserData.Radius];
        obj(indx).Handle.Back.YData = pstn(2) + [0 crcl(2,ceil(CNST.CircleResolution/4)+2:floor(3*CNST.CircleResolution/4)+2)*obj(indx).Handle.Back.UserData.Radius];
        obj(indx).Feature.ExtraHandleB.EstimationCurve = plot(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            'color',pllt.ReceiverEstimationCurve,'LineWidth',CNST.LineWidthTiny*px2pt,...
            'Visible','off',...
            'UserData',struct('Index',indx,'MinimumHeight',CNST.ReceiverInnerRadius,'MaximumHeight',CNST.ReceiverOuterRadius-CNST.DistanceSmall));
        obj(indx).Feature.ExtraHandleB.BeamformingCurve = plot(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            'color',pllt.ReceiverBeamformingCurve,'LineWidth',CNST.LineWidthTiny*px2pt,...
            'Visible','off',...
            'UserData',struct('Index',indx,'MinimumHeight',CNST.ReceiverInnerRadius,'MaximumHeight',CNST.ReceiverOuterRadius-CNST.DistanceSmall));
        obj(indx).Handle.Front = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.ReceiverFront,'EdgeColor','none',...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.ReceiverInnerRadius));
        obj(indx).Handle.Front.XData = pstn(1) + [0 crcl(1,ceil(CNST.CircleResolution/4)+2:floor(3*CNST.CircleResolution/4)+2)*obj(indx).Handle.Front.UserData.Radius];
        obj(indx).Handle.Front.YData = pstn(2) + [0 crcl(2,ceil(CNST.CircleResolution/4)+2:floor(3*CNST.CircleResolution/4)+2)*obj(indx).Handle.Front.UserData.Radius];
        uistack(obj(obj(indx).Parent(1)).Handle.Cover,'top');
        if vsbl
            hndl_name = fieldnames(obj(indx).Handle);
            for h = 1:numel(hndl_name)
                obj(indx).Handle.(hndl_name{h}).Visible = 'on';
            end
        end
    case 'me' %anchor point: middle-center
        dflt_prnt = [dmmyGetIndex('intrctn') dmmyGetIndex('wrld')];
        prnt(isnan(prnt)) = dflt_prnt(isnan(prnt));
        obj(indx).Parent = prnt;
        obj(indx).Name = name;
        obj(indx).Type = type;
        obj(indx).Pointer = [];
        obj(indx).Visible = vsbl;
        obj(indx).Active = actv;
        obj(indx).Handle = struct('Margin','','Arrow','','Back','','Slider','','Front','');
        obj(indx).Feature = struct('Type','','Power',0,'Direction',rand()*2*pi,'Velocity','','ExtraHandleA',struct('Line',''),'ExtraHandleB',struct('StartHook','','EndHook','','Text',''),'ExtraVisibleA','','ExtraVisibleB','','ExtraActiveA','','ExtraActiveB','');
		dflt_pstn = obj(obj(indx).Parent(2)).Handle.Back.Position(1:2) + [0.5 0]*obj(obj(indx).Parent(2)).Handle.Back.Position(3) + [0 0.5]*obj(obj(indx).Parent(2)).Handle.Back.Position(4);
        pstn(isnan(pstn)) = dflt_pstn(isnan(pstn));
        obj(indx).Handle.Margin = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.MeMargin,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownME_mrgn,...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.MeMarginRadius));
        obj(indx).Handle.Margin.XData = pstn(1) + crcl(1,:)*obj(indx).Handle.Margin.UserData.Radius;
        obj(indx).Handle.Margin.YData = pstn(2) + crcl(2,:)*obj(indx).Handle.Margin.UserData.Radius;
        obj(indx).Handle.Arrow = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.MeMargin,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownME_mrgn,...
            'Visible','off',...
            'UserData',struct('Index',indx,'Distance',CNST.MeMarginRadius^2/(CNST.MeMarginRadius+CNST.MeArrowHeight),'Base',2*CNST.MeMarginRadius*sqrt(1-CNST.MeMarginRadius^2/(CNST.MeMarginRadius+CNST.MeArrowHeight)^2),'Height',CNST.MeMarginRadius+CNST.MeArrowHeight-CNST.MeMarginRadius^2/(CNST.MeMarginRadius+CNST.MeArrowHeight)));
        crdntn = dmmyRotate([obj(indx).Handle.Arrow.UserData.Distance+arrw(1,:)*(obj(indx).Handle.Arrow.UserData.Height);arrw(2,:)*obj(indx).Handle.Arrow.UserData.Base],obj(indx).Feature.Direction);
        obj(indx).Handle.Arrow.XData = pstn(1) + crdntn(1,:);
        obj(indx).Handle.Arrow.YData = pstn(2) + crdntn(2,:);
        obj(indx).Handle.Back = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.MeBack,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownME_slde,...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.MeOuterRadius));
        obj(indx).Handle.Back.XData = pstn(1) + crcl(1,:)*obj(indx).Handle.Back.UserData.Radius;
        obj(indx).Handle.Back.YData = pstn(2) + crcl(2,:)*obj(indx).Handle.Back.UserData.Radius;
        obj(indx).Handle.Slider = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.MeSlider,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownME_slde,...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.MeOuterRadius));
        obj(indx).Handle.Slider.XData = pstn(1) + crcl(1,:)*obj(indx).Handle.Slider.UserData.Radius;
        obj(indx).Handle.Slider.YData = pstn(2) + crcl(2,:)*obj(indx).Handle.Slider.UserData.Radius;
        obj(indx).Handle.Slider.XData(ceil(obj(indx).Feature.Power*CNST.CircleResolution)+3:CNST.CircleResolution+2) = [];
        obj(indx).Feature.ExtraHandleB.StartHook = plot(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            'Color',pllt.MeStartHookLine,'LineWidth',CNST.LineWidthSmall*px2pt,...
            'Marker','o','MarkerFaceColor',pllt.MeStartHookFace,'MarkerEdgeColor',pllt.MeStartHookLine,'MarkerSize',2*CNST.MeHookRadius*px2pt,...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.MeMarginRadius+CNST.MeArrowHeight+CNST.DistanceSmall+CNST.MeHookRadius));
        crdntn = dmmyRotate([0 obj(indx).Feature.ExtraHandleB.StartHook.UserData.Radius;0 0],0);
        obj(indx).Feature.ExtraHandleB.StartHook.XData = pstn(1) + crdntn(1,:);
        obj(indx).Feature.ExtraHandleB.StartHook.YData = pstn(2) + crdntn(2,:);
        obj(indx).Feature.ExtraHandleB.EndHook = plot(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            'Color',pllt.MeEndHookLine,'LineWidth',CNST.LineWidthSmall*px2pt,...
            'Marker','o','MarkerFaceColor',pllt.MeEndHookFace,'MarkerEdgeColor',pllt.MeEndHookLine,'MarkerSize',2*CNST.MeHookRadius*px2pt,...
            'ButtonDownFcn',@cllbckClickDownME_hk,...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.MeMarginRadius+CNST.MeArrowHeight+CNST.DistanceSmall+CNST.MeHookRadius));
        crdntn = dmmyRotate([0 obj(indx).Feature.ExtraHandleB.EndHook.UserData.Radius;0 0],obj(indx).Feature.Power*2*pi);
        obj(indx).Feature.ExtraHandleB.EndHook.XData = pstn(1) + crdntn(1,:);
        obj(indx).Feature.ExtraHandleB.EndHook.YData = pstn(2) + crdntn(2,:);
        obj(indx).Handle.Front = fill(obj(obj(indx).Parent(1)).Handle.Axes,0,0,...
            pllt.MeFront_interferer,'EdgeColor','none',...
            'ButtonDownFcn',@cllbckClickDownME_plce,...
            'Visible','off',...
            'UserData',struct('Index',indx,'Radius',CNST.MeInnerRadius));
        obj(indx).Handle.Front.XData = pstn(1) + crcl(1,:)*obj(indx).Handle.Front.UserData.Radius;
        obj(indx).Handle.Front.YData = pstn(2) + crcl(2,:)*obj(indx).Handle.Front.UserData.Radius;
        obj(indx).Feature.ExtraHandleB.Text = text(obj(obj(indx).Parent(1)).Handle.Axes,pstn(1),pstn(2),sprintf('%.2f',obj(indx).Feature.Power),...
            'HorizontalAlignment','center','VerticalAlignment','middle',...
            'FontName',CNST.FontName,'FontSize',CNST.FontSizeTiny,'FontWeight',CNST.FontWeightBold,...
            'Color',pllt.MeText,...
            'ButtonDownFcn',@cllbckClickDownME_plce,...
            'Visible','off',...
            'UserData',struct('Index',indx));
        uistack(obj(obj(indx).Parent(1)).Handle.Cover,'top');
        if vsbl
            hndl_name = fieldnames(obj(indx).Handle);
            for h = 1:numel(hndl_name)
                obj(indx).Handle.(hndl_name{h}).Visible = 'on';
            end
        end
        obj(indx).Feature.ExtraVisibleB = false;
        obj(indx).Feature.ExtraActiveB = false;
end
end