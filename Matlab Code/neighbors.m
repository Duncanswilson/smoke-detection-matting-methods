function neigh=neighbors(k,k4,window,block)

window=window+2;
neigh=zeros(1,((window)*(window)));
f=1;
for i=(k-floor(window/2)):(k+floor(window/2))
    
    for j=(k4-floor(window/2)):(k4+floor(window/2))
        if i<1 || i>block
        elseif j<1 || j>block
        elseif i==k && j==k4
        else
            neigh(f)=((i-1)*block+j);
            f=f+1;
        end;
    end;
end;


end