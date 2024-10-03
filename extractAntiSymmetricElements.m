function elements = extractAntiSymmetricElements(A)
    % 確認 A 是一個 3x3 的矩陣
    if size(A, 1) ~= 3 || size(A, 2) ~= 3
        error('Input matrix must be 3x3.');
    end

    % 確認 A 是一個反對稱矩陣
    if ~isequal(A, -A')
        error('Input matrix must be anti-symmetric.');
    end

    % 提取反對稱矩陣中的元素，並存儲在一個向量中
    elements = [A(3, 2); A(1, 3); A(2, 1)];
end