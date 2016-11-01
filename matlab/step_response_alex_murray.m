close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions']);

c = sani_gen_curves(10);
figure;
subplot(211), grid on, grid minor, hold on
for i = 1:7
    plot(c(i).r, c(i).tu_tg);
end
subplot(212), grid on, grid minor, hold on
for i = 1:7
    plot(c(i).r, c(i).t_tg);
end
sani_tu_tg = str2num(fileread('tu_tg_ratio'));
sani_t_tg = str2num(fileread('tg_reciprocal'));
sanix = linspace(0, 1, length(sani_tu_tg));
figure;
subplot(211), grid minor, hold on
plot(sanix, sani_tu_tg);
subplot(212), grid minor, hold on
plot(sanix, sani_t_tg);

return;

% Load the step response of a heater directly from an image plot. We have
% to manually specify the offset and Y scale Ks.
yoffset = 22;
xtime = 10;
Ks = 37 - yoffset;
decimation_factor = 10;
[xdata, ydata, img] = import_curve_from_image('images/plant1.png', decimation_factor);

% The xdata vector is not monotonically increasing with evenly spaced time
% samples. It is very close to it though, so we can approximate it with
% linspace
xdata = linspace(xdata(1), xdata(end), length(xdata))';

scatter(xdata, ydata * Ks + yoffset); hold on, grid on, grid minor

% Input data is quite noisy, smooth it with a sliding average filter
ydata = sliding_average(ydata, 50);

%[Tu, Tg] = calculate_tu_tg(xdata, ydata);
%[T, r, order] = hudzovic_lookup(Tu, Tg);
%G = hudzovic_transfer_function(T, r, order);
%g = step(G * Ks + yoffset, xdata);
%plot(xdata, g);

[t10, t50, t90] = calculate_t10_t50_t90(xdata, ydata);
[T, r, order] = sani_lookup(t10, t50, t90);
G = sani_transfer_function(T, r, order);
g = step(G * Ks + yoffset, xdata);
plot(xdata, g);
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
