warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning
%% poke at a sample DNG file using imfinfo.
info = imfinfo('DSC01351.dng');
info.SubIFDs{1};
%% http://www.mathworks.com/help/matlab/ref/tiff-class.html
t = Tiff('DSC01351.dng','r');
offsets = getTag(t,'SubIFD');
setSubDirectory(t,offsets(1));
cfa = read(t);
close(t);
imtool(cfa);