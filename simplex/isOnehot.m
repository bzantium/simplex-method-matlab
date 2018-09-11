function index = isOnehot(t, icol)
epsilon=1e-8;
sum = 0;
nrow = size(t,1);
for i=2:nrow
    if abs(t(i, icol)) < epsilon
        continue;
    elseif abs(t(i, icol) - 1) < epsilon
        sum = sum + 1;
        index = i - 1;
    else
        index = 0;
        return;
    end
end

if sum > 1
    index = 0;
end
end