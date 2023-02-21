# Cmake_Template
Шаблон проекта C/C++ для Cmake

# Описание
Шаблон предоставляет возможность организовать модульную структуру проекта C/C++. Весь функционал для организации модульной структуры содержится в файле common-tools.cmake. В папку Components необходимо добавить файлы библиотек/модулей (с отдельным файлом CMakeLists.txt), заголовочные файлы которых будут доступны в главном приложении, сами библиотеки/модули будут собираться независимо. Между компонентами есть возможность выстраивать зависимости (задействовать заголовочные файлы из указанного компонента) с помощью директивы Depends_On в файле СMakeLists.txt компонента:

```
Depends_On(
  Dependency_1
  Dependency_2
  )
```

Допускается использование кавычек в названиях компонента, но не допускается наличие пробелов.

Также можно указать зависимость компонента от главного приложения:

```
Depends_On_Main()
```

Рекомендуемая структура файла CMakeLists.txt для компонента:

```
cmake_minimum_required(VERSION 3.10)

# Put directory name to COMPONENT_NAME variable
get_filename_component(COMPONENT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
# Set component name
project(${COMPONENT_NAME})

# Add source files
set(SOURCE_LIB 
    Src/file1.cpp
)

# Add includes
include_directories(
    Inc
)

# Creating static library
add_library(${COMPONENT_NAME} STATIC ${SOURCE_LIB})

# Set dependence (optionaly)
Depends_On(
    "Dependency_1"
    Dependency_2
    )
```

В случае если компонент не имеет зависимостей от других компонентов, появляется возможность компилировать компонент отдельно от проекта.
