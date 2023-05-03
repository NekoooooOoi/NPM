function ps = calculate_ps(pc)
dim = max(pc.Location)-min(pc.Location);
x_dim = dim(1);
y_dim = dim(2);
z_dim = dim(3);

max_dim = max([x_dim, y_dim, z_dim]);

power = ceil(log2(max_dim));
ps = 2^power - 1;