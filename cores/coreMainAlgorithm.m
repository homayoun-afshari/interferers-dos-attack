%% Initialization
global UP;
global CLSE;
global STOP;
global CNST;
global fgr;
global log;
global axs;
global txt;
global obj;
global arrw;

%%MEs
transmitter_index = 1;
authentication = obj(dmmyGetIndex('athntctn')).Handle.Text.String;
indx_me = find(and(strcmp({obj.Type},'me'),[obj.Visible]));
indx_scatterer = nan(1,numel(indx_me));
for k = 1:numel(indx_me)
    if strcmp(obj(indx_me(k)).Feature.Type,'scatterer')
        indx_scatterer(k) = k;
    end
end
indx_scatterer(isnan(indx_scatterer)) = [];
MEtot = numel(indx_me);
p = zeros(MEtot,1);
v = zeros(MEtot,2);
for k = 1:MEtot
    p(k) = obj(indx_me(k)).Feature.Power;
    v(k) = obj(indx_me(k)).Feature.Velocity;
end
theta = zeros(MEtot,1);
r = zeros(MEtot,1);

%%Modulation
modulation_level = eval(obj(dmmyGetIndex('mdltn_lvl')).Handle.Text.String);

%%Channel
mu_shad = eval(obj(dmmyGetIndex('mu')).Handle.Text.String);
sigma_shad = eval(obj(dmmyGetIndex('sgma')).Handle.Text.String);
gamma = eval(obj(dmmyGetIndex('gmma')).Handle.Text.String);
shadowing =  lognrnd(mu_shad,sigma_shad,[MEtot,1]);

%%Noise
variance = eval(obj(dmmyGetIndex('vrnce')).Handle.Text.String);

%%Antennas
M = eval(obj(dmmyGetIndex('arr_size')).Handle.Text.String);
lambda = 0.1;
d = 0.5*lambda;
a = @(M,theta) exp(1j*2*pi*(0:M-1)'*d*cosd(theta.')/lambda);

%%Symbols
C = ceil(8*numel(authentication)/modulation_level);
U  = eval(obj(dmmyGetIndex('rptn')).Handle.Text.String);
L = 2*M;
T = eval(obj(dmmyGetIndex('smbl_tme')).Handle.Text.String)/U;

%%Search Area
s_lim = [0 180];
s_res = 1800;

%%DoA Estimation Method
method = obj(dmmyGetIndex('mthd')).Handle.Text.String;
do_filter = all(eval(obj(dmmyGetIndex('fltr')).Handle.Text.String))>0;
limit_marg = eval(obj(dmmyGetIndex('fltr')).Handle.Text.String);

%%Console
if ~isvalid(log)
    log = figure('Units','pixels',...
        'Position',...
        [fgr.Position(1)-200 fgr.Position(2) 200 CNST.FigureHeight],...
        'Name','Log','NumberTitle','off','Resize','off',...
        'MenuBar','none',...
        'Color',[0.8 0.8 0.8]);
    axs = axes(log,'Units','normal','Position',[0 0 1 1],...
        'Clipping','off');
    hold(axs, 'on');
    axis(axs, 'off');
    xlim(axs, [0 300]);
    ylim(axs, [0 CNST.FigureHeight]);
    txt = text(axs, 5,CNST.FigureHeight-5,cell(60,1),...
        'Color',[0.3 0.3 0.3],...
        'HorizontalAlignment','left','VerticalAlignment','top',...
        'FontName','Consolas','FontSize',8,...
        'Interpreter', 'none');
end

%%Update
figure(fgr);
pause(0.5);
funcPopNewMessage(dmmyGetIndex('hnt'),...
    {'Total Number of Transmitted Symbols: 0';...
    'No Transmitter is found yet.';...
    'SINR in the Receiver: N/A'});
pause(0.5);
if ~dmmyGetIndex('stp')
    funcMakeObject(nan,'stp','btn','','Pause',true,false,...
        [CNST.FigureWidth-CNST.DistanceSmall-CNST.ObjectWidthSmall/2 ...
        (CNST.FigureHeight-CNST.FigureWidth)/2],...
        [CNST.ObjectWidthSmall ...
        CNST.FigureHeight-CNST.FigureWidth-2*CNST.DistanceSmall]);
else
    funcCoverChild(dmmyGetIndex('stp'),true);
    funcAct(dmmyGetIndex('stp'),false);
end
if UP
    dmmyTransition(obj(dmmyGetIndex('hnt')).Handle.Back,'Position',...
        obj(dmmyGetIndex('hnt')).Handle.Back.Position,...
        obj(dmmyGetIndex('hnt')).Handle.Back.Position+...
        [0 0 -CNST.DistanceMedium-CNST.ObjectWidthSmall 0],...
        CNST.TransitionSlow,[true true]);
    UP = false;
end
funcAct(dmmyGetIndex('stp'),true);

%% Main
s_transmitter = coreFunctionCoder8(authentication,modulation_level,C);
possible_theta = ((s_lim(2)-s_lim(1))*(0:s_res-1)/(s_res-1)+s_lim(1));
limit = limit_marg(1);
R = nan(M,M,L);
xi_calculation = nan(1,L);
skip = 1;
m = 0;
for l = 1:5000
    %%Commencing
    if CLSE || STOP
        break;
    end
    pause(0.05/U);
    
    %%GUI Update (1)
    %Log
    txt.String{1} = sprintf('%02.f - %02.f - %02.f',...
        l,floor((l-1)/U)+1,mod(floor((l-1)/U),C)+1);
    %Symbol Time
    obj(dmmyGetIndex('hnt')).Handle.Text.String{1} = ...
        sprintf('Number of Transmitted Symbols: %u',floor((l-1)/U)+1);
    
    %%Data of MEs
    s = normrnd(0,sqrt(1/2),[MEtot,1]) + 1j*normrnd(0,sqrt(1/2),[MEtot,1]);
    s(transmitter_index) = s_transmitter(mod(floor((l-1)/U),C)+1);
    s(indx_scatterer) = s(transmitter_index);
    
    %%Posititon of MEs
    for k = 1:MEtot
        crnt_pstn = ...
            [obj(indx_me(k)).Handle.Back.XData(1) ...
            obj(indx_me(k)).Handle.Back.YData(1)];
        obj(indx_me(k)).Feature.Direction = dmmyRicochet(...
            indx_me(k),...
            crnt_pstn + v(k)*[cos(obj(indx_me(k)).Feature.Direction) ...
            sin(obj(indx_me(k)).Feature.Direction)]*T,...
            obj(indx_me(k)).Feature.Direction);
        next_pstn = ...
            crnt_pstn + ...
            v(k)*[cos(obj(indx_me(k)).Feature.Direction) ...
            sin(obj(indx_me(k)).Feature.Direction)]*T;
        hndl_name = fieldnames(obj(indx_me(k)).Handle);
        for h = 1:numel(hndl_name)
            obj(indx_me(k)).Handle.(hndl_name{h}).XData = ...
                obj(indx_me(k)).Handle.(hndl_name{h}).XData - ...
                crnt_pstn(1) + next_pstn(1);
            obj(indx_me(k)).Handle.(hndl_name{h}).YData = ...
                obj(indx_me(k)).Handle.(hndl_name{h}).YData - ...
                crnt_pstn(2) + next_pstn(2);
        end
        crdntn = dmmyRotate(...
            [obj(indx_me(k)).Handle.Arrow.UserData.Distance+...
            arrw(1,:)*(obj(indx_me(k)).Handle.Arrow.UserData.Height);...
            arrw(2,:)*obj(indx_me(k)).Handle.Arrow.UserData.Base],...
            obj(indx_me(k)).Feature.Direction);
        obj(indx_me(k)).Handle.Arrow.XData = next_pstn(1) + crdntn(1,:);
        obj(indx_me(k)).Handle.Arrow.YData = next_pstn(2) + crdntn(2,:);
    end
    for k = 1:MEtot
        crdntn = ...
            [obj(indx_me(k)).Handle.Back.YData(1) ...
            -obj(indx_me(k)).Handle.Back.XData(1)]-...
            [obj(dmmyGetIndex('rcvr')).Handle.Back.YData(1) ...
            -obj(dmmyGetIndex('rcvr')).Handle.Back.XData(1)];
        theta(k) = dmmyGetAngle(crdntn,true);
        r(k) = sqrt(sum((crdntn).^2))*eval(obj(...
            dmmyGetIndex('cvrge')).Handle.Text.String)/CNST.FigureWidth;
    end
    
    %%Channel
    betta = shadowing./(r.^gamma);
    g = diag(sqrt(betta))*(normrnd(0,sqrt(1/2),...
        [MEtot,1])+1j*normrnd(0,sqrt(1/2),[MEtot,1]));

    %%Calculating Inner Vector
    n = normrnd(0,sqrt(variance/2),[M,1])+...
        1j*normrnd(0,sqrt(variance/2),[M,1]);
    x = sum(a(M,theta)*diag(sqrt(p).*g.*s),2) + n;
    
    %Skipping
    skip = skip - 1;
    if skip
        continue;
    end
    
    %%Counter Update
    m = m + 1;
    
    %%Timer Start
    cTime = zeros(5,1);
    tic;
    
    %%Estimating Auto-Corelation Matrix
    R(:,:,mod(m-1,L)+1) = x*x';
    
    %%DoA Estimation Algorithm
    if l > 1
        limit = 0.5*(limit+max(limit_marg(1), p_estimated-limit_marg(2)));
    end
    temp = a(M,possible_theta.');
    switch method
        case 'MVD'
            J = zeros(1,s_res);
            if m >= M
                J = 1./abs(sum(((temp'/mean(R,3,'omitnan')).').*temp,1));
            end
        case 'MUSIC'
            [V,~] = eig(mean(R,3,'omitnan'));
            J = 1./sum(abs(V(:,1:M-MEtot)'*temp).^2, 1);
    end
    J = J/max(J);
    
    %%Estimating DoA values
    extreme_points = ...
        find([0 and(J(1:end-2)<=J(2:end-1),J(2:end-1)>J(3:end)) 0]).';
    theta_estimated = ...
        (s_lim(2)-s_lim(1))*(extreme_points-1)/(s_res-1)+s_lim(1);
    if strcmp(method,'MUSIC')
        [~,idx] = sort(J(extreme_points),'descend');
        theta_estimated(idx(MEtot+1:end)) = nan;
    end
    if do_filter
        [~,idx] = find(J(extreme_points)<limit);
        theta_estimated(idx) = nan;
    end
    filteredMEs = find(~isnan(theta_estimated));
    MEtotal_estimated = numel(filteredMEs);
    %Timer Check
    cTime(1) = toc;
    
    %%Buffering
    if l > 1
        old_bfr1 = bfr1;
        old_bfr2 = bfr2;
        old_bfr3 = bfr3;
        old_bfr4 = bfr4;
        old_bfr5 = bfr5;
    end
    bfr1 = theta_estimated(filteredMEs);
    bfr2 = zeros(MEtotal_estimated,U*C);
    bfr3 = zeros(MEtotal_estimated,U*C);
    bfr4 = nan(MEtotal_estimated,C);
    bfr5 = false(MEtotal_estimated,1);
    transmitter_in_bfr = [];
    if l > 1
        old_MEtotal_estimated = numel(old_bfr1);
        bfr_idx = zeros(old_MEtotal_estimated,1);
        for k = 1:old_MEtotal_estimated
            [~,bfr_idx(k)] = min(abs(bfr1-old_bfr1(k)));
        end
        for k = 1:old_MEtotal_estimated
            bfr2(bfr_idx(k),:) = old_bfr2(k,:);
            bfr3(bfr_idx(k),:) = old_bfr3(k,:);
            bfr4(bfr_idx(k),:) = old_bfr4(k,:);
            if old_bfr5(k)
                transmitter_in_bfr = bfr_idx(k);
                temp = k;
            end
        end
    end
    if transmitter_in_bfr
        bfr2(transmitter_in_bfr,:) = old_bfr2(temp,:);
        bfr3(transmitter_in_bfr,:) = old_bfr3(temp,:);
        bfr4(transmitter_in_bfr,:) = old_bfr4(temp,:);
        bfr5(transmitter_in_bfr,:) = old_bfr5(temp,:);
    end
    %Timer Check
    cTime(2) = toc;
    
    %%Smartness (1)
    %Beamforming
    A = a(M,theta_estimated(filteredMEs));
    w = (A/(A'*A));
    %Output
    bfr2(:,mod(l-1,U*C)+1) = w'*x;
    %Data estimation
    [~,idx] = ...
        min(abs(bsxfun(@minus,theta_estimated(filteredMEs),theta.')),[],2);
    bfr3(:,mod(l-1,U*C)+1) = ...
        sqrt(p(idx)).*(sum((w').'.*a(M,theta(idx))).').*g(idx);
    c = mod(floor((l-1)/U),C)+1;
    bfr4(:,c) = ...
        sum(bfr2(:,U*(c-1)+1:U*c).*((bfr3(:,U*(c-1)+1:U*c)').'),2)./...
        sum(bfr3(:,U*(c-1)+1:U*c).*((bfr3(:,U*(c-1)+1:U*c)').'),2);
    %Timer Check
    cTime(3) = toc;
    
    %%Smartness (2)
    %Calculating likelihoods
    string = zeros(MEtotal_estimated,numel(authentication));
    likelihood_hard = zeros(MEtotal_estimated,1);
    likelihood_soft = zeros(MEtotal_estimated,1);
    if transmitter_in_bfr
        string(transmitter_in_bfr,:) = coreFunctionDecoder8(...
            bfr4(transmitter_in_bfr,:),...
            modulation_level,numel(authentication));
        likelihood_hard(transmitter_in_bfr) = ...
            sum(string(transmitter_in_bfr,:)==...
            authentication)/numel(authentication);
        likelihood_soft(transmitter_in_bfr) = ...
            sum(sum(de2bi(int8(string(transmitter_in_bfr,:)),8)==...
            de2bi(int8(authentication),8)))/8/numel(authentication);
    else
        for k = 1:MEtotal_estimated
            string(k,:) = coreFunctionDecoder8(...
                bfr4(k,:),modulation_level,...
                numel(authentication));
            likelihood_hard(k) = ...
                sum(string(k,:)==...
                authentication)/numel(authentication);
            likelihood_soft(k) = ...
                sum(sum(de2bi(int8(string(k,:)),8)==...
                de2bi(int8(authentication),8)))/8/numel(authentication);
        end
    end
    %Timer Check
    cTime(4) = toc;
    %Searching for the transmitter
    if sum(likelihood_soft>0.7)
        [~,transmitter_index_estimated] = max(likelihood_soft);
        bfr5(transmitter_index_estimated) = true;
        w_opt = w(:,transmitter_index_estimated);
    else
        transmitter_index_estimated = 0;
        bfr5 = false(MEtotal_estimated,1);
    end
    %Timer Check
    cTime(5) = toc;
    
    %%Power Estimation
    if transmitter_index_estimated
        p_estimated = J(extreme_points(filteredMEs(transmitter_index_estimated)));
    else
        p_estimated = 0;
    end
    
    %%GUI Update (2)
    %Log
    for i = 1:numel(cTime)
        txt.String{i+1} = sprintf('%.8f (%.u)',cTime(i),ceil(cTime(i)/T));
    end
    txt.String(numel(cTime)+2:end) = ...
        cell(numel(txt.String)-numel(cTime)-1,1);
    for k = 1:MEtotal_estimated
        string(k,(string(k,:)<33)|(string(k,:)>126)) = '?';
        txt.String{k+numel(cTime)+1} = sprintf('%.u: %s (%.2f|%.2f)',...
            k,string(k,:),likelihood_hard(k),likelihood_soft(k));
    end
    %DoA estiamtion and Beamforming
    dis = obj(dmmyGetIndex('rcvr')...
        ).Feature.ExtraHandleB.EstimationCurve.UserData.MinimumHeight + ...
        J*(obj(dmmyGetIndex('rcvr')...
        ).Feature.ExtraHandleB.EstimationCurve.UserData.MaximumHeight-...
        obj(dmmyGetIndex('rcvr')...
        ).Feature.ExtraHandleB.EstimationCurve.UserData.MinimumHeight);
    crdntn = [dis.*cosd(possible_theta);dis.*sind(possible_theta)];
    obj(dmmyGetIndex(...
        'rcvr')).Feature.ExtraHandleB.EstimationCurve.XData = ...
        -crdntn(2,:) + obj(dmmyGetIndex('rcvr')).Handle.Back.XData(1);
    obj(dmmyGetIndex(...
        'rcvr')).Feature.ExtraHandleB.EstimationCurve.YData = ...
        crdntn(1,:) + obj(dmmyGetIndex('rcvr')).Handle.Back.YData(1);
    obj(dmmyGetIndex(...
        'rcvr')).Feature.ExtraHandleB.EstimationCurve.Visible = 'on';
    G = zeros(1,s_res); %Beamforming gain (#)
    if transmitter_index_estimated
        xi_calculation(mod(m-1,L)+1) = ...
            10*log10(betta(transmitter_index)*p(transmitter_index)*...
            abs(w_opt'*a(M,theta(transmitter_index)))^2/...
            (sum(betta.*p.*(abs((w_opt'*a(M,theta)).').^2))-...
            betta(transmitter_index)*p(transmitter_index)*...
            abs(w_opt'*a(M,theta(transmitter_index)))^2+...
            variance*(w_opt'*w_opt)));
        obj(dmmyGetIndex('hnt')).Handle.Text.String{2} = ...
            sprintf('Soft Likelihood: %.2f%% | Hard Likelihood: %.2f%%',...
            likelihood_soft(transmitter_index_estimated)*100,...
            likelihood_hard(transmitter_index_estimated)*100);
        obj(dmmyGetIndex('hnt')).Handle.Text.String{3} = ...
            sprintf('SINR in the Receiver: %.2fdB',...
            mean(10*log10(xi_calculation),'omitnan'));
        obj(dmmyGetIndex(...
            'rcvr')).Feature.ExtraHandleB.BeamformingCurve.Visible = 'on';
        G = (abs(w_opt'*a(M,possible_theta.')).^2);
    else
        xi_calculation = nan(1,L);
        obj(dmmyGetIndex('hnt')).Handle.Text.String{2} = ...
            sprintf('Transmitter is lost');
        obj(dmmyGetIndex('hnt')).Handle.Text.String{3} = ...
            sprintf('SINR in the Receiver: N/A');
        obj(dmmyGetIndex(...
            'rcvr')).Feature.ExtraHandleB.BeamformingCurve.Visible = 'off';
    end
    G = sqrt(G/max(G)); %Magnifying smaller values
    dis = obj(dmmyGetIndex('rcvr')...
        ).Feature.ExtraHandleB.BeamformingCurve.UserData.MinimumHeight +...
        G*(obj(dmmyGetIndex('rcvr')...
        ).Feature.ExtraHandleB.BeamformingCurve.UserData.MaximumHeight-...
        obj(dmmyGetIndex('rcvr')...
        ).Feature.ExtraHandleB.BeamformingCurve.UserData.MinimumHeight);
    crdntn = [dis.*cosd(possible_theta);dis.*sind(possible_theta)];
    obj(dmmyGetIndex(...
        'rcvr')).Feature.ExtraHandleB.BeamformingCurve.XData = ...
        -crdntn(2,:) + obj(dmmyGetIndex('rcvr')).Handle.Back.XData(1);
    obj(dmmyGetIndex(...
        'rcvr')).Feature.ExtraHandleB.BeamformingCurve.YData = ...
        crdntn(1,:) + obj(dmmyGetIndex('rcvr')).Handle.Back.YData(1);
    
    %%Skip Calculations
    skip = ceil(cTime(end)/T);
end

%% End
if CLSE
    delete(fgr);
    delete(log);
end

if STOP
    UP = true;
    STOP = false;
    fgr.CloseRequestFcn = 'closereq';
    dmmyTransition(...
        obj(dmmyGetIndex('hnt')).Handle.Back,'Position',...
        obj(dmmyGetIndex('hnt')).Handle.Back.Position,...
        obj(dmmyGetIndex('hnt')).Handle.Back.Position+...
        [0 0 CNST.DistanceMedium+CNST.ObjectWidthSmall 0],...
        CNST.TransitionSlow,[true true]);
    funcCoverChild(dmmyGetIndex({'smlte' 'stp'}),[true false]);
    funcCoverChildExtra('B',dmmyGetIndex('rcvr'),false);a
    funcPopOutMessage(dmmyGetIndex('hnt'));
    funcAct(dmmyGetIndex({'wrld' 'rcvr'}),[true true]);
    funcAct(indx_me,true(1,numel(indx_me)));
end