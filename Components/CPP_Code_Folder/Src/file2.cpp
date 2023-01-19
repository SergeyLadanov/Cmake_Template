#include "file2.hpp"
#include "file1.h"
#include "IncludeOnlyComponent.hpp"
#include "main.hpp"



void Hello_From_CPP(void)
{
    ExtTest();
    Dependency_Demonstration();
    include_only_dependence_example();
    printf("Hello from CPP!\r\n");
}