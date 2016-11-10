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
title('\fontsize{16}Hudzovic Lookup, Tu / Tg');
axis square
legend('n=2', 'n=3', 'n=4', 'n=5', 'n=6', 'n=7', 'n=8');

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

figure;
subplot(211); grid on, hold on, grid minor
for k = 1:7
    plot(curves(k).r, curves(k).lambda, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}lambda (\lambda)');
title('\fontsize{16}Hudzovic Lookup, t10 / t50 / t90');
axis square
legend('n=2', 'n=3', 'n=4', 'n=5', 'n=6', 'n=7', 'n=8', 'Location', 'southeast');

subplot(212); grid on, hold on, grid minor
for k = 1:7
    plot(curves(k).r, curves(k).t_t50, 'LineWidth', 2);
end
xlabel('\fontsize{14}Parameter  r');
ylabel('\fontsize{14}1 / t50');
axis square

% draw in an example lookup
subplot(211);
plot([0, 0.3479], [1.767, 1.767], 'k--');
plot([0.3479, 0.3479], [1.767, 0], 'k--');
subplot(212);
plot([0.3479, 0.3479], [0.6, 0.2007], 'k--');
plot([0.3479, 0], [0.2007, 0.2007], 'k--');

