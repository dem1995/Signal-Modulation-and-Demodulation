%Demodulator. Created by David McKnight, April/May 2018

%% Preliminary: Grab Signal
signal = am_signal';

%% Preliminary: Prepare Time Information
ts = 1/320000;  %Time between samples
tmax = 0.625;   %Maximum time
t = (0:1:200000-1)*tmax/(200000-1);    %Time values

%% Part 1: Tuning/Bandpass Filter
i = 0;              %number of 4.5kHz offsets for carrier frequency
f0 = (20 + 4.5*0)*10^3      %carrier frequency (Hz)
w0 = f0*2*pi;       %carrier freq (radians/s)
B  = 2000*2*pi;     %4000 Hz bandwidth
num = [B, 0];       %Bs in the numerator
den = [1, B, w0^2]; %s^2 + Bs + w0^2 in the denominator
sys = tf(num, den); %Bandpass filter transfer function
signal = lsim(sys, signal, t);  %Apply the bandpass filter to the signal

%% Part 2: Half-wave Rectification
lambda = (@(x) (x>0)*x);
signal = arrayfun(lambda, signal);

%% Part 3: Lowpass Filter:
num = 2.49367*10^16
den = [1, 32837.5, 5.39151*10^8, 5.18549*10^12, num]
sys = tf(num, den); %2000 Hz second-order lowpass filter
signal = lsim(sys^2, signal, t);  %Apply the lowpass filter to the signal

%% Part 4: Remove DC Offset
signal = signal-mean(signal(1000:end));

%% Part 5: Down-sample:
signal = decimate(signal, 40, 'fir');

%% Part 6: Play back:
sound(signal, 8000)



