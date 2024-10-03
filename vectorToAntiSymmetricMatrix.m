function A = vectorToAntiSymmetricMatrix(vector)
    % 確認 vector 是一個長度為 3 的向量
    if length(vector) ~= 3
        error('Input must be a vector of length 3.');
    end

    % 從向量中提取元素
    a1 = vector(1);
    a2 = vector(2);
    a3 = vector(3);

    % 構建 3x3 反對稱矩陣
    A = [  0   -a3    a2;
           a3    0   -a1;
          -a2   a1    0];
end