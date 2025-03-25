% AUDIO PROCESSING SCRIPT WITH REVERB WITH CONV, ECHO, FILTERING, AND VISUALIZATION

% Clear environment
clear; clc; close all;

%% 1. Load Audio File
[filename, pathname] = uigetfile('*.wav', 'Select a WAV file');
if isequal(filename,0)
    disp('cancelled file selection.');
    return;
end
filePath = fullfile(pathname, filename);
[y, Fs] = audioread(filePath);
fprintf('Loaded file: %s at %d Hz\n', filename, Fs);

%% 2. Normalize Audio
y = normalize(y, 'range', [-1 1]);

%% 3. Apply Bandpass Filter (e.g., 300–3400 Hz for voice)
y_filtered = bandpass(y, [300 3400], Fs);

%% 4. Visualize Waveform
t = (0:length(y_filtered)-1)/Fs;
figure;
plot(t, y_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered Audio Waveform');

%% 5. Visualize Spectrogram
figure;
spectrogram(y_filtered, 256, 200, 1024, Fs, 'yaxis');
title('Spectrogram');


%% 6. Apply Convolution Reverb using an Impulse Response

% Load impulse response file
[irFile, irPath] = uigetfile('*.wav', 'Select an Impulse Response WAV file');
if isequal(irFile,0)
    disp('User canceled IR selection.');
    return;
end
[ir, irFs] = audioread(fullfile(irPath, irFile));

% Resample IR if sampling rates differ
if irFs ~= Fs
    ir = resample(ir, Fs, irFs);
end

% If stereo IR or input, convert to mono
if size(ir,2) > 1
    ir = mean(ir, 2);
end
if size(y_filtered,2) > 1
    y_filtered = mean(y_filtered, 2);
end

% Convolve filtered audio with impulse response
y_conv = conv(y_filtered, ir, 'full');

% Normalize to prevent clipping
y_processed = normalize(y_conv, 'range', [-1 1]);

%% 7. Apply Fade In & Fade Out
fadeDuration = 1; % in seconds
fadeSamples = round(Fs * fadeDuration);
fadeIn = linspace(0,1,fadeSamples)';
fadeOut = linspace(1,0,fadeSamples)';
y_processed(1:fadeSamples) = y_processed(1:fadeSamples) .* fadeIn;
y_processed(end-fadeSamples+1:end) = y_processed(end-fadeSamples+1:end) .* fadeOut;

%% 8. Save Processed Audio
[~, name, ~] = fileparts(filename);
outFilename = fullfile(pathname, [name '_processed.wav']);
audiowrite(outFilename, y_processed, Fs);
fprintf('Processed audio saved to: %s\n', outFilename);

%% 9. Play Original and Processed Audio
fprintf('Playing original audio...\n');
sound(y, Fs);
pause(length(y)/Fs + 1);

fprintf('Playing processed audio...\n');
sound(y_processed, Fs);