/* RT-13 ASan/UBSan driver for session_a79_begin_scene's malformed-row rejection
 * (the path the scene parser makes unreachable through a real SceneResource).
 * Every body is an exact-size heap copy (see the scene double). Exit 0 means
 * every case behaved: a rejected scene returns BOUNDS and leaves the previous
 * rows untouched, an accepted one replaces them. */
#include "session_bindings_a79.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void stub_scene_reset(void);
int stub_scene_add(uint8_t type, const uint8_t *body, size_t length, int unreadable);

int main(void)
{
    int16_t held = -1, count = 0;
    uint16_t items[8] = {0};
    int32_t presence[8] = {0};
    SessionA79Host host;
    SessionA79Binding *binding;
    uint8_t body[40];
    size_t length, tail, row;
    unsigned long accepted = 0u, rejected = 0u, unreadable = 0u;

    memset(&host, 0, sizeof(host));
    host.model.held_item = &held;
    host.model.item_count = &count;
    host.model.items = items;
    host.model.item_capacity = 8u;
    host.model.presence = presence;
    host.model.presence_capacity = 8u;
    binding = session_a79_create(&host);
    assert(binding != NULL);
    memset(body, 0xa7, sizeof(body));
    for (row = 0u; row < 3u; ++row) {
        for (length = 0u; length <= sizeof(body); ++length) {
            int status;
            const int expect_ok = length >= 2u && (length - 2u) % 16u == 0u;
            /* Seed the binding with one known good row. */
            stub_scene_reset();
            body[0] = 4u;
            body[1] = 0u;
            assert(stub_scene_add(0x79u, body, 2u, 0) == 0);
            assert(session_a79_begin_scene(binding, (const SceneResource *)binding) == ACTION79_OK);
            assert(session_a79_item_word(binding, 0u) == 4);
            stub_scene_reset();
            for (tail = 0u; tail < row; ++tail) {
                assert(stub_scene_add(0x79u, body, 2u, 0) >= 0);
            }
            assert(stub_scene_add(0x79u, body, length, 0) >= 0);
            status = session_a79_begin_scene(binding, (const SceneResource *)binding);
            if (expect_ok) {
                assert(status == ACTION79_OK);
                ++accepted;
                assert(session_a79_item_word(binding, row) == 4);
            } else {
                assert(status == ACTION79_ERR_BOUNDS);
                ++rejected;
                assert(session_a79_item_word(binding, 0u) == 4);
                assert(session_a79_item_word(binding, 1u) == -1);
            }
        }
        /* An unreadable row after `row` good rows. */
        stub_scene_reset();
        body[0] = 4u;
        assert(stub_scene_add(0x79u, body, 2u, 0) == 0);
        assert(session_a79_begin_scene(binding, (const SceneResource *)binding) == ACTION79_OK);
        stub_scene_reset();
        for (tail = 0u; tail < row; ++tail) {
            assert(stub_scene_add(0x79u, body, 2u, 0) >= 0);
        }
        assert(stub_scene_add(0x79u, body, 2u, 1) >= 0);
        assert(session_a79_begin_scene(binding, (const SceneResource *)binding) == ACTION79_ERR_BOUNDS);
        assert(session_a79_item_word(binding, 0u) == 4 && session_a79_item_word(binding, 1u) == -1);
        ++unreadable;
    }
    stub_scene_reset();
    session_a79_destroy(binding);
    assert(accepted > 0u && rejected > 0u && unreadable == 3u);
    printf("stub_begin_accepted=%lu stub_begin_rejected=%lu stub_begin_unreadable=%lu\n",
           accepted, rejected, unreadable);
    return 0;
}
