%
% Similarity judgemant:
% triangular display with Mondrian patch
%
% Use top figure as probe and choose which of the two figures 
% in the bottom most similar as top one
%

clear; clf;

% Name of data saved
prompt = {'Enter ID: '};
dlg_title = 'Filename';
num_lines = 1;
default = {'IF_run1'};
savestr = inputdlg(prompt, dlg_title, num_lines, default);

% Dominant Eye setup
prompt = {'Enter right or left eye: "rig" or "lef"'};
dlg_title = 'Dominant Eye';
num_lines = 1;
default = {'rig'};
dE = inputdlg(prompt, dlg_title, num_lines, default);

% Supress ScreenTest checking behavior
%oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
%oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);

try
    ListenChar(2);
    addpath('expFigure');
    addpath('figureMondrian');
    load('stiList.mat');
    load('monLabels.mat');
    
    % After PsychtoolboxKernalDriver installed
    v = bitor(2^16, Screen('Preference','ConserveVRAM'));
    Screen('Preference','ConserveVRAM', v);
    HideCursor;
    
    % Variables
    trial = 12;
    stiLabell = num2cell(zeros(7, trial));
    VBLTimestamp = zeros(1, trial);
    StimulusOnsetTime = zeros(1, trial);
    responsetime = zeros(1, trial);
    t = zeros(1, trial);
    response = num2cell(zeros(1, trial));
    RT = zeros(1, trial);
    rectM = [0, 0, 226, 226];
    rectI = [0, 0, 600, 600];
    
    % Sequency randomization of trial presentaion
    listA = 1:length(stiLabel);
    index = Shuffle(listA);
    % 2 sides randomize
    listB = repmat([2, 3], 1, length(stiLabel)/2);
    indexB = Shuffle(listB);
    % Prepare list flow
    for i = 1:length(stiLabel),
        stiLabell(1,i) = stiLabel(1,index(i));
        stiLabell(2,i) = stiLabel(indexB(i),index(i));
        stiLabell(3,i) = stiLabel((5 - indexB(i)),index(i));
        stiLabell(4,i) = stiLabel((indexB(i) + 2),index(i));
        stiLabell(5,i) = stiLabel((7 - indexB(i)),index(i));
    end;
    
    % Image position and scaling
    
    %dE = 'rig';
    %dE = 'lef';
    if strcmp('rig', dE),
        h1 = 0; h2 = 800;
    elseif strcmp('lef', dE);
        h1 = 800; h2 = 0;
    end;
    
    mh = 25; % horizontal micro-adjustment
    imsx = 0.6;
    imsy = 0.6;
    imx = (800*2/4) - (300*imsx) + h1 + mh;
    imy = 220;
    destT = [rectI(1) + imx, rectI(2) + imy, (rectI(3)*imsx) + imx, ...
        (rectI(4)*imsy) + imy];
    
    imx = (800/4) - (300*imsx) + h1 + mh;
    imy = 520;
    destL = [rectI(1) + imx, rectI(2) + imy, (rectI(3)*imsx) + imx, ...
        (rectI(4)*imsy) + imy];
    
    imx = (800*3/4) - (300*imsx) + h1 + mh;
    imy = 520;
    destR = [rectI(1) + imx, rectI(2) + imy, (rectI(3)*imsx) + imx, ...
        (rectI(4)*imsy) + imy];
     
    % Mondrial patch size and position
    imsMx = 600/266*imsx*1.5;
    imsMy = 600/266*imsy;
    
    imx = (800*2/4) - (300*imsx) + h2 - 40 + mh;
    imy = 200;
    destM = [rectM(1) + imx, rectM(2) + imy, (rectM(3)*imsMx) + imx, ...
        (rectM(4)*imsMy) + imy];
    
    imx = (800/4) - (300*imsx) + h2 + mh;
    imy = 520;
    destML = [rectI(1) + imx, rectI(2) + imy, (rectI(3)*imsx) + imx, ...
        (rectI(4)*imsy) + imy];
    
    imx = (800*3/4) - (300*imsx) + h2 + mh;
    imy = 520;
    destMR = [rectI(1) + imx, rectI(2) + imy, (rectI(3)*imsx) + imx, ...
        (rectI(4)*imsy) + imy];
           
    % Open display window mg
    screenNum = 0;
    [wPtr, rect] = Screen('OpenWindow', screenNum);
    HideCursor;
    white = WhiteIndex(wPtr);
    Screen('FillRect', wPtr, white);
    
    
    % Show instruction
    imnameI = 'instro.bmp';
    imgI = imread(imnameI, 'bmp');
    textureIndexI = Screen('MakeTexture', wPtr, double(imgI));
    Screen('DrawTexture', wPtr, textureIndexI);
    Screen(wPtr, 'Flip');
    KbWait;
    while KbCheck; end;
    
    
    % Trial loops
    for nTrial = 1:trial, % 1:trial
             
        % Extract img name        
        imnameT = stiLabell{1, nTrial};
        imnameL = stiLabell{2, nTrial};
        imnameR = stiLabell{3, nTrial};
        imnameM = monLabels{nTrial};
        
        % Read image       
        imgT = imread(imnameT, 'bmp');
        imgL = imread(imnameL, 'bmp');
        imgR = imread(imnameR, 'bmp');
        imgM = imread(imnameM, 'jpg');
        
        textureIndexT = Screen('MakeTexture', wPtr, double(imgT));
        textureIndexL = Screen('MakeTexture', wPtr, double(imgL));
        textureIndexR = Screen('MakeTexture', wPtr, double(imgR));               
        textureIndexM = Screen('MakeTexture', wPtr, double(imgM));
        
        Screen('DrawTexture', wPtr, textureIndexT, rectI, destT);
        Screen('DrawTexture', wPtr, textureIndexL, rectI, destL);
        Screen('DrawTexture', wPtr, textureIndexR, rectI, destR);
        Screen('DrawTexture', wPtr, textureIndexM, rectM, destM);
        Screen('DrawTexture', wPtr, textureIndexL, rectI, destML);
        Screen('DrawTexture', wPtr, textureIndexR, rectI, destMR);
        
        [VBLTimestamp(nTrial), StimulusOnsetTime(nTrial)] = ...
            Screen(wPtr, 'Flip');
        
        FlushEvents('keyDown');
      
        % Mondrian loop
        nMon = 1;
        KeyIsDown = 0;
        while KeyIsDown == 0,
            
            % Get response
            [KeyIsDown, responsetime(nTrial), keyCode] = KbCheck;
            response{nTrial} = KbName(keyCode);
            
            if nMon == 67, nMon = 1; end;
            imnameM = monLabels{nMon};
            imgM = imread(imnameM, 'jpg');
            textureIndexM = Screen('MakeTexture', wPtr, double(imgM));            
            Screen('DrawTexture', wPtr, textureIndexT, rectI, destT);
            Screen('DrawTexture', wPtr, textureIndexL, rectI, destL);
            Screen('DrawTexture', wPtr, textureIndexR, rectI, destR);
            Screen('DrawTexture', wPtr, textureIndexM, rectM, destM);
            Screen('DrawTexture', wPtr, textureIndexL, rectI, destML);
            Screen('DrawTexture', wPtr, textureIndexR, rectI, destMR);
            Screen(wPtr, 'Flip');
            nMon = nMon + 1;
        end;
        
        response{nTrial} = KbName(keyCode);
        
        RT(nTrial) = responsetime(nTrial) - StimulusOnsetTime(nTrial);
        
        stiLabell{6, nTrial} = response(nTrial);
        stiLabell{7, nTrial} = RT(nTrial);
        
        while KbCheck; end;
        
    end;
    
    % Close display window
    ListenChar(0);
    Screen('CloseAll');
    ShowCursor;
    clear mex;
    
    % Restore preferences
    %Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    %Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    
    
    strN = ['tri_', date,  '_', savestr{1}];
    strV = {'RT', 'StimulusOnsetTime', 'VBLTimestamp', 'index',...
        'indexB', 'keyCode', 'listA', 'listB', 'response', ...
        'responsetime', 'stiLabel', 'stiLabell'};
    save(strN, strV{:});
    
    
catch err,
    % Close display window
    ListenChar(0);
    Screen('CloseAll');
    ShowCursor;
    clear mex;
    
    % Restore preferences
    %Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    %Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);    
    
end;
