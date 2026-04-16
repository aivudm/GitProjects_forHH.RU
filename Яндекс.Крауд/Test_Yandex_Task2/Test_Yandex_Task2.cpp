#include <iostream>
#include <vector>
#include <algorithm>


std::string sInputMessage1("Input Number A:\n");
std::string sInputMessage2("Input Number B:\n");
std::string sOutputMessage1("Output: maximized number A by digits from B: \n"); //--- Выход:
std::string sOutputMessage2("Maximization number A by digits from B is not avaible. \n"); //--- Выход:
std::string sErrorInputData("Error input data\n"); //--- Ошибка входных данных

//--- Основная функция максимизирующая число А цифрами из числа В
//--- На входе: число А (&sNumberA) и число В (&sNumberB)
bool MaximizeAFromB(std::string &sNumberA, std::string &sNumberB)
{
    std::string outputResult = "";

//--- Загрузка цифр числа B в контейнер для сортировки и уникализации цифр
    std::vector<char> vDigitsB = {};
    for (char& cDigit : sNumberB)
    {
        vDigitsB.push_back(cDigit);
    }

//--- Сортировка и уникализация цифр числа B
//        std::ranges::sort(vDigitsA); //--- для компилятора С++20
    std::sort(vDigitsB.begin(), vDigitsB.end());
    auto itDigitsB = std::unique(vDigitsB.begin(), vDigitsB.end());
    vDigitsB.erase(itDigitsB, vDigitsB.end());

//--- Загрузка цифр числа A в контейнер
    std::vector<char> vDigitsA = {};
    for (char& cDigit : sNumberA)
    {
        vDigitsA.push_back(cDigit);
    }

 //--- Перебор цифр числа A от старших разрядов к младшим
//--- Замена цифрами числа В при условии, что они больше


    bool bIsChanged = false;
    char cDigitB = {};

    std::vector<char>::iterator itDigitsA = vDigitsA.begin();   //--- Для перебора цифр числа А слева направо 

//--- Цикл прохода по всем цифрам числа А
    do
    {
//--- Выбираем максимальную цифру числа В и удаляем её из контейнера        
        cDigitB = vDigitsB.back();
        vDigitsB.pop_back();

//--- Сравнение текущей цифры числа В с цифрами числа А (от старших разрядов к младшим)
//--- если цифрв числа А больше или равна, то пропуск (переход к следующей)
        while ((*itDigitsA >= cDigitB) && (++itDigitsA != vDigitsA.end()))
        {
//            itDigitsA++;
        }

        if (itDigitsA != vDigitsA.end())
        {
//            *itDigitsA = cDigitB; //--- Замена только первой слева цифры числа А на цифру числа В
//--- Поиск и замена всех данных цифр (если их несколько) 
            std::vector<char>::iterator itCurDigitsA = itDigitsA;   //--- Для перебора цифр от текущего числа А слева направо 
            auto cDigitA = *itDigitsA;
            itCurDigitsA = std::find(itDigitsA, vDigitsA.end(), cDigitA);
            while (itCurDigitsA != vDigitsA.end())
            {
                *itCurDigitsA = cDigitB;
                itCurDigitsA = std::find(itCurDigitsA, vDigitsA.end(), cDigitA);
            }
            bIsChanged = true;
        }

    } while ((itDigitsA != vDigitsA.end()) and (!vDigitsB.empty()));


//--- Если ни одна цифра числа А не была заменена то функция должна вернуть false
    if (!bIsChanged)
    {
        return false;
    }

//--- Выгрузка цифр из контейнера в число A 
    vDigitsA.begin();
    sNumberA = "";

    for (char& cDigit : vDigitsA)
    {
        sNumberA += cDigit;
    }
    return true;
}

static bool GetInputNumberAsString(std::string &sResultNumber)
{
//--- Ввод и проверка корректности ввода
    try
    {
        while (true)
        {
            bool bIsStringNumber = true;
            if (std::cin >> sResultNumber) {
                for (char& cBuffer : sResultNumber)
                {
                    if (!isdigit(cBuffer))
                    {
                        bIsStringNumber = false;
                        std::cout << sErrorInputData;
                        std::cin.clear();
                        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
                        break;
                    }
                }
            }
            if (bIsStringNumber)
            {
                break; //--- Как только считали корректное число, выходим из цикла чтения
            }

        };

    }
    catch (...)
    {
        return false;
    }

    return true;
}

int main()
{
    std::string sNumberA = "", sNumberB = "";
//--- Получение входных параметров 
    try
    {
        std::cout << sInputMessage1;
        while (!GetInputNumberAsString(sNumberA)) {}

        std::cout << sInputMessage2;
        while (!GetInputNumberAsString(sNumberB)) {}

//--- Вызов функции, реализующей алгоритм и вывод результата
        if (MaximizeAFromB(sNumberA, sNumberB))
        {
            std::cout << sOutputMessage1 << sNumberA;
        }
        else
        {
            std::cout << sOutputMessage2;
        }
    }
    catch (...)
    {
        std::cout << sErrorInputData;
        return 0;
    }



}

// Запуск программы: CTRL+F5 или меню "Отладка" > "Запуск без отладки"
// Отладка программы: F5 или меню "Отладка" > "Запустить отладку"

// Советы по началу работы 
//   1. В окне обозревателя решений можно добавлять файлы и управлять ими.
//   2. В окне Team Explorer можно подключиться к системе управления версиями.
//   3. В окне "Выходные данные" можно просматривать выходные данные сборки и другие сообщения.
//   4. В окне "Список ошибок" можно просматривать ошибки.
//   5. Последовательно выберите пункты меню "Проект" > "Добавить новый элемент", чтобы создать файлы кода, или "Проект" > "Добавить существующий элемент", чтобы добавить в проект существующие файлы кода.
//   6. Чтобы снова открыть этот проект позже, выберите пункты меню "Файл" > "Открыть" > "Проект" и выберите SLN-файл.
