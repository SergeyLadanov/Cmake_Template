
module;
#include <cstdio>
export module math;

export int add(int a, int b)
{
    return a + b;
}

export class Test
{
private:
    /* data */
public:
    Test(/* args */)
    {

    }

    void Action(void)
    {
        printf("Test::Action\n");
    }

    ~Test()
    {

    }
};

