% Make Mondrian patch V2
% with rounded corner
%
clf; clear;
a1 = 1;
b1 = 1;
c1 = 1;
d1 = 1;
Qs = 15000;
a = (a1*rand(1, Qs)*1)';
b = (b1*rand(1, Qs)*1)';
c = (c1*rand(1, Qs)*1)';
d = (d1*rand(1, Qs)*1)';
colorn = 63;
ind = Shuffle(repmat(1:colorn, 1, round((Qs + 3)/3)));
%ind = repmat(Shuffle(1:colorn), 1, round(Qs + 3)/3);
%cc = colormap('gray');
%cc = colormap('hot');
cc = colormap('jet');

% rectangle with rounded edge
for i = 1:Qs,
    so1{i} = abs(c(i, 1)*d(i, 1));
    
    x2{i} = [a(i, 1), b(i, 1)];
    y2{i} = [c(i, 1), d(i, 1)];
end;

[dum, so] = sort(cell2mat(so1),'descend' );
for i = 1:Qs,
    if c(so(i), 1) <= 1 && d(so(i), 1) <= 1 ...
            && abs(c(so(i), 1) - d(so(i), 1)) <= 0.1,
        
        rectangle('Position', [x2{so(i)} y2{so(i)}], 'Curvature', [0.6], ...
            'FaceColor', cc(ind(so(i)), :), 'EdgeColor', 'none');
    end;
end;
set(gca,'visible','off');
xlim([.1, 1]);
ylim([0.25, 1.25]);
figure(1);

