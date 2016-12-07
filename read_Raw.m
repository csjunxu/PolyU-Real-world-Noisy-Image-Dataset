row=1024;  col=1024;
fin=fopen('NIKOND40_0008_dng_converted','r');
I=fread(fin,row*col,'uint8=>uint8'); 
Z=reshape(I,row,col);
Z=Z';
k=imshow(Z);