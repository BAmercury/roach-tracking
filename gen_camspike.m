function [ output_args ] = gen_camspike( posv, freq, num)
%GEN_CAMSPIKE Summary of this function goes here
%   Detailed explanation goes here
% YOUR TASK:
% USING A SAMPLE RATE OF 10Khz:
% Create a two channel analog output with camera trigger and neural stimulation waveforms.
% 1. Camera trigger should have say 200 ms of zero, then, a series of 100 positive monophasic pulses
% of 1 millisecond in duration then 9 ms delay (100 Hz frequency), 3.3V tall, with 200 ms of zeros at end.
% 2. Neural trigger should be:

duration = 1/freq; % 1 milisecond if frequency is 100 Hz
duration = 1; % to get into miliseconds
padding = 200 % miliseconds of start and stop padding
delay = 9 % milisecond delay between pulses







