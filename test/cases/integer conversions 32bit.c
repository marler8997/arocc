//aro-args --target=x86-linux-gnu -Wno-c2x-extensions
#include "include/test_helpers.h"

void foo(void) {
    EXPECT_TYPE(1U + 1L, unsigned long);
}
