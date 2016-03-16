% load the noisy signal data
x = importdata('1D_Noise.dat');

% plot base signal
figure(1)
plot(x)
title('Noisy signal')
xlabel('Samples');
ylabel('Amplitude')
 
% plot magnitude spectrum of the signal
X_mags = abs(fft(x));
figure(10)
plot(X_mags, 'LineWidth', 10)
xlabel('DFT Bins')
ylabel('Magnitude')
 
% plot first half of DFT
num_bins = length(X_mags);
mag_max = max(max(X_mags));
X_mags_norm = rdivide(X_mags, mag_max);
plot(0:1/(num_bins/2 -1):1, X_mags_norm(1:num_bins/2), 'r')
xlabel('Normalized frequency (\pi rads/sample)')
ylabel('Normalized magnitude')
 
% design a second order butterworth filter with cutoff frequency 0.05
[b, a] = butter(2, 0.05, 'low');

% plot the frequency response
f_resp = freqz(b, a, floor(num_bins/2));
hold on
plot(0:1/(num_bins/2 -1):1, abs(f_resp),'k');

% plot the frequency post-filtering
X_mags_filtered = times(X_mags_norm(1:num_bins/2), abs(f_resp));
hold on
plot(0:1/(num_bins/2 - 1):1, X_mags_filtered,'-.b');
legend('Normalized DFT of signal', 'Butterworth lowpass filter', 'Normalized DFT of filtered signal');
 
% filter the signal
x_filtered = filter(b,a,x);
 
% plot the filtered signal
figure(2)
plot(x_filtered,'r')
title('Filtered Signal - Using Second Order Butterworth')
xlabel('Samples');
ylabel('Amplitude')