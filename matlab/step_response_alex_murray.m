close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions'])

% Load the step response of a heater directly from an image plot. We have
% to manually specify the offset and Y scale Ks.
yoffset = 22;
xtime = 10;
Ks = 37 - yoffset;
decimation_factor = 50;
[xdata, ydata, img] = import_curve_from_image('images/plant1.png', decimation_factor);

% For testing purposes, create a "perfect" step response
T1 = 0.5;
T2 = 0.5;
T3 = 1;
T4 = 1;
H = yoffset + Ks / (1+s*T1) * 1/(1+s*T2) * 1/(1+s*T3) * 1/(1+s*T4);
[ydata, xdata] = step(H);
%plot(xdata, ydata); hold on, grid on

[Tu, Tg] = hudzovic_tu_tg(xdata, ydata);
[T, r, order] = hudzovic_lookup(Tu, Tg);
return;
G = hudzovic_transfer_function(T, r, order);
g = step(G * Ks + yoffset, xdata);
plot(xdata, g);

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
