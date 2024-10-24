

C = compute_cost(compute_residual(se3_normalized, measurement))

r = compute_residual(se3_normalized, measurement)




J = compute_jacobian(se3_normalized, measurement)

% input = [se3_normalized; measuredNormal];
% 
% j1 = d_tau_d_rho1(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9));
% j2 = d_tau_d_rho2(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9));
% j3 = d_tau_d_rho3(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9));
% j4 = d_tau_d_phi1(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9));
% j5 = d_tau_d_phi2(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9));
% j6 = d_tau_d_phi3(input(1), input(2), input(3), input(4), input(5), input(6), input(7), input(8), input(9));
% 
% J = [j1, j2, j3, j4, j5, j6]





2 * r(1) * J(1, 4) + 2 * r(2) * J(2, 4) + 2 * r(3) * J(3, 4) 