% load the image to filter f(x, y)
raw_image = double(imread('2D_White_Box.png'));
imagemax = max(max(raw_image));
imagemin = min(min(raw_image));
image = (raw_image - imagemin) / (imagemax - imagemin);
[mrows, ncols] = size(raw_image);

% display the image before filtering
imtool(raw_image);

% calculate and display Fourier transform of image
f_image = fft2(ifftshift(image));
imtool(abs(fftshift(f_image)));

% initialize the uniform averaging filter
% A 9x9 uniform spatial averaging filter will look like:
%     [1/9 1/9 1/9
% M =  1/9 1/9 1/9
%      1/9 1/9 1/9]
% In HW #2 we did f(x, y) * M to get this result.
% For this lab we convert to Fourier domain and multiply,
%   as in F(f(x, y))F(M), so just calculate padded FT of M.
M(1:3, 1:3) = 1/9;
f_M = fft2(M, mrows, ncols);
imtool(abs(fftshift(f_M)));

% element-wise multiply and display F and FT(M)
f_filtered = f_image.*f_M;
imtool(abs(fftshift(f_filtered)));

% calculate filtered f by inverse Fourier transform
filtered = ifftshift(ifft2(f_filtered));
imtool(filtered);