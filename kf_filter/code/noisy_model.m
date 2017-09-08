function xdot = noisy_model(t, x, A, B, sigma)

u = input_fun(t);
n = sigma^2 * randn(1);
xdot = A * x + B * (u + n);
