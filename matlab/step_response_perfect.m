close all, clear all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

% Generate a "perfect" step response curve
yoffset = 22;
Ks = 37 - yoffset;
G = yoffset + Ks * hudzovic_transfer_function(1, 0.1, 4);
[ydata, xdata] = step(G);
% normalise Y data
ydata = ydata - ydata(1);
ydata = ydata / ydata(end);

[g_hudzovic_tu_tg, g_hudzovic_t3, g_sani_t3, g_sani_tu_tg, g_hudzovic_fit, g_sani_fit]...
    = all_step_responses(Ks, yoffset, xdata, ydata);

figure; hold on, grid on, grid minor
scatter(xdata, yoffset + Ks * ydata);
plot(xdata, g_hudzovic_tu_tg);
plot(xdata, g_hudzovic_t3);
plot(xdata, g_sani_tu_tg);
plot(xdata, g_sani_t3);
plot(xdata, g_hudzovic_fit);
plot(xdata, g_sani_fit);
legend('Original data', 'Hudzovic Tu/Tg', 'Hudzovic t10/t50/t90', 'Sani Tu/Tg', 'Sani t10/t50/t90', 'Hudzovic fit', 'Sani fit');
