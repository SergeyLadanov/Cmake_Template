cmake_minimum_required(VERSION 3.10)

# Установка папки с компонентами проекта
set(COMPONENTS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Components)

# Название проекта
project(Template)

# Переменная с именем исполняемого файла
set(EXECUTABLE ${PROJECT_NAME})

# Путь к проекту
set(Project_Path ${CMAKE_CURRENT_SOURCE_DIR})

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

# Получение списка компонентов в заданном каталоге
macro(__Get_DirectorytList result curdir)
    file(GLOB children RELATIVE ${curdir} ${curdir}/*)
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${curdir}/${child})
            # list(FIND dirlist ${child} res)
            message("Adding component \"${child}\"...")
            list(APPEND dirlist ${child})
        endif()
    endforeach()
    message("Removing dublicates in component list...")
    list(REMOVE_DUPLICATES  dirlist)
    set(${result} ${dirlist})
endmacro()

# Получение списка каталогов с заголовочными файлами в заданной директории
macro(__Get_IncludeDirectories result curdir)
    set(dirlist "")
    message("Adding include directories from dependency \"${curdir}\" to \"${PROJECT_NAME}\"...")
    file(READ ${curdir}/CMakeLists.txt text)
    # Find include directories call
    string(REGEX MATCHALL "[I,i][n,N][c,C][l,L][u,U][d,D][e,E]_[d,D][i,I][r,R][e,E][c,C][t,T][o,O][r,R][i,I][e,E][s,S]\\([^\\(]*\\)" out_var ${text})
    # Remove key word "include_directories"
    string(REGEX REPLACE "[I,i][n,N][c,C][l,L][u,U][d,D][e,E]_[d,D][i,I][r,R][e,E][c,C][t,T][o,O][r,R][i,I][e,E][s,S]" "" out_var "${out_var}")
    # Remove brackets and spaces"
    string(REGEX REPLACE "\\([\r\n\t ]*|[\r\n\t ]*\\)" "" out_var "${out_var}")
    # Remove quotes
    string(REGEX REPLACE "\"" "" out_var "${out_var}")
    # Convert to list
    string(REGEX REPLACE "[\r,\n,\t, ][\r\n\t ]*" ";" out_var "${out_var}")
    
    foreach(item ${out_var})
        # set(item ${curdir}/${item})
        list(APPEND dirlist ${curdir}/${item})
    endforeach()

    set(${result} ${dirlist})
endmacro()


# Получение списка файлов с исходным кодом
macro(__Get_SourceFiles result curdir)
    file(GLOB_RECURSE temp ${curdir}/*.c ${curdir}/*.cpp)
    set(${result} ${temp})
endmacro()

# Получение списка компонентов проекта
__Get_DirectorytList(COMPONENT_LIST ${COMPONENTS_DIRECTORY})

message("Project components: \"${COMPONENT_LIST}\"")

# Указать имя зависимости для компонента
function(Depends_On name)
    message("Handle dependency \"${name}\" for \"${PROJECT_NAME}\"")
    set(dirs "")

    # Put directory name to COMPONENT_NAME variable
    get_filename_component(COMPONENT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

    if (NOT ${COMPONENT_NAME} STREQUAL ${name})
        message("Test")
        __Get_IncludeDirectories(dirs ${COMPONENTS_DIRECTORY}/${name})
        __Get_SourceFiles(src_files ${COMPONENTS_DIRECTORY}/${name})
        target_include_directories(${PROJECT_NAME} PRIVATE ${dirs})

        if (src_files)
            target_link_libraries(${PROJECT_NAME} ${name})
        endif()
    endif()

endfunction()

# Указать зависимость от главного приложения
function(Depends_On_Main)
    message("Handle dependency \"Main app\" for \"${PROJECT_NAME}\"")
    target_include_directories(${PROJECT_NAME} PUBLIC ${Project_Path}/${Includes})
    Depends_All()
endfunction()

# Указать, что данный компонент зависит от всех остальных
function(Depends_All)
    if (COMPONENT_LIST)
        foreach(item ${COMPONENT_LIST})
            Depends_On(${item})
        endforeach()
    endif()
endfunction()

# Зарегистрировать компонент
function(__Register_Component name)
    add_subdirectory(Components/${name})
    get_property(inc_dirs DIRECTORY ${COMPONENTS_DIRECTORY}/${name} PROPERTY INCLUDE_DIRECTORIES)
    __Get_SourceFiles(src_files ${COMPONENTS_DIRECTORY}/${name})

    target_include_directories(${PROJECT_NAME} PRIVATE ${inc_dirs})

    if (src_files)
        target_link_libraries(${PROJECT_NAME} ${name})
    endif()
    
endfunction()

# Добавить компоненты в проект
function(__Add_Components components_list_in)
    set( _components_list ${components_list_in} ${ARGN} )
    foreach(item ${_components_list})
        __Register_Component(${item})
    endforeach()
endfunction()

# Добавление файлов исходного кода
add_executable(
    ${EXECUTABLE}
    ${Sources}
)

# Директории с *.h файлами
target_include_directories(${PROJECT_NAME} PRIVATE
    ${Includes}
)

# Если компоненты присутствуют, то нужно добавить их в проект
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



                    