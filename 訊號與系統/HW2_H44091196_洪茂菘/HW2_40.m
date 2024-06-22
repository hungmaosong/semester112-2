% n = 0:1:k 表示從 0 開始，每次增加 1，直到 k 結束。生成的向量是 [0, 1, 2, 3, 4, 5...]。
n = 0:1:20; 

%unit step function
u = zeros(size(n)); % 創建與n相同大小的零向量
u(n>=0) = 1;

x = cos(n*pi/6) .*u;
h = (0.6).^n .* u;

y = conv(x,h);

stem(0:length(y)-1, y, 'LineWidth', 1);
xlabel('n');
ylabel('y[n]');
title('Discrete System Output');