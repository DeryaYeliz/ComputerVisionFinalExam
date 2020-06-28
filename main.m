net = googlenet;
I = imread("ITU_Golet_Ari.jpeg");
rawPixelSize = 120;%90
columnPixelSize = 160;%200

splittedImg = mat2tiles(I,[rawPixelSize,columnPixelSize,3]);

figure
montage(splittedImg, 'Size', [size(splittedImg,1) size(splittedImg,1)]);

inputSize = net.Layers(1).InputSize;


for i=1:size(splittedImg,1)
    for j=1:size(splittedImg,2)
        I_temp = imresize(splittedImg{i,j},inputSize(1:2));
        label = classify(net,I_temp);
        if(categorical(label) == "bee")
            figure
            imshow(I_temp)
            title(string(label))
            x = i;
            y = j;
        end
    end
end

load('gTruth.mat');

myRectanglePos = [columnPixelSize*(y-1),rawPixelSize*(x-1),columnPixelSize,rawPixelSize];
gTruthRectanglePos = [gTruth.LabelData.Bee{1,1}(1,1),gTruth.LabelData.Bee{1,1}(1,2),gTruth.LabelData.Bee{1,1}(1,3),gTruth.LabelData.Bee{1,1}(1,4)];

figure
imshow(I)
hGTruth = drawrectangle('Position',gTruthRectanglePos,'Color','green')
h = drawrectangle('Position',myRectanglePos,'Color','red')
%save('gTruth.mat','gTruth');


%performance
area_intersection = rectint(myRectanglePos,gTruthRectanglePos);
area_myrectangle = rectint(myRectanglePos, myRectanglePos);
area_gTruthRectangle = rectint(gTruthRectanglePos, gTruthRectanglePos);
area_union = area_gTruthRectangle + area_myrectangle - area_intersection;

accuracy = area_intersection/area_union
