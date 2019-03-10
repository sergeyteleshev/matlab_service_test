%queueueue sorting by priority
function [queue, queue_device_time] = sortQueue(queue, queue_device_time)
    for j=1:1:(length(queue) - 2)
        for i=1:1:(length(queue) - 1)
            if (queue(i) > queue(i + 1))
                buf = queue(i);
                queue(i) = queue(i + 1);
                queue(i + 1) = buf;                        
                
                buf_t = queue_device_time(i);
                queue_device_time(i) = queue_device_time(i + 1);
                queue_device_time(i + 1) = buf_t;                        
            end
        end
    end 
end