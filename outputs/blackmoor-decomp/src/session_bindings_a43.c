#include "session_bindings_a43.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_37.h"

struct SessionA43Binding {
    SessionA43Host host;
    SessionA36Binding *a36;
    AutotextOwner owner;
    AutotextGlobals globals;
    const char *failure;
    unsigned long rendered;
};

SessionA43Binding *session_a43_create(const SessionA43Host *host, SessionA36Binding *a36)
{
    SessionA43Binding *b;
    if (host == NULL || a36 == NULL) {
        return NULL;
    }
    b = (SessionA43Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->a36 = a36;
        b->failure = "none";
    }
    return b;
}

void session_a43_destroy(SessionA43Binding *b)
{
    size_t k;
    if (b == NULL) {
        return;
    }
    for (k = 0u; k < AUTOTEXT_SURFACE_SLOTS; ++k) {
        if (b->globals.slots[k].pixels != NULL && b->host.backend.free_surface != NULL) {
            b->host.backend.free_surface(b->host.backend.context, (int)k, &b->globals.slots[k]);
        }
    }
    free(b);
}

const char *session_a43_failure(const SessionA43Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

const CaptionSurface *session_a43_slot(const SessionA43Binding *b, size_t k)
{
    return b != NULL && k < AUTOTEXT_SURFACE_SLOTS ? &b->globals.slots[k] : NULL;
}

unsigned long session_a43_rendered(const SessionA43Binding *b)
{
    return b == NULL ? 0ul : b->rendered;
}

static uint16_t rd16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

/* The 0xABA image 0x411f24 builds: 0x48945b over the row's own rectangle, the
 * options and geometry copied from the object, the name USE_AUTOTEXT<n>. Shares
 * the defaults with the raw 0x37 constructor by presenting the same 69 bytes. */
static int build_overlay_image(const uint8_t *object, uint8_t image[ACTION_FAMILY_37_OBJECT_BYTES])
{
    uint8_t body[ACTION_FAMILY_37_BODY_BYTES];
    ActionFamily37Constructed constructed;
    const int number = (int)(int16_t)rd16(object + 2u) + 1;
    char name[33];
    memset(body, 0, sizeof(body));
    if (snprintf(name, sizeof(name), "USE_AUTOTEXT%d", number) <= 0) {
        return -1;
    }
    memcpy(body, name, strlen(name) + 1u);
    memcpy(body + 0x21u, object + 0u, 2u);    /* option word +0x23 of the image */
    memcpy(body + 0x23u, object + 0xe7u, 2u); /* option word +0x27 */
    memcpy(body + 0x25u, object + 0xe9u, 16u); /* rectangle handed to 0x48945b */
    memcpy(body + 0x35u, object + 0xf9u, 16u); /* geometry at image +0xac.. */
    if (action_family_37_construct(body, sizeof(body), 0u, 1u, &constructed) !=
        ACTION_FAMILY_37_OK) {
        return -1;
    }
    memcpy(image, constructed.object_bytes, ACTION_FAMILY_37_OBJECT_BYTES);
    return 0;
}

static int refuse(SessionA43Binding *b, const char *why)
{
    b->failure = why;
    return SCENE_ACTION_HANDLER_UNSUPPORTED;
}

int session_a43_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA43Binding *b = (SessionA43Binding *)context;
    ActionFamily43Decoded decoded;
    ActionFamily43Constructed constructed;
    SessionA43RenderInputs inputs;
    AutotextResult result;
    uint8_t *object = NULL;
    uint8_t image[ACTION_FAMILY_37_OBJECT_BYTES];
    const uint8_t *resolved = NULL;
    uint8_t *resolved_copy = NULL;
    size_t resolved_length = 0u;
    size_t text_capacity;
    int status;

    if (b == NULL || action == NULL || before == NULL || out == NULL ||
        action->type != SESSION_A43_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    if (before->runtime_type_36) {
        /* The row is runtime type 0x36 now. Its generic completion runs with
         * the subtype 0x411f24 stored (1), not the raw one. */
        const int served = session_a36_handler(b->a36, index, action, before, out);
        if (served == SCENE_ACTION_HANDLER_OK && out->disposition == SCENE_ACTION_HANDLER_COMPLETED &&
            action->subtype != 1u) {
            out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
            out->phase = 0u;
        }
        if (served != SCENE_ACTION_HANDLER_OK) {
            b->failure = session_a36_failure(b->a36);
        }
        return served;
    }

    if (action_family_43_decode(action->raw_body, action->raw_body_length, &decoded) !=
        ACTION_FAMILY_43_OK) {
        return refuse(b, "invalid raw-0x43 scene row");
    }
    if (decoded.option_109 != 0u) {
        size_t key_length = 0u;
        while (key_length < sizeof(decoded.key) && decoded.key[key_length] != '\0') {
            ++key_length;
        }
        if (b->host.lookup == NULL ||
            b->host.lookup(b->host.context, (const uint8_t *)decoded.key, key_length, &resolved,
                           &resolved_length) != 0 ||
            resolved == NULL) {
            return refuse(b, "AUTOTEXT key not found (original fallback unverified)");
        }
        /* The lookup's value is borrowed and has no promised NUL after the visible bytes; the constructor takes the
         * string with its final NUL. */
        resolved_copy = (uint8_t *)malloc(resolved_length + 1u);
        if (resolved_copy == NULL) {
            b->failure = "text allocation failed";
            return SCENE_ACTION_HANDLER_ERROR;
        }
        memcpy(resolved_copy, resolved, resolved_length);
        resolved_copy[resolved_length] = 0u;
        resolved = resolved_copy;
        resolved_length += 1u;
    }
    if (action_family_43_construct(action->raw_body, action->raw_body_length, resolved,
                                   resolved_length, 0u, 1u, NULL, 0u, &constructed) !=
        ACTION_FAMILY_43_OK) {
        free(resolved_copy);
        return refuse(b, "raw-0x43 text outside the supported domain");
    }
    object = (uint8_t *)calloc(constructed.allocation_bytes != 0u ? constructed.allocation_bytes : 1u, 1u);
    if (object == NULL) {
        free(resolved_copy);
        b->failure = "text allocation failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = action_family_43_construct(action->raw_body, action->raw_body_length, resolved,
                                        resolved_length, 0u, 1u, object, constructed.allocation_bytes,
                                        &constructed);
    free(resolved_copy);
    if (status != ACTION_FAMILY_43_OK) {
        free(object);
        return refuse(b, "raw-0x43 object construction failed");
    }
    text_capacity = constructed.allocation_bytes - ACTION_FAMILY_43_PREFIX_BYTES;
    if (b->host.write_text != NULL) {
        status = b->host.write_text(b->host.context, object,
                                    (const char *)object + ACTION_FAMILY_43_PREFIX_BYTES,
                                    text_capacity) == 0
                     ? AUTOTEXT_WRITE_OK
                     : AUTOTEXT_WRITE_ERR_BACKEND;
    } else {
        if (b->host.render_inputs == NULL ||
            b->host.render_inputs(b->host.context, &inputs) != 0 || inputs.fonts == NULL ||
            inputs.font_state == NULL) {
            free(object);
            return refuse(b, "caption font/pixel-format provider unavailable");
        }
        memset(&result, 0, sizeof(result));
        status = autotext_write(inputs.fonts, &inputs.format, &b->owner, &b->globals,
                                inputs.font_state, &b->host.backend, object,
                                (const char *)object + ACTION_FAMILY_43_PREFIX_BYTES,
                                text_capacity, NULL, 0u, NULL, &result);
    }
    if (status != AUTOTEXT_WRITE_OK) {
        free(object);
        return refuse(b, autotext_write_status_string(status));
    }
    ++b->rendered;
    if (b->host.observe != NULL) {
        b->host.observe(b->host.context, SESSION_A43_FX_RENDERED, (int16_t)rd16(object + 2u),
                        (int32_t)strlen((const char *)object + ACTION_FAMILY_43_PREFIX_BYTES));
    }
    if (build_overlay_image(object, image) != 0 ||
        session_a36_adopt_row(b->a36, index, image) != OVERLAY36_OK) {
        free(object);
        return refuse(b, "overlay image for the converted row could not be installed");
    }
    if (b->host.observe != NULL) {
        b->host.observe(b->host.context, SESSION_A43_FX_CONVERTED, (int32_t)index,
                        (int16_t)rd16(object + 2u));
    }
    free(object);
    /* 0x42ba3a with the raw subtype; the completion byte is cleared again by the
     * tail of 0x411f24, so only the subtype-2 dependency reset survives. */
    out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES
                                              : SCENE_ACTION_HANDLER_PENDING;
    out->phase = 0u;
    out->become_overlay36 = 1u;
    return SCENE_ACTION_HANDLER_OK;
}
