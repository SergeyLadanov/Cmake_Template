
# Установка папки с компонентами проекта
set(COMPONENTS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Components)

# Путь к проекту
set(Project_Path ${CMAKE_CURRENT_SOURCE_DIR})

# Получение списка каталогов для заголовочных файлов исходного проекта
get_target_property(MainIncludes ${PROJECT_NAME} INCLUDE_DIRECTORIES)

# Вспомогательная переменная для сканирования вложенных зависимотсей компонентов
set(__dependency_tree "")

# Получение списка компонентов в заданном каталоге
macro(__Get_DirectorytList result curdir)
    file(GLOB children RELATIVE ${curdir} ${curdir}/*)
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${curdir}/${child})
            # list(FIND dirlist ${child} res)
            message(STATUS "Adding component \"${child}\"")
            list(APPEND dirlist ${child})
        endif()
    endforeach()
    message(STATUS "Removing dublicates in components list")
    list(REMOVE_DUPLICATES  dirlist)
    set(${result} ${dirlist})
endmacro()

# Получение списка каталогов с заголовочными файлами в заданной директории
macro(__Get_IncludeDirectories result curdir)
    set(dirlist "")
    message(STATUS "Adding include directories from dependency \"${curdir}\" to \"${PROJECT_NAME}\"")
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





# Получение списка каталогов с заголовочными файлами в заданной директории
macro(__Get_Dependencies result curdir)
    set(dirlist "")
    message(STATUS "Adding dependency from \"${curdir}\" to \"${PROJECT_NAME}\"")
    file(READ ${curdir}/CMakeLists.txt text)
    # Find include directories call
    string(REGEX MATCHALL "[D,d][e,E][p,P][e,N][n,N][d,D][s,S]_[o,O][n,N]\\([^\\(]*\\)" out_var ${text})
    # Remove key word "include_directories"
    string(REGEX REPLACE "[D,d][e,E][p,P][e,N][n,N][d,D][s,S]_[o,O][n,N]" "" out_var "${out_var}")
    # Remove brackets and spaces"
    string(REGEX REPLACE "\\([\r\n\t ]*|[\r\n\t ]*\\)" "" out_var "${out_var}")
    # Remove quotes
    string(REGEX REPLACE "\"" "" out_var "${out_var}")
    # Convert to list
    string(REGEX REPLACE "[\r,\n,\t, ][\r\n\t ]*" ";" out_var "${out_var}")
    
    foreach(item ${out_var})
        # set(item ${curdir}/${item})
        list(APPEND dirlist ${item})
    endforeach()

    set(${result} ${dirlist})
endmacro()


# Получение списка файлов с исходным кодом
macro(__SourceFilesPresent result curdir)
    file(READ ${curdir}/CMakeLists.txt text)
    string(REGEX MATCHALL "[a,A][d,D][d,D]_[l,L][i,I][b,B][r,R][a,A][r,R][y,Y]" out_var ${text})
    if (out_var)
        set(${result} "True")
    else()
        set(${result} "")
    endif()
    
endmacro()

# Получение списка компонентов проекта
__Get_DirectorytList(COMPONENT_LIST ${COMPONENTS_DIRECTORY})

message(STATUS "Final components list: \"${COMPONENT_LIST}\"")


#-----------------------------------------------
# Обработка дерева зависимостей
macro(__HandleDependencyTree name)

    list(FIND __dependency_tree ${name} res)

    if (res GREATER -1)
        message(STATUS "Dependency \"${name}\" already included") 
    else()
        list(APPEND __dependency_tree ${name})
        __Get_Dependencies(res ${COMPONENTS_DIRECTORY}/${name})

        foreach(item ${res})
            __HandleDependencyTree(${item})
        endforeach()
    
    endif()
    
endmacro()


# Указать имя зависимость для компонента
function(__Depends_On name)
    message(STATUS "Handle dependency \"${name}\" for \"${PROJECT_NAME}\"")
    set(dirs "")

    # Put directory name to COMPONENT_NAME variable
    get_filename_component(COMPONENT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

    if (NOT ${COMPONENT_NAME} STREQUAL ${name})
        __Get_IncludeDirectories(dirs ${COMPONENTS_DIRECTORY}/${name})
        __SourceFilesPresent(src_files ${COMPONENTS_DIRECTORY}/${name})
        target_include_directories(${PROJECT_NAME} PRIVATE ${dirs})

        if (src_files)
            target_link_libraries(${PROJECT_NAME} ${name})
        endif()
    endif()

endfunction()


# Указать список заивисимостей от других компнентов
macro( Depends_On )
    set( _OPTIONS_ARGS )
    set( _ONE_VALUE_ARGS )
    set(__dependency_tree "")

    cmake_parse_arguments(_ARGUMENTS "${_OPTIONS_ARGS}" "${_ONE_VALUE_ARGS}"  ${ARGN} )

    foreach(item ${ARGN})
        __HandleDependencyTree(${item})
    endforeach()

    message(STATUS "Final dependency tree for ${CMAKE_CURRENT_SOURCE_DIR}: ${__dependency_tree}")


    foreach(item ${__dependency_tree})
        __Depends_On(${item})
    endforeach()

endmacro()

# Указать зависимость от главного приложения
function(Depends_On_Main)
    message(STATUS "Handle dependency \"Main app\" for \"${PROJECT_NAME}\"")
    target_include_directories(${PROJECT_NAME} PUBLIC ${MainIncludes})
    Depends_All()
endfunction()

# Указать, что данный компонент зависит от всех остальных
function(Depends_All)
    if (COMPONENT_LIST)
        foreach(item ${COMPONENT_LIST})
            __Depends_On(${item})
        endforeach()
    endif()
endfunction()

# Зарегистрировать компонент
function(__Register_Component name)
    add_subdirectory(Components/${name})
    get_property(inc_dirs DIRECTORY ${COMPONENTS_DIRECTORY}/${name} PROPERTY INCLUDE_DIRECTORIES)
    __SourceFilesPresent(src_files ${COMPONENTS_DIRECTORY}/${name})

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


# Если компоненты присутствуют, то нужно добавить их в проект
if (COMPONENT_LIST)
    __Add_Components(${COMPONENT_LIST})
endif()
