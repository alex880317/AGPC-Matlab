% function H = compute_jacobian(se3, measurement)
% 
%     measuredNormal = measurement(1:3);
% 
%     pose = se3LieAlgebra2LieGroup(se3);
% 
%     % pose 是一個 4x4 的同構變換矩陣 (SE3)
%     R_k_W = pose(1:3, 1:3); % 旋轉矩陣
%     t_k_W = pose(1:3, 4);   % 平移向量
% 
%     % 固定的法向量 (G_k)
%     G_k = measuredNormal / norm(measuredNormal); % 正規化的法向量
% 
%     % 計算法向量在世界坐標系中的表示
%     measuredNormal_W = R_k_W * G_k;
% 
%     % 計算 denominator
%     sqrt_term = sqrt(1 - (measuredNormal_W(3) * measuredNormal_W(3)) / (norm(measuredNormal_W)^2));
%     denominator = (norm(measuredNormal_W)^3) * sqrt_term;
% 
%     epsilon = 1e-6; % 避免分母為零的情況
%     if abs(denominator) < epsilon
%         H_left = [0, 0, 0, 0;
%                   0, 0, 0, 1];
%     else
%         H_left = [(measuredNormal_W(3) * measuredNormal_W(1)) / denominator, ...
%                   (measuredNormal_W(3) * measuredNormal_W(2)) / denominator, ...
%                   -((measuredNormal_W(1)^2 + measuredNormal_W(2)^2)) / denominator, ...
%                   0;
%                   0, 0, 0, 1];
%     end
% 
%     % 使用反對稱矩陣構建旋轉的雅可比
%     skew_RWGk = R_k_W * skew_symmetric(G_k);
% 
%     so3 = se3(4:6); % 提取旋轉部分
%     rho = se3(1:3);   % 提取平移部分
% 
%     % 提取旋轉軸 (單位向量)
%     a = so3 / norm(so3); % 單位旋轉軸向量
%     a_hat = skew_symmetric(a);
%     angle = norm(so3); % 旋轉角度 (弧度)
% 
%     % 計算 J (使用 Rodriguez 公式)
%     J = (sin(angle) / angle) * eye(3) + (1 - sin(angle) / angle) * (a * a') + ((1 - cos(angle)) / angle) * a_hat;
% 
%     J_rho_diff = calculate_J_rho_diff(rho, so3);
% 
%     % 初始化 H_right
%     H_right = zeros(4, 6);
%     % 計算 H_right
%     H_right(1:3, 1:3) = zeros(3, 3);
%     H_right(1:3, 4:6) = -skew_RWGk; % 上三行
%     H_right(4, 1:3) = (R_k_W * G_k)' * J; % 1x3
%     H_right(4, 4:6) = (J_rho_diff' * (R_k_W * G_k))' - (t_k_W' * skew_RWGk);
% 
%     % 計算最終的Jacobian
%     H = H_left * H_right;
% end
% 
% % 輔助函數：構建反對稱矩陣
% function S = skew_symmetric(v)
%     S = [  0,   -v(3),  v(2);
%           v(3),  0,    -v(1);
%          -v(2),  v(1),  0];
% end










































function H = compute_jacobian(se3, measurement)

    measuredNormal = measurement(1:3);

    pose = se3LieAlgebra2LieGroup(se3);

    % pose 是一個 4x4 的同構變換矩陣 (SE3)
    R_k_W = pose(1:3, 1:3); % 旋轉矩陣
    t_k_W = pose(1:3, 4);   % 平移向量

    % 固定的法向量 (G_k)
    G_k = measuredNormal / norm(measuredNormal); % 正規化的法向量

    % 計算法向量在世界坐標系中的表示
    measuredNormal_W = R_k_W * G_k;

    % 計算 denominator
    sqrt_term = sqrt(1 - (measuredNormal_W(3) * measuredNormal_W(3)) / (norm(measuredNormal_W)^2));
    denominator = (norm(measuredNormal_W)^3) * sqrt_term;

    epsilon = 1e-6; % 避免分母為零的情況
    if abs(denominator) < epsilon
        H_left = [0, 0, 0, 0;
                  0, 0, 0, 1];
    else
        H_left = [(measuredNormal_W(3) * measuredNormal_W(1)) / denominator, ...
                  (measuredNormal_W(3) * measuredNormal_W(2)) / denominator, ...
                  -((measuredNormal_W(1)^2 + measuredNormal_W(2)^2)) / denominator, ...
                  0;
                  0, 0, 0, 1];
    end

    % 使用反對稱矩陣構建旋轉的雅可比
    skew_RWGk = R_k_W * skew_symmetric(G_k);

    % 使用 GTSAM 中的 Logmap 相當於 MATLAB 的 logm 函數
    so3 = se3(4:6); % 提取旋轉部分
    rho = se3(1:3);   % 提取平移部分

    % 提取旋轉軸 (單位向量)
    a = so3 / norm(so3); % 單位旋轉軸向量
    a_hat = skew_symmetric(a);
    angle = norm(so3); % 旋轉角度 (弧度)

    % 計算 J (使用 Rodriguez 公式)
    J = (sin(angle) / angle) * eye(3) + (1 - sin(angle) / angle) * (a * a') + ((1 - cos(angle)) / angle) * a_hat;

    J_rho_diff = calculate_J_rho_diff(rho, so3);

    % 初始化 H_right
    H_right = zeros(4, 4);
    % 計算 H_right
    H_right(1:3, 1) = zeros(3, 1);
    H_right(1:3, 2:4) = -skew_RWGk; % 上三行
    H_right(4, 2:4) = (J_rho_diff' * (R_k_W * G_k))' - (t_k_W' * skew_RWGk);
    J_mid_term = (R_k_W * G_k)' * J;
    H_right(4, 1) = J_mid_term(3); % 1x3

    % 計算最終的Jacobian
    H = H_left * H_right;
end

% 輔助函數：構建反對稱矩陣
function S = skew_symmetric(v)
    S = [  0,   -v(3),  v(2);
          v(3),  0,    -v(1);
         -v(2),  v(1),  0];
end

