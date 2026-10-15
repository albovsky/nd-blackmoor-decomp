#ifndef BLACKMOOR_ACTION_FAMILY_83_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_83_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define A83_MAIL_BYTES 74u
#define A83_WEB_BYTES 41u
#define A83_UICL_MIN_BYTES 0xda1u

typedef enum A83Status {
    A83_OK = 0, A83_ERR_ARGUMENT = 1, A83_ERR_BODY = 2,
    A83_ERR_UNSUPPORTED = 3, A83_ERR_HOST = 4, A83_ERR_CAPACITY = 5,
    A83_ERR_STATE = 6
} A83Status;

/* Process-persistent cell-phone email and web-link lists. Original counts
 * are signed words at 0x5a1e5e/60; records start at 0x5a2664/0x5a434c.
 * Capacities describe caller storage, not inferred original capacities.
 * Buffers and this view must be initialized by the host and remain alive. */
typedef struct A83World {
    uint8_t (*mail)[A83_MAIL_BYTES];
    size_t mail_capacity;
    int16_t mail_count;
    uint8_t (*web)[A83_WEB_BYTES];
    size_t web_capacity;
    int16_t web_count;
} A83World;

typedef struct A83Input {
    uint32_t phase;
    uint8_t subtype;
    uint8_t completed;
    uint8_t eligible;
} A83Input;

typedef struct A83Result {
    uint32_t phase;
    uint8_t completed;
    uint8_t applied;
    int16_t selected;
    uint8_t inserted;
    uint8_t list; /* 0 email, 1 web */
} A83Result;

typedef struct A83Backend {
    void *context;
    /* 0x4e0559(3,1,1 or 2): mark the shared UI control dirty. This is a
     * memory-state notification, not immediate rendering/caption/audio.
     * Return zero on success. A failure preserves earlier list writes and
     * does not complete the row; a missing callback is detected pre-effect. */
    int (*refresh)(void *, int16_t group, int32_t active, int16_t child);
} A83Backend;

/* Selected list reset from 0x4e2e64..0x4e2fa4 after 0x4e4337 copies UICL
 * to this+0x6d2. Initial email at UICL+0xccb, link at +0xd11. Contact
 * sorting, phone renderer and saved-game loading are separate consumers.
 * Preserves unused/trailing storage exactly like the original C-string
 * copies. Empty keys reset only counts. All validation precedes writes. */
int action83_initialize(A83World *, const uint8_t *uicl, size_t length);

/* Bounded value reconstruction of 0x4e72fb and 0x4e444d, reached by the
 * 0x4296f8 dispatcher arm. Uses the typed 74-byte body; no randomness or
 * AUTOTEXT resolution occurs here. Keys are case-sensitive byte strings.
 * Email: new entries prepend, existing entries retain position, read=0.
 * Web: new entries append, +0x44 is sign-extended to the stored DWORD.
 * Gate and completed skipping are also checked here for isolated visits;
 * the session executor owns actual dependency construction/evaluation.
 * Successful visits set completion directly, preserve phase, ignore subtype
 * and never reset dependencies (0x42973b). Output is untouched on error.
 * Null providers, malformed reached strings/counts and capacity exhaustion
 * fail before list or host effects. Host failures retain preceding writes.
 * Out-of-field strings, negative counts and overflow are native safety
 * rejections, not claims about the original's unchecked behavior. */
int action83_runtime_step(const uint8_t *, size_t, const A83Input *,
                          A83World *, const A83Backend *, A83Result *,
                          const char **failure);

#ifdef __cplusplus
}
#endif
#endif
