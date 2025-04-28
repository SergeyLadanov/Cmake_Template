#include <assert.h>
#include <cstdio>
#include "add.hpp"


int main(void)
{
    printf("Running tests for add...\n");

    // Test case 1
    assert(add(2, 3) == 5);

    // Test case 2
    assert(add(-1, 1) == 0);

    // Test case 3
    assert(add(0, 0) == 0);

    // If all asserts passed
    printf("All tests passed!\n");
    return 0;
}