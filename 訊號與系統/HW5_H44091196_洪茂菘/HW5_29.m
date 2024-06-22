Omega = 0:0.01:2*pi;
a = 0.75;
X = (1-a^2)./(1-2*a*cos(Omega) + a^2);
plot(Omega,abs(X));
xlabel('\Omega')
ylabel('X(\Omega)')