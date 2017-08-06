function [width, gau] = Guassian(sig)       
	GaussianDieOff = .0001; 
	pw = 1:30; 
	ssq = sig*sig;
	width = 50;
	width = max(find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff));
	if isempty(width)
       width = 1;  
	end
	t = (-width:width);
	gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq); 
	gau=gau/sum(gau);
return