
#include "main.hpp"
#include "IncludeOnlyComponent.hpp"
#include <cstdint>
#include <cstdlib>

#if INTELSENSE == 1
  #include "math.cppm"
#else
  import math;
#endif


void ExtTest(void)
{

}

Test myClass;

// Основная программа
int main(void)
{
	printf("Test module result %d\r\n", add(1, 2));
	myClass.Action();
	ExtTest();
	include_only_print();
	Hello_From_C();
	Hello_From_CPP();
	return 0;
}
