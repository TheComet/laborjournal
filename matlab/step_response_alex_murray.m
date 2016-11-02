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

[Tu, Tg] = normalise_curve(xdata, ydata);
[T, r, order] = hudzovic_lookup(Tu, Tg);
G = hudzovic_transfer_function(T, r, order);
g_hudzovic = step(G * Ks + yoffset, xdata);

[t10, t50, t90] = normalise_curve(xdata, ydata);
[T, r, order] = sani_lookup(t10, t50, t90);
G = sani_transfer_function(T, r, order);
g_sani = step(G * Ks + yoffset, xdata);

T = 2; n=3; r=0.7;
G = sani_transfer_function(T, r, n);
%G = 1/((1+2*s)*(1+1.4*s)*(1+0.98*s));
[y, t] = step(G);
[t10, t50, t90] = normalise_curve(t, y)
plot(t, y);
return;

figure; hold on, grid on, grid minor
scatter(xdata, ydata * Ks + yoffset);
plot(xdata, g_hudzovic);
plot(xdata, g_sani);
legend('original data', 'hudzovic', 'sani');
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
