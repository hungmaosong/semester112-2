num = [1,1];
den = [1,2,1,3];
n = 0:1:30;
x = 1*ones(size(n)); %u[n]
y = filter(num, den, x);

plot(n,y);
xlabel('n');
ylabel('y[n]');