function varargout = areaDetection(varargin)
% AREADETECTION M-file for areaDetection.fig
%      AREADETECTION, by itself, creates a new AREADETECTION or raises the existing
%      singleton*.
%
%      H = AREADETECTION returns the handle to a new AREADETECTION or the handle to
%      the existing singleton*.
%
%      AREADETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AREADETECTION.M with the given input arguments.
%
%      AREADETECTION('Property','Value',...) creates a new AREADETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before areaDetection_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to areaDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help areaDetection

% Last Modified by GUIDE v2.5 08-Feb-2017 14:54:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @areaDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @areaDetection_OutputFcn, ...
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


% --- Executes just before areaDetection is made visible.
function areaDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to areaDetection (see VARARGIN)

% Choose default command line output for areaDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes areaDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = areaDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject,handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.jpg','Select the Image file');
if isequal(FileName,0)
   disp('User selected Cancel')
else
   disp(['User selected', fullfile(PathName, FileName)])
end
im1 = imread(fullfile(PathName, FileName));
 handles.RGB=im1;
% handles.RGB=imresize(im1,0.1);
axes(handles.axes1);
imshow(handles.RGB);
axes(handles.axes2);
guidata(hObject,handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles);





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RGB=handles.RGB;
I = rgb2gray(RGB);
RGB=handles.RGB;
hsvVal=[0.99 0.6 0.1];  %green color const. with hue=0.33 ,sat=0.6, val=0.1
tol=[0.15 0.5 0.5];     %tolerace

HSV = rgb2hsv(RGB);     %conver image to hsv

% find the difference between required and real H value:
diffH = abs(HSV(:,:,1) - hsvVal(1));

[M,N,t] = size(RGB);
I1 = zeros(M,N); I2 = zeros(M,N); I3 = zeros(M,N);%vari with size mxn

T1 = tol(1);

I1( find(diffH < T1) ) = 1;

if (length(tol)>1)
% find the difference between required and real S value:
diffS = abs(HSV(:,:,2) - hsvVal(2)); 
T2 = tol(2);
I2( find(diffS < T2) ) = 1; 
if (length(tol)>2)
% find the difference between required and real V value:
difV = HSV(:,:,3) - hsvVal(3); 
T3 = tol(3);
I3( find(diffS < T3) ) = 1;
I = I1.*I2.*I3;
else
I = I1.*I2;
end
else
I = I1; 
end
 axes(handles.axes1);
imshow(RGB); title('Original Image');
% imshow(I,[]); title('Detected Areas');
 axes(handles.axes2);
imshow(I); title('Detected Areas');
pause(1);

abc=imfill(I,'holes');
imshow(abc);title('BW image');
% I_out2=imcomplement(abc);
I=imfill(abc,'holes');
imshow(I);title('fill');
pause(2);
I=bwmorph(I,'majority');
imshow(I);title('majority');
pause(2);
I=bwmorph(I,'clean');
imshow(I);title('clean');
pause(2);
guidata(hObject,handles);
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RGB=handles.RGB;
I = rgb2gray(RGB);
RGB=handles.RGB;
hsvVal=[0.33 0.6 0.1];  %green color const. with hue=0.33 ,sat=0.6, val=0.1
tol=[0.15 0.5 0.5];     %tolerace

HSV = rgb2hsv(RGB);     %conver image to hsv

% find the difference between required and real H value:
diffH = abs(HSV(:,:,1) - hsvVal(1));

[M,N,t] = size(RGB);
I1 = zeros(M,N); I2 = zeros(M,N); I3 = zeros(M,N);%vari with size mxn

T1 = tol(1);

I1( find(diffH < T1) ) = 1;

if (length(tol)>1)
% find the difference between required and real S value:
diffS = abs(HSV(:,:,2) - hsvVal(2)); 
T2 = tol(2);
I2( find(diffS < T2) ) = 1; 
if (length(tol)>2)
% find the difference between required and real V value:
difV = HSV(:,:,3) - hsvVal(3); 
T3 = tol(3);
I3( find(diffS < T3) ) = 1;
I = I1.*I2.*I3;
else
I = I1.*I2;
end
else
I = I1; 
end
 axes(handles.axes1);
imshow(RGB); title('Original Image');
% imshow(I,[]); title('Detected Areas');
 axes(handles.axes2);
imshow(I); title('Detected Areas');
pause(1);

abc=imfill(I,'holes');
imshow(abc);title('BW image');
% I_out2=imcomplement(abc);
I=imfill(abc,'holes');
imshow(I);title('fill');
pause(2);
I=bwmorph(I,'majority');
imshow(I);title('majority');
pause(2);
I=bwmorph(I,'clean');
imshow(I);title('clean');
pause(2);
guidata(hObject,handles);
