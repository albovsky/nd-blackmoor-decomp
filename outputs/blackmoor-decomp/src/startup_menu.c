#include "startup_menu.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MENU_RAW_SIZE 631u
#define MENU_BASE_RECT_OFFSET 39u
#define MENU_DEST_RECT_OFFSET 55u
#define MENU_PRESSED_RECT_OFFSET 199u
#define MENU_DISABLED_RECT_OFFSET 343u
#define MENU_HOVER_RECT_OFFSET 487u
#define LOGO_DISPLAY_MS 4000u
#define POINTER_HOTSPOT_Y 10

struct StartupMenu {
    StartupMenuStage stage;
    uint32_t stage_started_ms;
    uint32_t click_feedback_ms;
    uint16_t disabled_mask;
    char partner_logo_name[34];
    char company_logo_name[34];
    char menu_sheet_name[34];
    StartupMenuRect background_rect;
    StartupMenuRect hit_rects[STARTUP_MENU_BUTTON_COUNT];
    StartupMenuRect normal_rects[STARTUP_MENU_BUTTON_COUNT];
    StartupMenuRect pressed_rects[STARTUP_MENU_BUTTON_COUNT];
    StartupMenuRect disabled_rects[STARTUP_MENU_BUTTON_COUNT];
    StartupMenuRect hover_rects[STARTUP_MENU_BUTTON_COUNT];
    int hovered_button;
    int hover_armed;
    int pressed_button;
    uint32_t click_deadline_ms;
    StartupMenuCommand pending_command;
    StartupMenuCommand requested_command;
    int command_ready;
};

static const StartupMenuCommand k_button_commands[STARTUP_MENU_BUTTON_COUNT] = {
    STARTUP_MENU_COMMAND_CREDITS,       /* 0: Credits */
    STARTUP_MENU_COMMAND_NEW_GAME,      /* 1: New Game */
    STARTUP_MENU_COMMAND_LOAD,          /* 2: Load & Save Game */
    STARTUP_MENU_COMMAND_CONTINUE,      /* 3: Continue Game */
    STARTUP_MENU_COMMAND_SECOND_CHANCE, /* 4: Second Chance */
    STARTUP_MENU_COMMAND_SETUP,         /* 5: Game Setup */
    STARTUP_MENU_COMMAND_EXIT_GAME,     /* 6: Exit Game */
    STARTUP_MENU_COMMAND_HELP,          /* 7: Help */
    STARTUP_MENU_COMMAND_PROMO          /* 8: More Nancy Drew! */
};

static void set_error(char *error, size_t capacity, const char *message)
{
    if (error != NULL && capacity != 0u) {
        (void)snprintf(error, capacity, "%s", message);
    }
}

static uint32_t read_u32le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static int32_t read_i32le(const uint8_t *bytes)
{
    uint32_t value = read_u32le(bytes);
    int64_t signed_value = (value & UINT32_C(0x80000000)) != 0u
                               ? (int64_t)value - INT64_C(0x100000000)
                               : (int64_t)value;
    return (int32_t)signed_value;
}

static StartupMenuRect read_rect(const uint8_t *bytes)
{
    StartupMenuRect rect;
    rect.left = read_i32le(bytes);
    rect.top = read_i32le(bytes + 4u);
    rect.right = read_i32le(bytes + 8u);
    rect.bottom = read_i32le(bytes + 12u);
    return rect;
}

static int rect_is_ordered(StartupMenuRect rect)
{
    return rect.right >= rect.left && rect.bottom >= rect.top;
}

static int copy_asset_name(char destination[34], const char source[34])
{
    size_t length = strnlen(source, 34u);
    if (length == 0u || length >= 34u) {
        return 0;
    }
    memcpy(destination, source, length);
    destination[length] = '\0';
    return 1;
}

StartupMenu *startup_menu_create(const EngineBoot *boot,
                                 const StartupMenuConfig *config,
                                 uint32_t initial_tick_ms,
                                 char *error,
                                 size_t error_capacity)
{
    StartupMenu *menu;
    EngineBootMenuInfo menu_info;
    EngineBootPlgoInfo plgo_info;
    EngineBootImageDescriptor logo_descriptor;
    size_t index;

    if (error != NULL && error_capacity != 0u) {
        error[0] = '\0';
    }
    if (boot == NULL) {
        set_error(error, error_capacity, "EngineBoot is required");
        return NULL;
    }
    if (engine_boot_get_menu(boot, &menu_info) != ENGINE_BOOT_OK ||
        engine_boot_get_plgo(boot, &plgo_info) != ENGINE_BOOT_OK ||
        engine_boot_logo_count(boot) == 0u ||
        engine_boot_logo_at(boot, 0u, &logo_descriptor) != ENGINE_BOOT_OK) {
        set_error(error, error_capacity,
                  "BOOT must provide MENU, PLGO, and LG0 startup records");
        return NULL;
    }
    if (menu_info.raw == NULL || menu_info.raw_size < MENU_RAW_SIZE) {
        set_error(error, error_capacity, "BOOT MENU record is shorter than 631 bytes");
        return NULL;
    }

    menu = (StartupMenu *)calloc(1u, sizeof(*menu));
    if (menu == NULL) {
        set_error(error, error_capacity, "unable to allocate StartupMenu state");
        return NULL;
    }
    if (!copy_asset_name(menu->partner_logo_name, plgo_info.filename) ||
        !copy_asset_name(menu->company_logo_name, logo_descriptor.filename) ||
        !copy_asset_name(menu->menu_sheet_name, menu_info.first_image_filename)) {
        set_error(error, error_capacity, "BOOT startup resource name is invalid");
        free(menu);
        return NULL;
    }

    menu->background_rect = read_rect(menu_info.raw + MENU_BASE_RECT_OFFSET);
    if (!rect_is_ordered(menu->background_rect)) {
        set_error(error, error_capacity, "BOOT MENU base rectangle is invalid");
        free(menu);
        return NULL;
    }
    for (index = 0u; index < STARTUP_MENU_BUTTON_COUNT; ++index) {
        size_t offset = index * 16u;
        menu->hit_rects[index] = read_rect(menu_info.raw + MENU_DEST_RECT_OFFSET + offset);
        menu->normal_rects[index] = menu->hit_rects[index];
        menu->pressed_rects[index] = read_rect(menu_info.raw + MENU_PRESSED_RECT_OFFSET + offset);
        menu->disabled_rects[index] = read_rect(menu_info.raw + MENU_DISABLED_RECT_OFFSET + offset);
        menu->hover_rects[index] = read_rect(menu_info.raw + MENU_HOVER_RECT_OFFSET + offset);
        if (!rect_is_ordered(menu->hit_rects[index]) ||
            !rect_is_ordered(menu->pressed_rects[index]) ||
            !rect_is_ordered(menu->disabled_rects[index]) ||
            !rect_is_ordered(menu->hover_rects[index])) {
            set_error(error, error_capacity, "BOOT MENU button rectangle is invalid");
            free(menu);
            return NULL;
        }
    }

    menu->stage = STARTUP_MENU_PARTNER_SPLASH;
    menu->stage_started_ms = initial_tick_ms;
    menu->click_feedback_ms = config != NULL ? config->click_feedback_ms : 0u;
    menu->disabled_mask = config != NULL
                              ? (uint16_t)(config->disabled_button_mask & UINT16_C(0x01ff))
                              : 0u;
    menu->hovered_button = -1;
    menu->hover_armed = 0;
    menu->pressed_button = -1;
    menu->pending_command = STARTUP_MENU_COMMAND_NONE;
    menu->requested_command = STARTUP_MENU_COMMAND_NONE;
    menu->command_ready = 0;
    return menu;
}

void startup_menu_destroy(StartupMenu *menu)
{
    free(menu);
}

static int point_in_hit_rect(StartupMenuRect rect, int32_t x, int32_t y)
{
    int64_t y_with_hotspot = (int64_t)y - POINTER_HOTSPOT_Y;
    return x >= rect.left && x <= rect.right &&
           y >= rect.top && y_with_hotspot <= rect.bottom;
}

static int find_hovered_button(const StartupMenu *menu,
                               const StartupMenuInput *input)
{
    size_t index;
    if (!input->pointer_valid) {
        return -1;
    }
    for (index = 0u; index < STARTUP_MENU_BUTTON_COUNT; ++index) {
        if ((menu->disabled_mask & (uint16_t)(1u << index)) == 0u &&
            point_in_hit_rect(menu->hit_rects[index],
                              input->logical_x,
                              input->logical_y)) {
            return (int)index;
        }
    }
    return -1;
}

static int pointer_in_any_hit_rect(const StartupMenu *menu,
                                   const StartupMenuInput *input)
{
    size_t index;
    if (!input->pointer_valid) {
        return 0;
    }
    for (index = 0u; index < STARTUP_MENU_BUTTON_COUNT; ++index) {
        if (point_in_hit_rect(menu->hit_rects[index],
                              input->logical_x,
                              input->logical_y)) {
            return 1;
        }
    }
    return 0;
}

static void fill_frame(const StartupMenu *menu, StartupMenuFrame *frame)
{
    size_t index;
    const char *resource_name;

    memset(frame, 0, sizeof(*frame));
    frame->stage = menu->stage;
    frame->hovered_button = menu->hovered_button;
    frame->pressed_button = menu->pressed_button;
    frame->requested_command = menu->requested_command;
    frame->command_ready = menu->command_ready;

    if (menu->stage == STARTUP_MENU_PARTNER_SPLASH) {
        resource_name = menu->partner_logo_name;
        frame->full_screen_image = 1;
        frame->hovered_button = -1;
        frame->pressed_button = -1;
        frame->resource_name = resource_name;
        return;
    }
    if (menu->stage == STARTUP_MENU_COMPANY_LOGO) {
        resource_name = menu->company_logo_name;
        frame->full_screen_image = 1;
        frame->hovered_button = -1;
        frame->pressed_button = -1;
        frame->resource_name = resource_name;
        return;
    }

    frame->resource_name = menu->menu_sheet_name;
    frame->has_background = 1;
    frame->background_source = menu->background_rect;
    frame->background_destination = menu->background_rect;
    frame->button_count = STARTUP_MENU_BUTTON_COUNT;
    for (index = 0u; index < STARTUP_MENU_BUTTON_COUNT; ++index) {
        StartupMenuButtonFrame *button = &frame->buttons[index];
        int disabled = (menu->disabled_mask & (uint16_t)(1u << index)) != 0u;
        button->index = (uint8_t)index;
        button->command = k_button_commands[index];
        button->hit_rect = menu->hit_rects[index];
        button->destination_rect = menu->hit_rects[index];
        if (disabled) {
            button->visual = STARTUP_MENU_BUTTON_DISABLED;
            button->source_rect = menu->disabled_rects[index];
        } else if ((int)index == menu->pressed_button) {
            button->visual = STARTUP_MENU_BUTTON_PRESSED;
            button->source_rect = menu->pressed_rects[index];
        } else if ((int)index == menu->hovered_button) {
            button->visual = STARTUP_MENU_BUTTON_HOVER;
            button->source_rect = menu->hover_rects[index];
        } else {
            button->visual = STARTUP_MENU_BUTTON_NORMAL;
            button->source_rect = menu->normal_rects[index];
        }
    }
}

static void transition_to(StartupMenu *menu,
                          StartupMenuStage stage,
                          uint32_t now_ms)
{
    menu->stage = stage;
    menu->stage_started_ms = now_ms;
    menu->hovered_button = -1;
    menu->hover_armed = 0;
    menu->pressed_button = -1;
}

int startup_menu_step(StartupMenu *menu,
                      const StartupMenuInput *input,
                      StartupMenuFrame *frame)
{
    if (menu == NULL || input == NULL || frame == NULL) {
        return STARTUP_MENU_ERR_ARGUMENT;
    }

    if (menu->stage == STARTUP_MENU_PARTNER_SPLASH ||
        menu->stage == STARTUP_MENU_COMPANY_LOGO) {
        uint32_t elapsed = input->tick_ms - menu->stage_started_ms;
        if (elapsed > LOGO_DISPLAY_MS || input->primary_pressed) {
            if (menu->stage == STARTUP_MENU_PARTNER_SPLASH) {
                transition_to(menu, STARTUP_MENU_COMPANY_LOGO, input->tick_ms);
            } else {
                transition_to(menu, STARTUP_MENU_MAIN_MENU, input->tick_ms);
            }
        }
    } else if (!menu->command_ready && menu->pressed_button < 0) {
        int hovered = find_hovered_button(menu, input);
        int pointer_over_menu_button = pointer_in_any_hit_rect(menu, input);
        menu->hovered_button = hovered;

        if (!pointer_over_menu_button) {
            /* DAT_005aff51 clears only after the pointer leaves all nine
             * rectangles; it is shared across buttons and includes disabled
             * rectangles (0x4da430). */
            menu->hover_armed = 0;
        }
        if (hovered >= 0) {
            if (!menu->hover_armed) {
                menu->hover_armed = 1;
            } else if (input->primary_down || input->primary_pressed) {
                menu->pressed_button = hovered;
                menu->hovered_button = hovered;
                menu->pending_command = k_button_commands[(size_t)hovered];
                menu->click_deadline_ms = input->tick_ms + menu->click_feedback_ms;
            }
        }
    }

    if (menu->stage == STARTUP_MENU_MAIN_MENU && menu->pressed_button >= 0 &&
        !menu->command_ready && menu->click_deadline_ms < input->tick_ms &&
        input->click_sound_complete) {
        menu->requested_command = menu->pending_command;
        menu->command_ready = 1;
        menu->stage = STARTUP_MENU_COMMAND_PENDING;
    }

    fill_frame(menu, frame);
    return STARTUP_MENU_OK;
}

const char *startup_menu_status_string(int status)
{
    switch (status) {
    case STARTUP_MENU_OK:
        return "success";
    case STARTUP_MENU_ERR_ARGUMENT:
        return "invalid startup-menu argument";
    case STARTUP_MENU_ERR_MEMORY:
        return "out of memory";
    case STARTUP_MENU_ERR_BOOT:
        return "invalid BOOT startup records";
    case STARTUP_MENU_ERR_FORMAT:
        return "invalid BOOT MENU geometry";
    default:
        return "unknown startup-menu error";
    }
}
