#include "native_secondary_video.h"
#include "avf_decoder.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHECK(x) do { if (!(x)) { fprintf(stderr, "line %d: %s\n", __LINE__, #x); return 1; } } while (0)

static int operation(NativeSecondaryVideo *m, A33State *s, int op, int32_t a, int32_t b, int32_t *ret)
{
    A33OpArgs args = {a, b};
    return native_secondary_video_op(m, s, op, &args, ret);
}

static uint64_t pixel_hash(const uint8_t *pixels, size_t bytes)
{
    uint64_t h = UINT64_C(1469598103934665603);
    for (size_t i = 0; i < bytes; ++i) h = (h ^ pixels[i]) * UINT64_C(1099511628211);
    return h;
}

/* Drive frame/page requests as a consumer would. The adapter only fills the
 * requested hidden slot; this fixture does not supply a second controller. */
static int decode_complete_clip(NativeSecondaryVideo *m, A33State *state,
    const A33Set *set, int frames, int width, int height)
{
    int32_t ret = 0;
    int ran = -1;
    uint32_t old_buffer = state->buf_5b4db8;
    NativeSecondaryVideoFrame visible = {0};
    CHECK(native_secondary_video_validate_set(m, set) == 0);
    state->active_5c39f1 = 1; state->row_5b4e89 = 6;
    state->kind_5b4e8b = 1; state->present_5b4e04 = 2;
    state->page_5b4dc8 = 0; state->frame_5b4e00 = 0;
    strcpy(state->clip_5b4d8f, set->clip);
    CHECK(operation(m, state, A33_OP_STREAM_RESET, 0, 0, &ret) == 0);
    CHECK(native_secondary_video_load_world(m, state) == 0);
    CHECK(state->buf_5b4db8 != old_buffer && state->buf_5b4db8 != 0);
    CHECK(state->ready_5b4e0a == 0 && state->delay_5b4c5a == 66);
    CHECK(state->vrect_5b4df0 == width - 1 && state->vrect_5b4df4 == height - 1);
    CHECK(operation(m, state, A33_OP_SURFACE_CREATE, width, height, &ret) == 0);
    state->surface_5d03bf = (uint32_t)ret;
    CHECK(operation(m, state, A33_OP_THREAD_CREATE, 0, 0, &ret) == 0);
    state->thread_5b4e0c = (uint32_t)ret;
    CHECK(native_secondary_video_reader_pass(m, state, &ran) == 0 && ran == 0);
    CHECK(operation(m, state, A33_OP_THREAD_RESUME, (int32_t)state->thread_5b4e0c, 0, &ret) == 0);
    for (int i = 0; i < frames; ++i) {
        state->frame_5b4e00 = (int16_t)i;
        state->ready_5b4e0a = 0;
        CHECK(native_secondary_video_store_world(m, state) == 0);
        CHECK(native_secondary_video_reader_pass(m, state, &ran) == 0 && ran == 1);
        CHECK(native_secondary_video_load_world(m, state) == 0 && state->ready_5b4e0a == 1);
        CHECK(state->frame_5b4e00 == i); /* only the consumer may choose a frame */
        uint32_t hidden = state->page_5b4dc8 == 0 ? state->buf_5b4dbc : state->buf_5b4db8;
        CHECK(operation(m, state, A33_OP_SURFACE_PIXELS, (int32_t)state->surface_5d03bf,
                        (int32_t)hidden, &ret) == 0);
        CHECK(native_secondary_video_frame(m, state->surface_5d03bf, &visible) == 0);
        CHECK(visible.frame_index == i && visible.width == (uint32_t)width && visible.height == (uint32_t)height);
        CHECK(visible.pitch == (uint32_t)width * 2 && visible.bytes == (size_t)width * (size_t)height * 2);
        state->page_5b4dc8 = state->page_5b4dc8 == 0 ? 1 : 0;
    }
    /* The original next-init order retires buffers before releasing surfaces.
     * A live surface must keep its last borrowed frame throughout that order. */
    uint64_t last_hash = pixel_hash(visible.pixels, visible.bytes);
    CHECK(operation(m, state, A33_OP_THREAD_STOP, (int32_t)state->thread_5b4e0c, 0, &ret) == 0);
    CHECK(native_secondary_video_reader_pass(m, state, &ran) == 0 && ran == 0);
    CHECK(operation(m, state, A33_OP_THREAD_DELETE, (int32_t)state->thread_5b4e0c, 0, &ret) == 0);
    CHECK(operation(m, state, A33_OP_FREE, (int32_t)state->buf_5b4db8, 0, &ret) == 0);
    CHECK(operation(m, state, A33_OP_FREE, (int32_t)state->buf_5b4dbc, 0, &ret) == 0);
    CHECK(native_secondary_video_frame(m, state->surface_5d03bf, &visible) == 0);
    CHECK(pixel_hash(visible.pixels, visible.bytes) == last_hash);
    CHECK(native_secondary_video_load_world(m, state) == 0);
    CHECK(state->buf_5b4db8 == 0 && state->buf_5b4dbc == 0);
    uint32_t surface = state->surface_5d03bf;
    CHECK(operation(m, state, A33_OP_SURFACE_RELEASE, (int32_t)surface, 0, &ret) == 0);
    CHECK(native_secondary_video_frame(m, surface, &visible) != 0);
    state->surface_5d03bf = 0; state->thread_5b4e0c = 0;
    printf("SECONDARY_VIDEO %s: %d frames decoded, %dx%d RGB555, 66ms, final_fnv64=%016llx\n",
        set->clip, frames, width, height, (unsigned long long)last_hash);
    return 0;
}

int main(int argc, char **argv)
{
    NativeSecondaryVideo *m = NULL;
    A33Set set = {0};
    A33State state = {0};
    NativeSecondaryVideoFrame visible = {0}, next = {0};
    int32_t ret = 0;
    int ran = -1;
    CHECK(argc == 2);
    CHECK(native_secondary_video_create(argv[1], &m) == 0);
    strcpy(set.clip, "JAN_fidget");
    set.kind_46 = 1; set.w44 = 2; set.anim_48 = 1; set.w4a = 2;
    set.w4c = 0; set.w4e = 45; set.w50 = 46; set.w52 = 69; set.w54 = 0; set.w56 = 69;
    CHECK(native_secondary_video_validate_set(m, &set) == 0);
    state.active_5c39f1 = 1; state.row_5b4e89 = 6;
    state.kind_5b4e8b = 1; state.present_5b4e04 = 2;
    strcpy(state.clip_5b4d8f, set.clip);
    CHECK(operation(m, &state, A33_OP_STREAM_RESET, 0, 0, &ret) == 0);
    CHECK(native_secondary_video_load_world(m, &state) == 0);
    CHECK(state.delay_5b4c5a == 66 && state.vrect_5b4df0 == 104 && state.vrect_5b4df4 == 108);
    CHECK(state.ready_5b4e0a == 0 && state.buf_5b4db8 != 0 && state.buf_5b4dbc != 0);
    CHECK(state.buf_5b4db8 != state.buf_5b4dbc);
    CHECK(operation(m, &state, A33_OP_SURFACE_CREATE, 105, 109, &ret) == 0);
    state.surface_5d03bf = (uint32_t)ret;
    CHECK(operation(m, &state, A33_OP_THREAD_CREATE, 0, 0, &ret) == 0);
    state.thread_5b4e0c = (uint32_t)ret;
    CHECK(operation(m, &state, A33_OP_THREAD_RESUME, ret, 0, &ret) == 0);
    CHECK(native_secondary_video_frame(m, state.surface_5d03bf, &visible) != 0);
    CHECK(native_secondary_video_reader_pass(m, &state, &ran) == 0 && ran == 1);
    CHECK(native_secondary_video_load_world(m, &state) == 0 && state.ready_5b4e0a == 1);
    CHECK(native_secondary_video_reader_pass(m, &state, &ran) == 0 && ran == 0);
    CHECK(operation(m, &state, A33_OP_SURFACE_PIXELS, (int32_t)state.surface_5d03bf,
                    (int32_t)state.buf_5b4dbc, &ret) == 0);
    CHECK(native_secondary_video_frame(m, state.surface_5d03bf, &visible) == 0);
    CHECK(visible.width == 105 && visible.height == 109 && visible.pitch == 210 && visible.bytes == 22890);
    CHECK(visible.frame_index == 0 && visible.generation != 0);
    /* Independently expanded immutable JAN keyframes, not adapter-derived
     * expectations: this catches decoding the wrong frame or default pixels. */
    CHECK(pixel_hash(visible.pixels, visible.bytes) == UINT64_C(0xa1f8333e796b9594));
    A33Set other = set;
    strcpy(other.clip, "CON_fidget");
    other.w4e = 52; other.w50 = 53; other.w52 = other.w56 = 96;
    CHECK(native_secondary_video_validate_set(m, &other) == 0);
    strcpy(other.clip, "Nigel_Fidget"); /* same-name Bink exists; explicitly resolve AVF */
    other.w4e = 15; other.w50 = 16; other.w52 = other.w56 = 48;
    CHECK(native_secondary_video_validate_set(m, &other) == 0);
    other.kind_46 = 2;
    CHECK(native_secondary_video_validate_set(m, &other) != 0);
    other = set; other.w52 = 70;
    CHECK(native_secondary_video_validate_set(m, &other) != 0);
    CHECK(native_secondary_video_frame(m, state.surface_5d03bf, &next) == 0);
    CHECK(next.pixels == visible.pixels && next.generation == visible.generation);
    unsigned char *snapshot = malloc(visible.bytes);
    CHECK(snapshot != NULL);
    memcpy(snapshot, visible.pixels, visible.bytes);
    state.ready_5b4e0a = 0; state.page_5b4dc8 = 1; state.frame_5b4e00 = 1;
    CHECK(native_secondary_video_store_world(m, &state) == 0);
    CHECK(native_secondary_video_reader_pass(m, &state, &ran) == 0 && ran == 1);
    CHECK(memcmp(snapshot, visible.pixels, visible.bytes) == 0); /* decoding hidden slot never changes visible pixels */
    CHECK(native_secondary_video_load_world(m, &state) == 0);
    CHECK(operation(m, &state, A33_OP_SURFACE_PIXELS, (int32_t)state.surface_5d03bf,
                    (int32_t)state.buf_5b4db8, &ret) == 0);
    CHECK(native_secondary_video_frame(m, state.surface_5d03bf, &next) == 0);
    CHECK(next.frame_index == 1 && next.generation > visible.generation && next.pixels != visible.pixels);
    CHECK(memcmp(snapshot, next.pixels, next.bytes) != 0);
    CHECK(pixel_hash(next.pixels, next.bytes) == UINT64_C(0xddaebca13dfdbe02));
    /* Scene clear hides surface but must not pretend the reader/buffers were freed. */
    uint32_t old_surface = state.surface_5d03bf;
    CHECK(operation(m, &state, A33_OP_SURFACE_RELEASE, (int32_t)state.surface_5d03bf, 0, &ret) == 0);
    state.surface_5d03bf = 0; state.row_5b4e89 = -1; state.active_5c39f1 = 0;
    CHECK(native_secondary_video_store_world(m, &state) == 0);
    CHECK(native_secondary_video_reader_pass(m, &state, &ran) == 0 && ran == 0);
    CHECK(native_secondary_video_frame(m, old_surface, &next) != 0);
    CHECK(native_secondary_video_load_world(m, &state) == 0);
    CHECK(state.buf_5b4db8 != 0 && state.buf_5b4dbc != 0);
    CHECK(operation(m, &state, A33_OP_THREAD_STOP, (int32_t)state.thread_5b4e0c, 0, &ret) == 0);
    CHECK(operation(m, &state, A33_OP_THREAD_DELETE, (int32_t)state.thread_5b4e0c, 0, &ret) == 0);
    CHECK(operation(m, &state, A33_OP_FREE, (int32_t)state.buf_5b4db8, 0, &ret) == 0);
    CHECK(operation(m, &state, A33_OP_FREE, (int32_t)state.buf_5b4dbc, 0, &ret) == 0);
    CHECK(decode_complete_clip(m, &state, &set, 70, 105, 109) == 0);
    other = set; strcpy(other.clip, "CON_fidget");
    other.w4e = 52; other.w50 = 53; other.w52 = other.w56 = 96;
    CHECK(decode_complete_clip(m, &state, &other, 97, 108, 203) == 0);
    strcpy(other.clip, "Nigel_Fidget");
    other.w4e = 15; other.w50 = 16; other.w52 = other.w56 = 48;
    CHECK(decode_complete_clip(m, &state, &other, 49, 128, 203) == 0);
    free(snapshot);
    native_secondary_video_destroy(m);
    puts("SECONDARY_VIDEO all 3 actual AVFs: metadata, hidden-slot decode, readiness, suspended/stopped reader, surface publication and parked/retired lifetime passed");
    return 0;
}
