clear all;
training=load('training.mat');
training=training.training;
%% PCA to reduce the dimention from 256 to 20 

% centering
meanData=mean(training(:,1:256));
training(:,1:256)=training(:,1:256)-meanData(ones(size(training,1),1),:);
%testing(:,1:256)=testing(:,1:256)-meanData(ones(size(testing,1),1),:);

%compute the covariance matrix of each class
Cov=zeros(256,256);

for i=1:1000
    Cov(:,:)=Cov(:,:)+((training(i,1:256)-meanData(1:256))'*(training(i,1:256)-meanData(1:256)));
end;
Cov(:,:)=Cov(:,:)/1000;

eigens=cell(1,1);% eigen vectors, % eigen values
[eigens{1,1},eigens{1,2}]=eig(Cov(:,:));

%finidng 20 best eigen vectros based on eigen values
bestEigenVec=zeros(256,80);
[sortEigenValue ind]=sort(sum(eigens{1,2}));
bestEigenVec(:,1:80)=eigens{1,1}(:,177:256);
P=bestEigenVec;

%%

b=imread('1404409185.jpg');
%f=imread('image-0863.jpeg');
f=imread('1404410145.jpg');
% b=rgb2gray(b);
% f=rgb2gray(f);
b= b(:,:,1);
f= f(:,:,1);
%window=3;
%b = b(1:1072,1:1920);
%f = f(1:1072,1:1920);
block=16;
[m,n]=size(b);
% d1=m/15;
% d2=n/15;
% d3=d1*d2;
blockSize=block*block;
%lamda=0.8;
%T=zeros(d3*blockSize,blockSize);
alphaA=[];
sA=[];


%%
% Whole Picture
figure
imshow(f);
hold on;
for i=1:block:n
    for j=1:block:m
        %plot (i,j,'r.','MarkerSize',20); 
        f1=f(j:j+block-1,i:i+block-1);
        b1=b(j:j+block-1,i:i+block-1);
        %covariance
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
     if corr1<0.001
        f2=[];b2=[];
        for z=1:block
            f2=[f2,f1(z,:)];
            b2=[b2,b1(z,:)];
        end;
        s=(f2+b2)/2;
        alpha=1/2;
        %A=T'*T;
        for h=1:200
            first=P*inv(alpha*(P'*P)+(0.1*eye(80)));
            second=P'*(double(f2-b2+alpha*b2))';
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
        alpha;
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

