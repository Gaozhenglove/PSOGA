function fitness=CalFitness(x)
global num1 num2 num3 num4 num5;
    F1 = 9.89*(x(1) + num1) + 2.21*(x(2) + num2) + 15.11*(x(3) + num3) + 244.83*(x(4) + num4) + 496.3*(x(5) + num5);
    F3 = 0.81*(x(1) + num1) + 3.73*(x(2) + num2) + 25.76*(x(3) + num3) + 0.03*(x(4) + num4) + 7.38*(x(5) + num5);
    fitness = 0.373 * F1 + 0.627 * F3;
end

