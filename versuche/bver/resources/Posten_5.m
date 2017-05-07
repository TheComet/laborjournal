img_sony=imread('Posten_5_Not_so_rainbow_dildos_0.png');

imshow(img_sony);

X=[153 884];
Y=[434 494];

p=[];
for i=0:11
    p=roipoly(img_sony, ...
    [ X(1)+i*round((X(2)-X(1))/12), ...
      X(1)+(i+1)*round((X(2)-X(1))/12), ...
      X(1)+(i+1)*round((X(2)-X(1))/12), ...
      X(1)+i*round((X(2)-X(1))/12)], ...
    [ Y(1) Y(1) Y(2) Y(2)]);    
    IM=max(img_sony(p));
    Im=min(img_sony(p));
    MTF=double(IM-Im)/double(IM+Im)
end
figure(1);
imagesc(img_sony)
%imagesc(double(img_sony).*double(p))

img_s6=imread('Posten_5_Rainbow_dildos_S6.png');
img_s6=rgb2gray(img_s6);
imshow(img_s6);

X=[412 958];
Y=[459 500];

p=[];
for i=0:11
    p=roipoly(img_s6, ...
    [ X(1)+i*round((X(2)-X(1))/12), ...
      X(1)+(i+1)*round((X(2)-X(1))/12), ...
      X(1)+(i+1)*round((X(2)-X(1))/12), ...
      X(1)+i*round((X(2)-X(1))/12)], ...
    [ Y(1) Y(1) Y(2) Y(2)]);    
    IM=max(img_s6(p));
    Im=min(img_s6(p));
    MTF=double(IM-Im)/double(IM+Im)
end
figure(1);
imagesc(img_s6)
%imagesc(double(img_s6).*double(p))