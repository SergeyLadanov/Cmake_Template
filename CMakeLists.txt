cmake_minimum_required(VERSION 3.10)

# Название проекта
project(Template)

# Переменная с именем исполняемого файла
set(EXECUTABLE ${PROJECT_NAME})

# Язык C и C++
enable_language(CXX C)

# Файлы с исходым кодом
FILE(
    GLOB 
    Sources 
    "Core/Src/*.cpp"
    "Core/Src/*.c"
    )

# Директории с заголовочными файлами
set(
    Includes
    Core/Inc
)

# Добавление файлов исходного кода
add_executable(
    ${EXECUTABLE}
    ${Sources}
)

# Директории с *.h файлами
target_include_directories(${PROJECT_NAME} PRIVATE
    ${Includes}
)

# Подключение инструментов для работы с модулями
include(common-tools.cmake)

# Флаги компиляции
add_compile_options(
    $<$<COMPILE_LANGUAGE:CXX>:
    -fno-rtti 
    -fno-exceptions 
    $<$<CONFIG:Debug>:
    -Og>
    $<$<CONFIG:Release>:
    -Os>> 
    $<$<COMPILE_LANGUAGE:C>:
    $<$<CONFIG:Debug>:
    -Og>
    $<$<CONFIG:Release>:
    -Os>>
)



                    