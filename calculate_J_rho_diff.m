function J_rho_diff = calculate_J_rho_diff(rho, so3)

    % 計算三個 sigma_phi 向量
    sig_phi1 = calculate_sigma_phi1(rho(1), rho(2), rho(3), so3(1), so3(2), so3(3));
    sig_phi2 = calculate_sigma_phi2(rho(1), rho(2), rho(3), so3(1), so3(2), so3(3));
    sig_phi3 = calculate_sigma_phi3(rho(1), rho(2), rho(3), so3(1), so3(2), so3(3));

    % 構建 J_rho_diff 矩陣
    J_rho_diff = [sig_phi1(1), sig_phi2(1), sig_phi3(1);
                  sig_phi1(2), sig_phi2(2), sig_phi3(2);
                  sig_phi1(3), sig_phi2(3), sig_phi3(3)];
end

% 計算 sigma_phi1
function result = calculate_sigma_phi1(rho1, rho2, rho3, phi1, phi2, phi3)

    epsilon = 1e-10; % 防止數值不穩定

    % 計算 sigma_17
    sigma17 = abs(phi1)^2 + abs(phi2)^2 + abs(phi3)^2;
    safe_sigma17 = max(sigma17, epsilon); % 用 epsilon 防止 sigma17 為 0

    % 計算 sigma_1 到 sigma_16
    sigma13 = cos(sqrt(safe_sigma17)) - 1;
    sigma14 = (sin(sqrt(safe_sigma17)) / sqrt(safe_sigma17)) - 1;

    sigma1 = (2 * phi3 * abs(phi1) * sign(phi1) * sigma13) / safe_sigma17^2;
    sigma2 = (2 * phi2 * abs(phi1) * sign(phi1) * sigma13) / safe_sigma17^2;
    sigma3 = (2 * phi1 * abs(phi1) * sign(phi1) * sigma13) / safe_sigma17^2;
    sigma4 = (phi3 * sin(sqrt(safe_sigma17)) * abs(phi1) * sign(phi1)) / safe_sigma17^1.5;
    sigma5 = (phi2 * sin(sqrt(safe_sigma17)) * abs(phi1) * sign(phi1)) / safe_sigma17^1.5;
    sigma6 = (phi1 * sin(sqrt(safe_sigma17)) * abs(phi1) * sign(phi1)) / safe_sigma17^1.5;
    sigma7 = (2 * phi2 * phi3 * abs(phi1) * sign(phi1) * sigma14) / safe_sigma17^2;
    sigma8 = (2 * phi1 * phi3 * abs(phi1) * sign(phi1) * sigma14) / safe_sigma17^2;
    sigma9 = (2 * phi1 * phi2 * abs(phi1) * sign(phi1) * sigma14) / safe_sigma17^2;
    sigma15 = (sin(sqrt(safe_sigma17)) * abs(phi1) * sign(phi1)) / safe_sigma17^1.5;
    sigma16 = (cos(sqrt(safe_sigma17)) * abs(phi1) * sign(phi1)) / safe_sigma17;
    sigma10 = (phi2 * phi3 * (sigma16 - sigma15)) / safe_sigma17;
    sigma11 = (phi1 * phi3 * (sigma16 - sigma15)) / safe_sigma17;
    sigma12 = (phi1 * phi2 * (sigma16 - sigma15)) / safe_sigma17;

    % 計算向量結果
    result(1) = rho3 * (sigma5 - sigma11 - (phi3 * sigma14) / safe_sigma17 + sigma2 + sigma8) ...
              - rho2 * ((phi2 * sigma14) / safe_sigma17 + sigma12 + sigma4 + sigma1 - sigma9) ...
              - rho1 * ((phi1^2 * (sigma16 - sigma15)) / safe_sigma17 + (2 * phi1 * sigma14) / safe_sigma17 - sigma16 + sigma15 - (2 * phi1^2 * abs(phi1) * sign(phi1) * sigma14) / safe_sigma17^2);

    result(2) = rho1 * (sigma4 - sigma12 - (phi2 * sigma14) / safe_sigma17 + sigma1 + sigma9) ...
              - rho2 * ((phi2^2 * (sigma16 - sigma15)) / safe_sigma17 - sigma16 + sigma15 - (2 * phi2^2 * abs(phi1) * sign(phi1) * sigma14) / safe_sigma17^2) ...
              - rho3 * (sigma10 - (sigma13 / safe_sigma17) + sigma6 + sigma3 - sigma7);

    result(3) = rho2 * (sigma6 - sigma10 - (sigma13 / safe_sigma17) + sigma3 + sigma7) ...
              - rho3 * ((phi3^2 * (sigma16 - sigma15)) / safe_sigma17 - sigma16 + sigma15 - (2 * phi3^2 * abs(phi1) * sign(phi1) * sigma14) / safe_sigma17^2) ...
              - rho1 * ((phi3 * sigma14) / safe_sigma17 + sigma11 + sigma5 + sigma2 - sigma8);
end


% 計算 sigma_phi2
function result = calculate_sigma_phi2(rho1, rho2, rho3, phi1, phi2, phi3)

    epsilon = 1e-10; % 防止數值不穩定

    % 計算 sigma_17
    sigma17 = abs(phi1)^2 + abs(phi2)^2 + abs(phi3)^2;
    safe_sigma17 = max(sigma17, epsilon); % 用 epsilon 防止 sigma17 為 0

    % 計算 sigma_1 到 sigma_16
    sigma13 = cos(sqrt(safe_sigma17)) - 1;
    sigma14 = (sin(sqrt(safe_sigma17)) / sqrt(safe_sigma17)) - 1;

    sigma1 = (2 * phi3 * abs(phi2) * sign(phi2) * sigma13) / safe_sigma17^2;
    sigma2 = (2 * phi2 * abs(phi2) * sign(phi2) * sigma13) / safe_sigma17^2;
    sigma3 = (2 * phi1 * abs(phi2) * sign(phi2) * sigma13) / safe_sigma17^2;
    sigma4 = (phi3 * sin(sqrt(safe_sigma17)) * abs(phi2) * sign(phi2)) / safe_sigma17^1.5;
    sigma5 = (phi2 * sin(sqrt(safe_sigma17)) * abs(phi2) * sign(phi2)) / safe_sigma17^1.5;
    sigma6 = (phi1 * sin(sqrt(safe_sigma17)) * abs(phi2) * sign(phi2)) / safe_sigma17^1.5;
    sigma7 = (2 * phi2 * phi3 * abs(phi2) * sign(phi2) * sigma14) / safe_sigma17^2;
    sigma8 = (2 * phi1 * phi3 * abs(phi2) * sign(phi2) * sigma14) / safe_sigma17^2;
    sigma9 = (2 * phi1 * phi2 * abs(phi2) * sign(phi2) * sigma14) / safe_sigma17^2;
    sigma15 = (sin(sqrt(safe_sigma17)) * abs(phi2) * sign(phi2)) / safe_sigma17^1.5;
    sigma16 = (cos(sqrt(safe_sigma17)) * abs(phi2) * sign(phi2)) / safe_sigma17;
    sigma10 = (phi2 * phi3 * (sigma16 - sigma15)) / safe_sigma17;
    sigma11 = (phi1 * phi3 * (sigma16 - sigma15)) / safe_sigma17;
    sigma12 = (phi1 * phi2 * (sigma16 - sigma15)) / safe_sigma17;

    % 計算向量結果
    result(1) = rho3 * (sigma5 - sigma11 - (sigma13 / safe_sigma17) + sigma2 + sigma8) ...
              - rho1 * ((phi1^2 * (sigma16 - sigma15)) / safe_sigma17 - sigma16 + sigma15 - (2 * phi1^2 * abs(phi2) * sign(phi2) * sigma14) / safe_sigma17^2) ...
              - rho2 * ((phi1 * sigma14) / safe_sigma17 + sigma12 + sigma4 + sigma1 - sigma9);

    result(2) = rho1 * (sigma4 - sigma12 - (phi1 * sigma14) / safe_sigma17 + sigma1 + sigma9) ...
              - rho3 * ((phi3 * sigma14) / safe_sigma17 + sigma10 + sigma6 + sigma3 - sigma7) ...
              - rho2 * ((phi2^2 * (sigma16 - sigma15)) / safe_sigma17 + (2 * phi2 * sigma14) / safe_sigma17 - sigma16 + sigma15 - (2 * phi2^2 * abs(phi2) * sign(phi2) * sigma14) / safe_sigma17^2);

    result(3) = rho2 * (sigma6 - sigma10 - (phi3 * sigma14) / safe_sigma17 + sigma3 + sigma7) ...
              - rho3 * ((phi3^2 * (sigma16 - sigma15)) / safe_sigma17 - sigma16 + sigma15 - (2 * phi3^2 * abs(phi2) * sign(phi2) * sigma14) / safe_sigma17^2) ...
              - rho1 * (sigma11 - sigma13 / safe_sigma17 + sigma5 + sigma2 - sigma8);
end


% 計算 sigma_phi3
function result = calculate_sigma_phi3(rho1, rho2, rho3, phi1, phi2, phi3)

    epsilon = 1e-10; % 防止數值不穩定

    % 計算 sigma_17
    sigma17 = abs(phi1)^2 + abs(phi2)^2 + abs(phi3)^2;
    safe_sigma17 = max(sigma17, epsilon); % 用 epsilon 防止 sigma17 為 0

    % 計算 sigma_1 到 sigma_16
    sigma13 = cos(sqrt(safe_sigma17)) - 1;
    sigma14 = (sin(sqrt(safe_sigma17)) / sqrt(safe_sigma17)) - 1;

    sigma1 = (2 * phi3 * abs(phi3) * sign(phi3) * sigma13) / safe_sigma17^2;
    sigma2 = (2 * phi2 * abs(phi3) * sign(phi3) * sigma13) / safe_sigma17^2;
    sigma3 = (2 * phi1 * abs(phi3) * sign(phi3) * sigma13) / safe_sigma17^2;
    sigma4 = (phi3 * sin(sqrt(safe_sigma17)) * abs(phi3) * sign(phi3)) / safe_sigma17^1.5;
    sigma5 = (phi2 * sin(sqrt(safe_sigma17)) * abs(phi3) * sign(phi3)) / safe_sigma17^1.5;
    sigma6 = (phi1 * sin(sqrt(safe_sigma17)) * abs(phi3) * sign(phi3)) / safe_sigma17^1.5;
    sigma7 = (2 * phi2 * phi3 * abs(phi3) * sign(phi3) * sigma14) / safe_sigma17^2;
    sigma8 = (2 * phi1 * phi3 * abs(phi3) * sign(phi3) * sigma14) / safe_sigma17^2;
    sigma9 = (2 * phi1 * phi2 * abs(phi3) * sign(phi3) * sigma14) / safe_sigma17^2;
    sigma15 = (sin(sqrt(safe_sigma17)) * abs(phi3) * sign(phi3)) / safe_sigma17^1.5;
    sigma16 = (cos(sqrt(safe_sigma17)) * abs(phi3) * sign(phi3)) / safe_sigma17;
    sigma10 = (phi2 * phi3 * (sigma16 - sigma15)) / safe_sigma17;
    sigma11 = (phi1 * phi3 * (sigma16 - sigma15)) / safe_sigma17;
    sigma12 = (phi1 * phi2 * (sigma16 - sigma15)) / safe_sigma17;

    % 計算向量結果
    result(1) = rho3 * (sigma5 - sigma11 - (phi1 * sigma14) / safe_sigma17 + sigma2 + sigma8) ...
              - rho1 * (phi1^2 * (sigma16 - sigma15) / safe_sigma17 - sigma16 + sigma15 - (2 * phi1^2 * abs(phi3) * sign(phi3) * sigma14) / safe_sigma17^2) ...
              - rho2 * (sigma12 - (sigma13 / safe_sigma17) + sigma4 + sigma1 - sigma9);

    result(2) = rho1 * (sigma4 - sigma12 - (sigma13 / safe_sigma17) + sigma1 + sigma9) ...
              - rho2 * (phi2^2 * (sigma16 - sigma15) / safe_sigma17 - sigma16 + sigma15 - (2 * phi2^2 * abs(phi3) * sign(phi3) * sigma14) / safe_sigma17^2) ...
              - rho3 * ((phi2 * sigma14) / safe_sigma17 + sigma10 + sigma6 + sigma3 - sigma7);

    result(3) = rho2 * (sigma6 - sigma10 - (phi2 * sigma14) / safe_sigma17 + sigma3 + sigma7) ...
              - rho1 * ((phi1 * sigma14) / safe_sigma17 + sigma11 + sigma5 + sigma2 - sigma8) ...
              - rho3 * (phi3^2 * (sigma16 - sigma15) / safe_sigma17 + (2 * phi3 * sigma14) / safe_sigma17 - sigma16 + sigma15 - (2 * phi3^2 * abs(phi3) * sign(phi3) * sigma14) / safe_sigma17^2);
end

