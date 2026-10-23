#include <stdio.h>

extern double calc(float a, double b, double c);

int main(void)
{
    float a;
    double b, c;

    printf("a = ");
    scanf("%f", &a);

    printf("b = ");
    scanf("%lf", &b);

    printf("c = ");
    scanf("%lf", &c);

    double result = calc(a, b, c);

    printf("Result = %.10lf\n", result);

    return 0;
}