close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

% Load the step response of a heater directly from an image plot. We have
% to manually specify the offset and Y scale Ks.
yoffset = 22;
xtime = 10;
Ks = 37 - yoffset;
decimation_factor = 10;
[xdata_raw, ydata_raw, img] = import_curve_from_image('images/plant1.png', decimation_factor);

% The xdata vector is not monotonically increasing with evenly spaced time
% samples. It is very close to it though, so we can approximate it with
% linspace
xdata = linspace(xdata_raw(1), xdata_raw(end), length(xdata_raw))';

% Input data is quite noisy, smooth it with a sliding average filter
ydata = sliding_average(ydata_raw, 30);

s = tf('s');
G = 1/((1+s)^2*(1+s*0.5)^2);
[ydata, xdata] = step(G);
ydata = ydata - ydata(1);
xdata = xdata - xdata(1);
ydata = ydata / ydata(end);
xdata = xdata * 5 / xdata(end);
xdata_raw = xdata;
ydata_raw = ydata;

[Tu, Tg] = normalise_curve(xdata, ydata);
[t10, t50, t90] = normalise_curve(xdata, ydata);

[T, r, order] = hudzovic_lookup(Tu, Tg);
G = hudzovic_transfer_function(T, r, order);
g_hudzovic_tu_tg = step(G * Ks + yoffset, xdata);

%[T, r, order] = hudzovic_lookup(t10, t50, t90);
%G = hudzovic_transfer_function(T, r, order);
%g_hudzovic_t3 = step(G * Ks + yoffset, xdata);

[T, r, order] = sani_lookup(Tu, Tg);
G = sani_transfer_function(T, r, order);
g_sani_tu_tg = step(G * Ks + yoffset, xdata);

[T, r, order] = sani_lookup(t10, t50, t90);
G = sani_transfer_function(T, r, order);
g_sani_t3 = step(G * Ks + yoffset, xdata);

[T, r, order] = sani_lookup(xdata_raw, ydata_raw);
G = sani_transfer_function(T, r, order);
g_sani_fit = step(G * Ks + yoffset, xdata);

figure; hold on, grid on, grid minor
scatter(xdata, ydata * Ks + yoffset);
plot(xdata, g_hudzovic_tu_tg);
plot(xdata, g_sani_tu_tg);
plot(xdata, g_sani_t3);
plot(xdata, g_sani_fit);
legend('original data', 'hudzovic Tu/Tg', 'sani Tu/Tg', 'sani t10/t50/t90', 'sani fit');
return;

% Try fitting the time constants individually
% NOTE ydata needs to be normalised
Tk = ptn_fit(xdata, ydata, order);
s = tf('s');
H = 1;
for k = 1:length(Tk)
    H = H / (1 + s*Tk(k));
end
H = H * Ks + yoffset;
h = step(H, xdata);
plot(xdata, h);

legend('correct', 'hudzovic', 'fit');
