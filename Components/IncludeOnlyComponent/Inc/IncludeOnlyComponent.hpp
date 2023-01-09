#pragma once

#include <cstdio>

static inline void include_only_print(void)
{
    printf("Print from include only component\r\n");
}

static inline void include_only_dependence_example(void)
{
    printf("Print from include only dependence\r\n");
}