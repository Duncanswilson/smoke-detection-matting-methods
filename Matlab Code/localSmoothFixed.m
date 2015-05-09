clear all;
warning off;
%reading back ground and forgraound image
b=imread('image-0003.jpeg');
f=imread('image-2103.jpeg');
%b=rgb2gray(b);
%f=rgb2gray(f);
b= b(:,:,1);
f= f(:,:,1);
b=b(1:1072,:);
f=f(1:1072,:);
%window=3;
window=3;
block=16;
[m,n]=size(b);
% d1=m/15;
% d2=n/15;
% d3=d1*d2;
blockSize=block*block;
lamda=0.7;
%T=zeros(d3*blockSize,blockSize);
alphaA=[];
sA=[];


%%
% Whole Picture
figure
imshow(f);
hold on;
% plot (2048,1,'r.','MarkerSize',20);
% hold on; 
for i=1:block:n
    for j=1:block:m
     if i == 1626 && j == 778
         plot (i,j,'r.','MarkerSize',20);
     end;
        f1=f(j:j+block-1,i:i+block-1);
        b1=b(j:j+block-1,i:i+block-1);
        
        f3=double(reshape(f1,[256,1]));
        b3=double(reshape(b1,[256,1]));
%         corr1=cov(f3,b3)/var(f3)*var(b3);
        f3mean=mean(f3);
        b3mean=mean(b3);
        f3=f3-f3mean;
        b3=b3-b3mean;
        zarb=f3.*b3;
        zarb=sum(zarb);
        f3f3=f3.*f3;
        f3f3=sum(f3f3);
        b3b3=b3.*b3;
        b3b3=sum(b3b3);
        corr1=zarb/sqrt(f3f3*b3b3);
     if corr1<0.0001
        f2=[];b2=[];
        for z=1:block
            f2=[f2,f1(z,:)];
            b2=[b2,b1(z,:)];
        end;
        s=(f2+b2)/2;
        alpha=1/2;
        k1=1;k2=0;
        %in a block
        %creating matrix A
        [m1,n1]=size(f1);
        windowSize=(window+2)*(window+2);
        T=zeros(blockSize*(windowSize-1),blockSize);
        for k=1:m1
            for k4=1:n1
                %k=2;k4=2;
                neighbor=neighbors(k,k4,window,block);
                selfN=((k-1)*block+k4);
                k1=k2+1;
                k3=1;
                for k2=k1:k1+7
                   
                    if neighbor(k3)~=0
                        T(k2,neighbor(k3))=-1;
                        T(k2,selfN)=1;
                    end;
                     k3=k3+1;
                end;
            end;
        end;
        %
        A=T'*T;
        %loop here for 200 times to optimize the parameters 
        for h=1:200
            first=inv(alpha*alpha*eye(blockSize)+lamda*A);
            second=double(alpha*(f2-b2+alpha*b2)');
            sP=first*second;
            third=(double(b2)-sP')*(double(f2-b2))';
            forth=(double(b2)-sP')*(sP'-double(b2))';
            alphaStar=third/forth;
            if alphaStar<=0 
                alpha=0;
            elseif alphaStar>=1
                alpha=1;
            else
                alpha=alphaStar;
            end
        end
        alpha
        alphaA=[alphaA,alpha];
        sA=[sA;sP];
        if alpha > 0.1 && alpha <= 0.3
            %plot (i,j,'k.','MarkerSize',20)
        elseif alpha > 0.3 && alpha < 0.5
            plot (i,j,'r.','MarkerSize',20)
        elseif alpha >= 0.5 && alpha < 0.9
            plot (i,j,'b.','MarkerSize',20)
        elseif alpha >= 0.9
            plot (i,j,'g.','MarkerSize',20)
        end;
        hold on;
     end;
    end;
end;

