function so3 = so3LieGroup2LieAlgebra(SO3)
    theta = acos(0.5 * (trace(SO3)-1));
%     a_hat = (SO3 - SO3') / (2 * sin(theta));
%     a = extractAntiSymmetricElements(a_hat);
    if abs(theta) < 1e-5  % 當 theta 非常小時
        % 當旋轉角度非常小時，a_hat 近似為零矩陣
        a_hat = zeros(3, 3);
        a = [0; 0; 0];  % 將 a 設為零向量
    elseif pi - abs(theta) < 1e-5
%         [V, D] = eig(SE3(1:3, 1:3));
%         [row, col] = find(abs(D - 1) <= eps);
%         a = V(:, col);
%         a_hat = vectorToAntiSymmetricMatrix(a);
        [~, D, W] = eig(SE3(1:3, 1:3));
        eigenvalue = diag(real(D));
        index = abs(eigenvalue - 1) < 1e-5;
        a = W(:, index);
        a_hat = vectorToAntiSymmetricMatrix(a);
    else
        % 正常情況下計算 a_hat 和 a
        a_hat = (SO3 - SO3') / (2 * sin(theta));
        a = extractAntiSymmetricElements(a_hat);
    end
    so3 = theta * a;
end