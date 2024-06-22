x = [1 -1 2 4];
y = [2 6 4 0 8 5 12];

for i = 1:(length(y)+1-length(x))
    disp(['h(', num2str(i), ') = ', num2str(h(i))]);
end