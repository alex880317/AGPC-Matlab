clear; clc; close all;

% 參數設定
max_iterations = 1;   % 最大迭代次數
tolerance = 1e-6;       % 終止條件的容忍度

% 參考法向量與距離
measuredNormal = roty(1) * rotx(1) * [0; 0; 1];  % 地面法向量 (參考)
measuredDistance = 0.12;        % 參考的地面距離
measurement = [measuredNormal; measuredDistance];

% 初始化位姿
R_k = roty(2) * rotx(2);
t_k = [10, 10, 5]';
pose = [R_k, t_k; 0, 0, 0, 1];

se3 = se3LieGroup2LieAlgebra(pose);

% 定義尺度因子
scale_translation = 1; % 將平移項縮放到 1/10 的大小
scale_rotation = 1;    % 旋轉項保持不變

% 對平移和旋轉項分別進行標準化
se3_normalized = se3; % 初始化標準化後的向量
se3_normalized(1:3) = se3(1:3) * scale_translation; % 平移項縮放
se3_normalized(4:6) = se3(4:6) * scale_rotation;    % 旋轉項保持不變


for iter = 1:max_iterations


    H = compute_jacobian(se3_normalized, measurement);

    r = compute_residual(se3_normalized, measurement);


    singular_values = svd(H' * H); % 計算矩陣 A 的奇異值
    % disp(singular_values)
    % cond_number = cond(H' * H)
    
    % Gauss-Newton 步驟
    lambda = 1e-3; % 你可以根據具體情況調整 lambda 的值
    H_regularized = H' * H + lambda * eye(size(H, 2));
    delta_pose = -H_regularized \ (H' * r);
    % delta_pose = -(H' * H) \ (H' * r);

    delta_se3 = [0; 0; delta_pose];

    delta_SE3 = se3LieAlgebra2LieGroup(delta_se3);

    SE3 = se3LieAlgebra2LieGroup(se3_normalized);

    delta_SE3(1, 4) = 0;delta_SE3(2, 4) = 0; % 固定xy位置

    % 更新位姿
    SE3 = SE3 * delta_SE3

    se3_normalized = se3LieGroup2LieAlgebra(SE3);

    % 檢查終止條件
    if norm(delta_pose) < tolerance
        disp(['迭代結束於步驟：', num2str(iter)]);
        break;
    end
end

% 逆標準化
se3_unnormalized = se3_normalized;
se3_unnormalized(1:3) = se3_normalized(1:3) / scale_translation; % 恢復平移項
se3_unnormalized(4:6) = se3_normalized(4:6) / scale_rotation;    % 恢復旋轉項

SE3_opt = se3LieAlgebra2LieGroup(se3_unnormalized);



disp('優化後的位姿：');
disp(SE3_opt);


