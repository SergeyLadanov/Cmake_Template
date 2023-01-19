cmake_minimum_required(VERSION 3.21)

# Установка папки с компонентами проекта
set(COMPONENTS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Components)

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

# Получение списка компонентов в заданном каталоге
macro(__Get_ComponentList result curdir)
    file(GLOB children RELATIVE ${curdir} ${curdir}/*)
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${curdir}/${child})
            # Сортировка списка в соответствии с зависимостями
            file(READ ${curdir}/${child}/CMakeLists.txt text)
            # Find dependency function call
            string(REGEX MATCHALL "[D,d][e,E][p,P][e,E][n,N][d,D][s,S]_[o,O][n,N]\\([^\\(]*\\)" out_var ${text})
            # Remove all spaces near the breakets
            string(REGEX REPLACE "\\([\r\n\t ]*|[\r\n\t ]*\\)" "" out_var "${out_var}")
            # Remove quote marks and function name
            string(REGEX REPLACE "\"|[D,d][e,E][p,P][e,E][n,N][d,D][s,S]_[o,O][n,N]" "" out_var "${out_var}")
            # Convert to list
            string(REPLACE "\n" ";" out_var "${out_var}")
            foreach(item ${out_var})
                list(INSERT dirlist 0 ${item})
                message("Inserted dependency \"${item}\"")
            endforeach()

            list(FIND dirlist ${child} res)
            message("Adding component \"${child}\"...")
            if (res GREATER_EQUAL 0)
                message("Component \"${child}\" already included by dependencies")
            else()
                list(APPEND dirlist ${child})
            endif()
            
        endif()
    endforeach()
    message("Removing dublicates in component list...")
    list(REMOVE_DUPLICATES  dirlist)
    set(${result} ${dirlist})
endmacro()

# Получение списка каталогов с заголовочными файлами в заданной директории
macro(__Get_IncludeDirectories result curdir)
    file(GLOB_RECURSE children ${curdir}/*.h ${curdir}/*.hpp)
    message("Adding include directories from dependency \"${curdir}\" to \"${PROJECT_NAME}\"...")
    get_property(dirlist DIRECTORY ${curdir} PROPERTY INCLUDE_DIRECTORIES)
    set(${result} ${dirlist})
endmacro()


# Получение списка файлов с исходным кодом
macro(__Get_SourceFiles result curdir)
    file(GLOB_RECURSE temp ${curdir}/*.c ${curdir}/*.cpp)
    set(${result} ${temp})
endmacro()

# Получение списка компонентов проекта
__Get_ComponentList(COMPONENT_LIST ${COMPONENTS_DIRECTORY})

message("Project components: \"${COMPONENT_LIST}\"")

# Указать имя зависимости для компонента
function(Depends_On name)
    message("Handle dependency \"${name}\" for \"${PROJECT_NAME}\"")
    set(dirs "")
    __Get_IncludeDirectories(dirs ${COMPONENTS_DIRECTORY}/${name})
    __Get_SourceFiles(src_files ${COMPONENTS_DIRECTORY}/${name})
    target_include_directories(${PROJECT_NAME} PRIVATE ${dirs})

    if (src_files)
        target_link_libraries(${PROJECT_NAME} ${name})
    endif()
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



                    