%% Load in video


% File dialog to get video address
video_filename = uigetfile('*.*')


% Start videoreader object
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




%% Parse video and run prep, edges, kinematics

numbers = [];
frame_number = 0;


% Frame by Frame analysis
while hasFrame(vid_read_obj)
    frame_number = frame_number + 1;
    frame = readFrame(vid_read_obj);
    frame = flipdim(frame,2);
    frame = flipdim(frame,1);
    % Crop to ROI
    crop = imcrop(frame,[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
    % GrayScale, run through Guassian Filter
    crop_gry = rgb2gray(crop);
    crop_guass = imgaussfilt(crop_gry, 7.0);
    % Canny Edge Detection
    crop_bw = edge(crop_guass,'canny');
    
    
    % Remove objects containing fewer than 30 pixels
    crop_bw = bwareaopen(crop_bw,40);
    
    % Fill in gaps
    se = strel('disk',2);
    crop_bw = imclose(crop_bw,se);
    
    % Fill any more holes in an dsmooth it out for regionprops
    crop_bw = imfill(crop_bw,'holes');
    
    imshow(crop_gry)
    % Gather properties and Centroids
    props = regionprops('table',crop_bw,'Centroid','MajorAxisLength','MinorAxisLength');

    %contours = imcontour(crop_bw);
    centers = props.Centroid;
    diameters = mean([props.MajorAxisLength props.MinorAxisLength],2);
    radii = diameters/2;
    
    %hold on;
    %plot(centers(:,1), centers(:,2),'b*')
    %hold off;
    
    %Show joint positions of interest and save to a structure
%     hold on;
%     plot(centers(1,1),centers(1,2),'b*')
%     hold off;
%     hold on;
%     plot(centers(3,1),centers(3,2),'b*')
%     hold off;
%     hold on;
%     plot(centers(5,1),centers(5,2),'b*')
%     hold off;
    %hold off;
    
    %Make Homogenous
    dot_1 = [centers(1,1), centers(1,2),0];
    dot_2 = [centers(2,1), centers(2,2),0];
    dot_3 = [centers(3,1), centers(3,2),0];
    
    %Find angle of roach knee by taking norm of cross product between the
    %two legged vectors, as well as the dot product between both vectors
    %and running it through 4 quad inverse tangent
    
    
  
    
    v_1_2 = (dot_1 - dot_2);
    v_2_3 = (dot_2 - dot_3);
    
    
    joint_angle = atan2d( norm (cross(v_1_2, v_2_3)),dot(v_1_2,v_2_3));
    
    numbers = [numbers; frame_number, joint_angle];
    
    
    
    % To visulize all circles
    hold on;
    viscircles(centers,radii);
    hold off;

    
    
    
end

% Finiky Graphing of numbers, no filtering of data. Post analysis in terminal using smooth() is good enough
fig2 = figure;
plot(numbers(:,1), numbers(:,2))


fig3=figure;
%Plot against time
plot(((numbers(:,1)/100)*10000),numbers(:,2))


save('numbers.mat','numbers')
