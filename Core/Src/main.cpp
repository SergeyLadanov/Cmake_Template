
#include "main.hpp"
#include "IncludeOnlyComponent.hpp"
#include <cstdint>
#include <cstdlib>

import math;

void ExtTest(void)
{

}

// Основная программа
int main(void)
{
	printf("Test module result %d\r\n", add(1, 2));
	ExtTest();
	include_only_print();
	Hello_From_C();
	Hello_From_CPP();
	return 0;
}
