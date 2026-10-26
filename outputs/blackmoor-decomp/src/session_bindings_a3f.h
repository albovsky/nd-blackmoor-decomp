#ifndef BLACKMOOR_SESSION_BINDINGS_A3F_H
#define BLACKMOOR_SESSION_BINDINGS_A3F_H

#include "action_family_3f_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

/* RT-23: executor binding of raw 0x3f rows (runtime type 0x3f, dispatcher arm
 * 0x427a50 -> 0x420c17). The executor evaluates the row's dependency tree
 * (0x423f57 mode 0) and calls the handler only for eligible, not completed
 * rows. The finish branch completes the row DIRECTLY (completion byte := 1,
 * phase := 0, no dependency reset). */
#define SESSION_A3F_TYPE UINT8_C(0x3f)
/* RT-25: raw 0x3e cel-video rows run through the same binding (runtime type 0x3e,
 * same dispatcher arm and handler; the kernel selects the cel arm). */
#define SESSION_A3E_TYPE UINT8_C(0x3e)

typedef struct SessionA3fBinding SessionA3fBinding;

typedef struct SessionA3fHost {
    /* kernel.context is handed to every kernel callback and to the members
     * below. */
    Convo3fHost kernel;
    /* The binding keeps ONE persistent Convo3fWorld (conversation state:
     * [0x5c39e9]/[0x5c39ed], selection, response flags, text box words, the
     * per-line sound names, ...). Before every kernel call load_world receives
     * that world and overrides the fields the host owns: event/presence arrays,
     * held item, mode 3 while a scene runs, the settings (captions, Fast Convo,
     * exit flag), the cursor words, start_5bb1ca, the text box metrics. NULL or
     * a nonzero return makes the visit UNSUPPORTED before any effect. */
    int (*load_world)(void *context, Convo3fWorld *world);
    /* Commit the globals the kernel wrote (start_5bb1ca, ...). Called after a
     * successful call. */
    void (*store_world)(void *context, const Convo3fWorld *world);
    /* 0x423259: case-insensitive lookup of a CONVO key (33-byte field, length
     * excludes the NUL). Return 0 with a borrowed text pointer and length (valid for the
     * duration of the call: the binding copies it into the object image), or
     * nonzero when the key is missing (the loader's embedded fallback text is
     * then used). May be NULL: every key then counts as missing. */
    int (*resolve_text)(void *context, const uint8_t *key, size_t key_length,
                        const uint8_t **text, size_t *length);
    /* The finish branches store the scene-change words and mode 4; the native
     * stand-in is a transition request. REQUIRED: without it every visit is
     * UNSUPPORTED before any effect. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
} SessionA3fHost;

SessionA3fBinding *session_a3f_create(const SessionA3fHost *);
void session_a3f_destroy(SessionA3fBinding *);

/* Builds the object image of every raw 0x3f row (action_family_3f_construct
 * with the resolved CONVO texts, arena handle base 1) and resets the manager.
 * A row that cannot be built (text too long for its field, malformed body) is
 * remembered with a reason and its visits are UNSUPPORTED; the scene itself
 * still loads. Returns CONVO3F_OK, or an error for NULL arguments, allocation
 * failure or an unreadable row table. */
int session_a3f_begin_scene(SessionA3fBinding *, const SceneResource *);

/* Executor handler. PENDING with the kernel's phase after, or DIRECT_COMPLETED
 * with phase 0 once the finish branch ran (the row's image is then released;
 * a later visit is an ERROR, the original dereferences the freed object). */
int session_a3f_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a3f_failure(const SessionA3fBinding *);

/* Host input and executor queries on the persistent conversation state. */
/* [0x5c39e9] != 0: a conversation is active (the executor's modal flag, 0x43bfd3). */
int session_a3f_modal_active(const SessionA3fBinding *);
/* The pointer path 0x4e78c2: clears [0x5839b1..+0x1e] and sets entry `index`
 * to 1. Returns 0, or nonzero when no response with that index is listed. */
int session_a3f_choose_response(SessionA3fBinding *, int index);
/* Listed responses (manager +0xf21) and their text (NUL terminated, valid until
 * the next visit), NULL when out of range. */
int session_a3f_response_count(const SessionA3fBinding *);
/* Native dry UI layout; calls only load_world on a private world copy and
 * reuses the kernel's condition/list builder. Borrowed caption stays valid
 * until the next scene/visit. Caller supplies the preview manager storage. */
int session_a3f_preview_layout(const SessionA3fBinding *, size_t row,
    Convo3fManager *preview, Convo3fLayoutRequest *request);

const uint8_t *session_a3f_response_text(const SessionA3fBinding *, int index);

/* RT-25 cel arm. The reader thread of the original (0x422e4a) is replaced by explicit
 * passes: the host calls session_a3f_cel_reader_pass often while a cel row runs
 * (session_a3f_cel_active() != 0), e.g. several times per tick. 0 on success. */
int session_a3f_cel_active(const SessionA3fBinding *);
int session_a3f_cel_reader_pass(SessionA3fBinding *, int *ran);
/* The render callback 0x422a0a. Returns 1 and fills `plan` when the entry flag
 * [0x5d191d] was set (the flag is cleared), 0 when nothing is due or no cel row runs,
 * a negative value on failure (see session_a3f_failure). */
int session_a3f_cel_render(SessionA3fBinding *, Convo3fRenderPlan *plan);

/* Most recent kernel result (diagnostics); NULL before the first visit. */
const Convo3fStepResult *session_a3f_last_result(const SessionA3fBinding *);
const Convo3fManager *session_a3f_manager(const SessionA3fBinding *);
/* The row's object image (0x7a5 bytes), NULL for non-0x3f, unbuilt or released rows. */
const uint8_t *session_a3f_image(const SessionA3fBinding *, size_t row);
/* Reason a row cannot be run, NULL when it can (or is not a raw 0x3f row). */
const char *session_a3f_row_reason(const SessionA3fBinding *, size_t row);

#ifdef __cplusplus
}
#endif
#endif
