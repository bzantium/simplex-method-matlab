function P = assign(P, t, row, col)
%SIMPLEX 이 함수의 요약 설명 위치
%   자세한 설명 위치
nrow = size(P,1);
for i=1:nrow
    if i == row
        P(i,row) = 1/t(i,col);
    else
        P(i,row) = -t(i,col) / t(row,col);
    end
end

