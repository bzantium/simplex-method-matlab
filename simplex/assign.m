function P = assign(P, t, row, col)
nrow = size(P,1);
for i=1:nrow
    if i == row
        P(i,row) = 1/t(i,col);
    else
        P(i,row) = -t(i,col) / t(row,col);
    end
end

