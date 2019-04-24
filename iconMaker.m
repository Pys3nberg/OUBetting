
X = imread('C:\Users\pysenberg\Desktop\Flags\England.png');
% imshow(X);
% 
% xScaler = round(size(X(:,:,1),1))/300;
% yScaler = round(size(X(:,:,1),2))/180;
% 
% 
%     
% X1 = X(1:yScaler:end, 1:xScaler:end, 1);
% X2 = X(1:yScaler:end, 1:xScaler:end, 2);
% X3 = X(1:yScaler:end, 1:xScaler:end, 3);
% 
% Y(:,:,1) = X1;
% Y(:,:,2) = X2;
% Y(:,:,3) = X3;

figure()
uicontrol('style','pushbutton', 'position', [10 10 46 32], 'Cdata', X)