function gen_hudzovic_curves(resolution)
    if nargin < 1
        resolution = 10;
    end

    s = tf('s');
    curves = zeros(resolution, 6, 3);

    for order = 2:8

        % 0 <= r < 1/(order-1)
        r = linspace(0, 1/(order-1)-1e-9, resolution);

        for r_index = 1:resolution
            % Set T=1 for calculating Tk, construct transfer function G(s)
            H = 1;
            for k = 1:order
                Tk = 1/(1-(k-1)*r(r_index));
                H = H / (1+Tk*s);
            end
            
            % Get Tu/Tg from step response of resulting transfer function
            [h, t] = step(H);
            [Tu, Tg] = hudzovic_tu_tg(t, h);
            
            % Now we can calculate Tu/Tg as well as T/Tg with T=1 to yield
            % the two plots seen in the Hudzovic method
            curves(r_index, order-1, 2) = Tu/Tg;
            curves(r_index, order-1, 3) = 1/Tg;
        end
        % Need to store r vector for each curve, as it changes
        curves(:, order-1, 1) = r;
    end

    figure(1);
    subplot(211); hold on, grid on
    for order = 2:8
        plot(curves(:, order-1, 1), curves(:, order-1, 2));
    end
    subplot(212); hold on, grid on
    for order = 2:8
        plot(curves(:, order-1, 1), curves(:, order-1, 3));
    end
end
