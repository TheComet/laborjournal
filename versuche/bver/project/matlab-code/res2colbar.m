function barImg = res2colbar(img)
[~,w,~]=size(img);

f=ones(1, 2*w);
f=2*f/sum(f(:));

barImg=(imfilter(img,f));
barImg=barImg(:,ceil(end/2),:);


