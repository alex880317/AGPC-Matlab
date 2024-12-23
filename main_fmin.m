clear; clc; close all;

addpath("plotFunction/");


%% main------------------------------------------------------------------------------------
%% para set
% 參數設定
max_iterations = 100;   % 最大迭代次數
tolerance = 1e-4;       % 終止條件的容忍度

% 儲存每次迭代的狀態變數和殘差
global residual_history r1_history r2_history r3_history x_history;
residual_history = [];
r1_history = [];
r2_history = [];
r3_history = [];
x_history = [];


%% initial value
% 參考法向量與距離
measuredNormal = roty(1) * rotx(1) * [0; 0; 1];  % 地面法向量 (參考)
measuredDistance = 0.12;        % 參考的地面距離
measurement = [measuredNormal; measuredDistance];

% 初始化位姿
R_k = roty(2) * rotx(0);
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


%% optimal
% 設置 fmincon 選項，將 measurement 傳遞給 outputFcn
options = optimoptions('fmincon', 'OutputFcn', @(x,optimValues,state) outputFcn(x, optimValues, state, measurement), ...
                       'Display', 'iter', 'MaxIterations', max_iterations, 'TolFun', tolerance, 'Algorithm', 'sqp', ...
                       'GradObj', 'off');

% 調用 fmincon 進行優化
[x, fval, exitflag, output, lamda, grad, hessian] = fmincon(@(x) compute_cost(compute_residual(x, measurement)) ...
                                                            , se3_normalized, [], [], [], [], [], [], [], options);

% % 顯示優化後的位姿
% disp('優化後的位姿：');
% disp(x);
% 
% % 顯示所有的殘差歷史
% disp('所有迭代中的殘差平方和歷史：');
% disp(residual_history);
%% ----------------------------------------------------------------------------------------





%% draw
% 繪製殘差 r1, r2, r3 和殘差平方和的圖
iterations = 1:length(residual_history);
f1 = figure(1);
plot(iterations, abs(r1_history), '-r', 'DisplayName', 'r1', 'LineWidth', 2); hold on;
plot(iterations, abs(r2_history), '-g', 'DisplayName', 'r2', 'LineWidth', 2);
plot(iterations, abs(r3_history), '-b', 'DisplayName', 'r3', 'LineWidth', 2);
plot(iterations, residual_history, '--k', 'DisplayName', 'Residual Sum of Squares', 'LineWidth', 2);
plot_set_size(f1.Children, 15, 25, 20, 20, 2);
plot_set_text(f1.Children, "Residuals and Residual Sum of Squares", ...
              {"Iteration", "Residual Value"}, "show");
grid on;


% 繪製每次迭代中的狀態變數 x 的歷史變化
f2 = figure(2);
plot(iterations, x_history, '-o', 'LineWidth', 2);
plot_set_size(f2.Children, 15, 25, 20, 20, 2);
plot_set_text(f2.Children, "State Variable (x) Over Iterations", ...
              {"Iteration", "State Variable x"}, {'x1','x2','x3','x4','x5','x6'});
grid on;
















%% suport function
% 定義輸出函數來顯示每次迭代的殘差和記錄狀態變數
function stop = outputFcn(x, optimValues, state, measurement)
    global residual_history r1_history r2_history r3_history x_history;
    
    % 計算殘差
    residual = compute_residual(x, measurement);
    
    % 分別計算 r1, r2, r3
    r1 = residual(1);  % 第一個殘差分量
    r2 = residual(2);  % 第二個殘差分量
    r3 = residual(3);  % 第三個殘差分量
    
    % 儲存 r1, r2, r3 的歷史記錄
    r1_history = [r1_history; r1];
    r2_history = [r2_history; r2];
    r3_history = [r3_history; r3];
    
    % change to eular angle and translation
    SE3 = se3LieAlgebra2LieGroup(x);
    eul = rotm2eul(SE3(1:3, 1:3));
    x_star = [SE3(1:3, 4)', eul];

    % 儲存當前狀態變數 x 的歷史
    x_history = [x_history; x_star];
    
    % 計算殘差平方和
    cost = sum(residual.^2);
    
    % 儲存殘差平方和到歷史記錄
    residual_history = [residual_history; cost];
    
    % % 顯示每個殘差分量和平方和
    % fprintf('迭代 %d, r1: %f, r2: %f, r3: %f, 殘差平方和: %f\n', ...
    %         optimValues.iteration, r1, r2, r3, cost);
    
    stop = false; % 繼續迭代
end
