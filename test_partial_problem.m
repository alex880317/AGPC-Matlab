clear;clc;
close all;

%% initial value
translation = [-0.359481, 0.005900, 0.009153];
rotation = rotz(0.001121) * roty(0.115173) * rotx(0.011755);

T = [rotation, translation';
     0, 0, 0,       1      ];

se3 = se3LieGroup2LieAlgebra(T);

measurement = [0.018081, -0.015533, 1.000000, 1.757799]';

theta = norm(se3(4:6));

r1 = [];r2 = [];r3 = [];


for i = -100:0.01:100
    se3(5) = theta * i;

    r = compute_residual(se3, measurement);

    r1 = [r1, r(1)];
    r2 = [r2, r(2)];
    r3 = [r3, r(3)];
end
