function solSet = simplex(t, mode)
%SIMPLEX 
[nrow, ncol] = size(t);
epsilon = 1e-8;
basic_sequence = zeros(1, nrow-1);
optsol = zeros(1, ncol-1);
iteration = 0;
k = 0;
disp(t);
% Get basic sequence
for j=2:ncol
    if abs(t(1,j)) < epsilon
        for i=2:nrow
            if abs(t(i,j) - 1) < epsilon
                basic_sequence(i-1) = j-1;
            end
        end
    end
end

% Check the optimality
optimal = true;
for i=2:ncol
    if t(1,i) < -epsilon
        optimal = false;
        break;
    end
end

while(~optimal)
    iteration = iteration + 1;
    h = 0;
    if strcmp(mode, 'SIR')
        for j=2:ncol
            if t(1,j) < -epsilon
                k = j;
                break;
            end
        end
        
        val = realmax;
        
        for r=2:nrow
            if t(r,k) > epsilon
                temp = t(r,1) / t(r,k);
                
                if val > temp
                    val = temp;
                    h = r;
                elseif val == temp
                    if(basic_sequence(h-1) > basic_sequence(r-1))
                        h = r;
                    end
                end
            end
        end
        
    elseif strcmp(mode, 'SSR')
        if sum((t(1,2:ncol) < -epsilon)) > 1
            k = randsample(find(t(1,2:ncol) < -epsilon),1) + 1;
        else
            k = find(t(1,2:ncol) < -epsilon) + 1;
        end
        
        if sum(t(:,k) > epsilon) > 0
            index = find(t(:,k) > epsilon);
            if size(index, 1) < 2
                h = index;
            else
                temp = t(t(:,k) > epsilon, :) ./ t(t(:,k) > epsilon, k);
                h = index(lexicoComp(temp));
            end
        end
        
    elseif strcmp(mode, 'LIR')
        for j=ncol:-1:2
            if t(1,j) < -epsilon
                k = j;
                break;
            end
        end
        
        val = realmax;
        
        for r=2:nrow
            if t(r,k) > epsilon
                temp = t(r,1) / t(r,k);
                
                if val > temp
                    val = temp;
                    h = r;
                elseif val == temp
                    if(basic_sequence(h-1) < basic_sequence(r-1))
                        h = r;
                    end
                end
            end
        end        
    end
    
    if h==0
        fprintf('\n');
        disp('unbounded solution!');
        fprintf('\n');
        solSet.state = 'unbounded';
        solSet.table = t;
        solSet.basic_sequence = basic_sequence;
        solSet.optsol = optsol;
        solSet.iteration = iteration;
        return;
    end
    
    P = eye(nrow);
    P = assign(P, t, h, k);
    t = P * t;
    basic_sequence(h-1) = k-1;
    
    optimal = true;
    for j=2:ncol
        if t(1,j) < -epsilon
            optimal = false;
            break;
        end
    end

    disp(['iteration: ', num2str(iteration), '  objective value: ', num2str(getOptimalValue(t))]);
    disp(t);
end

for j=2:ncol
    if abs(t(1,j)) < epsilon
       temp = isOnehot(t, j);
        if temp
            optsol(j-1) = t(temp+1,1);
            if abs(round(optsol(j-1)) - optsol(j-1)) < epsilon
                optsol(j-1) = round(optsol(j-1));
            end
        end
    end
end

fprintf('\n');
solSet.table = t;
solSet.basic_sequence = basic_sequence;
solSet.optsol = optsol;
solSet.iteration = iteration;
solSet.state = 'optimal';
end