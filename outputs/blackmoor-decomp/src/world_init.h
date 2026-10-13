#ifndef BLACKMOOR_WORLD_INIT_H
#define BLACKMOOR_WORLD_INIT_H

#include "action_core.h"
#include "engine_boot.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define WORLD_INIT_EVENT_NEW_GAME_FIRST_ID 1000u
#define WORLD_INIT_EVENT_NEW_GAME_COUNT 1251u
#define WORLD_INIT_EVENT_SCENE_CLEAR_COUNT 31u
#define WORLD_INIT_VISIT_RESET_COUNT 10001u
#define WORLD_INIT_STATE_DWORD_COUNT 30u
#define WORLD_INIT_INVENTORY_ENTRY_COUNT 70u
#define WORLD_INIT_INVENTORY_OBJECT_SLOT_COUNT 16u
#define WORLD_INIT_INVENTORY_OBJECT_VIEW_MIN_BYTES 0x828au
#define WORLD_INIT_TIME_RECORD_COUNT 10u
#define WORLD_INIT_TIME_RECORD_SIZE 262u
#define WORLD_INIT_TIME_RECORD_BYTES \
    (WORLD_INIT_TIME_RECORD_COUNT * WORLD_INIT_TIME_RECORD_SIZE)
#define WORLD_INIT_SCENE_ID_LIMIT 9991

typedef enum world_init_status {
    WORLD_INIT_OK = 0,
    WORLD_INIT_ERR_ARGUMENT = 1,
    WORLD_INIT_ERR_BOUNDS = 2,
    WORLD_INIT_ERR_UNSUPPORTED_TEST_MODE = 3,
    WORLD_INIT_ERR_SCENE_ID = 4,
    WORLD_INIT_ERR_CORE = 5
} WorldInitStatus;

typedef struct world_init_u16_span {
    uint16_t *values;
    size_t count;
} WorldInitU16Span;

typedef struct world_init_i32_span {
    int32_t *values;
    size_t count;
} WorldInitI32Span;

typedef struct world_init_u32_span {
    uint32_t *values;
    size_t count;
} WorldInitU32Span;

/* Caller-owned spans corresponding to resettable original fields.
 * Counts bound this native view; they do not claim original global capacities. */
typedef struct world_init_inventory {
    int16_t *selected_item_candidate; /* VA 0x00583a29 */
    int16_t *opaque_selector_583f1d;  /* VA 0x00583f1d; meaning unresolved */
    WorldInitU16Span selector_words_583a2b; /* three adjacent 16-bit words */
    WorldInitI32Span presence_583bd5;
    WorldInitU16Span item_ids_583a31;
    WorldInitU16Span item_ids_583abd;
    WorldInitU16Span item_ids_583b49;
    WorldInitU32Span auxiliary_583ced;
    WorldInitU32Span auxiliary_583e05;
} WorldInitInventory;

/* Exact selected clock fields, with neutral names for display words whose
 * user-facing units have not been established. All addresses are original VAs. */
typedef struct world_init_clock {
    uint32_t run_start_tick;          /* 0x00585d33 */
    uint32_t run_elapsed_ticks;       /* 0x00585d37 */
    uint16_t run_display_word_0;      /* 0x00585d3b */
    uint16_t run_display_word_1;      /* 0x00585d3d */
    uint16_t run_display_word_2;      /* 0x00585d3f */
    uint32_t scene_elapsed_ticks;     /* 0x00585d41 */
    uint16_t scene_display_word_0;    /* 0x00585d45 */
    uint16_t scene_display_word_1;    /* 0x00585d47 */
    uint16_t scene_display_word_2;    /* 0x00585d49 */
    int32_t total_minutes;            /* 0x00585d4b */
    int16_t configured_minute;        /* 0x00585d4f */
    int16_t configured_hour;          /* 0x00585d51 */
    int16_t day_counter;              /* 0x00585d53 */
    uint32_t next_update_tick;        /* 0x00585d55 */
    int16_t first_day_event_hour;     /* 0x00585d59 */
    int16_t first_day_event_flag_id;  /* 0x00585d5b */
    uint32_t previous_tick_5d;        /* 0x00585d5d */
    uint32_t previous_tick_61;        /* 0x00585d61 */
    int16_t update_interval_ms;       /* BOOT BSUM + 235 / global 0x5b0280 */
} WorldInitClock;

typedef struct world_init_start_tuple {
    int32_t scene_id;
    int16_t coordinate_word_a;
    int16_t coordinate_word_b;
    uint8_t source; /* WorldInitStartSource */
} WorldInitStartTuple;

typedef enum world_init_start_source {
    WORLD_INIT_START_ORDINARY = 0,
    WORLD_INIT_START_ALTERNATE = 1,
    WORLD_INIT_START_FORCED_SCENE = 2
} WorldInitStartSource;

typedef struct world_init_startup_overrides {
    int32_t alternate_tuple_active; /* original dword 0x005bb1de */
    int32_t forced_scene_gate_a;    /* original dword 0x0063a4d1 */
    int32_t forced_scene_gate_b;    /* original dword 0x0063a4d5 */
    int32_t forced_scene_id;        /* original dword 0x0063a4dd */
    int32_t test_mode_enabled;      /* original dword 0x0063a4d9 */
} WorldInitStartupOverrides;

/* Caller-owned state view for only the exact spans modeled here. */
typedef struct world_init_state {
    ActionCoreWorld *action_core;
    WorldInitI32Span opaque_state_dwords_5839b1;
    WorldInitU16Span scene_visit_counts_587b2d; /* signed-short bit patterns */
    WorldInitInventory inventory;
    uint8_t *time_records_585d65;
    size_t time_records_size;
    WorldInitClock clock;
    WorldInitStartTuple start_tuple;
    int32_t forced_scene_mirror_63a4ed;
} WorldInitState;

/* PE cold-load zero-fill is represented only across the event-flag extent
 * supplied by the caller. This function does not infer that extent. */
int world_init_cold_zero_event_flags(ActionCoreWorld *action_core);

/* Applies only the original inventory object's directly observed data resets
 * from VA 0x4e7e15. `object_view` is based at that method's ECX/this pointer
 * and must cover through byte offset 0x8289 (minimum size 0x828a). The method
 * also destroys/recreates resource handles; those external effects are not
 * represented here. This helper is separate from New Game so callers can
 * supply an object view only when they own that lifecycle boundary. */
int world_init_reset_inventory_object_data(uint8_t *object_view,
                                           size_t object_view_size);

/* Models selected, instruction-verified writes made by VA 0x4381f4 and its
 * inventory/time-record initializer callees. The New Game clear is IDs
 * 1000..2250; IDs 0..999 retain same-process values. Test-mode's subsequent
 * filesystem path is out of scope and returns unsupported without mutation. */
int world_init_apply_new_game(WorldInitState *state,
                              const EngineBootStartupSettings *settings,
                              const WorldInitStartupOverrides *overrides,
                              uint32_t now_tick);

/* Models the selected reset fields from VA 0x43dbe3. A non-restore scene clear
 * zeros only scene elapsed/display fields. Restore mode re-baselines the
 * original run tick/deadline fields and preserves elapsed/readout values. */
int world_init_apply_scene_clear(WorldInitState *state,
                                 int restoring,
                                 uint32_t now_tick);

/* Call only after the original scene loader reports a successful resource
 * load. VA 0x43a6b0 increments the 16-bit visit word only when not restoring.
 * The table's reset extent and the loader's accepted scene-ID bound are separate
 * facts; caller storage is checked independently. */
int world_init_record_successful_scene_load(WorldInitState *state,
                                            int32_t scene_id,
                                            int restoring);

const char *world_init_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
