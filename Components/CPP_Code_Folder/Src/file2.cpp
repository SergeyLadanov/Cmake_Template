#include "file2.hpp"
#include "IncludeOnlyComponent.hpp"
#include "file1.h"
#include "main.hpp"

void Hello_From_CPP(void)
{
	ExtTest();
	Dependency_Demonstration();
	include_only_dependence_example();
	printf("Hello from CPP!\r\n");
}