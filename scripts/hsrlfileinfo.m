function varargout = hsrlfileinfo(varargin)
% HSRLFILEINFO MATLAB code for hsrlfileinfo.fig
%      HSRLFILEINFO, by itself, creates a new HSRLFILEINFO or raises the existing
%      singleton*.
%
%      H = HSRLFILEINFO returns the handle to a new HSRLFILEINFO or the handle to
%      the existing singleton*.
%
%      HSRLFILEINFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HSRLFILEINFO.M with the given input arguments.
%
%      HSRLFILEINFO('Property','Value',...) creates a new HSRLFILEINFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hsrlfileinfo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hsrlfileinfo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hsrlfileinfo

% Last Modified by GUIDE v2.5 27-Oct-2015 13:52:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hsrlfileinfo_OpeningFcn, ...
                   'gui_OutputFcn',  @hsrlfileinfo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before hsrlfileinfo is made visible.
function hsrlfileinfo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hsrlfileinfo (see VARARGIN)

% Choose default command line output for hsrlfileinfo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hsrlfileinfo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hsrlfileinfo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
close(get(hObject,'Parent'))
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function pushbutton1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

% Getting gui1 data:
h1 = findobj('Tag','hsrltoolgui');
g1data = guidata(h1);

fn = g1data.readfile;
[~,fnshrt,ext] = fileparts(fn);
set(hObject,'String',[fnshrt,ext])
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)

% Getting gui1 data:
h1 = findobj('Tag','hsrltoolgui');
g1data = guidata(h1);

info = h5info(g1data.readfile);
group = g1data.group{:};
cellfun1 = @(x) ~isempty(x);
contents = {info.Groups.Name}';
whichgroup = cellfun(cellfun1,regexp(contents,group));
vars = {info.Groups(whichgroup).Datasets.Name}';
whichvars = ismember(vars,g1data.vars4info{:});
idx = find(whichvars);

for i1 = 1:numel(idx)
    atts = {info.Groups(2).Datasets(3).Attributes.Name}';
    uidx = strcmpi(atts,'unit');
    didx = strcmpi(atts,'description');
    units(i1,1) = {info.Groups(whichgroup)...
        .Datasets(idx(i1)).Attributes(uidx).Value}';
    desc(i1,1) = {info.Groups(whichgroup)...
        .Datasets(idx(i1)).Attributes(didx).Value}';
    
    dimstemp = info.Groups(whichgroup)...
        .Datasets(idx(i1)).Dataspace.Size;
    dims{i1,1} = sprintf('%dx%d',dimstemp);
    type{i1,1} = info.Groups(whichgroup)...
        .Datasets(idx(i1)).Datatype.Class;
    
    fillval(i1,1) = info.Groups(whichgroup)...
        .Datasets(idx(i1)).FillValue;
    
end

vv = vars(whichvars);
fvcell = num2cell(fillval);
Data = [vv,units,dims,type,fvcell,desc];

set(hObject,'Data',Data)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
