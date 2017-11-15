function varargout = hsrltool(varargin)
% HSRLTOOL MATLAB code for hsrltool.fig
%      HSRLTOOL, by itself, creates a new HSRLTOOL or raises the existing
%      singleton*.
%
%      H = HSRLTOOL returns the handle to a new HSRLTOOL or the handle to
%      the existing singleton*.
%
%      HSRLTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HSRLTOOL.M with the given input arguments.
%
%      HSRLTOOL('Property','Value',...) creates a new HSRLTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hsrltool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hsrltool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hsrltool

% Last Modified by GUIDE v2.5 01-Mar-2016 11:10:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hsrltool_OpeningFcn, ...
                   'gui_OutputFcn',  @hsrltool_OutputFcn, ...
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


% --- Executes just before hsrltool is made visible.
function hsrltool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hsrltool (see VARARGIN)

% Choose default command line output for hsrltool
handles.output = hObject;
handles.mystruct = [];
handles.x = [];
set(handles.uipanel1,'Title','Action Center','fontsize',18,'fontname','helvetica')
set(handles.path_field,'String',[pwd filesep]);
% get files
fnames = dir([pwd filesep '*.h5']);
set(handles.filelist,'String',{fnames.name})


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hsrltool wait for user response (see UIRESUME)
uiwait(handles.hsrltoolgui);


% --- Outputs from this function are returned to the command line.
function varargout = hsrltool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.mystruct;
delete(handles.hsrltoolgui)


function path_field_Callback(hObject, eventdata, handles)
% hObject    handle to path_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_field as text
%        str2double(get(hObject,'String')) returns contents of path_field as a double


% --- Executes during object creation, after setting all properties.
function path_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir(pwd,'Set Path');
if path == 0;
    path = [pwd filesep];
else
    path = [path filesep];
end
set(handles.path_field,'String',path);


% --- Executes on button press in go_button.
% GO BUTTON
function go_button_Callback(hObject, eventdata, handles)
% hObject    handle to go_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.importcontainer,'Value',1);
set(handles.varcontainer,'String','Variables - You can preview these');
set(handles.varcontainer,'Value',1);
path_to_get = get(handles.path_field,'String');
addslash = isempty(regexp('[\/]',path_to_get(end),'once'));
if addslash
    d = dir([path_to_get filesep '*.h5']);
    set(handles.path_field,'String',[path_to_get filesep]);
else
    d = dir([path_to_get '*.h5']);
end
fnames = {d.name}';
set(handles.filelist,'String',fnames);

    

% --- Executes on selection change in filelist.
function filelist_Callback(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the selected file
isselect = strcmp(get(hObject,'Selection'),'on');
set(handles.groupselect,'Value',1);
set(handles.varcontainer,'Value',1);
set(handles.varcontainer,'String','Variables - You can preview these');
if isselect
    h = msgbox('This could be a minute. Wait while loading file.','Loading File','help');
    child = get(h,'Children');
    delete(child(3))
    set(hObject, 'Enable', 'off')
    pause(0.1)
    fileindex = get(hObject,'Value');
    files = get(hObject,'String');
    file4popup = files(fileindex);
    readfile = cell2mat([get(handles.path_field,'String') file4popup]);
    finfo = h5info(readfile);
    groups = {finfo.Groups.Name}';
    set(handles.groupselect,'String',[{'Select Data Group'};groups]);
    handles.readfile = readfile;
    handles.finfo = finfo;
    delete(h)
    pause(0.01)
    set(hObject, 'Enable', 'on')
    guidata(hObject,handles)
end

% Hints: contents = cellstr(get(hObject,'String')) returns filelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filelist


% --- Executes during object creation, after setting all properties.
function filelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in groupselect.
function groupselect_Callback(hObject, eventdata, handles)
% hObject    handle to groupselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.varcontainer,'Value',1)
isgroup = get(hObject,'Selection');
switch isgroup
    case {'on'}
        groups = get(hObject,'String');
        val = get(hObject,'Value');
        finfo = handles.finfo;
        try
            vars = {finfo.Groups(val-1).Datasets.Name}';
        catch
            vars = 'Empty Dataset';
        end
        set(handles.varcontainer,'String',[{'Variables - You can preview these'};vars]);
        handles.group = groups(val);
        guidata(hObject,handles)
end
        

% Hints: contents = cellstr(get(hObject,'String')) returns groupselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from groupselect


% --- Executes during object creation, after setting all properties.
function groupselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in varcontainer.
function varcontainer_Callback(hObject, eventdata, handles)
% hObject    handle to varcontainer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Max',length(get(hObject,'String'))+1)
% Hints: contents = cellstr(get(hObject,'String')) returns varcontainer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from varcontainer
contents = cellstr(get(hObject,'String'));
handles.vars4info = {contents(get(hObject,'Value'))}';
if isempty(handles.vars4info{:})
    set(handles.pushbutton9,'Enable','off')
else
    set(handles.pushbutton9,'Enable','on')
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function varcontainer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varcontainer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','Variables - You can preview these');
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in importcontainer.
function importcontainer_Callback(hObject, eventdata, handles)
% hObject    handle to importcontainer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        
% Hints: contents = cellstr(get(hObject,'String')) returns importcontainer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from importcontainer


% --- Executes during object creation, after setting all properties.
function importcontainer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to importcontainer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Max',1000);


% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = handles.x;
readvals = get(handles.varcontainer,'Value');
readvals(readvals==1) = [];
readvars = get(handles.varcontainer,'String');
vars2add = readvars(readvals);
if strcmp(vars2add,'Empty Dataset')
    vars2add = [];
end
varsold = get(handles.importcontainer,'String');
if all(strcmp(varsold,'Variables to Import'))
    vars2addplusold = [{'Variables to Import'};unique(vars2add,'stable')];
else
    varsold = varsold(2:end,:);
    vars2addplusold = [{'Variables to Import'};unique([varsold;vars2add],'stable')];
end


for i1 = 1:size(vars2add,1)
    x = [x;{[handles.readfile,char(handles.group),'/',vars2add{i1}]}];
end

set(handles.importcontainer,'String',vars2addplusold)
set(handles.varcontainer,'Selection','off')
newfiles = get(handles.importcontainer,'String');

handles.newfiles = newfiles;
handles.x = x;

guidata(hObject,handles);

% --- Executes on button press in delbutton.
function delbutton_Callback(hObject, eventdata, handles)
% hObject    handle to delbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vals = get(handles.importcontainer,'Value');
vars = get(handles.importcontainer,'String');
vars(vals(vals>1))=[];
set(handles.importcontainer,'Selection','off')
set(handles.importcontainer,'String',vars)
newfiles = handles.newfiles;
newfiles(vals-1) = [];
handles.newfiles = newfiles;
x = handles.x;
x(vals-1) = [];
handles.x = x;

if any(vals>size(get(handles.importcontainer,'String'),1))
    vindex = find(vals>size(get(handles.importcontainer,'String'),1));
    vals(vindex)=[];
    if isempty(vals)
        vals = size(get(handles.importcontainer,'String'),1);
    end
    set(handles.importcontainer,'Value',vals);    
end
guidata(hObject,handles);

% --- Executes on button press in importbutton.
function importbutton_Callback(hObject, eventdata, handles)
% hObject    handle to importbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = handles.x;
ischecked = get(handles.checkbox2,'Value');

data = ~isempty(x);
if data && ischecked == 1
   fid = fopen('import_these.txt','w');
   for i1 = 1:size(x,1)
        fprintf(fid,'%s\n',x{i1}');
   end
   fclose(fid);
end


% read in the data if there is any.
if data
    msg = 'Importing data now...';
    h = msgbox(msg,'Please Wait','help');
    child = get(h,'Children');
    delete(child(3));
    set(hObject,'enable','off')
    pause(0.01)
        for i2 = 1:size(x,1)
            strng = x{i2};
            findx = regexp(strng,'.*[.]h5','end');
            fn = strng(1:findx(end));
            strng(1:findx(end))=[];

            gn = regexp(strng,'/','split');

            temp = h5read(fn,strng);
            isnum = regexp(gn{3},'\d','once') == 1;

            if isnum
                fieldn = ['v' gn{3}];
            else
                fieldn = gn{3};
            end

            t = whos('fieldn');
            t = t.class;

            if strcmp(t,'cell')
                fieldn = fieldn{:};
            end   

             mystruct.(fieldn) = temp;
        end

    handles.mystruct = mystruct;    

    pause(0.01)
    delete(h)
    set(hObject,'enable','on')

else

 mystruct.error = 'No Variables Imported!';

end

handles.mystruct = mystruct;
     
guidata(hObject,handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vals = get(handles.varcontainer,'Value');
vname = get(handles.varcontainer,'String');
for i1 = 1:length(vals)
    fn = handles.readfile;
    fg = handles.group;
    variable = h5read(fn,cell2mat([fg '/' vname(vals(i1))]));
    if size(variable,2)<size(variable,1)
        variable = variable';
    end
    figure(i1)
    if any(size(variable)==1)
        plot(variable,'-k')
    else
        variable = double(variable);
        p=pcolor(variable); set(p,'edgecolor','none');
        axis xy;colorbar
        q90 = quantile(nanmean(variable,2),0.9);
        q10 = quantile(nanmean(variable,2),0.1);
        if q10 == q90
            q10 = 0;
        end
        caxis([q10,q90])
    end
    ylabel(vname(vals(i1)),'fontsize',16,'fontname','helvetica',...
        'interpreter','none');
    set(gca,'fontsize',16,'fontname','helvetica','tickdir','out',...
            'ticklength',get(gca,'ticklength')*3,'xminortick','on',...
            'yminortick','on')
end


% --- Executes when user attempts to close hsrltoolgui.
function hsrltoolgui_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to hsrltoolgui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);  
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
hsrlfileinfo
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton9_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
