
ExifToolGUI v5
==================================================================================
ExifToolGUI can be saved anywhere on disk, but to avoid troubles, I recommend you to create new directory (outside Windows system directories) and put ExifToolGUI.exe there; for example:

	C:\ExifToolGUI
or	C:\WinTools\ETGUI

However, for exiftool.exe, the BEST place is inside C:\Windows directory.



ExifToolGUI files
==================================================================================
ExifToolGUI.exe
-GUI for exiftool

ExifToolGUIv5.ini
-this file, which contains various GUI settings, will be automatically created/updated on closing ExifToolGUI. If you delete this file, next time you run GUI, it will appear in "fresh" default state. Do not manually edit this file.

jhead_jpegtran
-this folder contains two exe files, which are used for rotating jpg files. If you think you might use this in ExifToolGUI, then copy both files (not folder) into C:\Windows directory. Otherwise, you can delete jhead_jpegtran folder.



Workspace ini files
==================================================================================
These files are not needed for GUI to work -they are there, so you have something to start with. Anyway, it is expected, that you will modify them (inside GUI) according to your needs. To use them, use menu:
	Program > Workspace definition file > Load


WorkspaceDef.ini
================
This file contains (minimal) default GUI workspace.

WorkspaceRef.ini
================
This file contains about 60 most used metadata tags from various metadata sections. As you will see, there are many tags having very similar purpose. So, it's expected that you will remove unwanted tags and only keep those you wish to modify regulary.

*NOTE: After you load some Workspace.ini file and modify it inside GUI, you don't need to save it: current Workspace is saved automatically everytime when you exit GUI, and loaded when you start GUI next time.
That is, you only save Workspace for backup purpose.


WorkspaceTag.mie
================
This is a metadata file (same as image file -but without image in it), which contains metadata tag example values for WorkspaceRef.ini file.
That is, after you load WorkspaceRef.ini file into GUI, just click on this mie file to see tag values for each tag in WorkspaceRef.

-END-
