z = @(x,y) 0.5*x + 0.3*y + 2*sin(x/5) + 3*cos(y/2) + 0.35*sin(12*x/5).*cos(8*y) + 0.1*sin(10*x).*sin(40*y);
w2 = @(x,y) 1;
f1 = @(x,y) z(x,y) + x;  
w1 = @(x,y) (1/12*x.^2 - (11/6)*x + 20);
f2 = @(x,y) z(x,y) + 10;   

% Base de polinómios
p = {@(x,y) ones(size(x)), @(x,y) x, @(x,y) y, @(x,y) x.^2, @(x,y) x.*y, @(x,y) y.^2, ...
     @(x,y) x.^3, @(x,y) x.^2.*y, @(x,y) x.*y.^2, @(x,y) y.^3};
n = numel(p);

% Sistema linear sem condições iniciais
A = zeros(n);
b = zeros(n,1);

for i = 1:n
    for j = 1:n
        integral_1 = integral2(@(x,y) w1(x,y).*p{i}(x,y).*p{j}(x,y), 0,12,0,7);
        integral_2 = integral2(@(x,y) w2(x,y).*p{i}(x,y).*p{j}(x,y), 12,15,7,10);
        A(i,j) = integral_1 + integral_2;
    end
    Q1 = integral2(@(x,y) w1(x,y).*f1(x,y).*p{i}(x,y), 0,12,0,7);
    Q2 = integral2(@(x,y) w2(x,y).*f2(x,y).*p{i}(x,y), 12,15,7,10);
    b(i) = Q1 + Q2;
end

% CONDIÇÕES iniciais
x1 = 0;  y1 = 0;  val1 = z(x1,y1);        % p(0,0) = z(0,0)
x2 = 12; y2 = 7;  val2 = z(x2,y2) + 10;   % p(12,7) = z(12,7) + 10

% Matriz das condições
C = [1 x1 y1 x1^2 x1*y1 y1^2 x1^3 x1^2*y1 x1*y1^2 y1^3;
     1 x2 y2 x2^2 x2*y2 y2^2 x2^3 x2^2*y2 x2*y2^2 y2^3];
d = [val1; val2];

% Método dos multiplicadores de Lagrange
A_aug = [A, C'; C, zeros(2)];
b_aug = [b; d];
sol = A_aug \ b_aug;
a = sol(1:10);
lambda = sol(11:12);
% Polinómio final
p_final = @(x,y) a(1) + a(2)*x + a(3)*y + a(4)*x.^2 + a(5)*x.*y + a(6)*y.^2 + ...
                 a(7)*x.^3 + a(8)*x.^2.*y + a(9)*x.*y.^2 + a(10)*y.^3;

fprintf('Coeficientes obtidos:\n');
disp(a.');
fprintf('\nVerificação das condições:\n');
fprintf('p(0,0) = %.6f (deveria ser %.6f)\n', p_final(0,0), z(0,0));
fprintf('p(12,7) = %.6f (deveria ser %.6f)\n', p_final(12,7), z(12,7)+10);

% GRÁFICOS
figure('Position', [100, 100, 1200, 500]);
% Gráfico 1: Região 1 - p(x,y) vs z(x,y)+x
subplot(1,2,1);
[x1, y1] = meshgrid(linspace(0, 12, 40), linspace(0, 7, 40));
z_target1 = f1(x1, y1);    % z(x,y) + x
p_vals1 = p_final(x1, y1);

surf(x1, y1, z_target1, 'FaceAlpha', 0.7, 'EdgeColor', 'none', 'FaceColor', 'b');
hold on;
surf(x1, y1, p_vals1, 'FaceAlpha', 0.7, 'EdgeColor', 'none', 'FaceColor', 'r');
plot3(0, 0, p_final(0,0), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
plot3(12, 7, p_final(12,7), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
title('Região 1: x∈[0,12], y∈[0,7]');
xlabel('x'); ylabel('y'); zlabel('Altura');
legend('z(x,y)+x', 'p(x,y)', 'Condições contorno', 'Location', 'best');
view(45, 30); grid on;

% Gráfico 2: Região 2 - p(x,y) vs z(x,y)+10
subplot(1,2,2);
[x2, y2] = meshgrid(linspace(12, 15, 30), linspace(7, 10, 30));
z_target2 = f2(x2, y2);    % z(x,y) + 10
p_vals2 = p_final(x2, y2);

surf(x2, y2, z_target2, 'FaceAlpha', 0.7, 'EdgeColor', 'none', 'FaceColor', 'b');
hold on;
surf(x2, y2, p_vals2, 'FaceAlpha', 0.7, 'EdgeColor', 'none', 'FaceColor', 'r');
plot3(12, 7, p_final(12,7), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
title('Região 2: x∈[12,15], y∈[7,10]');
xlabel('x'); ylabel('y'); zlabel('Altura');
legend('z(x,y)+10', 'p(x,y)', 'Condição contorno', 'Location', 'best');
view(45, 30); grid on;
