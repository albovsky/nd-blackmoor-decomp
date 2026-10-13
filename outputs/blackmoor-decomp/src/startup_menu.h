#ifndef BLACKMOOR_STARTUP_MENU_H
#define BLACKMOOR_STARTUP_MENU_H

#include "engine_boot.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define STARTUP_MENU_BUTTON_COUNT 9u

typedef struct StartupMenu StartupMenu;

typedef enum startup_menu_stage {
    STARTUP_MENU_PARTNER_SPLASH = 0,
    STARTUP_MENU_COMPANY_LOGO = 1,
    STARTUP_MENU_MAIN_MENU = 2,
    STARTUP_MENU_COMMAND_PENDING = 3
} StartupMenuStage;

/* Commands are requests to the native engine. The menu does not claim that
 * the requested screen/scene/save operation has completed. */
typedef enum startup_menu_command {
    STARTUP_MENU_COMMAND_NONE = 0,
    STARTUP_MENU_COMMAND_CREDITS = 1,
    STARTUP_MENU_COMMAND_NEW_GAME = 2,
    STARTUP_MENU_COMMAND_LOAD = 3,
    STARTUP_MENU_COMMAND_CONTINUE = 4,
    STARTUP_MENU_COMMAND_SETUP = 5,
    STARTUP_MENU_COMMAND_HELP = 6,
    STARTUP_MENU_COMMAND_PROMO = 7,
    STARTUP_MENU_COMMAND_SECOND_CHANCE = 8,
    STARTUP_MENU_COMMAND_EXIT_GAME = 9,
    STARTUP_MENU_COMMAND_UNRESOLVED = 255
} StartupMenuCommand;

typedef enum startup_menu_status {
    STARTUP_MENU_OK = 0,
    STARTUP_MENU_ERR_ARGUMENT = 1,
    STARTUP_MENU_ERR_MEMORY = 2,
    STARTUP_MENU_ERR_BOOT = 3,
    STARTUP_MENU_ERR_FORMAT = 4
} StartupMenuStatus;

typedef enum startup_menu_button_visual {
    STARTUP_MENU_BUTTON_NORMAL = 0,
    STARTUP_MENU_BUTTON_HOVER = 1,
    STARTUP_MENU_BUTTON_PRESSED = 2,
    STARTUP_MENU_BUTTON_DISABLED = 3
} StartupMenuButtonVisual;

/* Original RECT coordinates use inclusive LTRB edges. */
typedef struct startup_menu_rect {
    int32_t left;
    int32_t top;
    int32_t right;
    int32_t bottom;
} StartupMenuRect;

typedef struct startup_menu_config {
    /* Per-run save/session state determines the original disabled buttons.
     * Bit N disables raw MENU button N. */
    uint16_t disabled_button_mask;
    /* Original DAT_005b0282 is zero-initialized in GAME.EXE's BSS. */
    uint32_t click_feedback_ms;
} StartupMenuConfig;

typedef struct startup_menu_input {
    uint32_t tick_ms;
    /* Host-mapped logical framebuffer coordinates. */
    int32_t logical_x;
    int32_t logical_y;
    int pointer_valid;
    /* Logo skip consumes the press edge once. Main-menu selection also reads
     * the held state, matching the original state==2 mouse poll. */
    int primary_down;
    int primary_pressed;
    /* Exposed to hosts; the original menu dispatch does not wait for release. */
    int primary_released;
    /* Result of the original click-sound completion gate. A silent host sets
     * this to nonzero; an audio host reports actual completion. */
    int click_sound_complete;
} StartupMenuInput;

typedef struct startup_menu_button_frame {
    uint8_t index;
    StartupMenuCommand command;
    StartupMenuButtonVisual visual;
    StartupMenuRect hit_rect;
    StartupMenuRect source_rect;
    StartupMenuRect destination_rect;
} StartupMenuButtonFrame;

typedef struct startup_menu_frame {
    StartupMenuStage stage;
    /* Stable, borrowed name owned by StartupMenu until destroy. */
    const char *resource_name;
    StartupMenuRect background_source;
    StartupMenuRect background_destination;
    int has_background;
    int full_screen_image;
    StartupMenuButtonFrame buttons[STARTUP_MENU_BUTTON_COUNT];
    size_t button_count;
    int hovered_button;
    int pressed_button;
    StartupMenuCommand requested_command;
    int command_ready;
} StartupMenuFrame;

/* Copies startup metadata from EngineBoot; the EngineBoot may be closed after
 * this call. Logo assets are obtained from PLGO and LG0; the menu sheet from
 * MENU. */
StartupMenu *startup_menu_create(const EngineBoot *boot,
                                 const StartupMenuConfig *config,
                                 uint32_t initial_tick_ms,
                                 char *error,
                                 size_t error_capacity);
void startup_menu_destroy(StartupMenu *menu);

/* Advances one original startup/menu update and returns a renderer-neutral
 * plan. A returned command is a request only; callers dispatch it downstream. */
/* Returns STARTUP_MENU_OK (zero) on success. */
int startup_menu_step(StartupMenu *menu,
                      const StartupMenuInput *input,
                      StartupMenuFrame *frame);

const char *startup_menu_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
