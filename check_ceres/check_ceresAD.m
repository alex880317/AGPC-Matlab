clear;clc;
close all;

R = rotz(15) * roty(30) * rotx(20);
t = [2, 5, 10]';
SE3 = [  R  ,  t  ;
       0, 0, 0, 1];

g = [1, 1, 1];
G = vectorToAntiSymmetricMatrix(g);

rightDisturbance = [  R  ,  -R * G ;
                    0, 0, 0, 0, 0, 0]

leftDisturbance = [  eye(3)  ,  -vectorToAntiSymmetricMatrix(R * G + t) ;
                    0, 0, 0, 0, 0, 0]


se3 = se3LieGroup2LieAlgebra(SE3)

R * g'

a = [0.1, 0.2, 0.3, 1.0, 2.0, 3.0]';
A = se3LieAlgebra2LieGroup(a)