# Get name of final executable 
if(NOT DEFINED TARGET_NAME)
    message(STATUS "Target name not definet. Using default name from variable PROJECT_NAME = \"${PROJECT_NAME}\"")
    set(TARGET_NAME ${PROJECT_NAME})
else()
    message(STATUS "Target name was definet \"${TARGET_NAME}\"")
endif()

# Установка папки с компонентами проекта
set(COMPONENTS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/Components)


# Получение списка каталогов для заголовочных файлов исходного проекта
get_target_property(MainIncludes ${TARGET_NAME} INCLUDE_DIRECTORIES)

# Если MainIncludes остутствует, то создается пустая переменная
if(NOT MainIncludes)
    set(MainIncludes "")
endif()


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


# Получение списка компонентов проекта
__Get_DirectorytList(COMPONENT_LIST ${COMPONENTS_DIRECTORY})

message(STATUS "Final components list: \"${COMPONENT_LIST}\"")


# Указать список заивисимостей от других компнентов
macro( Depends_On )
    set( _OPTIONS_ARGS )
    set( _ONE_VALUE_ARGS )
    set(__dependency_tree "")

    cmake_parse_arguments(_ARGUMENTS "${_OPTIONS_ARGS}" "${_ONE_VALUE_ARGS}"  ${ARGN} )

    foreach(item ${ARGN})
        #__HandleDependencyTree(${item})
        message(STATUS "Depends from ${item} for ${PROJECT_NAME}")
        target_link_libraries(${PROJECT_NAME} PUBLIC ${item})
        # add_dependencies(${PROJECT_NAME} ${item})
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
            if (NOT ${PROJECT_NAME} STREQUAL ${item})
                Depends_On(${item})
            endif()
        endforeach()
    endif()
endfunction()

# Зарегистрировать компонент
function(__Register_Component name)
    add_subdirectory(Components/${name})
    target_link_libraries(${TARGET_NAME} PRIVATE ${name})
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
