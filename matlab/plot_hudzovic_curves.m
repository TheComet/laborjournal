close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

curves = hudzovic_curves();

figure;
subplot(211); grid on, hold on, grid minor
for k = 1:7
    plot(curves(k).r, curves(k).tu_tg, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}Tu / Tg');
title('\fontsize{16}Hudzovic Lookup');
axis square
subplot(212), grid on, hold on, grid minor
for k = 1:7
    plot(curves(k).r, curves(k).t_tg, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}1 / Tg');
axis square

% draw in an example lookup
subplot(211);
plot([0, 0.4], [0.1653, 0.1653], 'k--');
plot([0.4, 0.4], [0.1653, 0], 'k--');
subplot(212);
plot([0.4, 0.4], [0.4, 0.10735], 'k--');
plot([0.4, 0], [0.10735, 0.10735], 'k--');

