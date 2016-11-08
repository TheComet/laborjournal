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
amp_rand = 0.1;
G = hudzovic_transfer_function(1, 1/3/2, 4);
[ydata_orig, xdata_orig] = step(G);
ydata_orig = ydata_orig - ydata_orig(1);
ydata_orig = ydata_orig / ydata_orig(end);
xdata_raw = xdata_orig;
ydata_raw = ydata_orig + amp_rand * (rand(length(ydata_orig),1)-0.5);

% The xdata vector is not monotonically increasing with evenly spaced time
% samples. It is very close to it though, so we can approximate it with
% linspace
xdata = linspace(xdata_raw(1), xdata_raw(end), length(xdata_raw))';

% Input data is quite noisy, smooth it with a sliding average filter
ydata = sliding_average(ydata_raw, log(0.6)/log(amp_rand) * length(ydata_raw));

plot(xdata, ydata); hold on
scatter(xdata_raw, ydata_raw);
return;

[Tu, Tg] = normalise_curve(xdata, ydata);
[t10, t50, t90] = normalise_curve(xdata, ydata);

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
%[T, r, order] = hudzovic_lookup(t10, t50, t90);
%[T, r] = hudzovic_fit(T, r, order, xdata_raw, ydata_raw);
%G = hudzovic_transfer_function(T, r, order);
%g_hudzovic_fit = step(G * Ks + yoffset, xdata);

% Sani fit of raw data
%[T, r, order] = sani_lookup(t10, t50, t90);
%[T, r] = sani_fit(T, r, order, xdata_raw, ydata_raw);
%G = sani_transfer_function(T, r, order);
%g_sani_fit = step(G * Ks + yoffset, xdata);

figure; hold on, grid on, grid minor
scatter(xdata_raw, ydata_raw * Ks + yoffset);
scatter(xdata, ydata * Ks + yoffset);
plot(xdata, g_hudzovic_tu_tg);
plot(xdata, g_hudzovic_t3);
plot(xdata, g_sani_tu_tg);
plot(xdata, g_sani_t3);
%plot(xdata, g_hudzovic_fit);
%plot(xdata, g_sani_fit);
legend(...
    'Original data',...
    'Smoothed data',...
    'Hudzovic Tu/Tg',...
    'Hudzovic t10/t50/t90',...
    'Sani Tu/Tg',...
    'Sani t10/t50/t90'...
);
%    'Hudzovic fit',...
%    'Sani fit'...