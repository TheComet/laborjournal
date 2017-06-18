function markResistors(imfile, alpha, box, val)
image=imread(imfile);
image=imrotate(image,alpha);
imshow(image);

for ind =1:length(box)
    rectangle('Position', box{ind}, 'LineWidth', 2, 'EdgeColor', [111 238 247]/255);
end

for ind =1:length(box)
    if ~isempty(val{ind})
        vala=strcat(string(val{ind}(1)), '\Omega or');
        valb=strcat(string(val{ind}(2)), '\Omega');
        str={'R = ', vala{1}, valb{1}};
        x=box{ind}(1);
        y=box{ind}(2);
        text(x,y,str,'FontSize',15);
    end
end