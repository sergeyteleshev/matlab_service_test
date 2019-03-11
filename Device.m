classdef Device < handle
    properties
        times
        priorities        
    end
    methods
        function obj = Device(divices_max)
            obj.times = zeros(1, divices_max);
            obj.priorities = zeros(1, divices_max);
        end       
        function put(obj, pr, t)
            pr_indexes = find(obj.priorities==0);
            if(~isempty(pr_indexes))
                obj.times(pr_indexes(1)) = t;
                obj.priorities(pr_indexes(1)) = pr;
            else
                error('device is full');
            end                        
        end   
        function delete(obj, index)
            if (index <= length(obj.times))
                obj.times(index) = 0;
                obj.priorities(index) = 0;
            else
                error('index is out of array');
            end            
        end
    end
end