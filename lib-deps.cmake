include(cmake/CPM.cmake)

# CPMAddPackage(URI "https://github.com/fmtlib/fmt/releases/download/7.1.3/fmt-7.1.3.zip"
# )
# CPMAddPackage(URI "https://github.com/nlohmann/json/archive/refs/tags/v3.10.5.tar.gz"
#     NAME json
#     OPTIONS "CMAKE_POLICY_VERSION_MINIMUM 3.10" # Совместимость с CMake 4
# )
# CPMAddPackage(URI "https://github.com/catchorg/Catch2/archive/refs/tags/v3.4.0.tar.gz"
#     NAME Catch2
# )

# target_link_libraries(${EXECUTABLE} PRIVATE fmt::fmt nlohmann_json::nlohmann_json)
# target_link_libraries(tests PRIVATE Catch2::Catch2)

# Пример подключения из архива релиза
# CPMAddPackage(NAME NVS_Lib URL "https://github.com/SergeyLadanov/NVS_Lib_CPP/releases/download/1.0.1/NVS_Lib_1.0.1.zip")
# target_link_libraries(${EXECUTABLE} PRIVATE NVS_Lib)
