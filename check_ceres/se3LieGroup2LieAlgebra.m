function se3 = se3LieGroup2LieAlgebra(SE3)
    theta = acos(0.5 * (trace(SE3(1:3, 1:3)) - 1));
%     a_hat = (SE3(1:3, 1:3) - SE3(1:3, 1:3)') / (2 * sin(theta));
%     a = extractAntiSymmetricElements(a_hat);
%     so3Jr = (sin(theta) / theta) * eye(3) + (1 - (sin(theta) / theta)) * (a * a') + ((1 - cos(theta)) / theta) * a_hat;
    % 處理 theta 非零和接近零的情況
    if abs(theta) < 1e-5% 當 theta 非常小時
        a_hat = zeros(3, 3); % 將 a_hat 設為零矩陣
        a = [0; 0; 0];       % 將 a 設為零向量
        so3Jr = eye(3);      % 將 so3Jr 設為單位矩陣
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
        so3Jr = (sin(theta) / theta) * eye(3) + (1 - (sin(theta) / theta)) * (a * a') + ((1 - cos(theta)) / theta) * a_hat;
    else
        % 正常情況下計算 a_hat 和 a
        a_hat = (SE3(1:3, 1:3) - SE3(1:3, 1:3)') / (2 * sin(theta));
        a = extractAntiSymmetricElements(a_hat);
        so3Jr = (sin(theta) / theta) * eye(3) + (1 - (sin(theta) / theta)) * (a * a') + ((1 - cos(theta)) / theta) * a_hat;
    end
    phi = theta * a;
    rho = inv(so3Jr) * SE3(1:3, 4);
    se3 = [rho; phi];
end