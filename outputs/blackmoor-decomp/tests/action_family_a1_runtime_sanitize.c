/* RT-21 ASan/UBSan driver: bounded malformed inputs for the raw 0xa1 object constructor, the
 * shared sound visit (event store) and the session binding. Every input is an exact-size heap
 * allocation, so any out-of-bounds read or write is reported. Exit 0 means every loop completed
 * and every rejection left the event table, the output object and the providers untouched. */
#include "session_bindings_aa1.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t lcg(uint32_t *state)
{
    *state = *state * 1664525u + 1013904223u;
    return *state >> 8;
}

/* ---- host stubs ------------------------------------------------------------------------- */
typedef struct {
    int caption, load, play, query, unload, transition, events, stored;
    int caption_status, load_status, play_status, query_status, unload_status, playing;
    int config_status, transition_status, events_status;
    A97EventTable table;
} Probe;

static ActionSoundBackendStatus on_caption(void *c, const ActionSoundCaptionRequest *r)
{
    Probe *p = (Probe *)c;
    assert(r != NULL && r->terminator_length == 0u);
    if (r->length != 0u) assert(r->bytes != NULL);
    ++p->caption;
    return (ActionSoundBackendStatus)p->caption_status;
}

static ActionSoundBackendStatus on_load(void *c, const ActionSoundAudioCommand *cmd)
{
    Probe *p = (Probe *)c;
    assert(cmd != NULL && cmd->channel < ACTION_SOUND_CHANNEL_COUNT);
    assert(memchr(cmd->asset_stem, 0, sizeof(cmd->asset_stem)) != NULL);
    ++p->load;
    return (ActionSoundBackendStatus)p->load_status;
}

static ActionSoundBackendStatus on_play(void *c, uint16_t channel)
{
    Probe *p = (Probe *)c;
    assert(channel < ACTION_SOUND_CHANNEL_COUNT);
    ++p->play;
    return (ActionSoundBackendStatus)p->play_status;
}

static ActionSoundBackendStatus on_query(void *c, uint16_t channel, int *playing)
{
    Probe *p = (Probe *)c;
    assert(channel < ACTION_SOUND_CHANNEL_COUNT && playing != NULL);
    ++p->query;
    *playing = p->playing;
    return (ActionSoundBackendStatus)p->query_status;
}

static ActionSoundBackendStatus on_unload(void *c, uint16_t channel)
{
    Probe *p = (Probe *)c;
    assert(channel < ACTION_SOUND_CHANNEL_COUNT);
    ++p->unload;
    return (ActionSoundBackendStatus)p->unload_status;
}

static int on_config(void *c, uint8_t *enabled)
{
    Probe *p = (Probe *)c;
    *enabled = 1u;
    return p->config_status;
}

static int on_transition(void *c, const ActionSoundTransition *t)
{
    Probe *p = (Probe *)c;
    assert(t != NULL && t->engine_state_value == 4u);
    ++p->transition;
    return p->transition_status;
}

static int on_events(void *c, A97EventTable *out)
{
    Probe *p = (Probe *)c;
    ++p->events;
    if (p->events_status == 0) *out = p->table;
    return p->events_status;
}

static void on_stored(void *c, size_t row, int16_t id, int32_t value, int32_t previous)
{
    Probe *p = (Probe *)c;
    (void)row;
    (void)previous;
    assert(id >= 0 && (size_t)id < p->table.count && p->table.flags[id] == value);
    ++p->stored;
}

static void fill_backend(ActionSoundBackend *b, Probe *p, uint32_t *seed)
{
    memset(b, 0, sizeof(*b));
    b->context = p;
    b->present_caption = lcg(seed) % 11u == 0u ? NULL : on_caption;
    b->load_sound = lcg(seed) % 13u == 0u ? NULL : on_load;
    b->play_sound = lcg(seed) % 13u == 0u ? NULL : on_play;
    b->is_playing = lcg(seed) % 11u == 0u ? NULL : on_query;
    b->unload_sound = lcg(seed) % 11u == 0u ? NULL : on_unload;
}

static void random_statuses(Probe *p, uint32_t *seed)
{
    p->caption_status = lcg(seed) % 9u == 0u ? 1 + (int)(lcg(seed) % 3u) : 0;
    p->load_status = lcg(seed) % 9u == 0u ? 1 + (int)(lcg(seed) % 3u) : 0;
    p->play_status = lcg(seed) % 9u == 0u ? 1 + (int)(lcg(seed) % 3u) : 0;
    p->query_status = lcg(seed) % 9u == 0u ? 1 + (int)(lcg(seed) % 3u) : 0;
    p->unload_status = lcg(seed) % 9u == 0u ? 1 + (int)(lcg(seed) % 3u) : 0;
    p->playing = (int)(lcg(seed) % 4u) == 0 ? 2 : (int)(lcg(seed) % 2u);
}

/* ---- AUTOTEXT stub ---------------------------------------------------------------------- */
static uint8_t g_text[40000];
static size_t g_text_length;
static int g_lookup_mode;

static ActionFamily97LookupStatus on_lookup(void *c, const uint8_t *key, size_t length,
                                            const uint8_t **text, size_t *text_length)
{
    (void)c;
    assert(key != NULL && length <= 32u);
    if (memchr(key, 0, length) != NULL) assert(0);
    switch (g_lookup_mode) {
    case 0: *text = g_text; *text_length = g_text_length; return ACTION_FAMILY_97_LOOKUP_FOUND;
    case 1: return ACTION_FAMILY_97_LOOKUP_MISSING;
    case 2: return ACTION_FAMILY_97_LOOKUP_FAILED;
    case 3: *text = NULL; *text_length = 0u; return ACTION_FAMILY_97_LOOKUP_FOUND;
    default: *text = NULL; *text_length = 5u; return ACTION_FAMILY_97_LOOKUP_FOUND;
    }
}

/* ---- construct sweep --------------------------------------------------------------------- */
typedef struct {
    uint64_t constructed, rejected, lookup_failed, missing;
} ConstructStats;

static void body_fill(uint8_t *b, size_t n, int16_t selector, uint32_t *seed)
{
    size_t i;
    for (i = 0; i < n; ++i) b[i] = (uint8_t)lcg(seed);
    if (n >= 0x33u) {
        b[0x31] = (uint8_t)selector;
        b[0x32] = (uint8_t)((uint16_t)selector >> 8);
        b[0x21] = (uint8_t)(lcg(seed) % 40u);
        b[0x22] = 0u;
        if (lcg(seed) % 4u != 0u) b[lcg(seed) % 33u] = 0u;
        if (n >= 84u) b[51u + lcg(seed) % 33u] = 0u;
        if (n >= 0x2f) { b[0x2c] = 0x0f; b[0x2d] = 0x27; }
    }
}

static ConstructStats construct_sweep(void)
{
    static const int16_t selectors[] = {-1, 0, 1, 2, 7, 40, 9999, 10000, -2, -300, 32767, -32768};
    ConstructStats stats;
    uint32_t seed = 1234u;
    size_t length, s;
    int iteration;
    memset(&stats, 0, sizeof(stats));
    for (iteration = 0; iteration < 6; ++iteration) {
        for (length = 0; length <= 140u; ++length) {
            for (s = 0; s < sizeof(selectors) / sizeof(selectors[0]); ++s) {
                /* Odd iterations size the body exactly as the selector requires (84 or 51 + n)
                 * so a good share of the inputs reaches the lookup and the object builder. */
                const size_t typed = selectors[s] == -1 ? 84u
                    : (selectors[s] >= 0 && selectors[s] <= 9999 ? 51u + (size_t)selectors[s] : 0u);
                const size_t n = (iteration & 1) != 0 && typed != 0u ? typed : length;
                uint8_t *body = (uint8_t *)malloc(n != 0u ? n : 1u);
                ActionA1Object *out = (ActionA1Object *)malloc(sizeof(*out));
                ActionA1Object before;
                int status;
                assert(body != NULL && out != NULL);
                body_fill(body, n, selectors[s], &seed);
                memset(out, 0xa5, sizeof(*out));
                memcpy(&before, out, sizeof(before));
                g_lookup_mode = (int)(lcg(&seed) % 5u);
                g_text_length = lcg(&seed) % 4u == 0u ? 32591u + lcg(&seed) % 3u : lcg(&seed) % 70u;
                memset(g_text, 'x', sizeof(g_text));
                if (lcg(&seed) % 6u == 0u && g_text_length > 3u) g_text[2] = 0;
                status = action_a1_runtime_construct(body, n,
                                                     lcg(&seed) % 23u == 0u ? NULL : on_lookup,
                                                     NULL, out);
                if (status == ACTION_A1_RT_OK) {
                    ++stats.constructed;
                    assert(out->length >= 175u && out->length <= ACTION_FAMILY_A1_MAX_OBJECT_BYTES);
                    assert(memchr(out->bytes, 0, 33u) != NULL);
                    stats.missing += out->key_missing;
                } else {
                    ++stats.rejected;
                    assert(memcmp(out, &before, sizeof(before)) == 0);
                    if (status == ACTION_A1_RT_ERR_LOOKUP) ++stats.lookup_failed;
                }
                free(body);
                free(out);
            }
        }
    }
    assert(action_a1_runtime_construct(NULL, 84u, on_lookup, NULL, NULL) == ACTION_A1_RT_ERR_ARGUMENT);
    return stats;
}

/* ---- step sweep -------------------------------------------------------------------------- */
typedef struct {
    uint64_t visits, ok, rejected, stores, unsupported, backend_error;
} StepStats;

static size_t table_sizes[] = {0u, 1u, 3u, 16u, 2300u};

static StepStats step_sweep(void)
{
    StepStats stats;
    uint32_t seed = 4321u;
    int iteration;
    memset(&stats, 0, sizeof(stats));
    for (iteration = 0; iteration < 12000; ++iteration) {
        uint8_t raw[84];
        ActionA1Object *object = (ActionA1Object *)malloc(sizeof(*object));
        size_t shrink = lcg(&seed) % 6u == 0u ? lcg(&seed) % 200u : 0u;
        size_t length;
        uint8_t *payload;
        size_t table_size = table_sizes[lcg(&seed) % (sizeof(table_sizes) / sizeof(table_sizes[0]))];
        int32_t *flags = (int32_t *)malloc((table_size != 0u ? table_size : 1u) * sizeof(int32_t));
        int32_t *before = (int32_t *)malloc((table_size != 0u ? table_size : 1u) * sizeof(int32_t));
        Probe probe;
        ActionSoundBackend backend;
        A97Input in;
        ActionSoundObjectResult result;
        const char *why = NULL;
        size_t i;
        int status, use_table;
        assert(object != NULL && flags != NULL && before != NULL);
        body_fill(raw, sizeof(raw), -1, &seed);
        raw[0x2e] = (uint8_t)(lcg(&seed) % 5u == 0u ? 0xff : lcg(&seed));
        raw[0x2f] = (uint8_t)(lcg(&seed) % 5u == 0u ? 0xff : lcg(&seed) % 10u);
        raw[0x30] = (uint8_t)lcg(&seed);
        g_lookup_mode = 0;
        memset(g_text, 'x', sizeof(g_text));
        g_text_length = lcg(&seed) % 40u;
        if (action_a1_runtime_construct(raw, sizeof(raw), on_lookup, NULL, object) != ACTION_A1_RT_OK) {
            free(object); free(flags); free(before);
            continue;
        }
        length = object->length;
        if (shrink != 0u) length = shrink < length ? length - shrink : 0u;
        payload = (uint8_t *)malloc(length != 0u ? length : 1u);
        assert(payload != NULL);
        memcpy(payload, object->bytes, length);
        if (lcg(&seed) % 7u == 0u && length > 0xb0u) payload[0xaa] ^= (uint8_t)lcg(&seed);
        if (lcg(&seed) % 9u == 0u && length > 0x25u) payload[0x21] = (uint8_t)(lcg(&seed) % 40u);
        for (i = 0; i < table_size; ++i) flags[i] = (int32_t)lcg(&seed);
        memcpy(before, flags, (table_size != 0u ? table_size : 1u) * sizeof(int32_t));
        memset(&probe, 0, sizeof(probe));
        probe.table.flags = table_size != 0u || lcg(&seed) % 2u ? flags : NULL;
        probe.table.count = table_size;
        random_statuses(&probe, &seed);
        fill_backend(&backend, &probe, &seed);
        memset(&in, 0, sizeof(in));
        in.phase = lcg(&seed) % 5u;
        in.subtype = (uint8_t)(lcg(&seed) % 4u);
        in.completed = (uint8_t)(lcg(&seed) % 2u);
        in.captions = (uint8_t)(lcg(&seed) % 2u);
        use_table = lcg(&seed) % 6u != 0u;
        status = action_sound_object_step(payload, length, &in, lcg(&seed) % 31u == 0u ? NULL : &backend,
                                          use_table ? &probe.table : NULL, &result, &why);
        ++stats.visits;
        assert(why != NULL);
        assert(status == ACTION_SOUND_OK || status == ACTION_SOUND_ERR_ARGUMENT ||
               status == ACTION_SOUND_ERR_BODY || status == ACTION_SOUND_ERR_UNSUPPORTED ||
               status == ACTION_SOUND_ERR_BACKEND);
        if (result.event_stored != 0u) {
            ++stats.stores;
            assert(result.event_id >= 0 && (size_t)result.event_id < table_size);
            assert(flags[result.event_id] == result.event_value);
            assert(result.event_previous == before[result.event_id]);
            for (i = 0; i < table_size; ++i) {
                if (i != (size_t)result.event_id) assert(flags[i] == before[i]);
            }
        } else {
            assert(memcmp(flags, before, table_size * sizeof(int32_t)) == 0);
        }
        if (status == ACTION_SOUND_OK) {
            ++stats.ok;
        } else if (status == ACTION_SOUND_ERR_UNSUPPORTED) {
            ++stats.unsupported;
            ++stats.rejected;
        } else if (status == ACTION_SOUND_ERR_BACKEND) {
            ++stats.backend_error;
        } else {
            ++stats.rejected;
            assert(probe.caption + probe.load + probe.play + probe.query + probe.unload == 0);
        }
        /* A rejection before the provider calls never touches the table. */
        if (status == ACTION_SOUND_ERR_BODY || status == ACTION_SOUND_ERR_ARGUMENT) {
            assert(result.event_stored == 0u);
        }
        free(object); free(payload); free(flags); free(before);
    }
    return stats;
}

/* ---- binding sweep ----------------------------------------------------------------------- */
static void put_be32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v >> 24); p[1] = (uint8_t)(v >> 16); p[2] = (uint8_t)(v >> 8); p[3] = (uint8_t)v;
}

static uint8_t *build_scene(const uint8_t *bodies[], const size_t lengths[], size_t rows,
                            size_t *out_length)
{
    size_t capacity = 8u + 4u + 8u + 126u + rows * (8u + 50u + 40u), used = 0, i;
    size_t extra = 0;
    uint8_t *data;
    uint8_t tsum[126] = {0};
    for (i = 0; i < rows; ++i) extra += lengths[i] + 1u;
    data = (uint8_t *)calloc(capacity + extra, 1u);
    assert(data != NULL);
    memcpy(data, "DATA", 4); memcpy(data + 8, "SCEN", 4); used = 12u;
    memcpy(tsum, "Session", 7); memcpy(tsum + 50, "background", 10); memcpy(tsum + 83, "sound", 5);
    memcpy(data + used, "TSUM", 4); put_be32(data + used + 4, 126u);
    memcpy(data + used + 8, tsum, 126u); used += 8u + 126u;
    for (i = 0; i < rows; ++i) {
        uint8_t *chunk = data + used;
        size_t payload = 50u + lengths[i];
        memcpy(chunk, "ACT\0", 4); put_be32(chunk + 4, (uint32_t)payload);
        memcpy(chunk + 8, "sanitize", 8);
        chunk[8 + 48] = 0xa1; chunk[8 + 49] = (uint8_t)(1u + i % 2u);
        memcpy(chunk + 8 + 50, bodies[i], lengths[i]);
        used += 8u + payload + (payload & 1u);
    }
    put_be32(data + 4, (uint32_t)(used - 8u));
    *out_length = used;
    return data;
}

typedef struct {
    uint64_t scenes_opened, scenes_rejected_by_parser, begin_ok, begin_rejected, handler_calls,
        handler_ok, handler_error, handler_unsupported, events_stored;
} BindingStats;

static BindingStats binding_sweep(void)
{
    BindingStats stats;
    uint8_t key_form[84], inline_form[51 + 4], empty_form[51];
    uint32_t seed = 99u;
    size_t variant, row;
    memset(&stats, 0, sizeof(stats));
    memset(key_form, 0, sizeof(key_form)); memset(inline_form, 0, sizeof(inline_form));
    memset(empty_form, 0, sizeof(empty_form));
    memcpy(key_form, "NSHT14", 7); key_form[0x21] = 13; key_form[0x23] = 1; key_form[0x2c] = 0x0f;
    key_form[0x2d] = 0x27; key_form[0x2e] = 0xe8; key_form[0x2f] = 0x03; key_form[0x30] = 1;
    key_form[0x31] = 0xff; key_form[0x32] = 0xff; memcpy(key_form + 51, "NSHT14", 7);
    memcpy(inline_form, key_form, 51); inline_form[0x31] = 4; inline_form[0x32] = 0;
    memcpy(inline_form + 51, "abcd", 4); inline_form[0x2e] = 0xff; inline_form[0x2f] = 0xff;
    memcpy(empty_form, key_form, 51); empty_form[0x31] = 0; empty_form[0x32] = 0;
    for (variant = 0; variant < 3; ++variant) {
        const uint8_t *bodies[4] = {key_form, inline_form, empty_form, key_form};
        size_t lengths[4] = {84, 55, 51, 84};
        uint8_t *data;
        size_t length, offset, limit;
        data = build_scene(bodies, lengths, 4, &length);
        limit = variant == 0 ? 1u : length;
        for (offset = 0; offset < limit; ++offset) {
            size_t scene_length = variant == 2 ? length - offset : length;
            uint8_t *copy = (uint8_t *)malloc(scene_length);
            SceneResource *scene;
            char error[128];
            int mode;
            assert(copy != NULL);
            memcpy(copy, data, scene_length);
            if (variant == 1) copy[offset] ^= 0x5au;
            scene = scene_resource_open_memory(copy, scene_length, error, sizeof(error));
            if (scene == NULL) {
                ++stats.scenes_rejected_by_parser;
            } else {
                for (mode = 0; mode < 4; ++mode) {
                    int32_t flags[2300];
                    Probe probe;
                    SessionAa1Host host;
                    SessionAa1Binding *binding;
                    size_t phase;
                    int status;
                    memset(&probe, 0, sizeof(probe));
                    memset(flags, 0, sizeof(flags));
                    probe.table.flags = flags;
                    probe.table.count = mode == 3 ? 3u : 2300u;
                    probe.events_status = mode == 2 ? 1 : 0;
                    probe.config_status = mode == 1 ? 1 : 0;
                    probe.playing = (int)(lcg(&seed) % 2u);
                    memset(&host, 0, sizeof(host));
                    host.sound.context = &probe;
                    host.sound.present_caption = on_caption;
                    host.sound.load_sound = on_load;
                    host.sound.play_sound = on_play;
                    host.sound.is_playing = on_query;
                    host.sound.unload_sound = on_unload;
                    host.lookup = mode == 1 ? NULL : on_lookup;
                    host.captions_enabled = on_config;
                    host.transition = mode == 3 ? NULL : on_transition;
                    host.load_events = on_events;
                    host.event_stored = on_stored;
                    g_lookup_mode = mode == 2 ? 1 : 0;
                    g_text_length = 11u;
                    memset(g_text, 'y', sizeof(g_text));
                    binding = session_aa1_create(&host);
                    assert(binding != NULL);
                    status = session_aa1_begin_scene(binding, scene);
                    ++stats.scenes_opened;
                    if (status == ACTION_SOUND_OK) ++stats.begin_ok; else ++stats.begin_rejected;
                    for (phase = 0; phase < 3; ++phase) {
                        for (row = 0; row < scene_resource_action_count(scene) + 2u; ++row) {
                            SceneActionInfo info;
                            SceneActionRuntimeState before;
                            SceneActionHandlerResult out = {0, 0u};
                            SessionAa1Row info_row;
                            int handled;
                            memset(&info, 0, sizeof(info));
                            before.completed = 0u;
                            before.phase = (uint32_t)phase;
                            if (row < scene_resource_action_count(scene)) {
                                (void)scene_resource_action_at(scene, row, &info);
                            }
                            handled = session_aa1_handler(binding, row, &info, &before, &out);
                            assert(handled == SCENE_ACTION_HANDLER_OK ||
                                   handled == SCENE_ACTION_HANDLER_ERROR ||
                                   handled == SCENE_ACTION_HANDLER_UNSUPPORTED);
                            ++stats.handler_calls;
                            if (handled == SCENE_ACTION_HANDLER_OK) ++stats.handler_ok;
                            else if (handled == SCENE_ACTION_HANDLER_ERROR) ++stats.handler_error;
                            else ++stats.handler_unsupported;
                            if (handled != SCENE_ACTION_HANDLER_OK) {
                                assert(out.disposition == 0 && out.phase == 0u);
                            }
                            (void)session_aa1_row(binding, row, &info_row);
                        }
                    }
                    assert(session_aa1_failure(binding) != NULL);
                    stats.events_stored += (uint64_t)probe.stored;
                    session_aa1_destroy(binding);
                }
                scene_resource_close(scene);
            }
            free(copy);
            if (variant == 1 && offset > 700u) break;
        }
        free(data);
    }
    assert(session_aa1_create(NULL) == NULL);
    assert(session_aa1_begin_scene(NULL, NULL) != ACTION_SOUND_OK);
    assert(session_aa1_row(NULL, 0, NULL) == 0);
    assert(strcmp(session_aa1_failure(NULL), "invalid binding") == 0);
    session_aa1_destroy(NULL);
    return stats;
}

int main(void)
{
    ConstructStats c = construct_sweep();
    StepStats s = step_sweep();
    BindingStats b = binding_sweep();
    printf("construct_ok=%llu construct_rejected=%llu construct_lookup_failed=%llu construct_missing=%llu "
           "step_visits=%llu step_ok=%llu step_rejected=%llu step_unsupported=%llu step_backend_error=%llu "
           "step_event_stores=%llu binding_scenes_opened=%llu scenes_rejected_by_parser=%llu begin_ok=%llu "
           "begin_rejected=%llu handler_calls=%llu handler_ok=%llu handler_error=%llu "
           "handler_unsupported=%llu binding_event_stores=%llu\n",
           (unsigned long long)c.constructed, (unsigned long long)c.rejected,
           (unsigned long long)c.lookup_failed, (unsigned long long)c.missing,
           (unsigned long long)s.visits, (unsigned long long)s.ok, (unsigned long long)s.rejected,
           (unsigned long long)s.unsupported, (unsigned long long)s.backend_error,
           (unsigned long long)s.stores, (unsigned long long)b.scenes_opened,
           (unsigned long long)b.scenes_rejected_by_parser, (unsigned long long)b.begin_ok,
           (unsigned long long)b.begin_rejected, (unsigned long long)b.handler_calls,
           (unsigned long long)b.handler_ok, (unsigned long long)b.handler_error,
           (unsigned long long)b.handler_unsupported, (unsigned long long)b.events_stored);
    fflush(stdout);
    assert(c.constructed > 0 && c.rejected > 0 && c.lookup_failed > 0 && c.missing > 0);
    assert(s.ok > 0 && s.rejected > 0 && s.stores > 0 && s.unsupported > 0);
    assert(b.scenes_opened > 0 && b.begin_ok > 0 && b.handler_ok > 0 && b.handler_error > 0 &&
           b.handler_unsupported > 0 && b.events_stored > 0 && b.scenes_rejected_by_parser > 0);
    return 0;
}
