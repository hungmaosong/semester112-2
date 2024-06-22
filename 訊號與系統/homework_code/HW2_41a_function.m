function value = h(n)
    x = [1 -1 2 4];
    y = [2 6 4 0 8 5 12];

    if n==1
        value = y(1)/x(1); %常數項
        return;
    end
       
    temp = 0;

    for i = 1 : (n-1)
        temp = temp + h(i)*x(n-i+1);
    end

    value = (y(n)-temp);    
end

