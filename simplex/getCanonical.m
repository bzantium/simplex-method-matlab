function cfset = getCanonical(t, mode)
epsilon = 1e-8;
[nrow, ncol] = size(t);
index = zeros(1, nrow-1);

cftable = zeros(nrow, ncol);

k = nrow - 1;
for j = 2:ncol
    if isOnehot(t, j)
        index(isOnehot(t, j)) = 1;
    end
end
k = k - sum(index);

table = zeros(nrow, ncol + k);

table(1,ncol+1:ncol+k) = 1;
table(2:nrow,1:ncol) = t(2:nrow,:);

P = eye(nrow);

for i=2:nrow
    if index(i-1) == 0
        P(1,i) = -1;
    end
end

for j= ncol+1:ncol+k
    for i = 2:nrow
        if index(i-1) == 0
            table(i,j) = 1;
            index(i-1) = 1;
            break;
        end
    end
end
disp(table);
table = P * table;
solSet = simplex(table, mode);

if solSet.state ~= 'optimal'
    cfset.table = table;
    cfset.no_artvar = 0;
    cfset.state = 'none';
    return;
end

% check whether or not the original system has a solution (if optimal value
% is non-zero, there is no solution for OP)
if abs(getOptimalValue(solSet.table)) > epsilon
    disp('There is no feasible solution!');
    fprintf('\n');
    cfset.table = table;
    cfset.no_artvar = 0;
    cfset.state = 'none';
    return;
end

% check degeneracy (if y is still in basic sequence, remove it)
for i=1:nrow-1
    if solSet.basic_sequence(i) >= ncol
        P = eye(nrow);
        for j=2:ncol
            if abs(solSet.table(i+1, j)) > epsilon
                P = assign(P, solSet.table, i+1, j);
                solSet.table = P * solSet.table;
                solSet.basic_sequence(i) = j-1;
                break;
            end
        end
    end
end

cftable(1,:) = t(1,:);
cftable(2:nrow, :) = solSet.table(2:nrow, 1:ncol);

% linearly dependent constraint check and remove
nrow_ = nrow;
k=0;
for i=2:nrow
    if norm(cftable(i-k,:)) < epsilon
        nrow_ = nrow_ - 1;
        cftable(i-k, :) = [];
        solSet.basic_sequence(i-k-1) = [];
        k = k + 1;
    end
end

for i=1:nrow_-1
    P = eye(nrow_);
    P = assign(P, cftable, i+1, solSet.basic_sequence(i)+1);
    cftable = P * cftable;
end

disp('get canonical form completely!');
cfset.table = cftable;
cfset.no_artvar = k;
cfset.state = 'canonical';
end

