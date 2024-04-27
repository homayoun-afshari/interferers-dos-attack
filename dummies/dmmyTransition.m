function dmmyTransition(hndl,prprty,sts1,sts2,drtn,ease)
global CNST;
global TRNSTN;

if ~iscell(hndl)
    hndl = {hndl};
    prprty = {prprty};
    sts1 = {sts1};
    sts2 = {sts2};
end

T = ceil(drtn*CNST.FramePerSecond);
ttl_h = numel(hndl);

if ~ease(1) && ~ease(2)
    cffcnt = @(t) t/T;
elseif ~ease(1) && ease(2)
    cffcnt = @(t) 2*t/T-(t/T)^2;
elseif ease(1) && ~ease(2)
    cffcnt = @(t) (t/T)^2;
else
    cffcnt = @(t) 3*(t/T)^2-2*(t/T)^3;
end

TRNSTN = true;
for t = 1:T
    for h = 1:ttl_h
        set(hndl{h},prprty{h},sts1{h}+(sts2{h}-sts1{h})*cffcnt(t));
    end
    pause(1/CNST.FramePerSecond);
    if ~TRNSTN
        break;
    end
end
TRNSTN = false;
end

