RGB=handles.RGB;
I = rgb2gray(RGB);
% threshold = graythresh(I);
% bw = ~im2bw(I,threshold);
% axes(handles.axes2);
% imshow(bw);title('gray');
% pause(2);
% bw = bwareaopen(bw,30);
% imshow(bw);title('open');
% pause(2);
% % fill a gap in the pen's cap
% se = strel('disk',2);
% bw = imclose(bw,se);
% imshow(bw);title('disk');
% pause(2);
% % fill any holes, so that regionprops can be used to estimate
% % the area enclosed by each of the boundaries
% bw = imfill(bw,'holes');
% 
% imshow(bw);title('holes');
% pause(2);
% [B,L] = bwboundaries(bw,'noholes');
% 
% % Display the label matrix and draw each boundary
% imshow(label2rgb(L, @jet, [.5 .5 .5]));title('label2');
% pause(2);
% hold on
% for k = 1:length(B)
%   boundary = B{k};
%   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end
% stats = regionprops(L,'Area','Centroid');
% 
% threshold = 0.9;
% 
% % loop over the boundaries
% for k = 1:length(B)
% 
%   % obtain (X,Y) boundary coordinates corresponding to label 'k'
%   boundary = B{k};
% 
%   % compute a simple estimate of the object's perimeter
%   delta_sq = diff(boundary).^2;
%   perimeter = sum(sqrt(sum(delta_sq,2)));
% 
%   % obtain the area calculation corresponding to label 'k'
%   area = stats(k).Area;
% 
%   % compute the roundness metric
%   metric = 4*pi*area/perimeter^2
% 
%   % display the results
%   metric_string = sprintf('%2.2f',metric);
% 
%   % mark objects above the threshold with a black circle
%   if metric > threshold
%     centroid = stats(k).Centroid;
%     coin_PixelCount = stats(k).Area
%     plot(centroid(1),centroid(2),'ko');
%   end
% 
%   text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
%        'FontSize',14,'FontWeight','bold');
% 
% end
% 
% title(['Metrics closer to 1 indicate that ',...
%        'the object is approximately round']);
% 
% pause(2);
% str1=strcat('Coin Pixel Count:',num2str(coin_PixelCount));%store in var.
% set(handles.text2, 'string',str1);%show ref.

RGB=handles.RGB;
hsvVal=[0.99 0.6 0.1];  %green color const. with hue=0.33 ,sat=0.6, val=0.1
tol=[0.15 0.5 0.5];     %tolerace

HSV = rgb2hsv(RGB);     %conver image to hsv

% find the difference between required and real H value:
diffH = abs(HSV(:,:,1) - hsvVal(1));

[M,N,t] = size(RGB);
I1 = zeros(M,N); I2 = zeros(M,N); I3 = zeros(M,N);%vari with size mxn

T1 = tol(1);

I1( find(diffH < T1) ) = 1;

if (length(tol)>1)
% find the difference between required and real S value:
diffS = abs(HSV(:,:,2) - hsvVal(2)); 
T2 = tol(2);
I2( find(diffS < T2) ) = 1; 
if (length(tol)>2)
% find the difference between required and real V value:
difV = HSV(:,:,3) - hsvVal(3); 
T3 = tol(3);
I3( find(diffS < T3) ) = 1;
I = I1.*I2.*I3;
else
I = I1.*I2;
end
else
I = I1; 
end
 subplot(1,2,1);
imshow(RGB); title('Original Image');
% imshow(I,[]); title('Detected Areas');
 subplot(1,2,2);
imshow(I); title('Detected Areas');
pause(1);

abc=imfill(I,'holes');
% level=graythresh(im2);
% abc=im2bw(im2,level);
% % T=[];
% % [irow icol] = size(im2);%image size
% % temp = reshape(im2',irow*icol,1);   % Reshaping 2D images into 1D image vectors
% % T = [T temp]; % 'T' grows after each turn                    
% % z=max(T);    
% % y=min(T);
% % 
% %  pause(1);
% % th=(z+y)/2; %find average
% % th=th-y;
% % %convert into bw
% % for x=1:irow
% %     for y=1:icol
% %         if (im2(x,y)>(th))
% %             abc(x,y)=1;
% %         else 
% %                 abc(x,y)=0;
% %         end 
% %     end
% % end
imshow(abc);title('BW image');
% I_out2=imcomplement(abc);
I=imfill(abc,'holes');
imshow(I);title('fill');
pause(2);
I=bwmorph(I,'majority');
imshow(I);title('majority');
pause(2);
I=bwmorph(I,'clean');
imshow(I);title('clean');
pause(2);
 I = bwareaopen(I,50);

imshow(I);title('bwopen');
pause(2);
[L,num] = bwlabel(I,8);

stats1 = regionprops(L);
    leaf_pixelcount=0;
for n=1:length(stats1)
    leaf_pixelcount=leaf_pixelcount+stats1(n).Area
end    
str1=strcat('Leaf Pixel Count:',num2str(leaf_pixelcount));%store in var.
set(handles.text3, 'string',str1);%show ref.

%  Area_coin=4.9087;   % area 1 rs new coin
% TotalLeafArea=leaf_pixelcount*(Area_coin/coin_PixelCount)

% str1=strcat('Total Area: ',num2str(TotalLeafArea),' cm^2');%store in var.
% set(handles.text4, 'string',str1);%show ref.
