function [] = testModelSystem(A,S,Pr)
    global queue_limit device_amount N;
    queue = zeros(1, queue_limit); %очередь с заявками
    queue_device_time = zeros(1, queue_limit); %очередь с временем обработки каждой заявки девайсом
    devices = zeros(1, device_amount); %обработчики заявок
    devices_time = zeros(1, device_amount); %Массив времени моделирования системы на девайсах
    T_devices = []; %Массив времени моделирования системы на девайсах
    T_A = []; %Массив времени моделирования системы на очереди
    T = []; %Массив времени - общее время моделирования
    Ns = 0; %число успешно обработанных системой заявок(отказов быть не должно)        
    devices_state = [devices];    
         
    %пока не кончился пул заявок
    while(~isempty(A))
        T_min = max([A,S, devices_time]);
        
        if(min(devices_time) <= T_min && min(devices_time) > 0)
            T_min = min(devices_time);
        end
        
        min_time_A = max(A(A>0));
        min_time_S = max(S(S>0));
        min_time_device = min(devices_time(devices_time>0));
                       
        for j=1:1:length(A)
            if(A(j) <= min_time_A && A(j) > 0)
                min_time_A = A(j);                
            end
        end

        %T_A(end+1) = min_time_A;

        for j=1:1:length(A)
            if(A(j) >= min_time_A)
                A(j) = A(j) - min_time_A;
            end
        end
                                         
        elements_to_queue_number = find(A==0);   
        
        %не учитывает, что может быть одинаковое время до прибытия заявки.
        %одна и более заявок может просто пропасть в никуда
        
        %закидываем заявки в очередь
        for t=1:1:length(elements_to_queue_number)                     
            queue_zeros = find(queue==0);
            %если в очереди есть место, то из пула заявок добавить ту,
            %которая подходит по времени
            %если в очереди есть место для всех тех чисел время которых
            %пришло, то кинуть их в эту очередь
            if(length(queue_zeros) >= length(elements_to_queue_number))
                for m=1:1:length(elements_to_queue_number)
                    queue(m) = Pr(elements_to_queue_number(t));
                    queue_device_time(m) = S(elements_to_queue_number(t));                    
                end                                
                               
                %упорядочивание приоритетов по мере их значимости. в конце
                %самые крутые
                                
                [queue, queue_device_time] = sortQueue(queue,queue_device_time);                                   
                
                free_devices_index = find(devices==0); 
                elements_in_queue_for_devices = find(queue~=0);                
                
                while(~isempty(free_devices_index) && ~isempty(elements_in_queue_for_devices))
                    %если устройства свободны, то загружаем из очереди наши
                    %заявки
                    min_time_devices = max(S);
                    
                    if(length(free_devices_index) >= length(elements_in_queue_for_devices))                                                                        
                        for o=1:1:length(elements_in_queue_for_devices)
                            devices(free_devices_index(o)) = queue(elements_in_queue_for_devices(o));                            
                            devices_time(free_devices_index(o)) = queue_device_time(elements_in_queue_for_devices(o));  
                            
                            queue(elements_in_queue_for_devices(o)) = 0;
                            queue_device_time(elements_in_queue_for_devices(o)) = 0;                            
                        end
                        
                        devices_state = [devices_state; devices];
                                                
                        %тут надо со временем сделать штуку для деайсов 
                        
                        [queue, queue_device_time] = sortQueue(queue, queue_device_time);
                    end     
                    
                    min_time_devices = max(devices_time);
                    
                    %заполнение девайсов заявками и временем обработки заявки
                    for z=1:1:length(devices)                        
                        %минимум для дальнейшего вычитания времени из всех девайсов.
                        %экономия, короче                            
                        
                        if(devices_time(z) > 0 && devices_time(z) <= min_time_devices)                
                            min_time_devices = devices_time(z);
                        end                                                                                        
                    end                         

                    T_devices(end+1) = min_time_devices;  
                    
                    %если это на девайсах и в очереди уже есть заявки то
                    %отнимаем общее время у всех                    
                    for z=1:1:length(devices)                            
                        if(devices_time(z) >= min_time_devices)
                            devices_time(z) = devices_time(z) - min_time_devices;
                        end                                                

                        %заявка обработана. при следующей итерации, утройство займёт
                        %другая заявка
                        if(devices_time(z) == 0 && devices(z) ~= 0)
                            devices(z) = 0;
                            Ns = Ns + 1;
                        end
                    end                      
                                        
                    T(end+1) = T_min;
                    
                    free_devices_index = find(devices==0);
                    elements_in_queue_for_devices = find(queue~=0);       
                end                                                
            else
                %если в очереди нет, места, то нужно просто подождать по
                %времени пока она в ней не найдётся место. не нужно
                %вытеснять другие элементы в очереди!
                
                %пока не достаточно места для всех. прибавлять время и
                %крутить девайсы шобы они работали                
            end
        end
        %исключаем из массива времени ушедшие в очередь заявки. из массива
        %приоритетов тоже исключаем элементы соответственно
                        
        for k=1:1:length(elements_to_queue_number)
            A(elements_to_queue_number(k)) = [];
            Pr(elements_to_queue_number(k)) = [];
            S(elements_to_queue_number(k)) = [];
        end        
    end  
   
    queue  
    %queue_device_time
    %A
    %Pr
    %S
    %devices
    %Ns
    %T_devices
    %sum(T_devices)
    devices_state     
    length(devices_state)
end