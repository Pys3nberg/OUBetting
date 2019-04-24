function UObettingv52()

if ~exist('Data','dir')
    mkdir('Data')
end

global years
years = {'1112','1213','1314', '1415', '1516', '1617', '1718', '1819'};
%% Figure setup
scrsz = get(0,'screensize');
fig = figure('pos',[50 50 (scrsz(3))-100 scrsz(4)-100],'menubar','none',...
    'name','OUbetting V5','numbertitle','off');
figcol = get(fig, 'color');

%% setup tabs
htab = uitabgroup;
ratingstab = uitab(htab,'title','Ratings','backgroundcolor',figcol);
histTab = uitab(htab,'title','History','backgroundcolor',figcol);
matchHist = uitab(htab,'title','Match History','backgroundcolor',figcol);
penplusPanel = uipanel('parent',ratingstab, 'title',' Pentration plus',...
    'units','normalized','position', [0.1 0.8 0.2 0.1]);
handles.penPlusRatings = uicontrol('parent',penplusPanel,'style','text','units',...
    'normalized','position',[0.1 0.1 0.5 0.5]);
handles.prp = uipanel('Title','Power Ratings','units','normalized',...
    'parent',ratingstab, 'position', [0.1 0.7 0.2 0.1]);
handles.fixtables = uitable('parent',ratingstab,'units','normalized',...
    'position',[0.325 0.3 0.65 0.6]);

%% Match history tab setup

handles.homeHomeGamesTable = uitable('parent',matchHist,'units','normalized',...
    'position',[0.025 0.5 0.2 0.4]);
handles.homeAwayGamesTable = uitable('parent',matchHist,'units','normalized',...
    'position',[0.25 0.5 0.2 0.4]);
handles.awayHomeGamesTable = uitable('parent',matchHist,'units','normalized',...
    'position',[0.55 0.5 0.2 0.4]);
handles.awayAwayGamesTable = uitable('parent',matchHist,'units','normalized',...
    'position',[0.775 0.5 0.2 0.4]);

handles.avhomeHomeScor = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.145 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);
handles.avhomeHomeCon = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.2 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);
handles.avhomeAwayCon = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.35 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);
handles.avhomeAwayScor = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.4 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);

handles.avAwayHomeScor = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.66 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);
handles.avAwayHomeCon = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.71 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);
handles.avAwayAwayCon = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.9 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);
handles.avAwayAwayScor = uicontrol('parent',matchHist,'style','text','units','normalized',...
    'position',[0.95 0.45 0.025 0.025], 'string','---','backgroundcolor', [0 0 0],...
    'foregroundcolor', [1 1 1]);
%labels

uicontrol('style','text','parent',matchHist,'units','normalized',...
    'position', [0.075 0.9 0.1 0.025], 'string' ,'Home', 'fontweight','bold', 'fontsize',12);
uicontrol('style','text','parent',matchHist,'units','normalized',...
    'position', [0.3 0.9 0.1 0.025], 'string' ,'Away', 'fontweight','bold', 'fontsize',12);
uicontrol('style','text','parent',matchHist,'units','normalized',...
    'position', [0.6 0.9 0.1 0.025], 'string' ,'Home', 'fontweight','bold', 'fontsize',12);
uicontrol('style','text','parent',matchHist,'units','normalized',...
    'position', [0.825 0.9 0.1 0.025], 'string' ,'Away', 'fontweight','bold', 'fontsize',12);
handles.mHistHomeLab = uicontrol('style','text','parent',matchHist,'units','normalized',...
    'position', [0.185 0.925 0.1 0.025],'fontweight','bold', 'fontsize',12);
handles.mHistAwayLab = uicontrol('style','text','parent',matchHist,'units','normalized',...
    'position', [0.71 0.925 0.1 0.025],'fontweight','bold', 'fontsize',12);

%% setup historical tab
handles.ax(1) = subplot(311);
set(handles.ax(1),'parent',histTab);
set(handles.ax(1),'nextplot','add')
set(handles.ax(1),'ydir','reverse','ytick', 0:1:20, 'xtick', 0:20:380);
grid on

handles.ax(2) = subplot(312);
set(handles.ax(2),'nextplot','add')
set(handles.ax(2),'ydir','reverse','ytick', 0:1:20, 'xtick', 0:20:380);
grid on

handles.prevGames = uitable('parent',histTab,'columnName',{'Home','Away'},...
    'units','normalized','position', [0.3 0.1 0.275 0.2]);

%% setup league select panel
lSelect = uipanel('parent', ratingstab,'title', 'League Selection',...
    'position', [0.275 0.025 0.7 0.1]);

imData = imread('Icons/England.png');
eng = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [10 20 46 32], 'Cdata', imData, 'string', 'English','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Scotland.png');
sco = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [70 20 46 32], 'Cdata', imData, 'string', 'Scotish','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Germany.png');
ger = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [130 20 46 32], 'Cdata', imData, 'string', 'German','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Italy.png');
ita = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [190 20 46 32], 'Cdata', imData, 'string', 'Italian','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Spain.png');
spa = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [250 20 46 32], 'Cdata', imData, 'string', 'Spanish','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/France.png');
fra = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [310 20 46 32], 'Cdata', imData, 'string', 'French','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Belgium.png');
bel = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [370 20 46 32], 'Cdata', imData, 'string', 'Belgian','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Netherlands.png');
net = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [430 20 46 32], 'Cdata', imData, 'string', 'Dutch','fontsize', 8,...
    'fontweight','bold');


imData = imread('Icons/Portugal.png');
por = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [490 20 46 32], 'Cdata', imData, 'string', 'Portugal','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Turkey.png');
tur = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [550 20 46 32], 'Cdata', imData, 'string', 'Turkish','fontsize', 8,...
    'fontweight','bold');

imData = imread('Icons/Greece.png');
gre = uicontrol('Style','Pushbutton', 'parent', lSelect,'position',...
    [610 20 46 32], 'Cdata', imData, 'string', 'Greek','fontsize', 8,...
    'fontweight','bold');

%% all other gui bits
uicontrol('style','text', 'position',[10 80 100 15],'string',...
    'Home Team');
uicontrol('style','text', 'position',[10 30 100 15],'string',...
    'Away Team');
handles.predGoals = uicontrol('style','text', 'position',[160 60 50 15],'string',...
    '');
handles.comp = uicontrol('style','text', 'position',[160 10 50 15],'string',...
    '');
handles.predGoalslabel = uicontrol('style','text', 'position',[150 80 100 15],'string',...
    'Predicted goals','horizontalalignment','left');
handles.complabel = uicontrol('style','text', 'position',[155 30 100 15],'string',...
    'Confidence','horizontalalignment','left');
handles.hpu = uicontrol('style','popup','position', [10 60 100 20],...
    'string','No Data loaded');
handles.apu = uicontrol('style','popup','position', [10 10 100 20],...
    'string','No Data loaded');
handles.ap = uipanel('Title','Ave settings','units','pixels',...
    'position', [10 100 100 100]);
handles.rb = uicontrol('style','radio','parent',handles.ap, 'position',...
    [15 60 70 20],'string','Ave all','value', 1);
handles.eb = uicontrol('style','edit','parent',handles.ap,'position',...
    [15 30 70 20],'string', '1', 'enable',' off');

handles.ltb = uicontrol('style','pushbutton',...
    'units','normalized','position',[0.15 0.15 0.1 0.03],'string','League Table');
handles.hpowert = uicontrol('style','text','parent',handles.prp,'units','normalized',...
    'position',[0.1 0.6 0.4 0.2]);
handles.apowert = uicontrol('style','text','parent',handles.prp,'units','normalized',...
    'position',[0.1 0.3 0.4 0.2]);
handles.powerPred = uicontrol('style','text','parent',handles.prp,'units','normalized',...
    'position',[0.5 0.45 0.4 0.2]);
handles.todaysFix = uicontrol('parent',ratingstab,'Style','togglebutton','Position', [800 250 120 20],...
    'string', 'Todays Fixtures');



%% Set callbacks

set(eng,'callback', {@switchLeague, 'eng',fig})
set(sco,'callback', {@switchLeague, 'sco',fig})
set(ger,'callback', {@switchLeague, 'ger',fig})
set(ita,'callback', {@switchLeague, 'ita',fig})
set(spa,'callback', {@switchLeague, 'spa',fig})
set(fra,'callback', {@switchLeague, 'fra',fig})
set(bel,'callback', {@switchLeague, 'bel',fig})
set(net,'callback', {@switchLeague, 'net',fig})
set(por,'callback', {@switchLeague, 'por',fig})
set(tur,'callback', {@switchLeague, 'tur',fig})
set(gre,'callback', {@switchLeague, 'gre',fig})
set(handles.hpu, 'callback', {@scorePredictor,fig});
set(handles.apu, 'callback', {@scorePredictor,fig});
set(handles.ltb, 'callback', {@openPremTab,fig});
set(handles.rb, 'callback', {@scorePredictor, fig});
set(handles.eb, 'callback', {@scorePredictor, fig});
set(handles.todaysFix, 'callback', {@updateFixtures, fig});
setappdata(fig,'handles',handles)

end

function switchLeague(~,~,country,fig)

switch country
    case 'eng'
        [~,data] = xlsread('data\leagues.xlsx','English');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'sco'
        [~,data] = xlsread('data\leagues.xlsx','Scotish');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'ger'
        [~,data] = xlsread('data\leagues.xlsx','German');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'ita'
        [~,data] = xlsread('data\leagues.xlsx','Italian');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'spa'
        [~,data] = xlsread('data\leagues.xlsx','Spanish');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'fra'
        [~,data] = xlsread('data\leagues.xlsx','French');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'bel'
        [~,data] = xlsread('data\leagues.xlsx','Belgian');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'net'
        [~,data] = xlsread('data\leagues.xlsx','Dutch');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'por'
        [~,data] = xlsread('data\leagues.xlsx','Portugese');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'tur'
        [~,data] = xlsread('data\leagues.xlsx','Turksih');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
    case 'gre'
        [~,data] = xlsread('data\leagues.xlsx','Greek');
        h = menu('Select League', data(:,1));
        dataCollection(data(h,2),fig)
        initialiseTings(data(h,2),fig)
        powerRatings(fig)
end

end

function dataCollection(league,fig)

global years
try
    Url = 'http://www.football-data.co.uk/mmz4281/';
    hw = waitbar(0,'Downloading Data...');
    if exist(['data\' league{1} '.xlsx'], 'file')
        waitbar(1,hw,'Updating Data...');
        s = urlread([Url years{end} '/' league{1} '.csv']);
        fid = fopen([league{1} '.csv'],'wb');
        fwrite(fid, s);
        fclose(fid);
        [~,~,raw] = xlsread([league{1} '.csv']);
        xlswrite(['data\' league{1} '.xlsx'],raw, years{end});
        disp('poop')
        
    else
        for idx = 1:numel(years)
            
            s = urlread([Url years{idx} '/' league{1} '.csv']);
            fid = fopen([league{1} '.csv'],'wb');
            fwrite(fid, s);
            fclose(fid);
            [~,~,raw] = xlsread([league{1} '.csv']);
            xlswrite(['data\' league{1} '.xlsx'],raw, years{idx});
            waitbar(idx/numel(years),hw,'Downloading Data...');
            
        end
        
    end
    
    waitbar(1,hw,'Updating Fixtures...');
    s = urlread('http://www.football-data.co.uk/fixtures.csv');
    fid = fopen('fixtures.csv','wb');
    fwrite(fid, s);
    fclose(fid);
    [~,~,fix] = xlsread('fixtures.csv');
    fix(:,5:10) = [];
    fix(:,8:end) = [];
    waitbar(1,hw,'Deleting temporary files...');
    delete([league{1} '.csv'],'fixtures.csv')
    
    
    waitbar(1,hw,'Listing fixtures...');
    handles = getappdata(fig,'handles');
    handles.fix = fix;
    set(handles.fixtables,'columnname',fix(1,:), 'data', fix(2:end, :));
    close(hw);
    handles.league = league{1};
    setappdata(fig, 'handles', handles);
catch err
    errordlg(err.message, 'error')
    close(hw);
end

end

function initialiseTings(league, fig)

global years

handles = getappdata(fig,'handles');
[~,~,raw] = xlsread(['data\' league{1} '.xlsx'], years{end});



if isnan(cell2mat(raw(end,5)));
    
    handles.HT = raw(2:end-1, 3);
    handles.AT = raw(2:end-1, 4);
    handles.teams = unique(handles.HT);
    handles.mdates = raw(2:end-1, 2);
    handles.FTHG = cell2mat(raw(2:end-1,5));
    handles.FTAG = cell2mat(raw(2:end-1,6));
    handles.FTR = cell2mat(raw(2:end-1,7));
    handles.HS = cell2mat(raw(2:end-1,12));
    handles.AS = cell2mat(raw(2:end-1,13));
    handles.HST = cell2mat(raw(2:end-1,14));
    handles.AST = cell2mat(raw(2:end-1,15));
    handles.HC = cell2mat(raw(2:end-1,18));
    handles.AC = cell2mat(raw(2:end-1,19));
    
else
    handles.HT = raw(2:end, 3);
    handles.AT = raw(2:end, 4);
    handles.teams = unique(handles.HT);
    handles.mdates = raw(2:end, 2);
    handles.FTHG = cell2mat(raw(2:end,5));
    handles.FTAG = cell2mat(raw(2:end,6));
    handles.FTR = cell2mat(raw(2:end,7));
    handles.HS = cell2mat(raw(2:end,12));
    handles.AS = cell2mat(raw(2:end,13));
    handles.HST = cell2mat(raw(2:end,14));
    handles.AST = cell2mat(raw(2:end,15));
    handles.HC = cell2mat(raw(2:end,18));
    handles.AC = cell2mat(raw(2:end,19));
end

set(handles.hpu,'string',handles.teams);
set(handles.apu,'string',handles.teams);
setappdata(fig,'handles',handles)
end

function openPremTab(~,~,~)
web('http://www.premierleague.com/en-gb/matchday/league-table.html',...
    '-browser');
end

function powerRatings(fig)

handles = getappdata(fig,'handles');

adjuster = 0.025;
PR.points = ones(numel(handles.teams), 1)*10;
initialIndicator = zeros(numel(handles.teams),1);

for idx = 1:numel(handles.HT)
    if initialIndicator(strcmp(handles.HT(idx), handles.teams)) == 0
        initialIndicator(strcmp(handles.HT(idx), handles.teams)) = 1;
    end
    if initialIndicator(strcmp(handles.AT(idx), handles.teams)) == 0
        initialIndicator(strcmp(handles.AT(idx), handles.teams)) = 1;
    end
    
    if ~all(initialIndicator)
        
        d = (handles.FTHG(idx) - handles.FTAG(idx))*adjuster;
        PR.points(strcmp(handles.HT(idx), handles.teams)) = PR.points(strcmp(handles.HT(idx), handles.teams)) +d;
        PR.points(strcmp(handles.AT(idx), handles.teams)) = PR.points(strcmp(handles.AT(idx), handles.teams)) -d;
        
    else
        d = ((handles.FTHG(idx) - handles.FTAG(idx))-...
            (PR.points(strcmp(handles.HT(idx), handles.teams))-...
            PR.points(strcmp(handles.AT(idx), handles.teams))+0.05))*adjuster;
        PR.points(strcmp(handles.HT(idx), handles.teams)) = PR.points(strcmp(handles.HT(idx), handles.teams)) +d;
        PR.points(strcmp(handles.AT(idx), handles.teams)) = PR.points(strcmp(handles.AT(idx), handles.teams)) -d;
        
    end
    
end

setappdata(fig,'PR',PR);
end

function scorePredictor(~,~,fig)

handles = getappdata(fig,'handles');
PR = getappdata(fig,'PR');
ht = handles.teams(get(handles.hpu,'value'));
at = handles.teams(get(handles.apu,'value'));

htInd = find(strcmp(ht, handles.HT) & ~isnan(handles.FTHG));
atInd = find(strcmp(at, handles.AT) & ~isnan(handles.FTHG));

set(handles.hpowert, 'string', num2str(PR.points(strcmp(ht, handles.teams))));
set(handles.apowert, 'string', num2str(PR.points(strcmp(at, handles.teams))));

powerRatingPrediction = PR.points(strcmp(ht, handles.teams)) - PR.points(strcmp(at, handles.teams)) + 0.05;
set(handles.powerPred, 'string', num2str(powerRatingPrediction));

if get(handles.rb,'value')
    set(handles.eb, 'enable','off');
    %Home calcs
    data(1) = mean(handles.FTHG(htInd));
    data(2) = mean(handles.FTAG(htInd));
    
    %Away calcs
    data(3) = mean(handles.FTAG(atInd));
    data(4) = mean(handles.FTHG(atInd));
    
elseif ~get(handles.rb,'value')
    
    set(handles.eb, 'enable','on');
    g = str2double(get(handles.eb, 'string'));
    if g > numel(htInd) || g > numel(atInd)
        set(handles.eb, 'string', num2str(min([numel(htInd) numel(atInd)])));
        g = min([numel(htInd) numel(atInd)]);
    elseif g < 1
        set(handles.eb, 'string', '1');
        g = 1;
    end
    
    set(handles.eb, 'tooltipstring', ['Max value: ' num2str(min([numel(htInd) numel(atInd)]))]);
    
    %Home calcs
    data(1) = mean(handles.FTHG(htInd(end-g+1:end)));
    data(2) = mean(handles.FTAG(htInd(end-g+1:end)));
    
    %Away calcs
    data(3) = mean(handles.FTAG(atInd(end-g+1:end)));
    data(4) = mean(handles.FTHG(atInd(end-g+1:end)));
    
end

kaka = data;
[~,I] = min(kaka);
min1 = kaka(I); kaka(I) = [];
mins = min1 + min(kaka);

kaka = data;
[~,I] = max(kaka);
max1 = kaka(I); kaka(I) = [];
maxs = max1 + max(kaka);

pG = mean([mins, maxs]);
set(handles.predGoals, 'string', num2str(pG));
set(handles.comp, 'string', num2str(data(1) + data(3)));

prevPerform(fig)
penetrationPlus(fig)
matchHistory(fig)

end

function prevPerform(fig)
global years
colours = [0, 0, 1;
    1, 0, 0;
    0, 1, 0;
    0, 0, 0;
    1, 1, 0
    0, 1, 1;
    0.6 0 1;
    1, 0, 0.6;
    0 0.6 0;
    0.8, 0.6, 1];
handles = getappdata(fig,'handles');

if ~isempty(getappdata(fig, 'prevPerfData'))
    
    prevPerfData = getappdata(fig, 'prevPerfData');
    
    if prevPerfData(1).league == handles.league;
        ht = handles.teams(get(handles.hpu,'value'));
        at = handles.teams(get(handles.apu,'value'));
        cla(handles.ax(1));
        cla(handles.ax(2));
        
        for idx = 1:numel(prevPerfData)
            try
                pl1(idx) = plot(handles.ax(1), prevPerfData(idx).positions(strcmp(ht, prevPerfData(idx).teams), :),...
                    'color',colours(idx,:),'linewidth', 2);
            catch
                pl1(idx) = plot(handles.ax(1),[1 380] ,[20 20],...
                    'color',colours(idx,:),'linewidth', 2);
            end
            try
                pl2(idx) = plot(handles.ax(2), prevPerfData(idx).positions(strcmp(at, prevPerfData(idx).teams), :),...
                    'color',colours(idx,:),'linewidth', 2);
            catch
                pl2(idx) = plot(handles.ax(2),[1 380] ,[20 20],...
                    'color',colours(idx,:),'linewidth', 2);
            end
        end
        
        legend(pl1, years,'location','eastoutside')
        title(handles.ax(1), ht,'fontweight','bold');
        ylabel(handles.ax(1), 'Position')
        xlabel(handles.ax(1), 'Game')
        legend(pl2, years,'location','eastoutside')
        title(handles.ax(2), at,'fontweight','bold');
        ylabel(handles.ax(2), 'Position')
        xlabel(handles.ax(2), 'Game')
        
        rowNames = {''};
        tableData = [];
        i = 1;
        for idx = 1:numel(prevPerfData)
            for idy = 1:numel(prevPerfData(idx).HT)
                if strcmp(ht,prevPerfData(idx).HT{idy}) && strcmp(at,prevPerfData(idx).AT{idy})
                    rowNames{i} = prevPerfData(idx).dates{idy};
                    tableData(i,1) = prevPerfData(idx).FTHG{idy};
                    tableData(i,2) = prevPerfData(idx).FTAG{idy};
                    i = i + 1;
                end
            end
            
        end
        
        set(handles.prevGames,'RowName', rowNames,'data',tableData);
        setappdata(fig,'prevPerfData',prevPerfData) ;
    else
        ht = handles.teams(get(handles.hpu,'value'));
        at = handles.teams(get(handles.apu,'value'));
        cla(handles.ax(1));
        cla(handles.ax(2));
        
        for idx = 1:numel(years)
            
            
            [~,~,raw] = xlsread(['data\' handles.league '.xlsx'], years{idx});
            prevPerfData(idx).HT = raw(2:end,3);
            prevPerfData(idx).AT = raw(2:end,4);
            prevPerfData(idx).FTHG = raw(2:end,5);
            prevPerfData(idx).FTAG = raw(2:end,6);
            prevPerfData(idx).FTR = raw(2:end,7);
            prevPerfData(idx).dates = raw(2:end,2);
            prevPerfData(idx).teams = sort(unique(prevPerfData(idx).HT));
            prevPerfData(idx).points = zeros(20, numel(prevPerfData(idx).FTR));
            prevPerfData(idx).positions = zeros(20, numel(prevPerfData(idx).FTR));
            i = 1;
            
            for idy = 1: numel(prevPerfData(idx).FTR)
                if idy > 1
                    prevPerfData(idx).points(:,idy) = prevPerfData(idx).points(:,idy-1);
                end
                %         for idz = 1:380
                if strcmp('H', prevPerfData(idx).FTR(i))
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) =...
                        prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) +3;
                elseif strcmp('D', prevPerfData(idx).FTR(i))
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) =...
                        prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) +1;
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) =...
                        prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) +1;
                else
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) =...
                        prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) + 3;
                end
                
                i = i + 1;
                %         end
                
                [~,temp] = sort(prevPerfData(idx).points(:,idy),'descend');
                for idz = 1:20
                    prevPerfData(idx).positions(temp(idz), idy) = idz;
                end
            end
            
            
            try
                pl1(idx) = plot(handles.ax(1), prevPerfData(idx).positions(strcmp(ht, prevPerfData(idx).teams), :),...
                    'color',colours(idx,:),'linewidth', 2);
            catch
                pl1(idx) = plot(handles.ax(1),[1 380] ,[20 20],...
                    'color',colours(idx,:),'linewidth', 2);
            end
            try
                pl2(idx) = plot(handles.ax(2), prevPerfData(idx).positions(strcmp(at, prevPerfData(idx).teams), :),...
                    'color',colours(idx,:),'linewidth', 2);
            catch
                pl2(idx) = plot(handles.ax(2),[1 380] ,[20 20],...
                    'color',colours(idx,:),'linewidth', 2);
            end
        end
        legend(pl1, years,'location','eastoutside')
        title(handles.ax(1), ht,'fontweight','bold');
        ylabel(handles.ax(1), 'Position')
        xlabel(handles.ax(1), 'Game')
        legend(pl2, years,'location','eastoutside')
        title(handles.ax(2), at,'fontweight','bold');
        ylabel(handles.ax(2), 'Position')
        xlabel(handles.ax(2), 'Game')
        rowNames = {''};
        tableData = [];
        i = 1;
        for idx = 1:numel(prevPerfData)
            for idy = 1:numel(prevPerfData(idx).HT)
                if strcmp(ht,prevPerfData(idx).HT{idy}) && strcmp(at,prevPerfData(idx).AT{idy})
                    rowNames{i} = prevPerfData(idx).dates{idy};
                    tableData(i,1) = prevPerfData(idx).FTHG{idy};
                    tableData(i,2) = prevPerfData(idx).FTAG{idy};
                    i = i + 1;
                end
            end
            
        end
        
        
        set(handles.prevGames,'RowName', rowNames,'data',tableData);
        prevPerfData(1).league = handles.league;
        setappdata(fig,'prevPerfData',prevPerfData) ;
    end
    
else
    ht = handles.teams(get(handles.hpu,'value'));
    at = handles.teams(get(handles.apu,'value'));
    cla(handles.ax(1));
    cla(handles.ax(2));
    
    for idx = 1:numel(years)
        
        
        [~,~,raw] = xlsread(['data\' handles.league '.xlsx'], years{idx});
        prevPerfData(idx).HT = raw(2:end,3);
        prevPerfData(idx).AT = raw(2:end,4);
        prevPerfData(idx).FTHG = raw(2:end,5);
        prevPerfData(idx).FTAG = raw(2:end,6);
        prevPerfData(idx).FTR = raw(2:end,7);
        prevPerfData(idx).dates = raw(2:end,2);
        prevPerfData(idx).teams = sort(unique(prevPerfData(idx).HT));
        prevPerfData(idx).points = zeros(numel(prevPerfData(idx).teams), numel(prevPerfData(idx).FTR));
        prevPerfData(idx).positions = zeros(numel(prevPerfData(idx).teams), numel(prevPerfData(idx).FTR));
        i = 1;
        
        for idy = 1: numel(prevPerfData(idx).FTR)
            if idy > 1
                prevPerfData(idx).points(:,idy) = prevPerfData(idx).points(:,idy-1);
            end
            %         for idz = 1:380
            if strcmp('H', prevPerfData(idx).FTR(i))
                prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) =...
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) +3;
            elseif strcmp('D', prevPerfData(idx).FTR(i))
                prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) =...
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).HT(i), prevPerfData(idx).teams)),idy) +1;
                prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) =...
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) +1;
            else
                prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) =...
                    prevPerfData(idx).points((strcmp(prevPerfData(idx).AT(i), prevPerfData(idx).teams)),idy) + 3;
            end
            
            i = i + 1;
            %         end
            
            [~,temp] = sort(prevPerfData(idx).points(:,idy),'descend');
            for idz = 1:20
                prevPerfData(idx).positions(temp(idz), idy) = idz;
            end
        end
        
        
        try
            pl1(idx) = plot(handles.ax(1), prevPerfData(idx).positions(strcmp(ht, prevPerfData(idx).teams), :),...
                'color',colours(idx,:),'linewidth', 2);
        catch
            pl1(idx) = plot(handles.ax(1),[1 380] ,[20 20],...
                'color',colours(idx,:),'linewidth', 2);
        end
        try
            pl2(idx) = plot(handles.ax(2), prevPerfData(idx).positions(strcmp(at, prevPerfData(idx).teams), :),...
                'color',colours(idx,:),'linewidth', 2);
        catch
            pl2(idx) = plot(handles.ax(2),[1 380] ,[20 20],...
                'color',colours(idx,:),'linewidth', 2);
        end
    end
    legend(pl1, years,'location','eastoutside')
    title(handles.ax(1), ht,'fontweight','bold');
    ylabel(handles.ax(1), 'Position')
    xlabel(handles.ax(1), 'Game')
    %     set(handles.ax(1),'ylim', [0 numel(prevPerfData(end).teams)],...
    %         'ytick',0:1:numel(prevPerfData(end).teams), 'xlim',[0 numel(prevPerfData(end).FTR)],...
    %         'xtick', 0:20:numel(prevPerfData(end).FTR));
    set(handles.ax(1),'ylim', [0 numel(prevPerfData(end).teams)],...
        'ytick',0:1:numel(prevPerfData(end).teams), 'xlim',[0 400],...
        'xtick', 0:20:numel(prevPerfData(end).FTR));
    legend(pl2, years,'location','eastoutside')
    title(handles.ax(2), at,'fontweight','bold');
    ylabel(handles.ax(2), 'Position')
    xlabel(handles.ax(2), 'Game')
    %     set(handles.ax(2),'ylim', [0 numel(prevPerfData(end).teams)],...
    %         'ytick',0:1:numel(prevPerfData(end).teams), 'xlim',[0 numel(prevPerfData(end).FTR)],...
    %         'xtick', 0:20:numel(prevPerfData(end).FTR));
    set(handles.ax(2),'ylim', [0 numel(prevPerfData(end).teams)],...
        'ytick',0:1:numel(prevPerfData(end).teams), 'xlim',[0 400],...
        'xtick', 0:20:numel(prevPerfData(end).FTR));
    rowNames = {''};
    tableData = [];
    i = 1;
    for idx = 1:numel(prevPerfData)
        for idy = 1:numel(prevPerfData(idx).HT)
            if strcmp(ht,prevPerfData(idx).HT{idy}) && strcmp(at,prevPerfData(idx).AT{idy})
                rowNames{i} = prevPerfData(idx).dates{idy};
                tableData(i,1) = prevPerfData(idx).FTHG{idy};
                tableData(i,2) = prevPerfData(idx).FTAG{idy};
                i = i + 1;
            end
        end
        
    end
    
    
    set(handles.prevGames,'RowName', rowNames,'data',tableData);
    prevPerfData(1).league = handles.league;
    setappdata(fig,'prevPerfData',prevPerfData) ;
    
    
end
end

function penetrationPlus(fig)

handles = getappdata(fig, 'handles');
ht = handles.teams(get(handles.hpu,'value'));
at = handles.teams(get(handles.apu,'value'));

% home team
homeTpoints = 0;
i = 0;
goals = 0;
for idx = 1:numel(handles.HT)
    if strcmp(ht, handles.HT(idx))
        goals =  round(((handles.HST(idx) * 2) + (handles.HS(idx) - handles.HST(idx))...
            + handles.HC(idx))/10);
        if strcmp('H',handles.FTR(idx))
            goals = goals + 1;
        end
        i = i + 1;
    end
    if strcmp(ht, handles.AT(idx))
        goals =  round(((handles.AST(idx) * 2) + (handles.AS(idx) - handles.AST(idx))...
            + handles.AC(idx))/10);
        if strcmp('A',handles.FTR(idx))
            goals = goals + 1;
        end
        i = i + 1;
    end
    homeTpoints = homeTpoints + goals;
    goals = 0;
end

homeTpoints = homeTpoints/i;

awayTpoints = 0;
i = 0;
for idx = 1:numel(handles.HT)
    if strcmp(at, handles.HT(idx))
        goals =  round(((handles.HST(idx) * 2) + (handles.HS(idx) - handles.HST(idx))...
            + handles.HC(idx))/10);
        if strcmp('H',handles.FTR(idx))
            goals = goals + 1;
        end
        i = i + 1;
    end
    if strcmp(at, handles.AT(idx))
        goals =  round(((handles.AST(idx) * 2) + (handles.AS(idx) - handles.AST(idx))...
            + handles.AC(idx))/10);
        if strcmp('A',handles.FTR(idx))
            goals = goals + 1;
        end
        i = i + 1;
    end
    awayTpoints = awayTpoints + goals;
    goals = 0;
end

awayTpoints = awayTpoints/i;
rating = 1000*(homeTpoints - awayTpoints);
set(handles.penPlusRatings, 'string', num2str(rating));
end

function updateFixtures(~,~,fig)
formatOut = 'dd/mm/yyyy';
todaysDate = datestr(now, formatOut);

handles = getappdata(fig,'handles');
temp = handles.fix(2:end, :);

if get(handles.todaysFix, 'value')
    temp = temp(strcmp(todaysDate, temp(:,2)),:);
    set(handles.fixtables, 'data', temp);
else
    set(handles.fixtables, 'data', temp(2:end, :));
end

end

function matchHistory(fig)

handles = getappdata(fig, 'handles');
ht = handles.teams(get(handles.hpu,'value'));
at = handles.teams(get(handles.apu,'value'));

%% Get and set home team home match stats
colNames = {'Away','FTHG','FTAG'};
ind = strcmp(ht, handles.HT);
rwNames = handles.mdates(ind);
temp(:,1) = handles.AT(ind);
temp(:,2) = num2cell(handles.FTHG(ind));
temp(:,3) = num2cell(handles.FTAG(ind));
avFTHG = mean(cell2mat(temp(:,2)));
avFTAG = mean(cell2mat(temp(:,3)));

set(handles.mHistHomeLab,'string', ht);
set(handles.mHistAwayLab,'string', at);

set(handles.homeHomeGamesTable, 'columnName',colNames,'rowname',rwNames,...
    'data',temp);
set(handles.avhomeHomeScor, 'string', num2str(avFTHG));
set(handles.avhomeHomeCon, 'string', num2str(avFTAG));

clear temp avFTHG avFTAG

%% Get and set home team away match
colNames = {'Home','FTHG','FTAG'};
ind = strcmp(ht, handles.AT);
rwNames = handles.mdates(ind);
temp(:,1) = handles.HT(ind);
temp(:,2) = num2cell(handles.FTHG(ind));
temp(:,3) = num2cell(handles.FTAG(ind));
avFTHG = mean(cell2mat(temp(:,2)));
avFTAG = mean(cell2mat(temp(:,3)));

set(handles.homeAwayGamesTable, 'columnName',colNames,'rowname',rwNames,...
    'data',temp);
set(handles.avhomeAwayCon, 'string', num2str(avFTHG));
set(handles.avhomeAwayScor, 'string', num2str(avFTAG));

clear temp avFTHG avFTAG

%% Get and set away team home match stats
colNames = {'Away','FTHG','FTAG'};
ind = strcmp(at, handles.HT);
rwNames = handles.mdates(ind);
temp(:,1) = handles.AT(ind);
temp(:,2) = num2cell(handles.FTHG(ind));
temp(:,3) = num2cell(handles.FTAG(ind));
avFTHG = mean(cell2mat(temp(:,2)));
avFTAG = mean(cell2mat(temp(:,3)));

set(handles.awayHomeGamesTable, 'columnName',colNames,'rowname',rwNames,...
    'data',temp);
set(handles.avAwayHomeScor, 'string', num2str(avFTHG));
set(handles.avAwayHomeCon, 'string', num2str(avFTAG));

clear temp avFTHG avFTAG

%% Get and set away team away match stats
colNames = {'Home','FTHG','FTAG'};
ind = strcmp(at, handles.AT);
rwNames = handles.mdates(ind);
temp(:,1) = handles.HT(ind);
temp(:,2) = num2cell(handles.FTHG(ind));
temp(:,3) = num2cell(handles.FTAG(ind));
avFTHG = mean(cell2mat(temp(:,2)));
avFTAG = mean(cell2mat(temp(:,3)));

set(handles.awayAwayGamesTable, 'columnName',colNames,'rowname',rwNames,...
    'data',temp);
set(handles.avAwayAwayCon, 'string', num2str(avFTHG));
set(handles.avAwayAwayScor, 'string', num2str(avFTAG));

clear temp avFTHG avFTAG

end
