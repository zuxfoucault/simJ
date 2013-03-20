%
% Similarity judgemant:
% triangular display
%

clear; clf;

% Name of data saved 
prompt = {'Enter ID: '};
dlg_title = 'Filename';
num_lines = 1;
default = {'IF_run1'};
savestr = inputdlg(prompt, dlg_title, num_lines, default);

% Supress ScreenTest checking behavior
%oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
%oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);

try
    ListenChar(2);
    addpath('expFigure');
    load('stiList.mat');
    
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
    
    % Sequency randomize
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
    
    
    % Open display window mg
    screenNum = 0;
    [wPtr, rect] = Screen('OpenWindow', screenNum);
    HideCursor;
    white = WhiteIndex(wPtr);
    Screen('FillRect', wPtr, white);
    
   
    % Show instuction
    imnameI = 'instro.bmp';
    imgI = imread(imnameI, 'bmp');
    textureIndexI = Screen('MakeTexture', wPtr, double(imgI));
    Screen('DrawTexture', wPtr, textureIndexI);
    Screen(wPtr, 'Flip');
    KbWait;
    while KbCheck; end;
    
    for nTrial = 1:3, % 1:trial
        
        
        % Extract img name
        imnameT = stiLabell{1, nTrial};
        imnameL = stiLabell{2, nTrial};
        imnameR = stiLabell{3, nTrial};
        
        % Image position and scaling
        imx = 530;
        imy = 0;
        imsx = 0.9;
        imsy = 0.9;
        destT = [rect(1) + imx, rect(2) + imy, (rect(3)*imsx) + imx, ...
            (rect(4)*imsy) + imy];
        
        imx = 140;
        imy = 500;
        destL = [rect(1) + imx, rect(2) + imy, (rect(3)*imsx) + imx, ...
            (rect(4)*imsy) + imy];
        
        imx = 940;
        imy = 500;
        destR = [rect(1) + imx, rect(2) + imy, (rect(3)*imsx) + imx, ...
            (rect(4)*imsy) + imy];
        
        % Read image
        imgT = imread(imnameT, 'bmp');
        imgL = imread(imnameL, 'bmp');
        imgR = imread(imnameR, 'bmp');
        textureIndexT = Screen('MakeTexture', wPtr, double(imgT));
        textureIndexL = Screen('MakeTexture', wPtr, double(imgL));
        textureIndexR = Screen('MakeTexture', wPtr, double(imgR));
        
        Screen('DrawTexture', wPtr, textureIndexT, rect, destT);
        Screen('DrawTexture', wPtr, textureIndexL, rect, destL);
        Screen('DrawTexture', wPtr, textureIndexR, rect, destR);
        
        
        [VBLTimestamp(nTrial), StimulusOnsetTime(nTrial)] = ...
            Screen(wPtr, 'Flip');
        
        FlushEvents('keyDown');
        
        % Get response
        responsetime(nTrial) = KbWait;
        [KeyIsDown, t, keyCode] = KbCheck;
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
       