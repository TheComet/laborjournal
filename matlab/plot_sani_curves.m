close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

curves = sani_curves();

figure;
subplot(211); grid on, hold on, grid minor
for k = 1:7
    plot(curves(k).r, curves(k).tu_tg, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}Tu / Tg');
title('\fontsize{16}Sani Lookup, Tu / Tg');
axis square
legend('n=2', 'n=3', 'n=4', 'n=5', 'n=6', 'n=7', 'n=8', 'Location', 'northwest');
subplot(212), grid on, hold on, grid minor
for k = 1:7
    plot(curves(k).r, curves(k).t_tg, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}1 / Tg');
axis square

% draw in an example lookup
subplot(211);
plot([0, 0.9], [0.3169, 0.3169], 'k--');
plot([0.9, 0.9], [0.3169, 0], 'k--');
subplot(212);
plot([0.9, 0.9], [1, 0.26], 'k--');
plot([0.9, 0], [0.26, 0.26], 'k--');

figure;
subplot(211); hold on, grid on, grid minor
r = linspace(0, 1);
for k = 2:8
    lambda = (1.315*sqrt(3.8 * (1-r.^(2*k))./(1-r.^2) - 1)) ./ (log(2) - 1 + (1-r.^k)./(1-r));
    plot(r, lambda, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}lambda (\lambda)');
title('\fontsize{16}Sani Lookup, t10 / t50 / t90');
axis square
legend('n=2', 'n=3', 'n=4', 'n=5', 'n=6', 'n=7', 'n=8', 'Location', 'northeast');
subplot(212); hold on, grid on, grid minor
for k = 2:8
    t_t50 = 1 ./ (log(2) - 1 + (1-r.^k)./(1-r));
    plot(r, t_t50, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}1 / t50');
axis square

% draw in an example lookup
subplot(211);
plot([0, 0.8], [1.6062, 1.6062], 'k--');
plot([0.8, 0.8], [1.6062, 0.5], 'k--');
subplot(212);
plot([0.8, 0.8], [1.5, 0.4688], 'k--');
plot([0.8, 0], [0.4688, 0.4688], 'k--');
