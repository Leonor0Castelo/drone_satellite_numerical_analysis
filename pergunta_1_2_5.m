%exercicio 1.2.5
%alínea a 

M=[1 1 1 1 1 ;
    -2 -1 0 1 2 ;
    2 0.5 0 0.5 2;
    -8 -1 0 1 8;
    16 1 0 1 16]
b=[0; 0; 1; 0; 0]
M_inv=inv(M)

A=rats(M_inv*b);
disp('Solução para [A_{0}, A_{1}, A_{2}, A_{3}, A_{4}]:')
disp(A)