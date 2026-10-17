#ifndef BLACKMOOR_SESSION_BINDINGS_A47_H
#define BLACKMOOR_SESSION_BINDINGS_A47_H

/* Session binding for raw action 0x47 (RT-42): add an entry to a journal table.
 *
 * Runtime: case 0x47 of 0x427a50 (arm 0x428515), gate mode 0 (the executor evaluates it; the handler runs for a true gate).
 * The arm calls the appender 0x412787 on the text owner 0x619a41 (action_family_47_runtime.h): it duplicates-checks the
 * name against the stored entries, asks the AUTOTEXT table 0x423259 whether the name exists, adds the entry and sets the
 * page-2 "new entry" flags, then the generic completion 0x42ba3a(row). Every outcome completes the row.
 * The binding owns the tables (world state in the original: they outlive scenes). The text writer's link table (RT-34,
 * table 0) lives in the same memory in the original; the app does not wire the two yet. */

#include "action_family_47_runtime.h"
#include "action_family_51.h"
#include "scene_executor.h"
#include "scene_resource.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A47_TYPE A47_RAW_TYPE

typedef struct SessionA47Binding SessionA47Binding;

typedef struct session_a47_host {
    /* 0x423259 on the AUTOTEXT table. Optional: a visit that needs the lookup without one is UNSUPPORTED before any effect. */
    ActionFamily51AutoTextLookup lookup;
    void *lookup_context;
} SessionA47Host;

SessionA47Binding *session_a47_create(const SessionA47Host *host);
void session_a47_destroy(SessionA47Binding *binding);

/* SceneActionExternalHandler for type 0x47: COMPLETED with phase 0 (the generic completion derives the completion byte and
 * the dependency reset from the subtype). A body the kernel rejects, a full table or a failing lookup is an ERROR; a visit
 * that needs the lookup while none is bound is UNSUPPORTED. Nothing changes in either case. */
int session_a47_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);

/* Diagnostics and state access (the text writer will read table 0). */
const A47Tables *session_a47_tables(const SessionA47Binding *binding);
/* The outcome of the last visit that reached the kernel. */
const A47Outcome *session_a47_last_outcome(const SessionA47Binding *binding);
unsigned long session_a47_visits(const SessionA47Binding *binding);
unsigned long session_a47_adds(const SessionA47Binding *binding);
const char *session_a47_failure(const SessionA47Binding *binding);
/* New game: empties the tables and the page-2 flags (the original's world init zeroes them). */
void session_a47_reset(SessionA47Binding *binding);

#ifdef __cplusplus
}
#endif

#endif
