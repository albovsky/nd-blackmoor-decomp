#ifndef BINK_ADAPTER_H
#define BINK_ADAPTER_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum bink_adapter_status {
    BINK_ADAPTER_OK = 0,
    BINK_ADAPTER_ERR_ARGUMENT = 1,
    BINK_ADAPTER_ERR_FILE = 2,
    BINK_ADAPTER_ERR_FORMAT = 3,
    BINK_ADAPTER_ERR_DECODE = 4,
    BINK_ADAPTER_ERR_MEMORY = 5,
    BINK_ADAPTER_ERR_BOUNDS = 6
} bink_adapter_status;

/* Host-side RGBA frame. The adapter owns rgba after success. */
typedef struct BinkFrame {
    uint32_t width;
    uint32_t height;
    uint32_t stride;
    uint8_t *rgba;
} BinkFrame;

/* Start with this zeroed value; destroy a prior frame before reusing it. */
#define BINK_FRAME_INIT { 0u, 0u, 0u, NULL }

/* Decode exactly the first video frame from a local Bink video file.
 * This is a native FFmpeg host adapter, not the game's original Bink DLL. */
int bink_adapter_decode_first_frame(const char *path,
                                    BinkFrame *frame,
                                    char *error,
                                    size_t error_capacity);
void bink_adapter_destroy(BinkFrame *frame);
const char *bink_adapter_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
