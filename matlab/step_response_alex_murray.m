close all;

% subroutines are located in this folder
addpath([pwd,'/mfunctions'])

gen_hudzovic_curves();
return

% Load the step response of a heater directly from an image plot. We have
% to manually specify the offset and Y scale Ks.
yoffset = 22;
Ks = 37 - yoffset;
decimation_factor = 10;
[x, y, img] = import_curve_from_image('images/plant1.png', decimation_factor);

Tn = ptn_fit(4, x, y);

% scale scatter data correctly
y = y * Ks + yoffset;

% scatter data used for fit
figure(1);
hold on
scatter(x, y);

% step response from fit
s = tf('s');
H = 1;
for k = 1:length(Tn)
    H = H * 1/(1 + s*Tn(k));
end
H = H * Ks + yoffset;
[y, t] = step(H, linspace(0, 1, length(x)));
plot(t, y);

% for comparison, these are from the hudzovic method
T1 = 0.495 / 10;
T2 = 0.602 / 10;
T3 = 0.770 / 10;
T4 = 1.068 / 10;
H = yoffset + Ks * 1/(1+s*T1) * 1/(1+s*T2) * 1/(1+s*T3) * 1/(1+s*T4);
[y, t] = step(H, linspace(0, 1, length(x)));
plot(t, y);

% for comparison, these are the correct parameters
T1 = 0.5 / 10;
T2 = 0.5 / 10;
T3 = 1 / 10;
T4 = 1 / 10;
H = yoffset + Ks * 1/(1+s*T1) * 1/(1+s*T2) * 1/(1+s*T3) * 1/(1+s*T4);
[y, t] = step(H, linspace(0, 1, length(x)));
plot(t, y);

legend('original data', 'fit', 'hudzovic', 'correct');
grid on
