function error_calculations()
    close all;
    
    % subroutines are located in this folder
    addpath([pwd,'/mfunctions']);
    
    %error_calculations_noise();
    error_calculations_order();
    %display_calculations();
end

function display_calculations()
    load('errors_order.mat', 'errors_order');
    load('errors_noise.mat', 'errors_noise');

    % Error vs Order
    for k = 2:8
        tmp(k-1, 1) = mean(errors_order(k-1).hudzovic_tu_tg(isfinite(errors_order(k-1).hudzovic_tu_tg)));
        tmp(k-1, 2) = mean(errors_order(k-1).hudzovic_t10_t50_t90(isfinite(errors_order(k-1).hudzovic_t10_t50_t90)));
        tmp(k-1, 3) = mean(errors_order(k-1).sani_tu_tg(isfinite(errors_order(k-1).sani_tu_tg)));
        tmp(k-1, 4) = mean(errors_order(k-1).sani_t10_t50_t90(isfinite(errors_order(k-1).sani_t10_t50_t90)));
        tmp(k-1, 5) = mean(errors_order(k-1).hudzovic_fit(isfinite(errors_order(k-1).hudzovic_fit)));
        tmp(k-1, 6) = mean(errors_order(k-1).sani_fit(isfinite(errors_order(k-1).sani_fit)));
    end

    figure;
    semilogy(2:8, tmp, 'LineWidth', 2);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit');
    %axis([2 8 10e-7 20e-3]);
    axis square
    xlabel('\fontsize{14}Order of filter');
    ylabel('\fontsize{14}Root-Mean-Square Error');
    title('\fontsize{16}Error vs Order');

    % Error vs Input noise
    tmp = zeros(length(errors_noise.hudzovic_tu_tg), 6);
    tmp(:,1) = errors_noise.hudzovic_tu_tg;
    tmp(:,2) = errors_noise.hudzovic_t10_t50_t90;
    tmp(:,3) = errors_noise.sani_tu_tg;
    tmp(:,4) = errors_noise.sani_t10_t50_t90;
    tmp(:,5) = errors_noise.hudzovic_fit;
    tmp(:,6) = errors_noise.sani_fit;
    for i = 1:6
        tmp(:,i) = sliding_average(tmp(:,i), 8);
    end
    figure;
    semilogy(errors_noise.noise_amplitude, tmp, 'LineWidth', 2);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit',...
        'Location', 'northwest');
    axis([0 0.35 10e-7 40e1]);
    axis square
    xlabel('\fontsize{14}Normalised noise amplitude');
    ylabel('\fontsize{14}Mean-squared error');
    title('\fontsize{16}Error vs Input noise');

    % Plot the "failure rate" in function of order. Whenever the error is
    % too large, the error is set to Inf. For every order, we created 100
    % random step responses which means the number of Inf items is directly
    % the failure rate in percent.
    tmp = zeros(7, 6);
    for k = 2:8
        tmp(k-1, 1) = 100 - sum(isfinite(errors_order(k-1).hudzovic_tu_tg));
        tmp(k-1, 2) = 100 - sum(isfinite(errors_order(k-1).hudzovic_t10_t50_t90));
        tmp(k-1, 3) = 100 - sum(isfinite(errors_order(k-1).sani_tu_tg));
        tmp(k-1, 4) = 100 - sum(isfinite(errors_order(k-1).sani_t10_t50_t90));
        tmp(k-1, 5) = 100 - sum(isfinite(errors_order(k-1).hudzovic_fit));
        tmp(k-1, 6) = 100 - sum(isfinite(errors_order(k-1).sani_fit));
    end
    figure;
    plot(2:8, tmp, 'LineWidth', 2);
    grid on
    legend('\fontsize{14}Hudzovic Tu/Tg',...
        '\fontsize{14}Hudzovic t10/t50/t90',...
        '\fontsize{14}Sani Tu/Tg',...
        '\fontsize{14}Sani t10/t50/t90',...
        '\fontsize{14}Hudzovic fit',...
        '\fontsize{14}Sani fit');
    axis square
    xlabel('\fontsize{14}Order of filter');
    ylabel('\fontsize{14}Failure Rate (%)');
    title('\fontsize{16}Failure vs Order');
end

function error_calculations_noise()

    rand('state', 0);
    errors_noise = struct;

    % generate transfer function
    G = hudzovic_transfer_function(1, 1/3/2, 4);
    [ydata_orig, xdata_orig] = step(G);
    ydata_orig = ydata_orig - ydata_orig(1);
    ydata_orig = ydata_orig / ydata_orig(end);

    num_simulations = 10000;
    for i = 1:num_simulations
        % apply noise
        amp_rand = 2 * (i-1) / (num_simulations-1);
        xdata_raw = xdata_orig;
        ydata_raw = ydata_orig + amp_rand * (rand(length(ydata_orig),1)-0.5);

        % save noise to struct as well
        errors_noise.noise_amplitude(i) = amp_rand;

        try
            [xdata, ydata] = preprocess_curve(xdata_raw, ydata_raw);
            [Tu, Tg] = characterise_curve(xdata, ydata);
            [t10, t50, t90] = characterise_curve(xdata, ydata, [0 1]); % We know it's normalised to 0-1

            % Hudzovic, Tu/Tg
            [T, r, order] = hudzovic_lookup(Tu, Tg);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_tu_tg = step(G, xdata);

            % Hudzovic, t10/t50/t90
            [T, r, order] = hudzovic_lookup(t10, t50, t90);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_t3 = step(G, xdata);

            % Sani, Tu/Tg
            [T, r, order] = sani_lookup(Tu, Tg);
            G = sani_transfer_function(T, r, order);
            g_sani_tu_tg = step(G, xdata);

            % Sani, t10/t50/t90
            [T, r, order] = sani_lookup(t10, t50, t90);
            G = sani_transfer_function(T, r, order);
            g_sani_t3 = step(G, xdata);

            % Hudzovic fit of raw data
            [T, r, order] = hudzovic_lookup(t10, t50, t90);
            [T, r] = hudzovic_fit(T, r, order, xdata_raw, ydata_raw);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_fit = step(G, xdata);

            % Sani fit of raw data
            [T, r, order] = sani_lookup(t10, t50, t90);
            [T, r] = sani_fit(T, r, order, xdata_raw, ydata_raw);
            G = sani_transfer_function(T, r, order);
            g_sani_fit = step(G, xdata);
            
        catch
        end

        errors_noise.hudzovic_tu_tg(i) = rmse(g_hudzovic_tu_tg, ydata_orig);
        errors_noise.hudzovic_t10_t50_t90(i) = rmse(g_hudzovic_t3, ydata_orig);
        errors_noise.sani_tu_tg(i) = rmse(g_sani_tu_tg, ydata_orig);
        errors_noise.sani_t10_t50_t90(i) = rmse(g_sani_t3, ydata_orig);
        errors_noise.hudzovic_fit(i) = rmse(g_hudzovic_fit, ydata_orig);
        errors_noise.sani_fit(i) = rmse(g_sani_fit, ydata_orig);
    end

    save('errors_noise.mat', 'errors_noise');
end

function error_calculations_order()
    rand('state', 0);

    for k = 2:8
        num_simulations = 100;
        errors_order(k-1) = struct(...
            'hudzovic_tu_tg', 0,...
            'hudzovic_t10_t50_t90', 0,...
            'sani_tu_tg', 0,...
            'sani_t10_t50_t90', 0,...
            'hudzovic_fit', 0,...
            'sani_fit', 0);
        
        for i = 1:num_simulations
            [xdata, ydata] = gen_random_ptn(k);

            [Tu, Tg] = characterise_curve(xdata, ydata);
            [t10, t50, t90] = characterise_curve(xdata, ydata, [0 1]); % We know it's normalised to 0-1

            try
            % Hudzovic, Tu/Tg
            [T, r, order] = hudzovic_lookup(Tu, Tg);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_tu_tg = step(G, xdata);

            % Hudzovic, t10/t50/t90
            [T, r, order] = hudzovic_lookup(t10, t50, t90);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_t3 = step(G, xdata);

            % Sani, Tu/Tg
            [T, r, order] = sani_lookup(Tu, Tg);
            G = sani_transfer_function(T, r, order);
            g_sani_tu_tg = step(G, xdata);

            % Sani, t10/t50/t90
            [T, r, order] = sani_lookup(t10, t50, t90);
            G = sani_transfer_function(T, r, order);
            g_sani_t3 = step(G, xdata);

            % Hudzovic fit of raw data
            [T, r, order] = hudzovic_lookup(t10, t50, t90);
            [T, r] = hudzovic_fit(T, r, order, xdata, ydata);
            G = hudzovic_transfer_function(T, r, order);
            g_hudzovic_fit = step(G, xdata);

            % Sani fit of raw data
            [T, r, order] = sani_lookup(t10, t50, t90);
            [T, r] = sani_fit(T, r, order, xdata, ydata);
            G = sani_transfer_function(T, r, order);
            g_sani_fit = step(G, xdata);
            catch
            end

            errors_order(k-1).hudzovic_tu_tg(i) = rmse(g_hudzovic_tu_tg, ydata);
            errors_order(k-1).hudzovic_t10_t50_t90(i) = rmse(g_hudzovic_t3, ydata);
            errors_order(k-1).sani_tu_tg(i) = rmse(g_sani_tu_tg, ydata);
            errors_order(k-1).sani_t10_t50_t90(i) = rmse(g_sani_t3, ydata);
            errors_order(k-1).hudzovic_fit(i) = rmse(g_hudzovic_fit, ydata);
            errors_order(k-1).sani_fit(i) = rmse(g_sani_fit, ydata);
        end
    end

    save('errors_order.mat', 'errors_order');
end

function error_calculations_order_sani_lookup()
    rand('state', 0);

    for k = 2:8
        num_simulations = 100;
        
        for i = 1:num_simulations
            [xdata, ydata] = gen_random_ptn(k);

            [Tu, Tg] = characterise_curve(xdata, ydata);
            [t10, t50, t90] = characterise_curve(xdata, ydata, [0 1]); % We know it's normalised to 0-1

            try
            % Sani, t10/t50/t90
            [T, r, order] = sani_lookup(t10, t50, t90);
            G = sani_transfer_function(T, r, order);
            g_sani_t3 = step(G, xdata);
            catch
            end

            errors_order(k-1) = rmse(g_sani_t3, ydata);
        end
    end

    save('errors_order_sani_lambda_lookup.mat', 'errors_order');
end

function [xdata, ydata] = gen_random_ptn(order)
    s = tf('s');
    G = 1;
    for k = 1:order
        Tk = (rand(1,1)*0.8+0.1) * 10;
        G = G / (1+s*Tk);
    end
    [ydata, xdata] = step(G);
    ydata = ydata - ydata(1);
    ydata = ydata / ydata(end);
end

