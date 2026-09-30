function [xprime, I_partes] = derivada_filtrada_4int(t, x, epsilon)
% [xprime, I_partes] = derivada_filtrada_4int(t, x, epsilon)
% Calcula a derivada aproximada x'(t) via convolução com g'_ε,
% separando os 4 integrais parciais, sem cortar células.
% I1 = -(∫_{y-2ε}^{y-ε}), I2 = -(∫_{y-ε}^{y}),
% I3 = -(∫_{y}^{y+ε}), I4 = -(∫_{y+ε}^{y+2ε})
% Entradas:
%   t -> vetor de nós igualmente espaçados
%   x -> valores da função x(t)
%   epsilon -> parâmetro ε
% Saídas:
%   xprime  -> soma dos 4 integrais em cada y
%   I_partes-> matriz N×4 com [I1 I2 I3 I4]
N = numel(t);
h = t(2) - t(1);             % passo (assume uniforme)
xprime = zeros(1, N);
I_partes = zeros(N, 4);

% g'_ε(x)
gprime_eps = @(u,eps) ...
    ((u >= 0) & (u < eps)).*(-2*u/eps^3 + 1.5*u.^2/eps^4) + ...
    ((u >= eps) & (u < 2*eps)).*(-(2*eps - u).^2 ./ (2*eps^4)) + ...
    ((u < 0) & (u > -eps)).*(-2*u/eps^3 - 1.5*u.^2/eps^4) + ...
    ((u <= -eps) & (u > -2*eps)).*((2*eps + u).^2 ./ (2*eps^4));
for k = 1:N
    y = t(k);
    I_local = zeros(1,4);
    lower = y - 2*epsilon;
    upper = y - epsilon;
    for j = 1:4
        I_temp = 0;
        % percorre pares [t(i), t(i+1)] completamente dentro do intervalo
        for i = 1:(N-1)
            if (t(i) >= lower) && (t(i+1) <= upper)
                f_i   = gprime_eps(t(i)   - y, epsilon) * x(i);
                f_ip1 = gprime_eps(t(i+1) - y, epsilon) * x(i+1);
                I_temp = I_temp+ h * (f_i + f_ip1) / 2;  % regra dos trapézios
            end
        end
        I_local(j) = I_temp;
        lower = lower + epsilon;
        upper = upper + epsilon;
    end

    I_partes(k,:) = I_local;
    xprime(k) = - sum(I_local);
end
end
