%% Load in video

video_filename = uigetfile('*.*')

if ( length(video_filename) > 0)
    vid_read_obj = VideoReader(video_filename)
    
else
    disp('File not loaded')
    
end

% Find region of interest
frame = readFrame(vid_read_obj);
frame = flipdim(frame ,2);
frame = flipdim(frame ,1);
fig = figure;
imshow(frame)
[x,y] = getpts(fig)
%h = msgbox('Specify Points to Crop out and hit ENTER')


%% Parse video, edge detect, contour, calculate joint angles

while hasFrame(vid_read_obj)
    
    frame = readFrame(vid_read_obj);
    frame = flipdim(frame,2);
    frame = flipdim(frame,1);
    crop = imcrop(frame,[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
    crop_gry = rgb2gray(crop);
    crop_guass = imgaussfilt(crop_gry, 7.0);
    crop_bw = edge(crop_guass,'canny');
    imshow(crop_bw)
    

    
    %props = regionprops(crop_bw,'Centroid');
    props = regionprops('table',crop_bw,'Centroid','MajorAxisLength','MinorAxisLength');
    %contours = imcontour(crop_bw);
    centers = props.Centroid;
    diameters = mean([props.MajorAxisLength props.MinorAxisLength],2);
    radii = diameters/2;
    %centroids = cat(1,props.Centroid);
    %imshow(crop_bw)
    hold on;
    %plot(centroids(:,1),centroids(:,2),'b*')
    hold on
    viscircles(centers,radii);
    hold off

    
    
    
end



% While loop to go over each frame for the length of the video



% In loop, you will crop the frame to ROI, and then threshold out the
% markers

% Crunch angles and save to a matrix [frame_number joint_angle]