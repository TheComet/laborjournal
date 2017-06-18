%
% Finds everything that resembles a THT resistor
%

function [match,  box, alpha] = findResistors(imfile)
image=imread(imfile);
imhsv=rgb2hsv(image);
imhsv(:,:,1)=imgaussfilt(imhsv(:,:,1), 3);

imfilt=hsv2rgb(imhsv);
imshow(imfilt);
axis image
imwrite(imfilt, '1.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% Enable this for color picker, though, it probably only works with blue
% resistors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    input(['Vergrössern sie einen Widerstand, \n' ...
            'so dass sie ein Pixel zwischen den Ringen\n'...
            'einfach anwählen können und drücken sie Enter']);
    
    disp('Klicken sie auf ein Feld mit der Grundfarbe des Widerstands')

    figure(1)
    [colY, colX] = ginput(1);
    colHSV=imhsv(floor(colX), floor(colY), :);
%}
hDef=.55;
colHSV=[0.55 0.37 0.75];

filtHSV=sqrt(10*(double(imhsv(:,:,1))-(colHSV(1))).^2 + ...
        (double(imhsv(:,:,2))-(colHSV(2))).^2 + ...
        (double(imhsv(:,:,3))-(colHSV(3))).^2);
filtHSV=(filtHSV-min(filtHSV));
filtHSV=filtHSV/max(filtHSV(:))<0.1;

filtHdef=((imhsv(:,:,1)>(hDef-0.02)) .* (imhsv(:,:,1)<(hDef+0.02))) .* ...
    ((imhsv(:,:,2)>0.1) .* (imhsv(:,:,3)>0.1)); % remove gray/black
                                                % objectsi
imfilt=(filtHdef.*filtHSV);

imfilt=imopen(imfilt, ones(4));
imwrite(imfilt, '3.jpg');
imfilt= bwconvhull(imfilt,'objects');
imwrite(imfilt, '4.jpg');

cc = bwconncomp(imfilt, 4);

mcc= regionprops(cc,'Centroid',...
    'MajorAxisLength','MinorAxisLength', ...
    'Area', 'ConvexArea', 'Perimeter', 'Orientation', 'Solidity');

labeled = labelmatrix(cc);
labeled = double(labeled);

orientation=[mcc.Orientation];
rect=(([mcc.MajorAxisLength]>=2.5*[mcc.MinorAxisLength]));
rect=logical(rect.*([mcc.Area]>mean([mcc.Area])));
I=mod(orientation, 90).*rect;
Q=mod(orientation+45, 90).*rect;

imwrite(I, '5.jpg');
imwrite(Q, '6.jpg');

filt=logical((I~=0)+(Q~=0));
I=I(filt);
Q=Q(filt);

imwrite(I, '7.jpg');
imwrite(Q, '8.jpg');

% remove outliers
SEM = 1.96*std(I)/sqrt(length(I));
Iin= logical((I<mean(I)+SEM) .* (I>mean(I)-SEM));

SEM = 1.96*std(Q)/sqrt(length(Q));
Qin= logical((Q<mean(Q)+SEM) .* (Q>mean(Q)-SEM));

I=I(logical(Iin+Qin));
Q=Q(logical(Iin+Qin));

imwrite(I, '9.jpg');
imwrite(Q, '10.jpg');

md=median(I);
mn=mean(I);
if abs(md-mn) < 7 || abs(mean(Q)-median(Q))>7
    alpha=mean(I);
else
    alpha=mean(Q)-45;
end

% TODO filter Winkel
winkel=logical((abs(mod(orientation,90)-alpha)<10) + (abs(90-mod(orientation,90)-alpha)<10));

select = (rect.*winkel);

alpha=-alpha;
labeled=imrotate(labeled, alpha);

labeled=double(ismember(labeled, find(select))).*labeled;
RGB_label = label2rgb(labeled, @spring, 'c', 'shuffle');
imshow(RGB_label)

imwrite(RGB_label, '11.jpg');

img=imrotate(image, alpha);
imwrite(img, '12.jpg');
imhsv=rgb2hsv(img);
imh=double(imhsv(:,:,1)).* ((imhsv(:,:,1)>(hDef-0.1)) .* (imhsv(:,:,1)<(hDef+0.1))) .* ...
    double((imhsv(:,:,2)>0.25) .* (imhsv(:,:,3)>0.25)); % remove gray/black objects
imh=imh/max(imh(:));


cc=bwconncomp(labeled);
mcc=regionprops(cc, 'MinorAxisLength', 'MajorAxisLength');
imgauss=imgaussfilt(imh, mean([mcc.MinorAxisLength]));
imwrite(RGB_label, '13.jpg');
imbw=im2bw(imadjust(imgauss));

labl=labelmatrix(bwconncomp(imbw));

RGB_label = label2rgb(labl, @spring, 'c', 'shuffle');
imwrite(RGB_label, '14.jpg');
imshow(RGB_label);

c=labl(logical(labeled));
M=unique(c(c~=0));

labl=double(ismember(labl, M)).*double(labl);
labl=labelmatrix(bwconncomp(labl));

imshow(img)

st=regionprops(labl, 'BoundingBox' );

match={}; match{length(st)}=[];
box={}; box{length(st)}=[];
ind=1;
for k = 1 : length(st)
    s = st(k).BoundingBox;
    
    match{ind}=imcrop(img, s);
    [a, b, ~] = size(match{ind});
    flip=false;
    if a<b
        flip=true;
        match{ind}=permute(match{ind},[2 1 3]);
        c=a; a=b; b=c;
    end
    
    box{ind}=s;
    
    if b*2>a
        match{ind+1}=match{ind}(:,1:ceil(end/2),:);
        match{ind}=match{ind}(:,ceil(end/2):end,:);

        box{ind+1}=box{ind};
        if flip
            box{ind+1}(4)=ceil(box{ind+1}(4)/2);
            box{ind}(2)=box{ind}(2)+box{ind+1}(4);
            box{ind}(4)=box{ind+1}(4);
        else
            box{ind+1}(3)=ceil(box{ind+1}(3)/2);            
            box{ind}(1)=box{ind}(1)+box{ind+1}(3);
            box{ind}(3)=box{ind+1}(3);
        end
        ind=ind+1;
    end

    ind=ind+1;
    end
end
