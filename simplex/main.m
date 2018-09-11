t = importdata('./data/ex3_14.txt', ' ');
epsilon = 1e-8;
mode = 'SSR';
[nrow, ncol] = size(t);
for i=2:nrow
    if t(i, 1) < 0
        t(i,:) = -t(i,:);
   end
end

canonical = isCanonical(t);

if ~canonical
    disp('Given table is not canonical form!');
    cfset = getCanonical(t, mode);
    if strcmp(cfset.state, 'none')
        return;
    end
    
    t = cfset.table;
else
    disp('Given table is canonical form!');
    fprintf('\n');
end
[nrow, ncol] = size(t);
initial_bfs = zeros(1, ncol-1);

for j=2:ncol
    if abs(t(1,j)) < epsilon
        for i=2:nrow
            if abs(t(i,j) - 1) < epsilon
                initial_bfs(j-1) = t(i,1);
            end
        end
    end
end

solSet = simplex(t, mode);

if ~strcmp(solSet.state, 'optimal')
    return;
end
disp('optimal solution:');
disp(solSet.optsol);
disp('Optimal Solution Obtained!');