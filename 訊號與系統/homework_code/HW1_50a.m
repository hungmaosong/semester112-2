t = -2:1:4;
x = 2*t .* (t>=0);

plot(t,x,'LineWidth',2);
xlabel('t s');
ylabel('x(t)');