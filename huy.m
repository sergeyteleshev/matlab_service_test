function [] = huy(A,S,Pr)
    global queue_limit device_amount N;
    
    queue = Queue(queue_limit);
    device = Device(device_amount);
    i = 1;
    
    while i <= N
        S_MIN = max([A,S])+1;        

        % Если какое-то из устройств занято...
        if ~isempty(device.priorities(device.priorities > 0))
           S_MIN = min(device.priorities(device.priorities > 0));
        end
        
        if S_MIN < A(i) %Следующее событие - выполнение имеющейся заявки
            
        else  %Следующее событие - поступление новой заявки             
            
        end
        
        i = i + 1;        
    end
end