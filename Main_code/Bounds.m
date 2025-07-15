% Application of simple limits/bounds
function s = Bounds( s, Ub, Lb , best_s)
    % Apply the lower bound vector
    temp = s;
    I = temp <= Lb;
    % temp(I) = pX(I);
    if rand() < 0.01
    temp(I) = best_s(I); 
    else
    temp(I) = rand(); 
    end
    % Apply the upper bound vector 
    J = temp >= Ub;
    % temp(J) = pX(J);
    if rand() < 0.01
        temp(J) = best_s(J); 
    else
        temp(J) = rand(); 
    end
      % Update this new move 
      s = temp;
end