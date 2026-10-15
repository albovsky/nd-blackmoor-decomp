/* Reuse RT-1's substitute host and synthetic asset tree. No output device. */
#define main rt1_fixture_main
#include "live_audio_fixture.c"
#undef main
#include <assert.h>
static int movie_play(MacAudioHost *h, uint32_t slot, const float *pcm, uint64_t n,
                      uint32_t ch, uint32_t rate, float gain, int loop, char *e, size_t cap)
{
    /* RT-1 fake has only game slots 0..63; map the extra bus for observation. */
    assert(slot <= 64u);
    return fake_play(h, slot == 64u ? 63u : slot, pcm, n, ch, rate, gain, loop, e, cap);
}
static int movie_stop(MacAudioHost *h, uint32_t slot, char *e, size_t cap)
{ assert(slot <= 64u); return fake_stop(h, slot == 64u ? 63u : slot, e, cap); }
int main(int argc, char **argv)
{
    Ctx ctx;LiveAudio *audio=NULL;LiveAudioChannelInfo before,after;
    float pcm[32];uint32_t bus=63u;
    assert(argc==2);memset(&ctx,0,sizeof(ctx));ctx.fixture_dir=argv[1];
    for(size_t i=0;i<32;++i)pcm[i]=0.25f;
    { LiveAudioHostOps ops=fake_ops();LiveAudioConfig c={0};char error[128];
      ops.play=movie_play;ops.stop=movie_stop;c.host_ops=&ops;c.game_directory=argv[1];
      c.mode=MAC_AUDIO_MODE_OFFLINE;
      assert(live_audio_create(&c,&audio,error,sizeof(error))==LIVE_AUDIO_OK); }
    ActionSoundAudioCommand c=make_command("Tone",7,1,1,1,0);
    assert(live_audio_load_sound(audio,&c)==ACTION_SOUND_BACKEND_OK);
    assert(live_audio_play_sound(audio,7)==ACTION_SOUND_BACKEND_OK);
    assert(live_audio_get_channel_info(audio,7,&before)==LIVE_AUDIO_OK);
    assert(live_audio_movie_start(NULL,pcm,32,1,44100)==LIVE_AUDIO_ERR_ARGUMENT);
    assert(live_audio_movie_start(audio,NULL,32,1,44100)==LIVE_AUDIO_ERR_ARGUMENT);
    assert(live_audio_movie_start(audio,pcm,32,3,44100)==LIVE_AUDIO_ERR_ARGUMENT);
    assert(live_audio_movie_start(audio,pcm,32,1,44100)==LIVE_AUDIO_OK);
    assert(g_fake->slots[bus].active&&g_fake->slots[bus].gain==1.0f);
    assert(g_fake->slots[bus].channels==1&&g_fake->slots[bus].rate==44100);
    assert(live_audio_get_channel_info(audio,7,&after)==LIVE_AUDIO_OK);
    assert(!memcmp(&before,&after,sizeof(before))&&playing(audio,7));
    assert(live_audio_movie_start(audio,pcm,16,2,48000)==LIVE_AUDIO_OK);
    assert(g_fake->slots[bus].plays==2&&g_fake->slots[bus].stops==1);
    assert(live_audio_movie_stop(audio)==LIVE_AUDIO_OK);
    assert(!g_fake->slots[bus].active&&playing(audio,7));
    assert(live_audio_movie_stop(audio)==LIVE_AUDIO_OK);
    g_fake->fail_play=1;
    assert(live_audio_movie_start(audio,pcm,32,1,44100)==LIVE_AUDIO_ERR_HOST);
    assert(live_audio_movie_stop(audio)==LIVE_AUDIO_OK);
    g_fake->fail_play=0;
    assert(live_audio_movie_start(audio,pcm,32,1,44100)==LIVE_AUDIO_OK);
    assert(live_audio_destroy(audio)==LIVE_AUDIO_OK);
    assert(!g_fake->slots[bus].active&&g_fake->closes==1);
    fake_free();
    puts("RT-9 movie mixer bus: separate slot, unchanged scene channel, unity, replace/stop/failure/destroy passed");
    return 0;
}
