function [] = testModelSystem(A,S,Pr)
    global queue_limit device_amount N;
    queue = zeros(1, queue_limit); %������� � ��������
    queue_device_time = zeros(1, queue_limit); %������� � �������� ��������� ������ ������ ��������
    devices = zeros(1, device_amount); %����������� ������
    devices_time = zeros(1, device_amount); %������ ������� ������������� ������� �� ��������
    T_devices = []; %������ ������� ������������� ������� �� ��������
    T_A = []; %������ ������� ������������� ������� �� �������
    n = length(Pr);
    Ns = 0; %����� ������� ������������ �������� ������(������� ���� �� ������)        
    devices_state = [devices];    
         
    %���� �� �������� ��� ������
    while(~isempty(A))
        min_time_A = max(A);
        for j=1:1:length(A)
            if(A(j) <= min_time_A)
                min_time_A = A(j);
            end
        end
        
        T_A(end+1)= min_time_A;
        
        for j=1:1:length(A)
            if(A(j) <= min_time_A)
                A(j) = A(j) - min_time_A;
            end
        end
                                 
        elements_to_queue_number = find(A==0);   
        
        %�� ���������, ��� ����� ���� ���������� ����� �� �������� ������.
        %���� � ����� ������ ����� ������ �������� � ������
        
        %���������� ������ � �������
        for t=1:1:length(elements_to_queue_number)                     
            queue_zeros = find(queue==0);
            %���� � ������� ���� �����, �� �� ���� ������ �������� ��,
            %������� �������� �� �������
            %���� � ������� ���� ����� ��� ���� ��� ����� ����� �������
            %������, �� ������ �� � ��� �������
            if(length(queue_zeros) >= length(elements_to_queue_number))
                for m=1:1:length(elements_to_queue_number)
                    queue(m) = Pr(elements_to_queue_number(t));
                    queue_device_time(m) = S(elements_to_queue_number(t));                    
                end
                               
                %�������������� ����������� �� ���� �� ����������. � �����
                %����� ������
                                
                [queue, queue_device_time] = sortQueue(queue,queue_device_time);                   
                
                free_devices_index = find(devices==0); 
                elements_in_queue_for_devices = find(queue~=0);                
                
                while(~isempty(free_devices_index) && ~isempty(elements_in_queue_for_devices))
                    %���� ���������� ��������, �� ��������� �� ������� ����
                    %������
                    min_time_devices = max(S);
                    
                    if(length(free_devices_index) >= length(elements_in_queue_for_devices))                                                                        
                        for o=1:1:length(elements_in_queue_for_devices)
                            devices(free_devices_index(o)) = queue(elements_in_queue_for_devices(o));                            
                            devices_time(free_devices_index(o)) = queue_device_time(elements_in_queue_for_devices(o));  
                            
                            queue(elements_in_queue_for_devices(o)) = 0;
                            queue_device_time(elements_in_queue_for_devices(o)) = 0;                            
                        end
                        
                        devices_state = [devices_state; devices];
                                                
                        %��� ���� �� �������� ������� ����� ��� ������� 
                        
                        [queue, queue_device_time] = sortQueue(queue, queue_device_time);
                    end                                        
                    
                    %���������� �������� �������� � �������� ��������� ������
                    for z=1:1:length(devices)                        
                        %������� ��� ����������� ��������� ������� �� ���� ��������.
                        %��������, ������
                        if((devices_time(z) > 0) && (devices_time(z) <= min_time_devices))                
                            min_time_devices = devices_time(z);
                        end                       
                    end                        

                    T_devices(end+1) = min_time_devices;

                    for z=1:1:length(devices)                                   
                        if(devices_time(z) >= min_time_devices)
                            devices_time(z) = devices_time(z) - min_time_devices;                
                        end

                        %������ ����������. ��� ��������� ��������, ��������� �����
                        %������ ������
                        if(devices_time(z) == 0 && devices(z) ~= 0)
                            devices(z) = 0;
                            Ns = Ns + 1;
                        end
                    end                       
                    
                    free_devices_index = find(devices==0);
                    elements_in_queue_for_devices = find(queue~=0);       
                end                                                
            else
                %���� � ������� ���, �����, �� ����� ������ ��������� ��
                %������� ���� ��� � ��� �� ������� �����. �� �����
                %��������� ������ �������� � �������!
                
                %���� �� ���������� ����� ��� ����. ���������� ����� �
                %������� ������� ���� ��� ��������                
            end
        end
        %��������� �� ������� ������� ������� � ������� ������. �� �������
        %����������� ���� ��������� �������� ��������������
                        
        for k=1:1:length(elements_to_queue_number)
            A(elements_to_queue_number(k)) = [];
            Pr(elements_to_queue_number(k)) = [];
            S(elements_to_queue_number(k)) = [];
        end        
    end  
   
    queue  
    queue_device_time
    A
    Pr
    S
    devices
    Ns
    T_devices
    sum(T_devices)
    devices_state
    %{
    ���������� ���� ��������� �����. � ���� ������ ���� �� �����
    for j=1:1:length(devices)
        if(devices(j) == 0)
            devices(j) = Pr(j);
            devices_time(j) = S(j);
        end
    end
        
    for i=length(devices):1:n
        min_time = max(S);        
        
        %���������� �������� �������� � �������� ��������� ������
        for j=1:1:length(devices)
            if(devices(j) == 0)
                devices(j) = Pr(i);
                devices_time(j) = S(i);
            end
            
            %������� ��� ����������� ��������� ������� �� ���� ��������.
            %��������, ������
            if((devices_time(j) > 0) && (devices_time(j) < min_time))                
                min_time = devices_time(j);
            end                       
        end                        
                
        T_devices(end+1) = min_time;
        
        for j=1:1:length(devices)                                   
            if(devices_time(j) >= min_time)
                devices_time(j) = devices_time(j) - min_time;                
            end
                                    
            %������ ����������. ��� ��������� ��������, ��������� �����
            %������ ������
            if(devices_time(j) == 0)
                devices(j) = 0;
                Ns = Ns + 1;
            end
        end                      
    end    
        
    Ns
    %}   
end