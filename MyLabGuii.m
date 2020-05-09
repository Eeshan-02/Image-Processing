function varargout = MyLabGuii(varargin)
% MYLABGUII MATLAB code for MyLabGuii.fig
%      MYLABGUII, by itself, creates a new MYLABGUII or raises the existing
%      singleton*.
%
%      H = MYLABGUII returns the handle to a new MYLABGUII or the handle to
%      the existing singleton*.
%
%      MYLABGUII('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYLABGUII.M with the given input arguments.
%
%      MYLABGUII('Property','Value',...) creates a new MYLABGUII or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MyLabGuii_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MyLabGuii_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MyLabGuii

% Last Modified by GUIDE v2.5 26-Jul-2019 10:49:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MyLabGuii_OpeningFcn, ...
                   'gui_OutputFcn',  @MyLabGuii_OutputFcn, ...
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


% --- Executes just before MyLabGuii is made visible.
function MyLabGuii_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MyLabGuii (see VARARGIN)

% Choose default command line output for MyLabGuii
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MyLabGuii wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MyLabGuii_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image_folder filenames total_images 
image_folder = uigetdir(path);
filenames = dir(fullfile(image_folder, '*.png'));
total_images = numel(filenames);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global total_images image_folder filenames final_images f  Entropy temp
global qGray glcms  maxProbability contrast_corre_energy_homogen Contrast Correlation Energy Homogeneity
for n = 1:total_images
    f = fullfile(image_folder, filenames(n).name);
    final_images = imread(f);  
    qGray = rgb2gray(final_images);
    glcms = graycomatrix(qGray);
    m = sum(sum(glcms));
    maxProbability(n) = max(glcms(:))/m;
    contrast_corre_energy_homogen = graycoprops(graycomatrix(glcms));
    Contrast(n) = contrast_corre_energy_homogen.Contrast;
    Correlation(n) = contrast_corre_energy_homogen.Correlation;
    Energy(n) = contrast_corre_energy_homogen.Energy;
    Homogeneity(n) = contrast_corre_energy_homogen.Homogeneity;
    Entropy(n) = entropy(glcms);
end

for i = 1:numel(filenames)
    temp{i} = getfield(filenames(i), 'name');

end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global q qImg qGray  total_images qmaxProbability qglcms qcontrast_corre_energy_homogen qContrast Entropy
global qCorrelation qEnergy qHomogeneity qEntropy qm Canbera maxProbability Contrast Correlation Energy Homogeneity
global name col_name out_x idx x contrast_corre_energy_homogen temp
q = imgetfile;
qImg = imread(q);
qGray = rgb2gray(qImg);
qglcms = graycomatrix(qGray);

axes(handles.axes1);
imshow(qImg);

qm = sum(sum(qglcms));
qmaxProbability = max(qglcms(:))/qm;
qcontrast_corre_energy_homogen = graycoprops(graycomatrix(qglcms));
qContrast = contrast_corre_energy_homogen.Contrast;
qCorrelation = contrast_corre_energy_homogen.Correlation;
qEnergy = contrast_corre_energy_homogen.Energy;
qHomogeneity = contrast_corre_energy_homogen.Homogeneity;
qEntropy = entropy(qglcms);


for n = 1:total_images
    
    Canbera(n) = (abs(maxProbability(n) - qmaxProbability))/(abs(maxProbability(n))+abs(qmaxProbability))+(abs(Contrast(n) - qContrast))/(abs(Contrast(n))+abs(qContrast))+(abs(Correlation(n) - qCorrelation))/(abs(Correlation(n))+abs(qCorrelation))+(abs(Energy(n) - qEnergy))/(abs(Energy(n))+abs(qEnergy))+(abs(Homogeneity(n) - qHomogeneity))/(abs(Homogeneity(n))+abs(qHomogeneity))+(abs(Entropy(n) - qEntropy))/(abs(Entropy(n))+abs(qEntropy));

end


name = cell2struct(temp,'Name',1);
col_name = {'Canbera Distance: '};
writetable(struct2table(name), 'Results3011.xlsx','Sheet',1);
xlswrite("Results3011.xlsx",[Canbera(:)],'Sheet1','B2');
xlswrite("Results3011.xlsx",col_name,'Sheet1','B1');

[x,idx]=sort(Canbera);
out_x= x(1:10);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename pathname data f2 out_x path image_folder filenames
global total_images qmaxProbability  qContrast Entropy 
global qCorrelation qEnergy qHomogeneity qEntropy Canbera2 maxProbability Contrast Correlation Energy Homogeneity


[filename pathname] = uigetfile({'*xlsx'},'File Selector');
data = xlsread(filename);
%[numbers, TEXT, everything] = xlsread("Results30.xlsx"); 

for n = 1:total_images
    f2 = fullfile(image_folder, filenames(n).name);
    Canbera2 = (abs(maxProbability(n) - qmaxProbability))/(abs(maxProbability(n))+abs(qmaxProbability))+(abs(Contrast(n) - qContrast))/(abs(Contrast(n))+abs(qContrast))+(abs(Correlation(n) - qCorrelation))/(abs(Correlation(n))+abs(qCorrelation))+(abs(Energy(n) - qEnergy))/(abs(Energy(n))+abs(qEnergy))+(abs(Homogeneity(n) - qHomogeneity))/(abs(Homogeneity(n))+abs(qHomogeneity))+(abs(Entropy(n) - qEntropy))/(abs(Entropy(n))+abs(qEntropy));

    for m = 1:10
        if(Canbera2 == out_x(m))
            path{m} = f2;
        else
            continue;
        end
      
    end
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path
axes(handles.axes2);
i1 = (path{1});
imshow(i1);
axes(handles.axes3);
i2 = (path{2});
imshow(i2);
axes(handles.axes4);
i3 = (path{3});
imshow(i3);
axes(handles.axes5);
i4 = (path{4});
imshow(i4);
axes(handles.axes6);
i5 = (path{5});
imshow(i5);
axes(handles.axes7);
i6 = (path{6});
imshow(i6);
axes(handles.axes8);
i7 = (path{7});
imshow(i7);
axes(handles.axes9);
i8 = (path{8});
imshow(i8);
axes(handles.axes10);
i9 = (path{9});
imshow(i9);
axes(handles.axes11);
i0 = (path{10});
imshow(i0);
