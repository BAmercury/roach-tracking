%% POINT GREY CAMERA SIGNALS:
% 1. Start menu -> point grey flycap2
% 2. Choose chameleon camera hit ok
% 3. Click sliders button to bring up camera settings panels
% 4. Uncheck Auto box on Shutter
% 5. Manually enter 3 ms on shutter (goes to 3.002ms maybe)
% 6. Focus, aperture, and align your camera
% 7. Click "Trigger/Strobe" panel
% 8. Check the "Enable" on "Trigger Control" box
% 9. Check the "high" on Trigger Polarity so it triggers on rising edge.
% 10. Click the red "recording settings" button on flycap main window
% 11. Click browse under filename and choose better place
% 12. Under saving options set it to capture 100 frames, or however many
% trigger pulses you are giving from matlab.
% 13. Under "only save corrupt"... click the "Videos" tab
% 14. Leave this set as uncompressed at 15.0 frame rate (this is playback
% rate.
% 15. Leave the recording settings dialog up. When ready to run, click
% "Start recording" button
% 16. Go back to matlab and trigger it. You should see the "Good Frames"
% counter in the point grey "Recording Settings" panel scroll up to 100.
% 17. Open your movie from windows explorer. You should see it play in slow
% motion.
% 18. To gauruntee you had good frames, download and open VirtualDub, and
% use it to see how many farmes are in the file.

%% Connecting the camera
% If you have the BLUE/WHITE CABLE:
%   Connect the BLUE WIRE to GND, WHITE WIRE TO AO0, on the breadboard

% If you have red/black cables:
%   Connect AO0 to SCREW TERMINAL 1 PIN 1, and GND to SCREW TERMINAL 1 PIN 2
%   Connect the BLACK WIRE to SCREW TERMINAL PIN2 = GND, RED WIRE to SCREW TERMINAL PIN 1
%   Use the NI screwdriver to GENTLY PINCH DOWN ON THE TINNED WIRE AT THE END
%   OF THE CABLE.
%% Testing shutter.
% 3 ms DOES WORK.
% Reduce it to 2ms. Works but dark.
% 3.980 ms DOES NOT WORK for 100 Hz!

%% Setup camera trigger output

% YOUR TASK:
% USING A SAMPLE RATE OF 10Khz:
% Create a two channel analog output with camera trigger and neural stimulation waveforms.
% 1. Camera trigger should have say 200 ms of zero, then, a series of 100 positive monophasic pulses
% of 1 millisecond in duration then 9 ms delay (100 Hz frequency), 3.3V tall, with 200 ms of zeros at end.
% 2. Neural trigger should be:

% CODE HERE make "pulses"

%% Setup neural trigger output
%% N=10 pulses, 10V, 100 Hz interpulse interval
% put in 400 ms delay so neural pusles start AFTER camera rolling
% Make them 10V high, 1ms dutaion, 9ms delay, so 100 hz freq also.
$ then after TEN pulses, add zeros to match the length of hte camera signal

% CODD HERE MAKE npulses

%% VARY THE NUMBER OF FREQUENCY OF PULSES AS PER LAB REPORT
% COPY ABOVE BLOCK ADJUST FOR NEW N or f, and execute...
% Lab requests use 3 values of N and 3 values of f. (or interpulseinverval)


%% Send output;
s = daq.createSession('ni');
%% Add stuff
addAnalogOutputChannel(s,'Dev2', 'ao0', 'Voltage')
addAnalogOutputChannel(s,'Dev2', 'ao1', 'Voltage')
addAnalogInputChannel(s,'Dev2', 'ai0', 'Voltage')
s.Rate=10000;

%% Triggering loop
outputdata=[pulses npulses];
queueOutputData(s,outputdata);
% May give error if not  analog input used...
d = startForeground(s);
figure(1); clf;
plot([outputdata d]);
legend('Analog Output Command','Analog Input');
%title('100 3.3V 1 ms wide pulses at 100 Hz: With output connected to input');

