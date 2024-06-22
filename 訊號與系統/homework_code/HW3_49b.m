numerator = [2 5];
denominator = [1 5 6];

t = 0:0.1:2;
y = step(numerator,denominator,t)

plot(t,y)

xlabel('time(s)')
ylabel('step response')