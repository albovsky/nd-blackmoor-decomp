#ifndef BLACKMOOR_AUTOTEXT_H
#define BLACKMOOR_AUTOTEXT_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define AUTOTEXT_KEY_BYTES 33u
#define AUTOTEXT_BUCKET_COUNT 1024u
#define AUTOTEXT_MAX_VALUE_BYTES 39999u

typedef struct AutoText AutoText;

typedef enum autotext_status {
    AUTOTEXT_OK = 0,
    AUTOTEXT_ERR_ARGUMENT = 1,
    AUTOTEXT_ERR_MEMORY = 2,
    AUTOTEXT_ERR_FORMAT = 3,
    AUTOTEXT_ERR_BOUNDS = 4,
    AUTOTEXT_ERR_UNSUPPORTED = 5,
    AUTOTEXT_ERR_NOT_FOUND = 6
} autotext_status;

/* Parse a complete decoded AUTOTEXT resource. The resource is a HIFF TEXT
 * DATA record containing a CVTX chunk. `original_nls_mode` corresponds to
 * the original global uppercase mode; only its ASCII mode (zero) is supported.
 * The parser owns an immutable copy of the source bytes until autotext_close.
 */
int autotext_open_memory(const void *resource,
                         size_t resource_length,
                         int original_nls_mode,
                         AutoText **output,
                         char *error,
                         size_t error_capacity);
void autotext_close(AutoText *autotext);

/* Keys are bounded byte strings without a trailing NUL. Returned value bytes
 * are borrowed from the immutable resource copy and remain valid until close.
 * `raw_value_length` is the CVTX record's declared byte length. The original
 * loaders copy these bytes into a zero-filled C-string buffer; consequently
 * `caption_length` stops at the first embedded NUL (or equals the raw length
 * when no NUL is present). Neither length implies UTF-8 decoding.
 */
int autotext_lookup(const AutoText *autotext,
                    const uint8_t *key,
                    size_t key_length,
                    const uint8_t **value,
                    size_t *raw_value_length,
                    size_t *caption_length);

size_t autotext_entry_count(const AutoText *autotext);
const char *autotext_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
