function error_star = compute_residual(se3, measurement)
    
    measuredNormal = measurement(1:3);
    measuredDistance = measurement(4);

    pose = se3LieAlgebra2LieGroup(se3);
    
    % pose 是一個 4x4 的同構變換矩陣 (SE3)
    R_k_W = pose(1:3, 1:3); % 旋轉矩陣
    t_k_W = pose(1:3, 4);   % 平移向量

    % 固定的法向量 (G_k)
    G_k = measuredNormal / norm(measuredNormal); % 正規化的法向量

    % 計算法向量在世界坐標系中的表示
    measuredNormal_W = R_k_W * G_k;
    % measuredNormal_W = [0, 0, 1]';

    % 計算 tau_measured 的參數化
    theta = atan2(measuredNormal_W(2), measuredNormal_W(1)); % 方位角
    phi = acos(measuredNormal_W(3) / norm(measuredNormal_W(1:3))); % 俯仰角
    d_k_prime = measuredDistance + (t_k_W' * measuredNormal_W); % 距離項

    tau_measured = [theta; phi; d_k_prime]; % 參數化後的測量值

    % 初始參數化
    initialNormal = [0; 0; 1];
    initialDistance = 0.12;
    % initialDistance = 1.78;

    initial_theta = atan2(initialNormal(2), initialNormal(1));
    initial_phi = acos(initialNormal(3) / norm(initialNormal(1:3)));
    initial_d_k_prime = initialDistance;

    tau_initial = [initial_theta; initial_phi; initial_d_k_prime];

    % % 計算殘差
    % error = tau_measured - tau_initial;
    % 
    % % 返回 2 維的誤差向量
    % error_star = error(2:3); % 我們只取俯仰角和距離部分

    error_star = tau_measured - tau_initial;
end
