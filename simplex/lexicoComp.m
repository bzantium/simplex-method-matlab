function order = lexicoComp(t)
[nrow, ncol] = size(t);
index = 1:nrow;
order = 0;
for i = 1:ncol
    if sum(t(:,i) == min(t(:,i))) < 2
        order = index(t(:,i) == min(t(:,i)));
        break;
    else
        index = find(t(:,i) == min(t(:,i)));
        t = t(t(:,i) == min(t(:,i)), :);
    end
end

if order == 0
    order = randsample(index, 1);
end 
end

