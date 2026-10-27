#include "puzzle_sound.h"

#include <string.h>

/* Descriptor interpretation: original 0x4fb77a and 0x4fba69, GAME.EXE
 * afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45.
 * Local REA/Ghidra evidence ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
 * supplies pseudocode hints; instruction bytes in asm/FUN_004fb77a.s and
 * asm/FUN_004fba69.s establish widths/offsets and the independent gain clamps.
 * Backend load owns resource replacement; this adapter does not reproduce the
 * private CSound object, DirectSound loader flags or original decoder. */

enum {
    D_CHANNEL = 0x21,
    D_LOADER_FLAGS = 0x23,
    D_LOOP_MODE = 0x25,
    D_CONTROL = 0x29,
    D_GAIN1 = 0x2d,
    D_GAIN2 = 0x2f
};

static uint16_t rd_u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static int16_t rd_s16(const uint8_t *p)
{
    const uint16_t bits = rd_u16(p);
    return bits <= INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static uint32_t rd_u32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static float gain_of(int16_t percent)
{
    const float gain = (float)percent / 100.0f;
    return gain <= 0.0f ? 0.0f : (gain >= 1.0f ? 1.0f : gain);
}

static int backend_status(ActionSoundBackendStatus status)
{
    switch (status) {
    case ACTION_SOUND_BACKEND_OK: return PUZZLE_SOUND_OK;
    case ACTION_SOUND_BACKEND_NO_RESOURCE: return PUZZLE_SOUND_NO_RESOURCE;
    case ACTION_SOUND_BACKEND_UNSUPPORTED: return PUZZLE_SOUND_ERR_UNSUPPORTED;
    default: return PUZZLE_SOUND_ERR_BACKEND;
    }
}

static int command_of(const uint8_t *record, size_t length, ActionSoundAudioCommand *command)
{
    /* 0x4faa03: default category 3, then the three sentinel-terminated lists
     * at 0x5604dc, 0x5604e4 and 0x5604f4 assign categories 0, 1 and 2. */
    static const uint8_t categories[ACTION_SOUND_CHANNEL_COUNT] = {
        1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 3, 3,
        3, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 1, 3, 1, 0, 2
    };
    const uint8_t *nul;
    size_t name_length;
    uint16_t channel;

    if (record == NULL) return PUZZLE_SOUND_ERR_ARGUMENT;
    if (length != PUZZLE_SOUND_RECORD_BYTES) return PUZZLE_SOUND_ERR_DESCRIPTOR;
    nul = memchr(record, 0, ACTION_SOUND_STEM_BYTES);
    if (nul == NULL) return PUZZLE_SOUND_ERR_DESCRIPTOR;
    name_length = (size_t)(nul - record);
    if (memchr(record, '/', name_length) != NULL || memchr(record, '\\', name_length) != NULL)
        return PUZZLE_SOUND_ERR_DESCRIPTOR;
    channel = rd_u16(record + D_CHANNEL);
    if (channel >= ACTION_SOUND_CHANNEL_COUNT) return PUZZLE_SOUND_ERR_DESCRIPTOR;
    /* 0x4fc722 overwrites loader arg3 with1 before its directory switch.
     * Actual Memory flags1 and existing puzzle flags2 share that path. */
    const int16_t loader_flags = rd_s16(record + D_LOADER_FLAGS);
    if ((loader_flags != 1 && loader_flags != PUZZLE_SOUND_LOADER_FLAGS) ||
        rd_s16(record + D_LOOP_MODE) != PUZZLE_SOUND_LOOP_MODE)
        return PUZZLE_SOUND_ERR_UNSUPPORTED;

    memset(command, 0, sizeof *command);
    memcpy(command->asset_stem, record, name_length);
    command->channel = channel;
    command->volume_category = categories[channel];
    command->control_word = rd_u32(record + D_CONTROL);
    command->first_percent = rd_s16(record + D_GAIN1);
    command->second_percent = rd_s16(record + D_GAIN2);
    command->first_gain = gain_of(command->first_percent);
    command->second_gain = gain_of(command->second_percent);
    command->mode = PUZZLE_SOUND_LOOP_MODE;
    command->transition_scene = 9999;
    return PUZZLE_SOUND_OK;
}

int puzzle_sound_init(PuzzleSound *sound, const ActionSoundBackend *backend)
{
    if (sound == NULL || backend == NULL) return PUZZLE_SOUND_ERR_ARGUMENT;
    if (backend->load_sound == NULL || backend->play_sound == NULL ||
        backend->is_playing == NULL || backend->unload_sound == NULL)
        return PUZZLE_SOUND_ERR_UNSUPPORTED;
    sound->backend = *backend;
    memset(sound->prepared, 0, sizeof sound->prepared);
    return PUZZLE_SOUND_OK;
}

int puzzle_sound_prepare(PuzzleSound *sound, const uint8_t *record, size_t length)
{
    ActionSoundAudioCommand command;
    int status;
    if (sound == NULL) return PUZZLE_SOUND_ERR_ARGUMENT;
    status = command_of(record, length, &command);
    if (status != PUZZLE_SOUND_OK) return status;
    if (sound->backend.load_sound == NULL) return PUZZLE_SOUND_ERR_UNSUPPORTED;
    /* The backend may release the previous clip before a failed replacement.
     * Never retain permission to play that previous clip after attempting load. */
    sound->prepared[command.channel] = 0;
    status = backend_status(sound->backend.load_sound(sound->backend.context, &command));
    if (status == PUZZLE_SOUND_OK) sound->prepared[command.channel] = 1;
    return status;
}

int puzzle_sound_stop(PuzzleSound *sound, const uint8_t *record, size_t length)
{
    ActionSoundAudioCommand command;
    int status;
    if (sound == NULL) return PUZZLE_SOUND_ERR_ARGUMENT;
    status = command_of(record, length, &command);
    if (status != PUZZLE_SOUND_OK) return status;
    if (sound->backend.unload_sound == NULL) return PUZZLE_SOUND_ERR_UNSUPPORTED;
    sound->prepared[command.channel] = 0;
    return backend_status(sound->backend.unload_sound(sound->backend.context, command.channel));
}

int puzzle_sound_play(PuzzleSound *sound, uint16_t channel)
{
    if (sound == NULL) return PUZZLE_SOUND_ERR_ARGUMENT;
    if (channel >= ACTION_SOUND_CHANNEL_COUNT) return PUZZLE_SOUND_ERR_DESCRIPTOR;
    if (sound->backend.play_sound == NULL) return PUZZLE_SOUND_ERR_UNSUPPORTED;
    if (sound->prepared[channel] == 0) return PUZZLE_SOUND_NO_RESOURCE;
    return backend_status(sound->backend.play_sound(sound->backend.context, channel));
}

int puzzle_sound_busy(PuzzleSound *sound, uint16_t channel, int *still_playing)
{
    int playing = 0;
    int status;
    if (sound == NULL || still_playing == NULL) return PUZZLE_SOUND_ERR_ARGUMENT;
    if (channel >= ACTION_SOUND_CHANNEL_COUNT) return PUZZLE_SOUND_ERR_DESCRIPTOR;
    if (sound->backend.is_playing == NULL) return PUZZLE_SOUND_ERR_UNSUPPORTED;
    if (sound->prepared[channel] == 0) {
        *still_playing = 0;
        return PUZZLE_SOUND_OK;
    }
    status = backend_status(sound->backend.is_playing(sound->backend.context, channel, &playing));
    if (status != PUZZLE_SOUND_OK) return status;
    if (playing != 0 && playing != 1) return PUZZLE_SOUND_ERR_BACKEND;
    *still_playing = playing;
    return PUZZLE_SOUND_OK;
}
