% Make Mondrian patch
% 
%
clf; clear;
a1 = [1; 1];
b1 = [1; 1];
Qs = 500;
a = (a1*rand(1, Qs)*1)';
b = (b1*rand(1, Qs)*1)';
colorn = 63;
ind = Shuffle(repmat(1:colorn, 1, round((Qs + 3)/3)));
%ind = repmat(Shuffle(1:colorn), 1, round(Qs + 3)/3);
%cc = colormap('gray');
%cc = colormap('hot');
cc = colormap('jet');

% rectangle
for i = 1:Qs,
    
x1{i} = [a(i, 1); b(i, 1); b(i, 1); a(i, 1)];
y1{i} = [a(i, 2); a(i, 2); b(i, 2); b(i, 2)];
so1{i} = sort(abs(a(i, 1) - b(i, 1)));

end;

[dum, so] = sort(cell2mat(so1), 'descend');
for i = 1:Qs,
patch(x1{so(i)}, y1{so(i)}, cc(ind(so(i)), :), 'EdgeColor', 'none', ...
    'EdgeLighting', 'gouraud');
end;
set(gca,'visible','off');
figure(1);