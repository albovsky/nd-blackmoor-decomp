#ifndef BLACKMOOR_NATIVE_PHONE_POPUP_H
#define BLACKMOOR_NATIVE_PHONE_POPUP_H

#include "action_family_80_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define NATIVE_PHONE_UICL_MIN_BYTES 0xda1u
#define NATIVE_PHONE_SOUND_BYTES 49u
#define NATIVE_PHONE_MAX_BLITS 8u

enum { NATIVE_PHONE_OK, NATIVE_PHONE_ARGUMENT, NATIVE_PHONE_FORMAT,
       NATIVE_PHONE_UNSUPPORTED, NATIVE_PHONE_HOST };
enum { NATIVE_PHONE_EVENT_NONE, NATIVE_PHONE_EVENT_WAIT_OPEN,
       NATIVE_PHONE_EVENT_PICKUP_STARTED, NATIVE_PHONE_EVENT_PICKUP_FINISHED,
       NATIVE_PHONE_EVENT_CALL_REQUESTED, NATIVE_PHONE_EVENT_CLOSED };
enum { NATIVE_PHONE_SHEET_BASE, NATIVE_PHONE_SHEET_EXTRAS };

typedef struct {
    /* Borrow authoritative original cells. The same Action80Object passed to
     * every API is also the one read/written by raw0x80; there is no copy here. */
    Action80World cells;
    int32_t unavailable_5a1e58;
    int32_t battery_5a1e54;
    int16_t frame_5bb50b, vertical_5bb593;
    int32_t dword_5bb5a7, dword_5bb5ab, dword_5bb5af;
} NativePhoneWorld;

typedef struct {
    uint8_t active;
    uint8_t pickup_loaded;
    uint8_t pickup[NATIVE_PHONE_SOUND_BYTES];
    int32_t requested_mode;
    int16_t saved_current_scene_6b8; /* written by0x4e3a64; raw0x80 uses6ba */
} NativePhonePopup;

typedef struct {
    void *context;
    /* Load/own actual UICL surfaces and generic popup resources. No UI state is
     * committed before this succeeds. Resources remain through the call. */
    int (*open)(void *context);
    /* The original0x4ee5cd boundary, not a fabricated elapsed-time rule.
     * ready is0 while pending,1 when decoded resources/transition are ready.
     * A synchronous host may return1 immediately. Fade timing is unverified. */
    int (*transition_ready)(void *context, int *ready);
    int (*sound_prepare)(void *context, const uint8_t *record, size_t bytes);
    int (*sound_play)(void *context, uint16_t channel);
    int (*sound_busy)(void *context, uint16_t channel, int *playing);
    int (*sound_unload)(void *context, const uint8_t *record, size_t bytes);
    int (*request_transition)(void *context, const SceneTransitionRequest *request);
    /* Actual generic popup/buttons/fonts/extras teardown0x4e303b. */
    int (*close)(void *context);
} NativePhoneHost;

typedef struct {
    int event;
    uint8_t redraw;
} NativePhoneResult;

/* BOOT/UICL names and forced pickup descriptor0x4e498d. Output arguments are
 * unchanged on failure. This does not extract or own assets. */
int native_phone_popup_assets(const uint8_t *uicl, size_t bytes,
    char base[33], char extras[33], uint8_t pickup[NATIVE_PHONE_SOUND_BYTES]);

/* Consume the deferred phone flag only after screen1->0 normalization. Caller
 * has already cleared the flag and set cells.cell_583204=5 as0x43a7ca does.
 * open preserves forced target/auto-close and all existing saved tuple cells;
 * current mode starts0 and requested mode is2. Does not process ACT or invent
 * an immediate sound/transition. Only forced calls, unavailable==0 supported. */
int native_phone_popup_open(NativePhonePopup *popup, Action80Object *object,
    NativePhoneWorld *world, const uint8_t *uicl, size_t bytes,
    const NativePhoneHost *host);

/*0x4e4cb6 subset: modes0/4/5->2, substates0/5/6, then retained frame during
 * the call. Call once in the request-open branch (skip ACT), otherwise after
 * ACT when screen==5. Pass freshly sampled return mirrors before substate6.
 * Raw0x80 can update object directly; its65d2 causes real close here, possibly
 * in the same return-dispatch tick. Host failures may leave host-owned prefix
 * effects; they are terminal, not retry-safe. Model commits after success.
 * Normal dialing/keypad/manual-close and other modes explicitly unsupported. */
int native_phone_popup_process(NativePhonePopup *popup, Action80Object *object,
    NativePhoneWorld *world, const NativePhoneHost *host, NativePhoneResult *result);

typedef struct { int32_t left, top, right, bottom; } NativePhoneRect;
typedef struct {
    unsigned sheet;
    NativePhoneRect source, destination;
} NativePhoneBlit;
typedef struct {
    NativePhoneBlit blits[NATIVE_PHONE_MAX_BLITS];
    size_t count;
    uint8_t visible;
} NativePhonePlan;

/* Opaque normal-size forced-call frame/connecting subset of0x4e6658. Base
 * destination adds VIEW origin iff UICL+67; extra destinations remain the
 * absolute coordinates installed by0x4e3093. Empty-screen source subtracts
 * original popup origin AND VIEW origin. load_game1 keeps the frame visible
 * with screen0/2, including battery/web/directory crops but suppressing
 * keypad/connecting overlays. Emit this layer
 * before conversation captions/choices. No text/fade/input parity claim.
 * Entire plan is validated before publication; failures leave out unchanged. */
int native_phone_popup_plan(const NativePhonePopup *popup,
    const Action80Object *object, const NativePhoneWorld *world,
    const uint8_t *uicl, size_t bytes, int32_t origin_x, int32_t origin_y,
    uint32_t base_width, uint32_t base_height,
    uint32_t extras_width, uint32_t extras_height, NativePhonePlan *out);

#ifdef __cplusplus
}
#endif
#endif
