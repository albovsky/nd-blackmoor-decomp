#import <AVFAudio/AVFAudio.h>
#import <Foundation/Foundation.h>

#include "macos_audio.h"

#include <cmath>
#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <limits>
#include <memory>
#include <mutex>
#include <new>
#include <unordered_map>

namespace {

constexpr uint32_t kMaximumRenderFrames = 65536;
constexpr uint32_t kMinimumSampleRate = 1;
constexpr uint32_t kMaximumSampleRate = 192000;

struct Slot {
    __strong AVAudioPlayerNode *player = nil;
    __strong AVAudioPCMBuffer *buffer = nil;
    uint32_t source_rate = 0;
    uint32_t source_channels = 0;
    uint64_t generation = 0;
    bool active = false;
    bool looping = false;
    bool started = false;
    uint64_t source_frame_count = 0;
    uint64_t play_render_mark = 0;
    uint64_t last_cursor_frames = 0;
};

struct HostState {
    MacAudioMode mode = MAC_AUDIO_MODE_OUTPUT;
    __strong AVAudioEngine *engine = nil;
    __strong AVAudioFormat *render_format = nil;
    uint32_t render_rate = 0;
    uint32_t render_channels = 0;
    bool started = false;
    bool closed = false;
    uint64_t rendered_frames = 0;
    std::mutex mutex;
    std::unordered_map<uint32_t, Slot> slots;
};

} // namespace

struct MacAudioHost {
    std::shared_ptr<HostState> state;
};

namespace {

void write_error(char *buffer, size_t capacity, const char *format, ...) {
    if (buffer == nullptr || capacity == 0) {
        return;
    }
    va_list args;
    va_start(args, format);
    (void)vsnprintf(buffer, capacity, format, args);
    va_end(args);
    buffer[capacity - 1] = '\0';
}

void clear_error(char *buffer, size_t capacity) {
    if (buffer != nullptr && capacity != 0) {
        buffer[0] = '\0';
    }
}

int fail(int status, char *error, size_t capacity, const char *message) {
    write_error(error, capacity, "%s", message);
    return status;
}

int fail_nserror(int status, char *error, size_t capacity,
                 const char *operation, NSError *ns_error) {
    if (ns_error != nil) {
        const char *description = ns_error.localizedDescription.UTF8String;
        if (description == nullptr) {
            description = "unknown AVFAudio error";
        }
        write_error(error, capacity, "%s: %s", operation,
                    description);
    } else {
        write_error(error, capacity, "%s failed", operation);
    }
    return status;
}

bool on_main_thread(void) {
    return [NSThread isMainThread];
}

int check_host(MacAudioHost *host, std::shared_ptr<HostState> *state,
               char *error, size_t capacity) {
    if (host == nullptr || !host->state) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, capacity, "audio host is null");
    }
    if (!on_main_thread()) {
        return fail(MAC_AUDIO_ERR_THREAD, error, capacity,
                    "audio host calls must run on the main thread");
    }
    *state = host->state;
    {
        std::lock_guard<std::mutex> lock((*state)->mutex);
        if ((*state)->closed) {
            return fail(MAC_AUDIO_ERR_CLOSED, error, capacity, "audio host is closed");
        }
    }
    return MAC_AUDIO_OK;
}

bool valid_rate(uint32_t rate) {
    return rate >= kMinimumSampleRate && rate <= kMaximumSampleRate;
}

AVAudioFormat *float_format(uint32_t sample_rate, uint32_t channels) {
    return [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32
                                           sampleRate:(double)sample_rate
                                             channels:(AVAudioChannelCount)channels
                                          interleaved:NO];
}

bool valid_gain(float gain) {
    return std::isfinite(gain) && gain >= 0.0f && gain <= 1.0f;
}

int ensure_engine_started(const std::shared_ptr<HostState> &state,
                          char *error, size_t capacity) {
    if (state->started) {
        return MAC_AUDIO_OK;
    }
    NSError *ns_error = nil;
    @try {
        if (![state->engine startAndReturnError:&ns_error]) {
            return fail_nserror(MAC_AUDIO_ERR_ENGINE, error, capacity,
                                "starting AVAudioEngine", ns_error);
        }
    } @catch (NSException *exception) {
        const char *reason = exception.reason.UTF8String;
        write_error(error, capacity, "starting AVAudioEngine raised: %s",
                    reason != nullptr ? reason : "unknown Objective-C exception");
        return MAC_AUDIO_ERR_ENGINE;
    }
    state->started = true;
    return MAC_AUDIO_OK;
}

int create_slot(const std::shared_ptr<HostState> &state, uint32_t slot_id,
                AVAudioFormat *format, uint32_t sample_rate, uint32_t channels,
                Slot **slot_out, char *error, size_t capacity) {
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        auto existing = state->slots.find(slot_id);
        if (existing != state->slots.end()) {
            *slot_out = &existing->second;
            return MAC_AUDIO_OK;
        }
    }

    Slot slot;
    slot.player = [[AVAudioPlayerNode alloc] init];
    if (slot.player == nil) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, capacity,
                    "allocating AVAudioPlayerNode failed");
    }
    NSError *ns_error = nil;
    @try {
        [state->engine attachNode:slot.player];
        if (![state->engine connect:slot.player to:state->engine.mainMixerNode
                             format:format error:&ns_error]) {
            [state->engine detachNode:slot.player];
            return fail_nserror(MAC_AUDIO_ERR_ENGINE, error, capacity,
                                "connecting AVAudioPlayerNode", ns_error);
        }
    } @catch (NSException *exception) {
        const char *reason = exception.reason.UTF8String;
        write_error(error, capacity, "connecting AVAudioPlayerNode raised: %s",
                    reason != nullptr ? reason : "unknown Objective-C exception");
        return MAC_AUDIO_ERR_ENGINE;
    }
    slot.source_rate = sample_rate;
    slot.source_channels = channels;
    std::lock_guard<std::mutex> lock(state->mutex);
    auto inserted = state->slots.emplace(slot_id, std::move(slot));
    if (!inserted.second) {
        [state->engine detachNode:slot.player];
        return fail(MAC_AUDIO_ERR_ENGINE, error, capacity,
                    "registering AVAudioPlayerNode failed");
    }
    *slot_out = &inserted.first->second;
    return MAC_AUDIO_OK;
}

int configure_slot_format(const std::shared_ptr<HostState> &state, Slot *slot,
                          AVAudioFormat *format, uint32_t sample_rate,
                          uint32_t channels, char *error, size_t capacity) {
    if (slot->source_rate == sample_rate && slot->source_channels == channels) {
        return MAC_AUDIO_OK;
    }
    AVAudioFormat *previous_format = float_format(slot->source_rate, slot->source_channels);
    [state->engine disconnectNodeOutput:slot->player];
    NSError *ns_error = nil;
    @try {
        if (![state->engine connect:slot->player to:state->engine.mainMixerNode
                             format:format error:&ns_error]) {
            NSError *restore_error = nil;
            (void)[state->engine connect:slot->player to:state->engine.mainMixerNode
                                   format:previous_format error:&restore_error];
            return fail_nserror(MAC_AUDIO_ERR_ENGINE, error, capacity,
                                "reconnecting AVAudioPlayerNode for PCM format", ns_error);
        }
    } @catch (NSException *exception) {
        const char *reason = exception.reason.UTF8String;
        write_error(error, capacity, "reconnecting AVAudioPlayerNode raised: %s",
                    reason != nullptr ? reason : "unknown Objective-C exception");
        return MAC_AUDIO_ERR_ENGINE;
    }
    slot->source_rate = sample_rate;
    slot->source_channels = channels;
    return MAC_AUDIO_OK;
}

} // namespace

extern "C" int mac_audio_host_open(MacAudioMode mode,
                                    uint32_t offline_sample_rate,
                                    uint32_t offline_channels,
                                    MacAudioHost **host,
                                    char *error,
                                    size_t error_capacity) {
    clear_error(error, error_capacity);
    if (host == nullptr) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "host output pointer is null");
    }
    *host = nullptr;
    if (!on_main_thread()) {
        return fail(MAC_AUDIO_ERR_THREAD, error, error_capacity,
                    "audio host calls must run on the main thread");
    }
    if (mode != MAC_AUDIO_MODE_OUTPUT && mode != MAC_AUDIO_MODE_OFFLINE) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "unknown audio host mode");
    }
    if (mode == MAC_AUDIO_MODE_OFFLINE &&
        (!valid_rate(offline_sample_rate) || offline_channels < 1 || offline_channels > 2)) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "offline format must be 1..192000 Hz and mono or stereo");
    }

    auto state = std::shared_ptr<HostState>(new (std::nothrow) HostState());
    if (!state) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "allocating audio host state failed");
    }
    state->mode = mode;
    state->engine = [[AVAudioEngine alloc] init];
    if (state->engine == nil) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "allocating AVAudioEngine failed");
    }
    /* Owner-requested host policy: mute the complete bus without changing
     * player scheduling, individual gains or natural completion. */
    @try {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BlackmoorAudioMuted"])
            state->engine.mainMixerNode.outputVolume = 0.0f;
    } @catch (NSException *exception) {
        write_error(error, error_capacity, "configuring master mute raised: %s",
                    exception.reason.UTF8String != nullptr ? exception.reason.UTF8String : "unknown exception");
        return MAC_AUDIO_ERR_ENGINE;
    }

    if (mode == MAC_AUDIO_MODE_OFFLINE) {
        state->render_format = float_format(offline_sample_rate, offline_channels);
        if (state->render_format == nil) {
            return fail(MAC_AUDIO_ERR_FORMAT, error, error_capacity,
                        "creating offline PCM format failed");
        }
        NSError *ns_error = nil;
        state->render_rate = offline_sample_rate;
        state->render_channels = offline_channels;
        @try {
            if (![state->engine enableManualRenderingMode:AVAudioEngineManualRenderingModeOffline
                                                   format:state->render_format
                                      maximumFrameCount:kMaximumRenderFrames
                                                    error:&ns_error]) {
                return fail_nserror(MAC_AUDIO_ERR_ENGINE, error, error_capacity,
                                    "enabling offline manual rendering", ns_error);
            }
        } @catch (NSException *exception) {
            const char *reason = exception.reason.UTF8String;
            write_error(error, error_capacity,
                        "enabling offline manual rendering raised: %s",
                        reason != nullptr ? reason : "unknown Objective-C exception");
            return MAC_AUDIO_ERR_ENGINE;
        }
    }

    MacAudioHost *handle = new (std::nothrow) MacAudioHost();
    if (handle == nullptr) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "allocating audio host handle failed");
    }
    handle->state = std::move(state);
    *host = handle;
    return MAC_AUDIO_OK;
}

extern "C" int mac_audio_host_close(MacAudioHost *host,
                                     char *error,
                                     size_t error_capacity) {
    clear_error(error, error_capacity);
    if (host == nullptr || !host->state) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity, "audio host is null");
    }
    if (!on_main_thread()) {
        return fail(MAC_AUDIO_ERR_THREAD, error, error_capacity,
                    "audio host calls must run on the main thread");
    }
    std::shared_ptr<HostState> state = host->state;
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        if (state->closed) {
            return fail(MAC_AUDIO_ERR_CLOSED, error, error_capacity, "audio host is closed");
        }
        state->closed = true;
        for (auto &entry : state->slots) {
            ++entry.second.generation;
            entry.second.active = false;
        }
    }
    for (auto &entry : state->slots) {
        [entry.second.player stop];
        [state->engine detachNode:entry.second.player];
    }
    [state->engine stop];
    state->started = false;
    state->slots.clear();
    host->state.reset();
    delete host;
    return MAC_AUDIO_OK;
}

extern "C" int mac_audio_play(MacAudioHost *host,
                               uint32_t slot_id,
                               const float *interleaved_pcm,
                               uint64_t frame_count,
                               uint32_t channels,
                               uint32_t sample_rate,
                               float gain,
                               int loop,
                               char *error,
                               size_t error_capacity) {
    clear_error(error, error_capacity);
    std::shared_ptr<HostState> state;
    int status = check_host(host, &state, error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }
    if (interleaved_pcm == nullptr || frame_count == 0 ||
        frame_count > std::numeric_limits<AVAudioFrameCount>::max() ||
        channels < 1 || channels > 2 || !valid_rate(sample_rate) ||
        !valid_gain(gain) || (loop != 0 && loop != 1)) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "PCM, frame count, format, gain, or loop flag is invalid");
    }
    if (frame_count > std::numeric_limits<size_t>::max() / channels / sizeof(float)) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "PCM buffer size overflows addressable memory");
    }
    const size_t source_sample_count = (size_t)frame_count * channels;
    for (size_t index = 0; index < source_sample_count; ++index) {
        if (!std::isfinite(interleaved_pcm[index])) {
            return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                        "input PCM samples must be finite");
        }
    }

    AVAudioFormat *format = float_format(sample_rate, channels);
    if (format == nil) {
        return fail(MAC_AUDIO_ERR_FORMAT, error, error_capacity,
                    "creating source PCM format failed");
    }
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc]
        initWithPCMFormat:format
        frameCapacity:(AVAudioFrameCount)frame_count];
    if (buffer == nil || buffer.floatChannelData == nullptr) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "allocating owned PCM buffer failed");
    }
    buffer.frameLength = (AVAudioFrameCount)frame_count;
    for (uint32_t channel = 0; channel < channels; ++channel) {
        float *destination = buffer.floatChannelData[channel];
        for (uint64_t frame = 0; frame < frame_count; ++frame) {
            destination[frame] = interleaved_pcm[frame * channels + channel];
        }
    }

    Slot *slot = nullptr;
    status = create_slot(state, slot_id, format, sample_rate, channels,
                         &slot, error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }

    uint64_t generation;
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        generation = ++slot->generation;
        slot->active = false;
        slot->started = false;
        slot->source_frame_count = frame_count;
        slot->last_cursor_frames = 0;
        slot->looping = (loop != 0);
        slot->buffer = buffer;
    }
    @try {
        [slot->player stop];
        slot->player.volume = gain;
    } @catch (NSException *exception) {
        const char *reason = exception.reason.UTF8String;
        write_error(error, error_capacity, "preparing AVAudioPlayerNode raised: %s",
                    reason != nullptr ? reason : "unknown Objective-C exception");
        return MAC_AUDIO_ERR_ENGINE;
    }
    status = configure_slot_format(state, slot, format, sample_rate, channels,
                                   error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }

    if (state->mode == MAC_AUDIO_MODE_OFFLINE) {
        // The graph is manual-rendered, so this starts no device and opens no
        // output route. AVAudioEngine requires start before its render method.
        status = ensure_engine_started(state, error, error_capacity);
        if (status != MAC_AUDIO_OK) {
            return status;
        }
    } else {
        status = ensure_engine_started(state, error, error_capacity);
        if (status != MAC_AUDIO_OK) {
            return status;
        }
    }

    std::weak_ptr<HostState> weak_state(state);
    const AVAudioPlayerNodeBufferOptions options = loop != 0
        ? AVAudioPlayerNodeBufferLoops
        : (AVAudioPlayerNodeBufferOptions)0;
    // Production slots remain active until AVAudioPlayerNode reports that
    // the samples have left the output path. Offline manual rendering has no
    // output device, so only its DataRendered callback can observe completion.
    const AVAudioPlayerNodeCompletionCallbackType completion_type =
        state->mode == MAC_AUDIO_MODE_OFFLINE
            ? AVAudioPlayerNodeCompletionDataRendered
            : AVAudioPlayerNodeCompletionDataPlayedBack;
    @try {
        [slot->player scheduleBuffer:buffer
                              atTime:nil
                             options:options
           completionCallbackType:completion_type
                    completionHandler:^(AVAudioPlayerNodeCompletionCallbackType callback_type) {
                        (void)callback_type;
                        std::shared_ptr<HostState> callback_state = weak_state.lock();
                        if (!callback_state) {
                            return;
                        }
                        std::lock_guard<std::mutex> lock(callback_state->mutex);
                        if (callback_state->closed) {
                            return;
                        }
                        auto found = callback_state->slots.find(slot_id);
                        if (found != callback_state->slots.end() &&
                            found->second.generation == generation &&
                            !found->second.looping) {
                            found->second.active = false;
                            found->second.last_cursor_frames = found->second.source_frame_count;
                        }
                    }];
    } @catch (NSException *exception) {
        const char *reason = exception.reason.UTF8String;
        write_error(error, error_capacity, "scheduling PCM raised: %s",
                    reason != nullptr ? reason : "unknown Objective-C exception");
        return MAC_AUDIO_ERR_ENGINE;
    }
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        if (state->closed || slot->generation != generation) {
            return fail(MAC_AUDIO_ERR_CLOSED, error, error_capacity,
                        "audio host changed during playback setup");
        }
        slot->active = true;
    }
    NSError *play_error = nil;
    BOOL play_succeeded = NO;
    @try {
        play_succeeded = [slot->player playAndReturnError:&play_error];
    } @catch (NSException *exception) {
        const char *reason = exception.reason.UTF8String;
        write_error(error, error_capacity, "starting AVAudioPlayerNode raised: %s",
                    reason != nullptr ? reason : "unknown Objective-C exception");
        play_succeeded = NO;
    }
    if (!play_succeeded) {
        {
            std::lock_guard<std::mutex> lock(state->mutex);
            if (slot->generation == generation) {
                ++slot->generation;
                slot->active = false;
            }
        }
        [slot->player stop];
        if (play_error != nil) {
            return fail_nserror(MAC_AUDIO_ERR_ENGINE, error, error_capacity,
                                "starting AVAudioPlayerNode", play_error);
        }
        if (error == nullptr || error_capacity == 0 || error[0] == '\0') {
            return fail(MAC_AUDIO_ERR_ENGINE, error, error_capacity,
                        "starting AVAudioPlayerNode failed");
        }
        return MAC_AUDIO_ERR_ENGINE;
    }
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        slot->started = true;
        slot->play_render_mark = state->rendered_frames;
    }
    return MAC_AUDIO_OK;
}

extern "C" int mac_audio_stop(MacAudioHost *host,
                               uint32_t slot_id,
                               char *error,
                               size_t error_capacity) {
    clear_error(error, error_capacity);
    std::shared_ptr<HostState> state;
    int status = check_host(host, &state, error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }
    __strong AVAudioPlayerNode *player = nil;
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        auto found = state->slots.find(slot_id);
        if (found == state->slots.end()) {
            return MAC_AUDIO_OK;
        }
        ++found->second.generation;
        found->second.active = false;
        found->second.started = false;
        found->second.last_cursor_frames = 0;
        player = found->second.player;
    }
    [player stop];
    return MAC_AUDIO_OK;
}

extern "C" int mac_audio_set_gain(MacAudioHost *host,
                                   uint32_t slot_id,
                                   float gain,
                                   char *error,
                                   size_t error_capacity) {
    clear_error(error, error_capacity);
    std::shared_ptr<HostState> state;
    int status = check_host(host, &state, error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }
    if (!valid_gain(gain)) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "gain must be finite and between zero and one");
    }
    __strong AVAudioPlayerNode *player = nil;
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        auto found = state->slots.find(slot_id);
        if (found == state->slots.end()) {
            return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                        "audio slot has not been created");
        }
        player = found->second.player;
    }
    player.volume = gain;
    return MAC_AUDIO_OK;
}

extern "C" int mac_audio_is_playing(MacAudioHost *host,
                                     uint32_t slot_id,
                                     int *is_playing,
                                     char *error,
                                     size_t error_capacity) {
    clear_error(error, error_capacity);
    if (is_playing == nullptr) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "is_playing output pointer is null");
    }
    *is_playing = 0;
    std::shared_ptr<HostState> state;
    int status = check_host(host, &state, error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }
    std::lock_guard<std::mutex> lock(state->mutex);
    auto found = state->slots.find(slot_id);
    if (found != state->slots.end()) {
        *is_playing = found->second.active ? 1 : 0;
    }
    return MAC_AUDIO_OK;
}

extern "C" int mac_audio_host_render_offline(MacAudioHost *host,
                                              uint32_t frame_count,
                                              MacAudioRender *render,
                                              char *error,
                                              size_t error_capacity) {
    clear_error(error, error_capacity);
    if (render == nullptr) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "render output pointer is null");
    }
    *render = MacAudioRender{};
    std::shared_ptr<HostState> state;
    int status = check_host(host, &state, error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }
    if (state->mode != MAC_AUDIO_MODE_OFFLINE) {
        return fail(MAC_AUDIO_ERR_MODE, error, error_capacity,
                    "manual render is available only in offline mode");
    }
    if (frame_count == 0 || frame_count > kMaximumRenderFrames) {
        return fail(MAC_AUDIO_ERR_ARGUMENT, error, error_capacity,
                    "offline render frame count must be between 1 and 65536");
    }
    status = ensure_engine_started(state, error, error_capacity);
    if (status != MAC_AUDIO_OK) {
        return status;
    }

    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc]
        initWithPCMFormat:state->render_format
        frameCapacity:(AVAudioFrameCount)frame_count];
    if (buffer == nil || buffer.floatChannelData == nullptr) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "allocating offline render buffer failed");
    }
    NSError *ns_error = nil;
    AVAudioEngineManualRenderingStatus render_status =
        AVAudioEngineManualRenderingStatusCannotDoInCurrentContext;
    @try {
        render_status = [state->engine renderOffline:(AVAudioFrameCount)frame_count
                                            toBuffer:buffer
                                               error:&ns_error];
    } @catch (NSException *exception) {
        const char *reason = exception.reason.UTF8String;
        write_error(error, error_capacity, "offline render raised: %s",
                    reason != nullptr ? reason : "unknown Objective-C exception");
        return MAC_AUDIO_ERR_ENGINE;
    }
    if (render_status != AVAudioEngineManualRenderingStatusSuccess ||
        buffer.frameLength != frame_count) {
        if (ns_error != nil) {
            return fail_nserror(MAC_AUDIO_ERR_ENGINE, error, error_capacity,
                                "rendering offline audio", ns_error);
        }
        write_error(error, error_capacity,
                    "offline render returned status %ld and %u of %u frames",
                    (long)render_status, (unsigned)buffer.frameLength,
                    (unsigned)frame_count);
        return MAC_AUDIO_ERR_ENGINE;
    }
    /* Count actual successful manual renders, even if later copy allocation
     * fails. Virtual provider advances never enter this host counter. */
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        state->rendered_frames += frame_count;
    }
    if ((uint64_t)frame_count >
        std::numeric_limits<size_t>::max() / state->render_channels / sizeof(float)) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "offline output size overflows addressable memory");
    }
    size_t sample_count = (size_t)frame_count * state->render_channels;
    float *interleaved = new (std::nothrow) float[sample_count];
    if (interleaved == nullptr) {
        return fail(MAC_AUDIO_ERR_MEMORY, error, error_capacity,
                    "allocating offline interleaved output failed");
    }
    for (uint32_t channel = 0; channel < state->render_channels; ++channel) {
        const float *source = buffer.floatChannelData[channel];
        for (uint32_t frame = 0; frame < frame_count; ++frame) {
            interleaved[(size_t)frame * state->render_channels + channel] = source[frame];
        }
    }
    render->sample_rate = state->render_rate;
    render->channels = state->render_channels;
    render->frame_count = frame_count;
    render->interleaved_pcm = interleaved;
    return MAC_AUDIO_OK;
}

extern "C" void mac_audio_render_destroy(MacAudioRender *render) {
    if (render == nullptr) {
        return;
    }
    delete[] render->interleaved_pcm;
    *render = MacAudioRender{};
}

extern "C" const char *mac_audio_status_string(int status) {
    switch (status) {
        case MAC_AUDIO_OK: return "ok";
        case MAC_AUDIO_ERR_ARGUMENT: return "invalid argument";
        case MAC_AUDIO_ERR_THREAD: return "wrong thread";
        case MAC_AUDIO_ERR_ENGINE: return "audio engine error";
        case MAC_AUDIO_ERR_FORMAT: return "unsupported audio format";
        case MAC_AUDIO_ERR_MEMORY: return "allocation failed";
        case MAC_AUDIO_ERR_MODE: return "operation unavailable in this mode";
        case MAC_AUDIO_ERR_CLOSED: return "audio host is closed";
        case MAC_AUDIO_ERR_STALE: return "stale playback generation";
        default: return "unknown audio status";
    }
}

extern "C" int mac_audio_get_playback_cursor(MacAudioHost *host, uint32_t slot_id,
                                             uint64_t expected_generation,
                                             MacAudioPlaybackCursor *cursor,
                                             char *error, size_t capacity) {
    clear_error(error, capacity);
    if (cursor == nullptr) return fail(MAC_AUDIO_ERR_ARGUMENT, error, capacity, "cursor output is null");
    std::shared_ptr<HostState> state;
    int status = check_host(host, &state, error, capacity);
    if (status != MAC_AUDIO_OK) return status;
    MacAudioPlaybackCursor built{};
    __strong AVAudioPlayerNode *player = nil;
    uint64_t render_delta = 0;
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        auto found = state->slots.find(slot_id);
        if (found == state->slots.end()) {
            if (expected_generation != 0)
                return fail(MAC_AUDIO_ERR_STALE, error, capacity, "playback generation no longer exists");
            built.position_valid = 1;
            *cursor = built;
            return MAC_AUDIO_OK;
        }
        const Slot &slot = found->second;
        if (expected_generation != 0 && expected_generation != slot.generation)
            return fail(MAC_AUDIO_ERR_STALE, error, capacity, "playback generation changed");
        built.generation = slot.generation;
        built.source_frame_count = slot.source_frame_count;
        built.sample_rate = slot.source_rate;
        built.channels = slot.source_channels;
        built.started = slot.started;
        built.playing = slot.active;
        built.source_frames = slot.last_cursor_frames;
        player = slot.player;
        render_delta = state->rendered_frames - slot.play_render_mark;
    }
    built.position_valid = 1;
    if (!built.started) {
        built.source_frames = 0;
    } else if (!built.playing) {
        built.source_frames = built.source_frame_count;
    } else if (state->mode == MAC_AUDIO_MODE_OFFLINE) {
        /* source_frame_count is bounded by AVAudioFrameCount (u32), so if
         * multiplication overflows the clamped source end is already passed. */
        built.source_frames = render_delta > UINT64_MAX / built.sample_rate
            ? built.source_frame_count : (render_delta * built.sample_rate) / state->render_rate;
    } else {
        /* Apple's SDK documents that stop resets the player timeline to zero
         * and playerTimeForNodeTime converts node time to time since play.
         * nil before a native render is an explicit unavailable position. */
        @try {
            AVAudioTime *node_time = player.lastRenderTime;
            AVAudioTime *time = node_time != nil ? [player playerTimeForNodeTime:node_time] : nil;
            if (time == nil || !time.isSampleTimeValid || !std::isfinite(time.sampleRate) || time.sampleRate <= 0) {
                built.position_valid = 0;
            } else {
                const double frames = std::fmax(0.0, (double)time.sampleTime) * built.sample_rate / time.sampleRate;
                built.source_frames = frames >= (double)built.source_frame_count
                    ? built.source_frame_count : (uint64_t)std::floor(frames);
            }
        } @catch (NSException *exception) {
            write_error(error, capacity, "querying native player timeline raised: %s", exception.reason.UTF8String);
            return MAC_AUDIO_ERR_ENGINE;
        }
    }
    if (built.source_frames > built.source_frame_count) built.source_frames = built.source_frame_count;
    {
        std::lock_guard<std::mutex> lock(state->mutex);
        auto found = state->slots.find(slot_id);
        if (found == state->slots.end() || found->second.generation != built.generation)
            return fail(MAC_AUDIO_ERR_STALE, error, capacity, "playback generation changed during query");
        Slot &slot = found->second;
        if (slot.started && !slot.active) {
            built.source_frames = built.source_frame_count;
            built.position_valid = 1;
        }
        built.playing = slot.active;
        if (built.position_valid) {
            if (built.source_frames < slot.last_cursor_frames) built.source_frames = slot.last_cursor_frames;
            slot.last_cursor_frames = built.source_frames;
        }
    }
    *cursor = built;
    return MAC_AUDIO_OK;
}
