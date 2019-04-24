function hacky()

%% Historical footbal data analysis
%

%% Needs sorting out
% generalize data set
% improve layout



%% Download and extract data
handles.dataSets ={'0809','0910','1011','1112','1213','1314'};
dataCollection(handles.dataSets)
% s = urlread('http://www.football-data.co.uk/mmz4281/1314/E0.csv');
% fid = fopen('E0.csv','wb');
% fwrite(fid, s);
% fclose(fid);
[~,~,raw] = xlsread('E0.xlsx',handles.dataSets{end});
handles.HT = raw(2:end, 3);
handles.AT = raw(2:end, 4);
handles.teams = unique(handles.HT);
handles.FTHG = cell2mat(raw(2:end,5));
handles.FTAG = cell2mat(raw(2:end,6));
handles.FTR = cell2mat(raw(2:end,7));
handles.HS = cell2mat(raw(2:end,12));
handles.AS = cell2mat(raw(2:end,13));
handles.HST = cell2mat(raw(2:end,14));
handles.AST = cell2mat(raw(2:end,15));
handles.HC = cell2mat(raw(2:end,18));
handles.AC = cell2mat(raw(2:end,19));


%% Figure setup
scrsz = get(0,'screensize');
handles.fig = figure('pos',[50 50 scrsz(3)/2 scrsz(4)-100],'menubar','none',...
    'name','OUbetting V4','numbertitle','off');
figcol = get(handles.fig, 'color');

%% setup tabs
htab = uitabgroup;
ratingstab = uitab(htab,'title','Ratings','backgroundcolor',figcol);
histTab = uitab(htab,'title','History','backgroundcolor',figcol);
penplusPanel = uipanel('parent',ratingstab, 'title',' Pentration plus',...
    'units','normalized','position', [0.1 0.8 0.2 0.1]);
handles.penPlusRatings = uicontrol('parent',penplusPanel,'style','text','units',...
    'normalized','position',[0.1 0.1 0.5 0.5]);
handles.prp = uipanel('Title','Power Ratings','units','normalized',...
    'parent',ratingstab, 'position', [0.1 0.7 0.2 0.1]);

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

%% all other badades needs sorting
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
    'string',handles.teams);
handles.apu = uicontrol('style','popup','position', [10 10 100 20],...
    'string',handles.teams);
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

set(handles.hpu, 'callback', {@scorePredictor, handles});
set(handles.apu, 'callback', {@scorePredictor, handles});
set(handles.rb, 'callback', {@scorePredictor, handles});
set(handles.eb, 'callback', {@scorePredictor, handles});
set(handles.ltb, 'callback', {@openPremTab, handles});

powerRatings(handles)
end

%% needs sorting out
function scorePredictor(~,~,handles)

PR = getappdata(handles.fig,'PR');
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

prevPerform(handles)
penetrationPlus(handles)

end

%% complete
function openPremTab(~,~,~)
web('http://www.premierleague.com/en-gb/matchday/league-table.html',...
    '-browser');
end
%% complete
function dataCollection(dataSets)
Url = {'http://www.football-data.co.uk/mmz4281/', '/E0.csv'};
if exist('E0.xlsx', 'file')
    s = urlread([Url{1} dataSets{end} Url{2}]);
    fid = fopen('E0.csv','wb');
    fwrite(fid, s);
    fclose(fid);
    [~,~,raw] = xlsread('E0.csv');
    xlswrite('E0.xlsx',raw, dataSets{end});
    disp('poop')
    
else
    for idx = 1:numel(dataSets)
        
        s = urlread([Url{1} dataSets{idx} Url{2}]);
        fid = fopen('E0.csv','wb');
        fwrite(fid, s);
        fclose(fid);
        [~,~,raw] = xlsread('E0.csv');
        xlswrite('E0.xlsx',raw, dataSets{idx});
        
    end
    
end
end

%% beta stage complete *****TEST*****
function prevPerform(handles)

colours = [0, 0, 1;
    1, 0, 0;
    0, 1, 0;
    0, 0, 0;
    1, 1, 0
    0, 1, 1];

if ~isempty(getappdata(handles.fig, 'prevPerfData'))
    prevPerfData = getappdata(handles.fig, 'prevPerfData');
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
    
    legend(pl1, handles.dataSets(1:end),'location','eastoutside')
    title(handles.ax(1), ht,'fontweight','bold');
    ylabel(handles.ax(1), 'Position')
    xlabel(handles.ax(1), 'Game')
    legend(pl2, handles.dataSets(1:end),'location','eastoutside')
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
    setappdata(handles.fig,'prevPerfData',prevPerfData) ;
    
else
    
    handles.dataSets ={'0809','0910','1011','1112','1213','1314'};
    ht = handles.teams(get(handles.hpu,'value'));
    at = handles.teams(get(handles.apu,'value'));
    cla(handles.ax(1));
    cla(handles.ax(2));
    
    for idx = 1:numel(handles.dataSets)
        
        
        [~,~,raw] = xlsread('E0.xlsx',handles.dataSets{idx});
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
    legend(pl1, handles.dataSets(1:end),'location','eastoutside')
    title(handles.ax(1), ht,'fontweight','bold');
    ylabel(handles.ax(1), 'Position')
    xlabel(handles.ax(1), 'Game')
    legend(pl2, handles.dataSets(1:end),'location','eastoutside')
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
    setappdata(handles.fig,'prevPerfData',prevPerfData) ;
    
    
end
end

function penetrationPlus(handles)

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

function powerRatings(handles)

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

setappdata(handles.fig,'PR',PR);
end