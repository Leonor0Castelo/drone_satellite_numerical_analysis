% definição de g
g = @(x) (abs(x)<1) .* (1/6).*(4 - 6*x.^2 + 3*abs(x).^3) + ...
         ((abs(x)>=1) & (abs(x)<2)) .* (1/6).*(2 - abs(x)).^3;

% definição da normal N(0, σ²)
Normal = @(x, sigma) (1./(sigma*sqrt(2*pi))) .* exp(-x.^2./(2*sigma.^2));

% intervalo de x
x = linspace(-4, 4, 2000);

% valores de ϵ e σ a comparar
epsilons = [-1000,-100,0.25, 0.5, 1, 2, 100, 1000];          % diferentes larguras do filtro
sigmas = [-1000,-100,0.25, 0.5, 1, 2, 100, 1000];            % desvios-padrão das normais

% g_\epsilon(x) para vários ϵ
figure('Color','w');
hold on; grid on;
for i = 1:length(epsilons)
    eps = epsilons(i);
    g_eps = (1/eps) * g(x/eps);
    plot(x, g_eps, 'LineWidth', 1.8, ...
        'DisplayName', sprintf('$g_{\\epsilon}(x)$, $\\epsilon = %.2f$', eps));
end
xlabel('$x$', 'Interpreter','latex');
ylabel('$g_{\\epsilon}(x)$', 'Interpreter','latex');
title('Filtros $g_{\\epsilon}(x)$ para diferentes valores de $\epsilon$', ...
      'Interpreter','latex');
legend('show','Location','best','Interpreter','latex','FontSize',11);
xlim([-4 4]);

% distribuições N(0, σ²) para vários σ
figure('Color','w');
hold on; grid on;
for i = 1:length(sigmas)
    sigma = sigmas(i);
    normal_vals = Normal(x, sigma);
    plot(x, normal_vals, '--', 'LineWidth', 1.8, ...
        'DisplayName', sprintf('$\\mathcal{N}(0, %.2f^2)$', sigma));
end
xlabel('$x$', 'Interpreter','latex');
ylabel('Distribuição normal em x', 'Interpreter','latex');
title('Distribuições normais $\mathcal{N}(0,\sigma^2)$ para diferentes valores de $\sigma$', ...
      'Interpreter','latex');
legend('show','Location','best','Interpreter','latex','FontSize',11);
xlim([-4 4]);