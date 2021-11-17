cmake_minimum_required(VERSION 3.5)

project(Template)

set(EXECUTABLE ${PROJECT_NAME})


enable_language(CXX C)


SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${CPP_FLAGS} ${C_FLAGS}")


add_executable(${EXECUTABLE} 
    Core/Src/main.cpp
    C_Code_Folder/Src/file1.c
    CPP_Code_Folder/Src/file2.cpp
)

include_directories(
    Core/Inc
    C_Code_Folder/Inc
    CPP_Code_Folder/Inc
)



add_compile_options(
                    $<$<COMPILE_LANGUAGE:CXX>:
                    -fno-rtti 
                    -fno-exceptions 
                    $<$<CONFIG:Debug>:-Og>
                    $<$<CONFIG:Release>:-O3>> 
                    $<$<COMPILE_LANGUAGE:C>:
                    $<$<CONFIG:Debug>:-Og>
                    $<$<CONFIG:Release>:-Og>>
                    )

                    