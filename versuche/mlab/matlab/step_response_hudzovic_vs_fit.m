close all, clear all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

rand('state', 0);

% Load the step response of a heater directly from an image plot. We have
% to manually specify the offset and Y scale Ks.
yoffset = 22;
xtime = 10;
Ks = 37 - yoffset;

% generate transfer function and apply some noise on top
amp_rand = 0.2;
G = sani_transfer_function(1, 0.5, 4);
[ydata_orig, xdata_raw] = step(G);
ydata_orig = ydata_orig - ydata_orig(1);
ydata_orig = ydata_orig / ydata_orig(end);
ydata_raw = ydata_orig + amp_rand * (rand(length(ydata_orig),1)-0.5);

[xdata, ydata] = preprocess_curve(xdata_raw, ydata_raw);
[Tu, Tg] = characterise_curve(xdata, ydata);
[T, r, n] = hudzovic_lookup(Tu, Tg);
g_normal = step(hudzovic_transfer_function(T, r, n), xdata);
[T, r] = hudzovic_fit(T, r, n, xdata_raw, ydata_raw);
g_fit = step(hudzovic_transfer_function(T, r, n), xdata);

err_normal = (g_normal - ydata_orig).^2;
err_fit = (g_fit - ydata_orig).^2;

figure;
subplot(211); hold on, grid on, grid minor
scatter(xdata_raw, ydata_raw);
plot(xdata_raw, ydata_orig, 'k--');
plot(xdata, g_normal, 'LineWidth', 2);
plot(xdata, g_fit, 'LineWidth', 2);

axis square
xlabel('\fontsize{14}Time');
ylabel('\fontsize{14}Amplitude');
title('\fontsize{15}Hudzovic vs Fit, Noise=20%');

yyaxis right
plot(xdata, err_normal);
plot(xdata, err_fit);
ylabel('\fontsize{14}Squared Error');

legend('Input Data', 'Correct Response', 'Hudzovic Tu / Tg', 'Hudzovic Fit', 'Error of Hudzovic Tu / Tg', 'Error of Hudzovic Fit', 'Location', 'east');

[xdata, ydata] = preprocess_curve(xdata, ydata_orig);
[Tu, Tg] = characterise_curve(xdata, ydata);
[T, r, n] = hudzovic_lookup(Tu, Tg);
g_normal = step(hudzovic_transfer_function(T, r, n), xdata);
[T, r] = hudzovic_fit(T, r, n, xdata_raw, ydata_orig);
g_fit = step(hudzovic_transfer_function(T, r, n), xdata);

err_normal = (g_normal - ydata_orig).^2;
err_fit = (g_fit - ydata_orig).^2;


subplot(212); hold on, grid on, grid minor
scatter(xdata, ydata_orig);
plot(xdata_raw, ydata_orig, 'k--');
plot(xdata, g_normal, 'LineWidth', 2);
plot(xdata, g_fit, 'LineWidth', 2);

axis square
xlabel('\fontsize{14}Time');
ylabel('\fontsize{14}Amplitude');
title('\fontsize{15}Hudzovic vs Fit, Noise=0%');

yyaxis right
plot(xdata, err_normal);
plot(xdata, err_fit);
ylabel('\fontsize{14}Squared Error');

legend('Input Data', 'Correct Response', 'Hudzovic Tu / Tg', 'Hudzovic Fit', 'Error of Hudzovic Tu / Tg', 'Error of Hudzovic Fit', 'Location', 'east');
