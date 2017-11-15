GUI Tool:  HSRLTOOL
Author:    Kyle Dawson
Date:      15-Nov-2017
Platform support:  MATLAB R2017b**
** sort of works with 2015 and can work with 2014, 2012.

% Usage Syntax:

x = hsrltool; % calls hsrltool and assigns to structure "x".

% Motivation:

Matlab provides no tool for importing HDF5 files

% Purpose:

This is a GUI application for use in simplifying import of HSRL .h5 files.
It's purpose is to quickly visualize data from the various groups and get
information on the variables like units and a long description. It is not 
to be used for scienfific analysis but only as a quick read tool.

% Functions:

To use, you must first navigate to the path
where the HSRL .h5 files are stored, either by pressing the browse button
or entering manually. Next, hit the "Go" button to populate the file list.

Select 1 file and then a group from the file from the drop down menu under
groupnames.

Select variables to add to the import container (hold cntrl or cmd for 
multiple). Here you can preview plot your selected variables and also get 
the file info like units, size, description, etc.

Once you have added all variables to the import container, press import.
This does two things. 
1) A structure is created that stores your selected variables
2) A file list is created to incorporate into scripts for easy reading of 
those variables. The file list contains the full pathname of the variables
selected.

Not a product of NASA# hsrltool
