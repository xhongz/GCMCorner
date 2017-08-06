% Authors---- zhang xiaohong
%Creation ----2006.12

function GCMDetector

if nargin == 0
    threshold = 0.001;
    sig =3.5;
    Near =1;
    k= 0;
    s = 1;  % have strong influence to house image ***  house:1,  j: 5,  
    H = 0.25;  % house: 0.1
    I = imread('lab.gif');
%  I = imread('astroid.bmp');
%     I = (I==1).*255;
    
%   
    I = im2double(I);
%     I = imnoise(I,'Gaussian',0,0.1);  
%     figure,imshow(I);
%     I = imresize(I,0.5);
%     I = imrotate(I,90);
end

% I = imnoise(I, 'gaussian', 0.02);

Gap_size =1;
L = 0;

BW=EDGE(I,'canny',[L,H],1.5);  % Detect edges,  don't use 2  ***
% figure,imshow(BW);
% tem = ~BW;
% imwrite(tem, 'edge.bmp')
% Gap_Size = 10;
[curve,curve_start,curve_end,curve_mode,curve_num]=extract_curve(BW,Gap_size);  

corner = [];
for j = 1:size(curve, 2)
    cur= curve{j};
    
    x=cur(:,2);
    y=cur(:,1);

    W= 100;

    [W, b] = Guassian(sig);
    L=length(x);
    if L>W
        % Calculate curvature
        if curve_mode(j,:) == 'loop'
            x1=[x(L-W+1:L);x;x(1:W)];
            y1=[y(L-W+1:L);y;y(1:W)];
        else
            x1=[ones(W,1)*2*x(1)-x(W+1:-1:2);x;ones(W,1)*2*x(L)-x(L-1:-1:L-W)];
            y1=[ones(W,1)*2*y(1)-y(W+1:-1:2);y;ones(W,1)*2*y(L)-y(L-1:-1:L-W)];
        end
    end
    
    
    y = y1';
    x = x1';    

    xtemp = convolution(x, b)';
    ytemp = convolution(y, b)';

    nLen = length(x);
    xx=[xtemp(2)-xtemp(1) ; (xtemp(3:nLen)-xtemp(1:nLen-2))/2 ; xtemp(nLen)-xtemp(nLen-1)]';
    yy=[ytemp(2)-ytemp(1) ; (ytemp(3:nLen)-ytemp(1:nLen-2))/2 ; ytemp(nLen)-ytemp(nLen-1)]';
    
    R = GCMatrix(xx,yy,W);
  

    P = R;
%     P = abs(msp);
    extremum=[];
    N=length(P);
    n=0;
    Search=1;

    
    for j=W+1:L+W
        if sum(P(j)>P(j-Near:j+Near))==(Near*2)
            n=n+1;
            extremum(n)=j-W;  % In extremum, odd points is minima and even points is maxima
        end    
    end
    
    P =abs(P(W+1:L+W));
    
    index1 = logical(zeros(1,size(cur,1)));
    index2 = index1;
    index1(extremum) = 1;
    index2 = (P>threshold);
    index = find((index1 & index2)==1);
    
   
    MiniCorner = min(P(index));
    P(index) = 0;  
    MaxnonCorner = max(P(index1));
    Ratio = MiniCorner/MaxnonCorner
    temp = cur(index', :);
    corner = [corner; temp]; 

end


figure, imshow(~BW);
hold on
plot(corner(:, 2), corner(:, 1), 'r.')