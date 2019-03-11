classdef Queue < handle
    properties
        times
        priorities        
    end
    methods
        function obj = Queue(capacity)
            obj.times = zeros(1, capacity);
            obj.priorities = zeros(1, capacity);
        end       
        
        function obj = push(obj, pr, t)            
            if(~isempty(find(obj.priorities==0)) && ~isempty(find(obj.times==0)))
                obj.times(1) = t;
                obj.priorities(1) = pr;
                obj.sort();
            end
        end
        
        function obj = sort(obj)
            for j=1:1:(length(obj.priorities) - 2)
                for i=1:1:(length(obj.priorities) - 1)
                    if (obj.priorities(i) > obj.priorities(i + 1))
                        buf = obj.priorities(i);
                        obj.priorities(i) = obj.priorities(i + 1);
                        obj.priorities(i + 1) = buf;                        

                        buf_t = obj.times(i);
                        obj.times(i) = obj.times(i + 1);
                        obj.times(i + 1) = buf_t;                        
                    end
                end
            end 
        end
        
        function delete(obj, index)
            obj.times(index) = 0;
            obj.priorities(index) = 0;
        end  
        
        function deleteLast(obj)
            obj.delete(length(obj.priorities));
            obj.sort();
        end
    end
end