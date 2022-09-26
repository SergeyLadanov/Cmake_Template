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

set(INCLUDE_LIST
    Core/Inc
)



macro(__Get_DirectorytList result curdir)
  file(GLOB children RELATIVE ${curdir} ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${curdir}/${child})
      list(APPEND dirlist ${child})
    endif()
  endforeach()
  set(${result} ${dirlist})
endmacro()


macro(__Get_IncludeDirectories result curdir)
  file(GLOB_RECURSE children ${curdir}/*.h ${curdir}/*.hpp)
  message("Adding include directories for \"${PROJECT_NAME}\"...")
  set(dirlist "")
  set(curItem "")
  foreach(child ${children})

    # Get current path
    set(path ${child})
    cmake_path(GET path PARENT_PATH newResult)

    if (NOT curItem STREQUAL newResult)
        message("Add \"${newResult}\" to icnlude directory list")
        list(APPEND dirlist ${newResult})
        set(curItem ${newResult})
    endif()
    
  endforeach()
  set(${result} ${dirlist})
endmacro()


set(COMPONENTS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Components)

__Get_DirectorytList(COMPONENT_LIST ${COMPONENTS_DIRECTORY})

message("Project components: \"${COMPONENT_LIST}\"")


function(Depends_On name)
    message("Add dependency \"${name}\" for \"${PROJECT_NAME}\"")
    set(dirs "")
    __Get_IncludeDirectories(dirs ${COMPONENTS_DIRECTORY}/${name})
    target_include_directories(${PROJECT_NAME} PRIVATE ${dirs})
    target_link_libraries(${PROJECT_NAME} ${name})
endfunction()


function(Depends_All)
    if (COMPONENT_LIST)
        foreach(item ${COMPONENT_LIST})
            Depends_On(${item})
        endforeach()
    endif()
endfunction()


function(__Register_Component name)
    add_subdirectory(Components/${name})
    get_property(inc_dirs DIRECTORY ${COMPONENTS_DIRECTORY}/${name} PROPERTY INCLUDE_DIRECTORIES)
    target_include_directories(${PROJECT_NAME} PRIVATE ${inc_dirs}) 
    target_link_libraries(${PROJECT_NAME} ${name})
endfunction()


function(__Add_Components components_list_in)
    set( _components_list ${components_list_in} ${ARGN} )
    foreach(item ${_components_list})
        __Register_Component(${item})
    endforeach()
endfunction()

# Добавление файлов исъодного кода
add_executable(
    ${EXECUTABLE}
    ${Sources}
)

# Директории с *.h файлами
target_include_directories(${PROJECT_NAME} PRIVATE
    ${INCLUDE_LIST}
)

if (COMPONENT_LIST)
    __Add_Components(${COMPONENT_LIST})
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

                    