% $ Author : Suraj Gampa $ 
%% 
clc;
clear all;
close all;
%%
%use to change names of images from 1_0_0 to 001.png. Specify the input
%folder and the output folder bears the same name with -ren appended in the
%end. 
%% 
filename1 = 'C:\Users\sgamp\Desktop\Tobacco\128-099\'; 
srcFilesT = dir(filename1);
for i1 = 3 : length(srcFilesT)
    a = strcat(filename1,srcFilesT(i1).name,'\Hyp_SV_90','\*.png');
    srcFiles = dir(a);
    a1 = strcat(srcFilesT(i1).name(1:60),'-renamed');
    status = mkdir(filename1,a1);
    for i = 1 : length(srcFiles)
        filename = strcat(filename1,srcFilesT(i1).name,'\Hyp_SV_90','\',srcFiles(i).name);
        I = imread(filename);
        q = srcFiles(i).name;
        q1 = length(q);
        if q1 == 10
            b = q(1:2);
            c = strcat('0',b);
            img_dir = strcat(filename1,a1,'\',c);
            img_name = strcat(img_dir,'.png');
            imwrite(I,img_name);
        end
        if q1 == 11
            b = q(1:3);
            img_dir_1 = strcat(filename1,a1,'\',b);
            img_name_1 = strcat(img_dir_1,'.png');
            imwrite(I,img_name_1);      
        end
        if q1 == 9
            b = q(1);
            c = strcat('00',b);
            img_dir_2 = strcat(filename1,a1,'\',c);
            img_name_2 = strcat(img_dir_2,'.png');
            imwrite(I,img_name_2);      
        end
    end
end

fileName2 = strcat(filename1,'..-ren');
fileName3 = strcat(filename1,'.-ren');
status1 = rmdir(fileName2);
status2 = rmdir(fileName3);

%%
% %This code is used to create hyperspectral cubes of cotton plants. We have
% %to define the path for retrieval and storage. They are present in exp1 and
% %exp2 folders.
clc;
clear all;
close all;
fileName = 'C:\Users\sgamp\Desktop\Tobacco\128-099 \';
srcFilesT = dir(fileName);
for i1 = 3 : length(srcFilesT)
    z1 = srcFilesT(i1).name;
    z3 = length(z1); 
    if z3 > 3
    z4 = z1(end-3:end);
    z2 = strcmp(z1(end-7:end),'-renamed');
    if z2 == 1
        a1 = strcat(fileName,srcFilesT(i1).name,'\*.png');
        srcFiles = dir(a1);
        no_of_iterations = size(srcFiles);
        hyperspectral_cube = [];
        cube_location = strcat(fileName,srcFilesT(i1).name);
        for num = 1 : no_of_iterations
            s1 = strcmp(srcFiles(num).name,'001.png');
            s2 = strcmp(srcFiles(num).name,'1_0_0.png');
            s3 = srcFiles(num).name;
            if s1~=1 && s2~=1
                filename = strcat(fileName,srcFilesT(i1).name,'\',srcFiles(num).name);
                a = srcFiles(num).name;
                image = imread(filename);
                image_gray = rgb2gray(image);
                hyperspectral_cube = cat(3, hyperspectral_cube, image_gray);
            end
        end
        file_loc = strcat(srcFilesT(i1).name,'.mat');
        file_path = strcat(fileName,'\',file_loc);
        save(file_path, 'hyperspectral_cube');
    end
   end
end
%%
%This file stores segmented cubes of the input plant folder in a folder
%called segmented cotton inside the same plant folder. Each cube in the
%folder contains segmented hyperspectral image pixel values.
clc;
clear all;
close all;
fileName1 = 'C:\Users\sgamp\Desktop\Tobacco\128-099\';
fileName2 = strcat(fileName1,'*.mat');
srcFile = dir(fileName2);
status = mkdir(fileName1,'segmentedTobacco');
for i3 = 1 : length(srcFile)
    a = strcat(srcFile(i3).folder,'\',srcFile(i3).name);
    a1 =  load(a,'-mat');
    b = cell2mat(struct2cell(a1));
    c1 = b(:,:,101);
    c21 = b(:,:,34);

    if i3 < 24
        c12 = 1.7*c1;
        c12 = imadjust(c12);
        c12 = imgaussfilt(c12);
        figure,imshow(c12);
        c21 = 3.5*c21;
        c21 = imadjust(c21);
        c21 = imgaussfilt(c21);
        figure,imshow(c21);
        c3 = c12 - c21;
        c31 = im2bw(c3); 
        c31 = bwareaopen(c31,500);
        figure,imshow(c31);
    end
    
    if i3 >= 24
        c12 = 1.4*c1;
        c12 = imadjust(c12);
        c12 = imgaussfilt(c12);
        figure,imshow(c12);
        c21 = 3.5*c21;
        c21 = imadjust(c21);
        c21 = imgaussfilt(c21);
        figure,imshow(c21);
        c3 = c12 - c21;
        c31 = im2bw(c3); 
        c31 = bwareaopen(c31,500);
        figure,imshow(c31);
    end
    
    
    [m,n] = size(c31);
    r = zeros();
    p = 1;
    for i = 1:m
        for j = 1:n
            if c31(i,j) ~= 0 
                r(1,p) = i;
                r(2,p) = j;
                p = p+1;
            end
        end
    end
    [m1,n1] = size(r);
    m2 = zeros();
    for i2 = 1:244
        p1 = 1;
        c = b(:,:,i2);
        for i1 = 1:n1
            e1 = r(1,i1);
            e2 = r(2,i1);
            m2(i2,p1) = c(e1,e2);
            p1 = p1+1;
        end
    end
    l = strcat(fileName1,'segmentedTobacco');
    a21 = strcat(srcFile(i3).name(1:60),'segMat');
    a2 = strcat(l,'\',a21,'.mat');
    save(a2,'m2');
end
%%
%This file stores segmented cubes of the input plant folder in a folder
%called segmented cotton inside the same plant folder. Each cube in the
%folder contains segmented hyperspectral image pixel values.
clc;
clear all;
close all;
fileName1 = 'C:\Users\sgamp\Desktop\Tobacco\128-099\';
fileName2 = strcat(fileName1,'*.mat');
srcFile = dir(fileName2);
for i3 = 1 : length(srcFile)
    a = strcat(srcFile(i3).folder,'\',srcFile(i3).name);
    a1 =  load(a,'-mat');
    b = cell2mat(struct2cell(a1));
    c1 = b(:,:,101);
    c21 = b(:,:,34);

    if i3 < 24
        c12 = 1.7*c1;
        c12 = imadjust(c12);
        c12 = imgaussfilt(c12);
        figure,imshow(c12);
        c21 = 3.5*c21;
        c21 = imadjust(c21);
        c21 = imgaussfilt(c21);
        figure,imshow(c21);
        c3 = c12 - c21;
        c31 = im2bw(c3); 
        c31 = bwareaopen(c31,500);
        figure,imshow(c31);
    end
    
    if i3 >= 24
        c12 = 1.4*c1;
        c12 = imadjust(c12);
        c12 = imgaussfilt(c12);
        figure,imshow(c12);
        c21 = 3.5*c21;
        c21 = imadjust(c21);
        c21 = imgaussfilt(c21);
        figure,imshow(c21);
        c3 = c12 - c21;
        c31 = im2bw(c3); 
        c31 = bwareaopen(c31,500);
        figure,imshow(c31);
    end
    
    [m,n] = size(c31);
    r = zeros();
    p = 1;
    for i = 1:m
        for j = 1:n
            if c31(i,j) ~= 0 
                r(1,p) = i;
                r(2,p) = j;
                p = p+1;
            end
        end
    end
    l = strcat(fileName1,'segmentedTobacco');
    a21 = strcat(srcFile(i3).name(1:60),'pixLoc');
    a2 = strcat(l,'\',a21,'.mat');
    save(a2,'r');
end
%%
%This file is used to create a single mat file in segmentedFolder of plant
%folder which contains all plant pixels for all days labeled.
clc;
clear all;
close all;
z = 'C:\Users\sgamp\Desktop\Tobacco\128-099\segmentedTobacco\*.mat';

srcFile = dir(z);
j = 1;
j1 = 1;
c = zeros(1,245);
c1 = zeros(1,6);
for i = 1 : length(srcFile)
    a = srcFile(i).name;
    ca = strcat(a(22:24),a(26:28));
    cb = strcat(a(42:45),a(47:48),a(50:51));
    cc = strcat(a(53:54),a(56:57),a(59:60));
    cc2 = a(37:40);
    treatment_ID = strcmp(cc2,'SD-4');
    if treatment_ID == 1
        cc3 = 24;
    else
        cc3 = 0;
    end
    ca = str2double(ca);
    cb = str2double(cb);
    cc = str2double(cc);
 %   cc2 = str2double(cc2);
    d = a(end-9:end-4);
    if d == 'segMat'
        a1 = strcat(srcFile(i).folder,'\',a);
        a2 =  load(a1,'-mat');
        b = cell2mat(struct2cell(a2));
        b1 = transpose(b);
        [f,g] = size(b1);
        jm = zeros();
        for i1 = 1:f
            jm(i1,1) = j;
        end
        b12 = horzcat(jm,b1);
        c = vertcat(c,b12);
        disp(j);
        j = j+1;
    end
    if d == 'pixLoc'
        a3 = strcat(srcFile(i).folder,'\',a);
        a4 = load(a3,'-mat');
        b2 = cell2mat(struct2cell(a4));
        b3 = transpose(b2);
        [m3,n3] = size(b3);
        b32 = zeros(1,4);
        for q1 = 1:m3
            b32(q1,1) = ca;
            b32(q1,2) = cb;
            b32(q1,3) = cc;
            b32(q1,4) = cc3;
        end
        b3 = horzcat(b3,b32);
        c1 = vertcat(c1,b3);
        j1 = j1+1;       
    end
    disp(a);
end

z1 = z(end-31:end-23);
z1 = strcat(z1(1:3),z1(5),z1(7:9));
z1 = str2double(z1);

c2 = zeros(1,1);
[m,n] = size(c);
for j = 1:m
    c2(j,1) = z1;
end

d = c(:,1);
c = c(:,2:end);
c = horzcat(c1(:,3),d,c1(:,1:2),c1(:,4:end),c);
c = c(2:end,:);

z = z(1:end-5);
z2 = num2str(z1);
z2 = strcat(z2,'.mat');
z3 = strcat(z,z2);

save(z3,'c');

%% All plant pixels into a single cumulative matfile
clc;
clear all;
close all;
srcFile = dir('C:\Users\sgamp\Desktop\Tobacco\AllPlantPixels\*.mat');
c = zeros(1,251);
for i3 = 1 : length(srcFile)
    a = strcat(srcFile(i3).folder,'\',srcFile(i3).name);
    a1 =  load(a,'-mat');
    b = cell2mat(struct2cell(a1));
    c = vertcat(c,b);
end
c = c(2:end,:);
z = 'C:\Users\sgamp\Desktop\Tobacco\AllPlantPixels\LabelledAllPlantPixels-Tobacco.mat';
save(z,'c');
%% Spectral Curve Generation
a = load('C:\Users\sgamp\Desktop\sorghumPlant\108-31-304\segmentedCotton\10-22-sorg-clemente_108-31-304-LN_2018-11-19_09-33-14_302120segMat.mat');
b = cell2mat(struct2cell(a));