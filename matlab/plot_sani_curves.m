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
title('\fontsize{16}Sani Lookup');
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

