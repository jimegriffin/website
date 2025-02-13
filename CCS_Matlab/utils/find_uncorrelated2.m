function [x1, x2] = find_uncorrelated2(samples, oldx1, oldx2, i1)

[n, pdim] = size(samples);

dist = zeros(size(oldx1, 1) * (size(oldx1, 1) - 1) / 2, 1);
dethold = 0;
for i = 1:size(oldx1, 1)
    xstar = oldx1{i, 1};
    if ( i == 1 )
        c1 = length(xstar);
    elseif ( length(xstar) > c1 )
        c1 = length(xstar);
    end

    [~,~,ic] = unique(samples(:, xstar), 'rows');
    nstar = accumarray(ic, 1);

    dethold = sum(nstar / n .* log(nstar / n));
end
cdist = c1 * ones(size(oldx1, 1) * (size(oldx1, 1) - 1) / 2, 1);
indhold = zeros(size(oldx1, 1) * (size(oldx1, 1) - 1) / 2, 2);
indhold2 = zeros(size(oldx1, 1) * (size(oldx1, 1) - 1) / 2, 2);
counter = 0;
for i = 1:size(oldx1, 1)
    for j = (i + 1):size(oldx1, 1)

        counter = counter + 1;
        indhold(counter, :) = [i j];
        indhold2(counter, :) = [oldx2(i) oldx2(j)];
        xstar = [oldx1{i, 1} oldx1{j, 1}];
        if ( length(xstar) > c1 )
            cdist(counter) = length(xstar);
        end

        dist(counter) = dethold;

        [~,~,ic] = unique(samples(:, xstar), 'rows');
        nstar = accumarray(ic, 1);

        dist(counter) = dist(counter) + sum(nstar / n .* log(nstar / n));

        xstar = oldx1{i, 1};
        [~,~,ic] = unique(samples(:, xstar), 'rows');
        nstar = accumarray(ic, 1);

        dist(counter) = dist(counter) - sum(nstar / n .* log(nstar / n));


        xstar = oldx1{j, 1};
        [~,~,ic] = unique(samples(:, xstar), 'rows');
        nstar = accumarray(ic, 1);

        dist(counter) = dist(counter) - sum(nstar / n .* log(nstar / n));

    end
end

%    dist

[~, m2] = max(dist);

x1 = cell(pdim - i1 + 1, 1);
x2 = zeros(pdim - i1 + 1, 1);
counter = 0;
for i = 1:(indhold(m2, 1) - 1)
    counter = counter + 1;
    x1{counter, 1} = oldx1{i, 1};
    x2(counter) = oldx2(i);
end
counter = counter + 1;
x1{counter, 1} = [oldx1{indhold(m2, 1)} oldx1{indhold(m2, 2), 1}];
x2(counter) = max(oldx2) + 1;
for i = (indhold(m2, 1) + 1):(indhold(m2, 2) - 1)
    counter = counter + 1;
    x1{counter, 1} = oldx1{i, 1};
    x2(counter) = oldx2(i);
end
for i = (indhold(m2, 2) + 1):size(oldx1, 1)
    counter = counter + 1;
    x1{counter, 1} = oldx1{i, 1};
    x2(counter) = oldx2(i);
end


