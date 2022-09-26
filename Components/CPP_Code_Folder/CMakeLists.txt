cmake_minimum_required(VERSION 3.21)

# Get current path
set(path ${CMAKE_CURRENT_SOURCE_DIR})
# Put directory name to COMPONENT_NAME variable
cmake_path(GET path FILENAME COMPONENT_NAME)
# Set component name
project(${COMPONENT_NAME})

# Add source files
set(SOURCE_LIB 
    Src/file2.cpp
)

# Add includes
include_directories(
    Inc
)

# Creating static library
add_library(${COMPONENT_NAME} STATIC ${SOURCE_LIB})

# Set dependence
Depends_On("C_Code_Folder")