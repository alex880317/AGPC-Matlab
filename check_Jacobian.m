clear;clc;
close all;

% 參考法向量與距離
Gx = 0;Gy = 0;Gz = 1;
Gk = [Gx; Gy; Gz];
measuredNormal = roty(1) * rotx(1) * Gk;  % 地面法向量 (參考)
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

input = [se3_normalized; measuredNormal];

j1 = d_tau_d_rho1(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9))
j2 = d_tau_d_rho2(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9))
j3 = d_tau_d_rho3(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9))
j4 = d_tau_d_phi1(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9))
j5 = d_tau_d_phi2(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9))
j6 = d_tau_d_phi3(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9))

J = [j1, j2, j3, j4, j5, j6]

H = compute_jacobian(se3_normalized, measurement)
