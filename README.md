# Cmake_Template
Шаблон проекта C/C++ для Cmake

# Установка компонентов
1. [CMake](https://cmake.org/) версии 3.14 или новее. Для сборки с пресетами нужен CMake 3.21 или новее.
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

## Внешние библиотеки

В [dependencies.cmake](dependencies.cmake) перечислены зависимости приложения (fmt 7.1.3 и nlohmann/json 3.10.5) и тестов (Catch2 3.4.0). Скрипт CPM.cmake 0.43.2 входит в репозиторий. При первой конфигурации CMake скачивает архивы с GitHub и распаковывает их в `_deps` внутри каталога сборки.

Для fmt используется ZIP-файл, опубликованный автором в релизе (`releases/download/<тег>/<файл>`). Для nlohmann/json и Catch2 используются архивы исходников по тегу (`archive/refs/tags/<тег>.tar.gz`). При добавлении библиотеки укажите ссылку на архив с `CMakeLists.txt` и добавьте его цель в `target_link_libraries(...)`.

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
