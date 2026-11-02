/* Exercise generated 0x50df94 with finite nonnegative doubles and CW=0x27f.
 * No game entry, original x86 execution or output device. Exceptional inputs,
 * EFLAGS across calls, errno/matherr and other control words are outside scope. */
#include <float.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "rc.h"
#include "rc_internal.h"
#include "original_methods_fl41_x87.h"

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s OWNER_GAME_EXE\n", argv[0]);
        return 2;
    }
    char error[512] = {0};
    if (rc_start(argv[1], error, sizeof error)) {
        fprintf(stderr, "rc_start: %s\n", error);
        return 2;
    }
    if (!rc_has(0x50df94u)) {
        fprintf(stderr, "generated entry 0x50df94 absent\n");
        return 2;
    }
    static const double input[] = {0, 1, 2, 4, 50, 100, 625, 2500, 5000};
    unsigned failures = 0;
    rc_threads_enter();
    for (unsigned i = 0; i < sizeof input / sizeof input[0]; ++i) {
        uint32_t arguments[2];
        memcpy(arguments, &input[i], sizeof arguments);
        Fl41Fpu *fp = rc_fpu();
        memset(fp, 0, sizeof *fp);
        fp->cw = FL41_FCW_WIN32;
        uint32_t eax = 0;
        int stopped = rc_call_raw(0x50df94u, 2, arguments, 0, &eax);
        unsigned valid = 0, top = FL41_FTOP(fp);
        for (unsigned k = 0; k < 8; ++k) valid += fp->valid[k] != 0;
        double got = fp->valid[top] ? (double)FL41_FST(fp, 0) : NAN;
        double want = sqrt(input[i]);
        double tolerance = 4.0 * DBL_EPSILON * fmax(1.0, want);
        int pass = !stopped && valid == 1 && fp->valid[top] &&
                   fp->cw == FL41_FCW_WIN32 && isfinite(got) &&
                   fabs(got - want) <= tolerance;
        printf("RECOMP_SQRT input=%.17g got=%.17g expected=%.17g valid=%u cw=0x%x stopped=%d pass=%d\n",
               input[i], got, want, valid, fp->cw, stopped, pass);
        if (stopped) fprintf(stderr, "guest stop: %s\n", rc_abort_reason());
        if (!pass) ++failures;
    }
    rc_threads_leave();
    printf("RECOMP_SQRT cases=%zu failures=%u\n",
           sizeof input / sizeof input[0], failures);
    return failures ? 1 : 0;
}
