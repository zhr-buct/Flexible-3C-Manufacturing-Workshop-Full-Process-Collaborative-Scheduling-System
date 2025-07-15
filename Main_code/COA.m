function [X,fitness_f]  =COA(pop,data,info,Max_iter)
%% Define Parameters
X = pop;
T = Max_iter;
dim = data.n * 3;
N = info.np;
ub = 1;
lb = 0;
lb=lb.*ones(1,dim);
ub=ub.*ones(1,dim);


Best_fitness = inf;
best_position = zeros(1,dim);
fitness_f = zeros(1,N);
for i=1:N
    fitness_f(i) = decode_01( X(i,:), info, data );  
   
    if fitness_f(i)<Best_fitness
       Best_fitness = fitness_f(i);
       best_position = X(i,:);
    end
end
global_position = best_position; 


t=1; 
while(t <= T / 1000)
    C = 2-(t/T); %Eq.(7)
    temp = rand*15+20; %Eq.(3)
    xf = (best_position+global_position)/2; % Eq.(5)
    Xfood = best_position;
    for i = 1:N
        if temp>30
            %% summer resort stage
            if rand<0.5
                Xnew(i,:) = X(i,:)+C*rand(1,dim).*(xf-X(i,:)); %Eq.(6)
            else
            %% competition stage
                for j = 1:dim
                    z = round(rand*(N-1))+1;  %Eq.(9)
                    Xnew(i,j) = X(i,j)-X(z,j)+xf(j);  %Eq.(8)
                end
            end
        else
            %% foraging stage
            temp_X = decode_01( Xfood, info, data ); 
            P = 3*rand*fitness_f(i)/ temp_X; %Eq.(4)
            if P>2   % The food is too big
                 Xfood = exp(-1/P).*Xfood;   %Eq.(12)
                for j = 1:dim
                    Xnew(i,j) = X(i,j)+cos(2*pi*rand)*Xfood(j)*p_obj(temp)-sin(2*pi*rand)*Xfood(j)*p_obj(temp); %Eq.(13)
                end
            else
                Xnew(i,:) = (X(i,:)-Xfood)*p_obj(temp)+p_obj(temp).*rand(1,dim).*X(i,:); %Eq.(14)
            end
        end
    end
    %% boundary conditions
    for i=1:N
        for j =1:dim
            if length(ub)==1
                Xnew(i,j) = min(ub,Xnew(i,j));
                Xnew(i,j) = max(lb,Xnew(i,j));
            else
                Xnew(i,j) = min(ub(j),Xnew(i,j));
                Xnew(i,j) = max(lb(j),Xnew(i,j));
            end
        end
    end
   
    global_position = Xnew(1,:);
    global_position = Bounds( global_position, ub, lb ,best_position);

    global_fitness = decode_01( global_position, info, data );  
    
 
    for i =1:N
         %% Obtain the optimal solution for the updated population
        Xnew(i,:) = Bounds( Xnew(i,:), ub, lb,best_position);
        new_fitness = decode_01( Xnew(i,:), info, data );  
        if new_fitness<global_fitness
                 global_fitness = new_fitness;
                 global_position = Xnew(i,:);
        end
        %% Update the population to a new location
        if new_fitness<fitness_f(i)
             fitness_f(i) = new_fitness;
             X(i,:) = Xnew(i,:);
             if fitness_f(i)<Best_fitness
                 Best_fitness=fitness_f(i);
                 best_position = X(i,:);
             end
        end
    end


        t=t+1;

end


function y = p_obj(x)   %Eq.(4)
    y = 0.2*(1/(sqrt(2*pi)*3))*exp(-(x-25).^2/(2*3.^2));
end


end


