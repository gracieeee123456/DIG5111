% AUDIO PROCESSING SCRIPT WITH CONVOLUTION REVERB, ECHO, FILTERING, AND VISUALIZATION

% Clear environment: removes variables, closes figures, clears command window
clear; clc; close all;

%% 1. Load Audio File
% Open file selection dialog for WAV files
[filename, pathname] = uigetfile('*.wav', 'Select a WAV file');
if isequal(filename,0)
    disp('Cancelled file selection.');
    return;
end

% Construct full file path and read audio
filePath = fullfile(pathname, filename);
[y, Fs] = audioread(filePath);  % y = audio data, Fs = sample rate
fprintf('Loaded file: %s at %d Hz\n', filename, Fs);

%% 2. Normalize Audio
% Normalize audio amplitude to range [-1, 1] to prevent clipping
y = normalize(y, 'range', [-1 1]);

%% 3. Apply Bandpass Filter
% Keep only frequencies between 300–3400 Hz (typical voice frequency range)
y_filtered = bandpass(y, [300 3400], Fs);

%% 4. Visualize Waveform
% Time vector for plotting
t = (0:length(y_filtered)-1)/Fs;
% Plot the filtered waveform
figure;
plot(t, y_filtered);
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered Audio Waveform');

%% 5. Visualize Spectrogram
% Display frequency content over time
figure;
spectrogram(y_filtered, 256, 200, 1024, Fs, 'yaxis');
title('Spectrogram');

%% 6. Apply Convolution Reverb using an Impulse Response (IR)

% Ask user to select an IR file (e.g., room/hall impulse response)
[irFile, irPath] = uigetfile('*.wav', 'Select an Impulse Response WAV file');
if isequal(irFile,0)
    disp('User canceled IR selection.');
    return;
end
[ir, irFs] = audioread(fullfile(irPath, irFile));  % Load IR and its sample rate

% Resample IR to match original audio's sample rate if needed
if irFs ~= Fs
    ir = resample(ir, Fs, irFs);
end

% Convert stereo IR or audio to mono (by averaging channels)
if size(ir,2) > 1
    ir = mean(ir, 2);
end
if size(y_filtered,2) > 1
    y_filtered = mean(y_filtered, 2);
end

% Apply convolution to simulate reverberation effect
y_conv = conv(y_filtered, ir, 'full');  % 'full' includes entire response

% Normalize to prevent clipping
y_processed = normalize(y_conv, 'range', [-1 1]);

%% 7. Apply Fade In & Fade Out
% Set fade duration (in seconds) and convert to number of samples
fadeDuration = 1;
fadeSamples = round(Fs * fadeDuration);

% Generate linear fade-in and fade-out curves
fadeIn = linspace(0,1,fadeSamples)';
fadeOut = linspace(1,0,fadeSamples)';

% Apply fades to start and end of processed audio
y_processed(1:fadeSamples) = y_processed(1:fadeSamples) .* fadeIn;
y_processed(end-fadeSamples+1:end) = y_processed(end-fadeSamples+1:end) .* fadeOut;

%% 8. Save Processed Audio
% Create output filename and save as a new WAV file
[~, name, ~] = fileparts(filename);
outFilename = fullfile(pathname, [name '_processed.wav']);
audiowrite(outFilename, y_processed, Fs);
fprintf('Processed audio saved to: %s\n', outFilename);

%% 9. Play Original and Processed Audio
% Playback original audio
fprintf('Playing original audio...\n');
sound(y, Fs);
pause(length(y)/Fs + 1);  % Wait until playback finishes

% Playback processed audio
fprintf('Playing processed audio...\n');
sound(y_processed, Fs);