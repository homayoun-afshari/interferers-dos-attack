function indx = dmmyGetIndex(name)
global obj;

if ~iscell(name)
    name = {name};
end

ttl = numel(name);

indx = zeros(1,ttl);
for o1 = 1:ttl
    temp = {obj.Name};
    for o2 = 1:numel(temp)
        if strcmp(temp{o2},name{o1})
            indx(o1) = o2;
            break;
        end
    end
end
end

