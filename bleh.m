%% 
daq.getDevices()
%% 
s = daq.createSession('ni');
s.DurationInSeconds = 4.0
s.Rate = 10000
%%
chIn1 = addAnalogInputChannel(s, 'Dev2', 'ai1', 'Voltage')
%chIn2 = addAnalogInputChannel(s, 'SimDev1', 'ai1', 'Voltage')
%%
chOut1 = addAnalogOutputChannel(s, 'Dev2', 'ao0', 'Voltage') % Muscle Stim
chOut2 = addAnalogOutputChannel(s, 'Dev2', 'ao1', 'Voltage') % Camera Control
%%
time = 4
%%
blah = cameraControl(time);
%%
blah2 = generateStimPulse(1, 100, 100); % Voltage, Frequency, Count
queueOutputData(s, [blah2' blah']);
d = startForeground(s)

%% Function Definitions
function out = generateStimPulse(voltage, frequency, pulse_count)
    Pulseup = voltage;
    Pulsedown = -1*voltage;
    Top = linspace(Pulseup, Pulseup, 10); %1 ms
    Bottom = linspace(Pulsedown,Pulsedown, 10);   %1 ms
    Pulsetime = 1/frequency;
    Spacer = zeros(1, (Pulsetime*10000)-20);
    SinglePulse = horzcat(Top, Bottom, Spacer);
    SpikeTrain = repmat(SinglePulse, 1, pulse_count);
    Flatline = zeros(1, (4-(Pulsetime*pulse_count))*10000/2);
    Signal = horzcat(Flatline, SpikeTrain, Flatline);
    out = Signal;
    %plot(Signal)

end

function out = cameraControl(time)
 voltage_pulse = 3.3;
 top = linspace(voltage_pulse, voltage_pulse, 10); % 1 ms
 bottom = linspace(0, 0, 90); % 9 ms
 one_pulse = horzcat(top, bottom);
 
 total = (time * 1000) / 10
 out = repmat(one_pulse, 1, total);
 %plot(out)
 %disp(size(out))
end