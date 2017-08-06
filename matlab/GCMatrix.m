function R = GCMatrix(x,y,W)

k = 0.001;

b = [0.25 0.5 0.25];

Mxx = convolution(x.^2, b);
Myy = convolution(y.^2, b);
Mxy = convolution(x.*y, b);
% R = (x.^2).*(y.^2)-(x.*y).^2 - k*(x+y).^2;
R = (Mxx.*Myy-Mxy.^2);% -k*(Mxx+Myy).^2;
