function SE3 = se3LieAlgebra2LieGroup(se3)
    theta = norm(se3(4:6));
%     a = se3(4:6) / theta;
%     a_hat = vectorToAntiSymmetricMatrix(a);
%     SO3 = cos(theta) * eye(3) + sin(theta) * a_hat + (1 - cos(theta)) * (a * a');
%     Jr = (sin(theta) / theta) * eye(3) + (1 - (sin(theta) / theta)) * (a * a') + ((1 - cos(theta)) / theta) * a_hat;
    if theta < 1e-5  % 當 theta 非常小時
        % 當旋轉非常小時，直接將 SO3 設為單位矩陣
        SO3 = eye(3);
        Jr = eye(3); % 將 Jr 設為單位矩陣
%     elseif pi - abs(theta) < 1e-5
%         
    else
        % 正常情況下計算 SO3 和 Jr
        a = se3(4:6) / theta;
        a_hat = vectorToAntiSymmetricMatrix(a);
        SO3 = cos(theta) * eye(3) + sin(theta) * a_hat + (1 - cos(theta)) * (a * a');
        Jr = (sin(theta) / theta) * eye(3) + (1 - (sin(theta) / theta)) * (a * a') + ((1 - cos(theta)) / theta) * a_hat;
    end
    SE3 = [SO3, Jr * se3(1:3); 0, 0, 0, 1];
end