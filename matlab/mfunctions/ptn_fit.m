function Tn = ptn_fit(ptn_order, xdata, ydata)
    % Set the initial time constants to 1
    initials = ones(1, ptn_order);
    Tn = lsqcurvefit(@ptn, initials, xdata, ydata);
end

function ydata = ptn(Tn, xdata)
    s = tf('s');
    H = 1;
    for k = 1:length(Tn)
        H = H * 1/(1 + s*Tn(k));
    end
    ydata = step(H, linspace(0, 1, length(xdata)));
end
