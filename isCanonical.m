function output = isCanonical(t)
%ISCANONICAL 이 함수의 요약 설명 위치
%   자세한 설명 위치
[nrow, ncol] = size(t);
sequence = zeros(1, ncol - 1);
k = sum(t(1,2:ncol) == 0);

if k < nrow - 1
    output = false;
    return;
end


k = 1;

for j=2:ncol
    if t(1,j) == 0
        sequence(k) = isOnehot(t, j);
        k = k + 1;
    end
end

if size(unique(sequence), 2) >= nrow
    output = true;
else
    output = false;
end
end

