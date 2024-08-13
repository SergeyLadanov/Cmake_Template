# Cmake_Template
Шаблон проекта C/C++ для Cmake

# Установка компонентов
1. CMake: https://cmake.org/;
2. make
```
winget install ezwinports.make
```
3. Компилятор: https://github.com/niXman/mingw-builds-binaries/releases

# Описание
Шаблон предоставляет возможность организовать модульную структуру проекта C/C++. Весь функционал для организации модульной структуры содержится в файле common-tools.cmake. В папку Components необходимо добавить файлы библиотек/модулей (с отдельным файлом CMakeLists.txt), заголовочные файлы которых будут доступны в главном приложении, сами библиотеки/модули будут собираться независимо. Между компонентами есть возможность выстраивать зависимости (задействовать заголовочные файлы из указанного компонента) с помощью директивы Depends_On в файле СMakeLists.txt компонента:

```cmake
Depends_On(
  Dependency_1
  Dependency_2
  )
```

Допускается использование кавычек в названиях компонента, но не допускается наличие пробелов.

Также можно указать зависимость компонента от главного приложения:

```cmake
Depends_On_Main()
```

Рекомендуемая структура файла CMakeLists.txt для компонента:

```cmake
cmake_minimum_required(VERSION 3.10)

# Put directory name to COMPONENT_NAME variable
get_filename_component(COMPONENT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
# Set component name
project(${COMPONENT_NAME})

# Add source files
set(SOURCE_LIB 
    Src/file1.cpp
)

# Creating static library
add_library(${COMPONENT_NAME} STATIC ${SOURCE_LIB})


# Add includes
target_include_directories(
    ${COMPONENT_NAME}
    PUBLIC 
    Inc
)

# Set dependence (optionaly)
Depends_On(
    "Dependency_1"
    Dependency_2
    )
```
Если у компонента используются только заголовочные файлы, то структура примет следующий вид

```cmake
cmake_minimum_required(VERSION 3.10)

# Put directory name to COMPONENT_NAME variable
get_filename_component(COMPONENT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
# Set component name
project(${COMPONENT_NAME})


# Creating static library
add_library(${COMPONENT_NAME} INTERFACE)


# Add includes
target_include_directories(
    ${COMPONENT_NAME}
    INTERFACE 
    Inc
)
```

В случае если компонент не имеет зависимостей от других компонентов, появляется возможность компилировать компонент отдельно от проекта.

Пример подгрузки компонента из репозитория:

```cmake
include(FetchContent)
FetchContent_Declare(
    Example1
    GIT_REPOSITORY https://github.com/url1.git
    GIT_TAG        1.0.35
    )

FetchContent_Declare(
    Example2
    GIT_REPOSITORY https://github.com/url2.git
    GIT_TAG        1.1.35
    )

FetchContent_MakeAvailable(Example1 Example2)

target_link_libraries(${PROJECT_NAME} PRIVATE Example1)

target_link_libraries(${PROJECT_NAME} PRIVATE Example2)
```

# Генерация файлов сборки и сборка
## Без пресетов
```
cmake . -G "MinGW Makefiles" -B"build" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_SYSTEM_NAME=Windows
cmake --build ./build -j4
```
Очитска:
```
cmake --build ./build --target clean
```


## С пресетами
```
cmake --preset Debug
cmake --build --preset Debug -j4
```
Очитска:
```
cmake --build --preset Debug --target clean
```
