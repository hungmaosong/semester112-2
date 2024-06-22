t = 0:0.01:4; %unit step function only takes t>=0 parts
y = 5*exp(-2*t);

plot(t,y,'LineWidth',2);
xlabel('t s');
ylabel('y(t)');