#include <typeinfo>
#include <iostream>

int f()
{
    return 0;
}

int main()
{
    typedef int(*FUNC)(int);
    //std::cout << typeid(typename boost::result_of<FUNC>::type).name() << "\n";
    return 0;
}
