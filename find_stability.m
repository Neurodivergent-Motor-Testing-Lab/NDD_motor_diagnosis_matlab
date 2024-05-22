function [first_ind, inth] = find_stability(biometrics, delta_y_threshold)

y = biometrics;
inst_y_dt = zeros(size(y));
inst_y_dt(2:end) = diff(y);
inst_y_dt(1) = inst_y_dt(2);
w = gausswin(15);
w = w / sum(w);
y_dt = filter(w, 1, inst_y_dt);
dy_dt = zeros(size(y));
dy_dt(2:end) = diff(y_dt);
dy_dt(1) = dy_dt(2);

stab = abs(y_dt) < delta_y_threshold;

for i = 1:length(stab)
    cum_stab(i) = sum(stab(i:end)) / (length(stab) - i + 1);
end
if cum_stab(1) < 1
    stable_section = find(cum_stab < 1);
    first_ind = stable_section(end) + 1;
else
    first_ind = 1;
end
if first_ind >= length(stab)
    first_ind = 300;
end

inth = var(y(first_ind:end));

%%
figure;
plot(y_dt)
xline(first_ind, 'r')
ax = gca;
ax.FontSize = 15;
ylabel('S')
xlabel('Trials')

end