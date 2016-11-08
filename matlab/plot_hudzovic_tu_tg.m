close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

s = tf('s');
G = 1.4 + 5/(1+s)^2/(1+0.5*s)/(1+0.4*s);
[y, t] = step(G);

[Tu, Tg] = normalise_curve(t, y);
ymin = min(y);
ymax = max(y);
int_top = {Tu + Tg, 6.4};
int_bottom = {Tu, 1.4};
int_dir = [Tu + Tg, 6.4] - [Tu, 1.4];
int_dir = int_dir/norm(int_dir);

plot(t, y, 'LineWidth', 2); hold on, grid on
plot(int_top{:},'r.','MarkerSize',50);
plot(int_bottom{:},'r.','MarkerSize',50);
plot([0, 10], [1.4, 1.4], 'k--', 'LineWidth', 2);
plot([0, 10], [6.4, 6.4], 'k--', 'LineWidth', 2);
x = [int_bottom{1} - int_dir(1), int_top{1} + int_dir(1)];
y = [int_bottom{2} - int_dir(2), int_top{2} + int_dir(2)];
plot(x, y, 'k--', 'LineWidth', 2);
axis square
xlabel('\fontsize{14}Time');
ylabel('\fontsize{14}Amplitude');
title('\fontsize{16}Method of Hudzovic: Tu / Tg');