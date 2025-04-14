
#include "main.hpp"
#include "IncludeOnlyComponent.hpp"
#include <cstdint>
#include <cstdlib>

void ExtTest(void)
{

}

// Основная программа
int main(void)
{
	ExtTest();
	include_only_print();
	Hello_From_C();
	Hello_From_CPP();
	return 0;
}
