close all
figure(1)
subplot(221)
plot(t,myPredictions1(1,:),'r');
hold on;
plot(t,zeros(1,N)+1,'--b');
hold on;
plot(t,x1,'-.g');
h = legend('$x$', '$x_{real}$','$\hat{x}$','Location', 'NorthEast');
set(h,'Interpreter','latex');
h = title(['$x_{object}$', ' without ','$a_x$']);
set(h,'Interpreter','latex');
hold on; grid on;


subplot(222)
plot(t,myPredictions1(2,:),'r');
hold on;
plot(t,zeros(1,N),'--b');
hold on;
plot(t,y1,'-.g');
h = legend('$y$', '$y_{real}$','$\hat{y}$','Location', 'NorthEast');
set(h,'Interpreter','latex');
h = title(['$y_{object}$', ' without ','$a_y$']);
set(h,'Interpreter','latex');
hold on; grid on;


subplot(223)
plot(t,myPredictions2(1,:),'r');
hold on; 
plot(t,zeros(1,N)+1,'--b');
hold on;
plot(t,x1,'-.g');
h = legend('$x$', '$x_{real}$','$\hat{x}$','Location', 'NorthEast');
set(h,'Interpreter','latex');
h = title(['$x_{object}$', ' with ','$a_x$']);
set(h,'Interpreter','latex');
hold on; grid on;

subplot(224)
plot(t,myPredictions2(2,:),'r');
hold on;
plot(t,zeros(1,N),'--b');
hold on;
plot(t,y1,'-.g');
h = legend('$y$', '$y_{real}$','$\hat{y}$','Location', 'NorthEast');
set(h,'Interpreter','latex');
h = title(['$y_{object}$', ' with ','$y_x$']);
set(h,'Interpreter','latex');
hold on; grid on;
hold off;