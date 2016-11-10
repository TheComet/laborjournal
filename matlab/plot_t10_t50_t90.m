close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

s = tf('s');
G = 1.4 + 5/(1+s)^2/(1+0.5*s)/(1+0.4*s);
[y, t] = step(G);

[t10, t50, t90] = characterise_curve(t, y);
y10 = spline(t, y, t10);
y50 = spline(t, y, t50);
y90 = spline(t, y, t90);

plot(t, y, 'LineWidth', 2); hold on, grid on
plot(t10, y10,'r.','MarkerSize',50);
plot(t50, y50,'r.','MarkerSize',50);
plot(t90, y90,'r.','MarkerSize',50);
plot([0,t10], [y10,y10], 'k--', 'LineWidth', 2);
plot([t10,t10], [y10,1], 'k--', 'LineWidth', 2);
plot([0,t50], [y50,y50], 'k--', 'LineWidth', 2);
plot([t50,t50], [y50,1], 'k--', 'LineWidth', 2);
plot([0,t90], [y90,y90], 'k--', 'LineWidth', 2);
plot([t90,t90], [y90,1], 'k--', 'LineWidth', 2);

axis square
xlabel('\fontsize{14}Time');
ylabel('\fontsize{14}Amplitude');
title('\fontsize{16}Method of Sani: Tu / Tg');
