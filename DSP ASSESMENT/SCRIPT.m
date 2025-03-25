% File Import & Export

%audioread('filename.wav') – Read audio file
%audiowrite('filename.wav', y, Fs) – Save processed audio
%(Use instead of deprecated wavread / wavwrite)
%----------------------------------------------------------

% Audio Editing & Processing

%resample(y, p, q) – Change sampling rate
%normalize(y, 'range', [-1 1]) – Normalize amplitude
%filter(b, a, y) – Apply a digital filter
%bandpass(y, [lowFreq highFreq], Fs) – Bandpass filter
%lowpass(y, cutoffFreq, Fs) – Low-pass filter
%highpass(y, cutoffFreq, Fs) – High-pass filter
%conv(y, h) – Convolution (e.g. for reverb)
%-----------------------------------------------------

% Signal Analysis & Visualization

%plot(t, y) – Plot waveform
%spectrogram(y, window, overlap, nfft, Fs, 'yaxis') – Plot spectrogram
%fft(y) – Compute Fourier Transform
%ifft(Y) – Compute Inverse Fourier Transform
%pwelch(y, window, overlap, nfft, Fs) – Estimate power spectral density
%------------------------------------------------------------


% Mixing & Multi-Track Processing

%mix = y1 + y2 – Mix two signals
%alignsignals(y1, y2) – Align two signals
%fadein = linspace(0,1,length(y))'.*y – Apply fade-in
%fadeout = linspace(1,0,length(y))'.*y – Apply fade-out
%------------------------------------------------------


% Audio Effects

%reverb(y, Fs) – Add reverb (DSP Toolbox required)
%chorus(y, Fs) – Add chorus effect
%flanger(y, Fs) – Add flanger effect
%echo(y, Fs, delay, gain) – Add echo effect
%----------------------------------------------------