for /r C:\Users\csjunxu\Desktop\Projects\RID_Dataset\20161224DF\ %%i in (*.ARW) do dcraw -D -4 -j -t 0 %%i
for /r C:\Users\csjunxu\Desktop\Projects\RID_Dataset\20161224DF\ %%i in (*.ARW) do dcraw -4 -T -D -v %%i