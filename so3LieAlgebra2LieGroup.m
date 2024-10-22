function SO3 = so3LieAlgebra2LieGroup(so3)
    theta = norm(so3);
%     a = so3 / theta;
%     a_hat = vectorToAntiSymmetricMatrix(a);
%     SO3 = cos(theta) * eye(3) + sin(theta) * a_hat + (1 - cos(theta)) * (a * a');
    % if theta < 1e-5  % 當 theta 非常小時
    %     % 當旋轉角度非常小時，直接將 SO3 設為單位矩陣
    %     SO3 = eye(3);
    % else
    %     % 正常情況下計算 SO3
    %     a = so3 / theta;
    %     a_hat = vectorToAntiSymmetricMatrix(a);
    %     SO3 = cos(theta) * eye(3) + sin(theta) * a_hat + (1 - cos(theta)) * (a * a');
    % end

    SO3 = piecewise(theta < 1e-5, eye(3), ...
                theta >= 1e-5, cos(theta) * eye(3) + sin(theta) * vectorToAntiSymmetricMatrix(so3 / theta) + (1 - cos(theta)) * ((so3 / theta) * (so3 / theta)'));
end