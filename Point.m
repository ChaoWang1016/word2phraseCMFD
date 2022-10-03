function  [points,tt] = Point(GI,PeakThresh,EdgeThresh,OI)
clc;
fprintf(1,'Point...\n');
%% SIFT
tic;
[f,~] = vl_sift(single(GI),'PeakThresh',PeakThresh,'EdgeThresh', EdgeThresh) ;
points(1,:)=f(2,:);
points(2,:)=f(1,:);
points(3,:)=f(3,:);
points(1:2,:)=round(points(1:2,:));
[points,~,~]=unique(points,'rows','stable');
tt=toc;
%
figure('Name','Keypoint Detection');
imshow(OI), hold on;
plot(points(2,:),points(1,:),'.y','MarkerSize',9)
%
end

