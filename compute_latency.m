function [latency_mean, freq] = compute_latency(latency_array)
    latency_mean = mean(latency_array);
    freq = 1 / latency_mean;
end