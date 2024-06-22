syms z;  % 聲明為符號，而不是数值
X = z / (z - 0.6);  

x = iztrans(X);  % reverse z-transform

disp(x);  % 打印结果