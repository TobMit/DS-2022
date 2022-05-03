cmake_minimum_required(VERSION 3.21)
project(DS_2022)

set(CMAKE_CXX_STANDARD 14)

add_executable(CV6-zamestnanci
        "Cvicenie 6/Main.cpp")

add_executable(CV8-name_day_calendar
        "Cvicenie 8/Main.cpp")

add_executable(ChovnaStanica
        "ChovnaStanica/InpExp dat/GenerovanieDat/MainChovnaStanica.cpp"
        "ChovnaStanica/InpExp dat/GenerovanieDat/dataLoader/dataLoader.cpp"
        "ChovnaStanica/InpExp dat/GenerovanieDat/dataLoader/dataLoader.h")