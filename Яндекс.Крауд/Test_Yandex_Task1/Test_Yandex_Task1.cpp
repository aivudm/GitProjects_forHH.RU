#include <iostream>
#include <sstream>
//#include <string>
#include <map>


std::string sInputMessage("Input:\n"); //--- Вход:
std::string sOutputMessage("Output:\n"); //--- Выход:
std::string sErrorInputData("Error input data\n"); //--- Ошибка входных данных
std::string sEOL = "\r\n";
std::string sEONum = " ";


//--- Основная функция расчитывающая остаток воды в увлажнителе
//--- На входе: "многострочная строка" с количеством итераций по доливу воды
std::string CalculateHumidifierWaterRest(std::string& inputData) {
   
    unsigned short  iterCount = 0, iT = 0, iV = 0, iResult = 0;
    std::string sTmpBuffer = "", sTmpBuffer1 = "", outResult = "";
    std::map <unsigned int, unsigned int> mapAddWater = {};    //--- контейнер для хранения пар числовых значений (T_i и V_i) операций по доливу воды
//--- Загружаем входную строку в стринг стрим для последующего парсинга
    std::stringstream ssBuffer(inputData);

//--- Считываем первое значение из потока - количество итераций доливов
    ssBuffer >> iterCount;
    do 
    {
        ssBuffer >> iT >> iV;
        mapAddWater[iT] = iV;
    } while (!ssBuffer.eof());

//--- Последовательный проход по итерациям долива/утечек
//--- За количество проходов взято последнее (максимальное) значение T_i из входной строки
    for (unsigned short i = 1; i <= iT; i++)
    {
//--- Если вода в увлажнителе есть, то вычтем утечку (= 1л) на текущей итерации
        if (iResult > 0)
        {
            iResult--;
        }

//--- Проверка - есть ли доливка в увлажнитель на текущей итерации
        if (mapAddWater.find(i) != mapAddWater.end())
        {
            iResult += mapAddWater[i];
        }
    }

//--- Преобразуем результат в строку (согласно условию задачи)
    outResult = std::to_string(iResult);
    return outResult;
}


int main()
{
    std::string inputString = "";
    unsigned short  iterCount = 0, iterT = 0, iterV = 0;
    try
    {
        std::cout << sInputMessage;
//--- Ввод и проверка корректности ввода количества циклов доливки воды
//--- 
        while (true)
        {
            if (std::cin >> iterCount) {
               break;  //--- Как только считали корректное число итераций, следуем на продолжение считывания ланных
            }
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            std::cout << sErrorInputData;
        };

//--- Запись кол-ва доливов (итераций) в итоговую строку с данными
        inputString += std::to_string(iterCount);
        inputString += sEOL; //--- Добавляем "\r\n" к текущей подстроке в составе итоговой строки

//        std::cout << "Input pairs T_i, V_i\n";

//--- Ввод и проверка корректности ввода количества циклов доливки воды
        unsigned short iterT_pred = 0;
        for (uint8_t i = 0; i < iterCount; i++)
        {
            while (true)
            {
                if (std::cin >> iterT >> iterV) {
                   //--- Как только считали корректную пару T_i, V_i, записываем в итоговую строку и следуем на продолжение считывания ланных
                    if (iterT > iterT_pred) //--- Дополнительная проверка на корректность ввода значения T_i (строго больше предыдущего)
                    {
                        iterT_pred = iterT; //--- Запоминаем последнее значение T_i

                        inputString += std::to_string(iterT);
                        inputString += sEONum;
                        inputString += std::to_string(iterV);
                        inputString += sEOL; //--- Добавляем "\r\n" к текущей подстроке в составе итоговой строки

                        break;
                    }
                }
                else
                {
                    std::cin.clear();
                    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
                    std::cout << sErrorInputData;
                }
            }

        }
    }
    catch (...)
    {
        std::cout << sErrorInputData;
        return 0;
    }


    std::cout << sOutputMessage << (CalculateHumidifierWaterRest(inputString));

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
