cmake_minimum_required(VERSION 3.10)

# Put directory name to COMPONENT_NAME variable
get_filename_component(COMPONENT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
# Set component name
project(${COMPONENT_NAME})


# Add source files
set(SOURCE_LIB 
    Src/file2.cpp
)


# Creating static library
add_library(${COMPONENT_NAME} STATIC ${SOURCE_LIB})


# Add includes
target_include_directories(
    ${COMPONENT_NAME}
    PUBLIC 
    Inc
)




# Set dependence
Depends_On(
    "C_Code_Folder" 
    "IncludeOnlyComponent"
    )

Depends_On_Main()