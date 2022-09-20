cmake_minimum_required(VERSION 3.5)

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


# Директории с *.h файлами
include_directories(
    Core/Inc
)


MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()


set(COMPONENTS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Components)

SUBDIRLIST(COMPONENT_LIST ${COMPONENTS_DIRECTORY})

message("Components is \"${COMPONENT_LIST}\"")


function(depends_on name)
    include_directories(${COMPONENTS_DIRECTORY}/${name}/Inc)
    target_link_libraries(${PROJECT_NAME} ${name})		# Линковка программы с библиотекой
endfunction()


function(all_dependencies)
    if (COMPONENT_LIST)
        foreach(item ${COMPONENT_LIST})
            depends_on(${item})
        endforeach()
    endif()
endfunction()


function(register_component name)
    include_directories(Components/${name}/Inc)
    add_subdirectory(Components/${name})
    target_link_libraries(${PROJECT_NAME} ${name})
endfunction()


function(add_components components_list_in)
    set( _components_list ${components_list_in} ${ARGN} )
    foreach(item ${_components_list})
        register_component(${item})
    endforeach()
endfunction()

# Добавление файлов исъодного кода
add_executable(
    ${EXECUTABLE}
    ${Sources}
)

if (COMPONENT_LIST)
add_components(${COMPONENT_LIST})
endif()

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


# Пример подключения библиотек
# Для Windows
if (WIN32)
    # Подключение библиотек
    target_link_libraries(${PROJECT_NAME} ws2_32)
    target_link_libraries(${PROJECT_NAME} wsock32)
    target_link_libraries(${PROJECT_NAME} pthread)
endif ()

# Для Linux
if (UNIX)
    target_link_libraries(${PROJECT_NAME} pthread)
endif ()

                    