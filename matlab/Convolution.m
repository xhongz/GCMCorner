function Z = Convlution(X,Filter)
   LenF = length(Filter);
   HalfLen = fix(LenF/2);
   [Height,Width] = size(X);
 
   Result = zeros(Height,Width);
   Exp1 = zeros(Height,HalfLen);
   Exp2 = Exp1;
   
   a = HalfLen +1;
   c = LenF-1;
   
   for i = 1:HalfLen
      Exp1(:,a-i) = X(:,i+1);
      Exp2(:,i)=X(:,Width-i);
   end
   Y = [Exp1,X,Exp2];
   
   for i = 1:Width
       Result(:,i) = Y(:,i:i+c)*Filter';
   end
 Z = Result;
 