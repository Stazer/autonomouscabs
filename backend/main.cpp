#include <iostream>
#include <exception>

#include "application.hpp"

int main(int argc, char** argv)
{
    std::cout << "Autonomous Cabs Backend\n";

    int return_value = 0;

    try
    {
        application application;
        return_value = application.run(argc, argv);
    }
    catch(std::exception& e)
    {
        std::cerr << "Critital error\n" << e.what() << std::endl;
        std::cerr << "Program terminated" << std::endl;

        return_value = -1;
    }

    return return_value;
}
