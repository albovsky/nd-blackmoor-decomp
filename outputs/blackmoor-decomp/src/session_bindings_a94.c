#include "session_bindings_a94.h"

#include <stdlib.h>
#include <string.h>

struct SessionA94Binding {
    SessionA94Host host;
    const char *failure;
    unsigned long written;
    unsigned long refused;
    char last_path[A94_PATH_BYTES];
};

SessionA94Binding *session_a94_create(const SessionA94Host *host)
{
    SessionA94Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA94Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a94_destroy(SessionA94Binding *b)
{
    free(b);
}

static int host_complete(const SessionA94Host *h)
{
    return h->set_capture_flag != NULL && h->request_refresh != NULL && h->display != NULL && h->capture != NULL &&
           h->write_file != NULL;
}

/* Phase 2 once the rectangle fits the screen: 0x4c3777 .. 0x4c3c46. Returns a handler status. */
static int capture_screen_file(SessionA94Binding *b, const A94Request *request, const SessionA94Display *display)
{
    const A94Screen *screen = &display->screen;
    const size_t screen_bytes = (size_t)screen->width * (size_t)screen->height * 2u;
    uint8_t *pixels = NULL;
    uint8_t *file = NULL;
    size_t length = 0u;
    char path[A94_PATH_BYTES];
    char name[A94_NAME_BYTES + 1u];
    int status = SCENE_ACTION_HANDLER_OK;

    if (!a94_request_valid(screen, request)) {
        b->failure = "capture rectangle outside the valid domain of the original (non-positive size or negative origin)";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    memcpy(name, request->name, A94_NAME_BYTES);
    name[A94_NAME_BYTES] = '\0';
    if (a94_make_path(path, sizeof path, display->drive, display->dir, name, a94_extension(request)) != A94_OK ||
        a94_encode(screen, request, NULL, NULL, 0u, &length) != A94_OK) {
        b->failure = "file path or encoding is outside the native limits";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    pixels = (uint8_t *)malloc(screen_bytes);
    file = (uint8_t *)malloc(length);
    if (pixels == NULL || file == NULL) {
        /* 0x4c37d1 / 0x4c3863: the original only logs (debug mode) and still ends the capture. */
        free(pixels);
        free(file);
        return SCENE_ACTION_HANDLER_OK;
    }
    if (b->host.capture(b->host.context, pixels, screen_bytes) != 0) {
        b->failure = "front buffer capture failed";
        status = SCENE_ACTION_HANDLER_ERROR;
    } else if (a94_encode(screen, request, pixels, file, length, &length) != A94_OK) {
        b->failure = "encoding failed";
        status = SCENE_ACTION_HANDLER_ERROR;
    } else if (b->host.write_file(b->host.context, path, file, length) != 0) {
        ++b->refused;
    } else {
        ++b->written;
        memcpy(b->last_path, path, strlen(path) + 1u);
    }
    free(pixels);
    free(file);
    return status;
}

int session_a94_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA94Binding *b = (SessionA94Binding *)context;
    A94Request request;
    SessionA94Display display;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A94_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action->typed_body_length != A94_BODY_BYTES || action->typed_body == NULL) {
        b->failure = "invalid raw-0x94 body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (!host_complete(&b->host)) {
        b->failure = "screen capture host (flag, refresh, display, front buffer, file write)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    b->failure = "none";
    out->phase = before->phase;
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    switch (before->phase) {
    case A94_PHASE_START:
        b->host.set_capture_flag(b->host.context, 1);  /* 0x4c3719 */
        b->host.request_refresh(b->host.context);       /* 0x4c3727 */
        out->phase = A94_PHASE_CAPTURE;                 /* 0x4c3730: phase 0 jumps to 2 */
        break;
    case A94_PHASE_CAPTURE: {
        int status;
        memset(&display, 0, sizeof display);
        a94_request_from_body(action->typed_body, &request);
        if (b->host.display(b->host.context, &display) != 0) {
            b->failure = "display state unavailable";
            return SCENE_ACTION_HANDLER_ERROR;
        }
        display.drive[sizeof display.drive - 1u] = '\0';
        display.dir[sizeof display.dir - 1u] = '\0';
        if (!a94_capture_reachable(&display.screen, &request)) {
            break; /* the row waits in phase 2 for ever */
        }
        status = capture_screen_file(b, &request, &display);
        if (status != SCENE_ACTION_HANDLER_OK) {
            return status;
        }
        b->host.set_capture_flag(b->host.context, 0);  /* 0x4c3c19 */
        out->phase = A94_PHASE_DONE;                    /* 0x4c3c23 */
        break;
    }
    case A94_PHASE_DONE:
        out->disposition = SCENE_ACTION_HANDLER_COMPLETED; /* 0x42ba3a */
        out->phase = 0u;
        break;
    default:
        break;
    }
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a94_failure(const SessionA94Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a94_files_written(const SessionA94Binding *b)
{
    return b == NULL ? 0ul : b->written;
}

unsigned long session_a94_files_refused(const SessionA94Binding *b)
{
    return b == NULL ? 0ul : b->refused;
}

const char *session_a94_last_path(const SessionA94Binding *b)
{
    return b == NULL ? "" : b->last_path;
}
