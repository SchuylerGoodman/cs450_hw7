% load the image with the interference pattern
raw_image = double(imread('interfere.png'));
[mrows, ncols] = size(raw_image);

% calculate normalized version of image
imagemax = double(max(max(raw_image)));
imagemin = double(min(min(raw_image)));
image = (raw_image - imagemin) / (imagemax - imagemin);
imtool(image);

% calculate and display the Fourier transform of the image
f_image = fft2(ifftshift(image));
imtool(abs(fftshift(f_image)));
f_min = min(min(f_image));
f_max = max(max(f_image));
f_image_norm = (f_image - f_min) / (f_max - f_min);
imtool(abs(fftshift(f_image_norm)));

% TODO - Find part of Fourier transform that is out of place
% Maybe convolve transform with a highpass filter like:
% [-1 -1 -1
%  -1  1 -1
%  -1 -1 -1]
% This way the highest intensity locations after convolution are places
% where one frequency is much higher than its surrounding frequencies,
% and the surrounding frequencies are closer to 0.
M(1:3,1:3) = -1;
M(2,2) = 1;
f_mfilt_if = round(conv2(fftshift(abs(f_image_norm)), M, 'same'), 4);

% find the coordinates with the maximum response from the highpass filter
[ypeak, xpeak] = find(f_mfilt_if == max(max(f_mfilt_if)));

% display the normalized transform after finding "lonely frequencies"
f_filtmin = min(min(f_mfilt_if));
f_filtmax = max(max(f_mfilt_if));
f_filtnorm = (f_mfilt_if - f_filtmin) / (f_filtmax - f_filtmin);
imtool(f_filtnorm);

% average out noise due to "lonely frequencies"
f_filt_image = fftshift(f_image);
for t = 1:length(ypeak)
    yp = ypeak(t);
    xp = xpeak(t);
    surrounding = f_filt_image(yp-1:yp+1,xp-1:xp+1);
    val = mean(mean(surrounding));
    f_filt_image(yp, xp) = val;
end
f_filt_image = ifftshift(f_filt_image);

% calculate and display inverse transform after averaging out noise
filt_image = ifft2(f_filt_image);
filtmin = min(min(filt_image));
filtmax = max(max(filt_image));
filtnorm = (filt_image - filtmin) / (filtmax - filtmin);
imtool(abs(fftshift(filtnorm)));