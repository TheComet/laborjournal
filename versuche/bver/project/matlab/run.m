%imfile='test_images/DSC00508.JPG';
%imfile='test_images/DSC00510.JPG';
imfile='test_images/DSC00520.JPG';
%imfile='test_images/DSC00524.JPG';

[m,b,a]=findResistors(imfile);
val={};val{length(m)}=[];

for ind = 1:length(m)
   bar=res2colbar(m{ind});
   %imagesc(bar);
   %pause(2);

   val{ind}=rescol2value(bar);
   %val{ind}=b{ind};
end

markResistors(imfile, a, b, val);
