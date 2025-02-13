function [totalrows] = plots_CCS(nodeToComponent, variables, Conf_Set, prob_set, VarNames, maxlen2)

VarNames

for i = 1:length(VarNames)
    len1 = strlength(VarNames{1, i});
    if ( i == 1 )
        namelength = len1;
    elseif ( len1 > namelength )
        namelength = len1;
    end
end
letterwidth = 0.3;
%bstar = (namelength - namelength * letterwidth) / 2;
bstar = 0.1;

nodeToComponent2 = cell(1, max(nodeToComponent));
for i = 1:max(nodeToComponent)
    nodeToComponent2{1, i} = find(nodeToComponent == i);
end

check1 = zeros(1, length(Conf_Set));
max1 = size(Conf_Set{1, 1}, 1);
sum1 = 0;
for i = 1:length(Conf_Set)
    model_sum = sum(Conf_Set{1, i}, 2);
    if ( size(Conf_Set{1, i}, 2) > 1 )
        check1(i) = 1;
        sum1 = sum1 + size(Conf_Set{1, i}, 2);
    elseif ( sum(model_sum > 0) > 0 )
        check1(i) = 1;
        sum1 = sum1 + 1;
    end
    if ( size(Conf_Set{1, i}, 1) > max1 )
        max1 = size(Conf_Set{1, i}, 1);
    end
end

Conf_Set1 = Conf_Set(1, check1 == 1);
prob_set1 = prob_set(1, check1 == 1);
nodeToComponent21 = nodeToComponent2(check1 == 1);

count = 0;
row = 1;
col = 0;
for j = 1:length(nodeToComponent21)
    if ( col + length(nodeToComponent21{1, j}) > maxlen2 )
        row = row + 1;
        col = 0;
    end
    for i = 1:length(nodeToComponent21{1, j})
        count = count + 1;
        col = col + 1;
    end
end

rowsize = zeros(1, row);
sum1 = 0;
max1 = 0;
col = 0;
row = 0;
for i = 1:length(nodeToComponent21)
    if ( col + length(nodeToComponent21{1, i}) > maxlen2 )
        row = row + 1;
        if ( row > 0 )
            rowsize(row) = max1 + 2;
        end
        col = 0;
        max1 = 0;
    end
    for i1 = 1:length(nodeToComponent21{1, i})
        count = count + 1;
        col = col + 1;
    end

    model_sum = sum(Conf_Set1{1, i}, 2);
    if ( size(Conf_Set1{1, i}, 2) > 1 )
        sum1 = sum1 + size(Conf_Set1{1, i}, 2);
    elseif ( sum(model_sum > 0) > 0 )
        sum1 = sum1 + 1;
    end
    if ( max1 == 0 )
        max1 = size(Conf_Set1{1, i}, 1);
    elseif ( size(Conf_Set1{1, i}, 1) > max1 )
        max1 = size(Conf_Set1{1, i}, 1);
    end
end
rowsize(row + 1) = max1;

rowsize = cumsum(rowsize) / 2;

cmap = colormap(cool);
axes()
xlim([0 sum1+1])
ylim([-(max1+1)/2 0])
grid on

count = 0;
row = 1;
col = 0;
for j = 1:length(nodeToComponent21)
    pos1 = sum(Conf_Set1{1, j}, 2) > 0;
    probstar = sum(prob_set1{1, j}(pos1 == 1));
    if ( col + length(nodeToComponent21{1, j}) > maxlen2 )
        row = row + 1;
        col = 0;
    end
    for i = 1:length(nodeToComponent21{1, j})
        count = count + 1;
        col = col + 1;

        x1 = (col - 1) * namelength;
        x2 = col * namelength;
        xax = [x1 x2 x2 x1];
        if ( row > 1 )
            start = rowsize(row - 1);
        else
            start = 0;
        end
        y1 = -start - 0.25;
        y2 = -start - 0.75;
        yax = [y1 y1 y2 y2];
        if ( probstar == 0 )
            fill(xax, yax, cmap(1, :));
        else
            fill(xax, yax, cmap(ceil(probstar * size(cmap, 1)), :));
        end

        hold on
        i1 = nodeToComponent21{1, j}(i);
        len1 = bstar + letterwidth * (namelength - strlength(VarNames{1, variables(i1)}));

        text((col - 1)*namelength + len1, -start -0.5, VarNames{1, variables(i1)}, 'FontSize', 8)
    end
end

count = 0;
row = 1;
col = 0;
for i = 1:length(nodeToComponent21)
    if ( col + length(nodeToComponent21{1, i}) > maxlen2 )
        row = row + 1;
        col = 0;
    end

    x1 = col * namelength;
    x2 = (col + length(nodeToComponent21{1, i})) * namelength;

    if ( row > 1 )
        start = rowsize(row - 1);
    else
        start = 0;
    end

    line([x1+0.3 x2-0.3], [-start-0.15 -start-0.15], 'Color', 'k', 'LineWidth', 4)

    count = count + length(nodeToComponent21{1, i});
    col = col + length(nodeToComponent21{1, i});
end



count = 0;
row = 1;
col = 0;
for i = 1:length(Conf_Set1)
    if ( col + length(nodeToComponent21{1, i}) > maxlen2  )
        row = row + 1;
        col = 0;
    end
    for k1 = 1:size(Conf_Set1{1, i}, 1)
        count1 = count;
        col1 = col + 1;
        for k2 = 1:size(Conf_Set1{1, i}, 2)
            x1 = (col1 - 1) * namelength;
            x2 = col1 * namelength;
            xax = [x1 x2 x2 x1];
            if ( row > 1 )
                start = rowsize(row - 1);
            else
                start = 0;
            end
            y1 =  -start - (k1 - 0.5) / 2 - 0.5;
            y2 =  -start - (k1 + 0.5) / 2 - 0.5;
            yax = [y1 y1 y2 y2];
            fill(xax, yax, cmap(ceil(prob_set1{1, i}(k1) * size(cmap, 1)), :));
            hold on
            text((col1 - 0.5)*namelength, -start  - k1 / 2 - 0.5, num2str(Conf_Set1{1, i}(k1, k2)), 'FontSize', 7)
            count1 = count1 + 1;
            col1 = col1 + 1;
        end
    end
    count = count + length(nodeToComponent21{1, i});
    col = col + length(nodeToComponent21{1, i});
end
hold off

colorbar
%colorbar(Ticks, [0 0.5 1])

ax = gca;
ax.Visible = 'off';


totalrows = 2 * rowsize(end);
