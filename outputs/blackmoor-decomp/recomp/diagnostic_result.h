#ifndef RC_DIAGNOSTIC_RESULT_H
#define RC_DIAGNOSTIC_RESULT_H

#include <string.h>

/* rc_main unwinds both a requested stop and ExitProcess through rc_abort.
 * An appended native call trace starts with a space. Do not mistake another
 * abort with a similar prefix for a successful diagnostic run. */
static inline int rc_diagnostic_guest_succeeded(int result, const char *reason)
{
    if (!result) return 1;
    if (!reason) return 0;
    const char *expected[] = {"stop requested", "ExitProcess(0)"};
    for (unsigned i = 0; i < sizeof expected / sizeof expected[0]; ++i) {
        size_t length = strlen(expected[i]);
        if (!strncmp(reason, expected[i], length) &&
            (!reason[length] || reason[length] == ' ')) return 1;
    }
    return 0;
}

#endif
