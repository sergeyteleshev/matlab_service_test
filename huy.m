function [] = huy(A,S,Pr)
    global queue_limit device_amount N;
    
    queue = Queue(queue_limit);
    device = Device(device_amount);
    i = 1;
    
    while i <= N
        S_MIN = max([A,S])+1;        

        % ���� �����-�� �� ��������� ������...
        if ~isempty(device.priorities(device.priorities > 0))
           S_MIN = min(device.priorities(device.priorities > 0));
        end
        
        if S_MIN < A(i) %��������� ������� - ���������� ��������� ������
            
        else  %��������� ������� - ����������� ����� ������             
            
        end
        
        i = i + 1;        
    end
end