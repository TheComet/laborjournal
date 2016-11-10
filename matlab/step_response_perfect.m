close all, clear all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

% Generate a "perfect" step response curve
yoffset = 22;
Ks = 37 - yoffset;
G = yoffset + Ks * hudzovic_transfer_function(1, 0.1, 2);
[ydata, xdata] = step(G);
% normalise Y data
ydata = ydata - ydata(1);
ydata = ydata / ydata(end);

[Tu, Tg] = characterise_curve(xdata, ydata);
[t10, t50, t90] = characterise_curve(xdata, ydata);

% Hudzovic, Tu/Tg
[T, r, order] = hudzovic_lookup(Tu, Tg);
G = hudzovic_transfer_function(T, r, order);
g_hudzovic_tu_tg = step(G * Ks + yoffset, xdata);

% Hudzovic, t10/t50/t90
[T, r, order] = hudzovic_lookup(t10, t50, t90);
G = hudzovic_transfer_function(T, r, order);
g_hudzovic_t3 = step(G * Ks + yoffset, xdata);

% Sani, Tu/Tg
[T, r, order] = sani_lookup(Tu, Tg);
G = sani_transfer_function(T, r, order);
g_sani_tu_tg = step(G * Ks + yoffset, xdata);

% Sani, t10/t50/t90
[T, r, order] = sani_lookup(t10, t50, t90);
G = sani_transfer_function(T, r, order);
g_sani_t3 = step(G * Ks + yoffset, xdata);

% Hudzovic fit of raw data
[T, r, order] = hudzovic_lookup(t10, t50, t90);
[T, r] = hudzovic_fit(T, r, order, xdata, ydata);
G = hudzovic_transfer_function(T, r, order);
g_hudzovic_fit = step(G * Ks + yoffset, xdata);

% Sani fit of raw data
[T, r, order] = sani_lookup(t10, t50, t90);
[T, r] = sani_fit(T, r, order, xdata, ydata);
G = sani_transfer_function(T, r, order);
g_sani_fit = step(G * Ks + yoffset, xdata);

figure; hold on, grid on, grid minor
scatter(xdata, yoffset + Ks * ydata);
plot(xdata, g_hudzovic_tu_tg);
plot(xdata, g_hudzovic_t3);
plot(xdata, g_sani_tu_tg);
plot(xdata, g_sani_t3);
plot(xdata, g_hudzovic_fit);
plot(xdata, g_sani_fit);
legend('Original data', 'Hudzovic Tu/Tg', 'Hudzovic t10/t50/t90', 'Sani Tu/Tg', 'Sani t10/t50/t90', 'Hudzovic fit', 'Sani fit');
