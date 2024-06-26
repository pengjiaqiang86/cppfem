#include <iostream>

#define MAX_STEPS 100
#define MAX_ERROR 1E-7

using namespace std;

double calcError(double *arr1, double *arr2, int len)
{
    double error = 0.0;

    for (int i = 0; i < len; i++)
    {
        double d = arr1[i] - arr2[i];
        d = d < 0 ? -d : d;
        error += d;
    }

    return error;
}

double * initArr(double *arr, int len)
{
    double *arrCopy = new double[len];

    for (int i = 0; i < len; i++)
    {
        arrCopy[i] = arr[i];
    }

    return arrCopy;
}

void printArray(const double *arr, int len)
{
    for (int i = 0; i < len; i++)
    {
        cout << arr[i] << " ";
    }
    cout << endl;
}

int main(int argc, char const *argv[])
{
    const int len = 5;
    double arr[len] = {27, 0, 0, 0, 100};

    for (int i = 0; i < MAX_STEPS; i++)
    {
        double *arrCopy = initArr(arr, len);

        for (int j = 1; j < len-1; j++)
        {
            arr[j] = (arr[j-1] + arr[j+1]) / 2.0;
        }

        double error = calcError(arrCopy, arr, len);

        cout << "Step: " << i << "\t\t" << error << endl;

        delete[] arrCopy;

        if (error < MAX_ERROR || i == MAX_STEPS - 1)
        {
            printArray(arr, len);
            break;
        }
    }

    system("pause");
    return 0;
}
