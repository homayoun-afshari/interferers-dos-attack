function obj_stp()
global STOP;
global obj;
obj(dmmyGetIndex('me-01')).Feature.Power = obj(dmmyGetIndex('me-01')).Feature.Power/2;
STOP = true;
end

