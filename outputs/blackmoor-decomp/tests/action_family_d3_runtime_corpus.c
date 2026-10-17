/* RT-53 corpus check: runs every raw 0xd3 row of the decoded scene resources given on the command line through the production
 * parser, the session binding and the kernel with a scripted host. Per row, pass 0: begin_scene validates the body, phase 0
 * sets the grid up, every piece/direction pair is probed with the pointer (the candidate must agree with an independent
 * reimplementation of the move rules written here from the header, not from the kernel), then a breadth-first search over the
 * piece positions finds the shortest solution and the moves are played through the pointer, the accepted-release click and the
 * phase 1 visits (render callback after each visit) until the solved scan fires and the finish runs (phase 2, generic
 * completion). Pass 1 (a fresh binding): phase 0, one move if any is possible, then the cancel rectangle is clicked and the
 * cancel finish runs. Output is derived counts only: one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line.
 * Resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_ad3.h"

#define VIEW_X 7
#define VIEW_Y 11

typedef struct {
    int loads, releases, plays, transitions, flag_stores, registers, stops, prepares;
    uint32_t now;
} Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x19; return 0; }
static int register_slot(void *c, int16_t s, const char *label)
{
    (void)s;
    ((Ctx *)c)->registers++;
    return strcmp(label, "COLLISION PUZZLE OVERLAYS") != 0;
}
static int load_surface(void *c, const char *n, uint32_t *s) { ((Ctx *)c)->loads++; *s = n[0] != '\0' ? 5u : 0u; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = VIEW_X; *y = VIEW_Y; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->prepares++; return 0; }
static int sound_stop(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->stops++; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static uint32_t tick(void *c) { Ctx *x = (Ctx *)c; x->now += 600u; return x->now; }
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const CpzTransition *t) { (void)t; ((Ctx *)c)->transitions++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }

/* Body offsets written here from the header documentation of the 855-byte allocation, independent of the kernel source. */
enum { O_ROWS = 0x22, O_COLS = 0x24, O_PIECES = 0x26, O_TYPES = 0x28, O_START = 0xa8, O_PIECE_SRC = 0xd0, O_ORIGIN_X = 0x240,
       O_ORIGIN_Y = 0x244, O_GAP = 0x248, O_CANCEL_RECT = 0x347 };
enum { D_LEFT = 0x10, D_UP = 0x11, D_DOWN = 0x12, D_RIGHT = 0x13, T_WALL = 0x14 };

static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}
static int rd16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }

typedef struct {
    int rows, cols, np;
    int type[8][8];
    int pr[10], pc[10];
} Puzzle;

static const int DIRS[4] = {D_LEFT, D_UP, D_DOWN, D_RIGHT};
static int d_dr(int d) { return d == D_UP ? -1 : d == D_DOWN ? 1 : 0; }
static int d_dc(int d) { return d == D_LEFT ? -1 : d == D_RIGHT ? 1 : 0; }
static int d_opp(int d) { return d == D_LEFT ? D_RIGHT : d == D_RIGHT ? D_LEFT : d == D_UP ? D_DOWN : D_UP; }

static int occupied(const Puzzle *p, int r, int c)
{
    for (int k = 0; k < p->np; ++k)
        if (p->pr[k] == r && p->pc[k] == c) return 1;
    return 0;
}

/* The piece k at its position may step one cell in direction d. */
static int may_step(const Puzzle *p, int k, int d)
{
    const int r = p->pr[k], c = p->pc[k], nr = r + d_dr(d), nc = c + d_dc(d);
    if (nr < 0 || nc < 0 || nr >= p->rows || nc >= p->cols) return 0;
    if (p->type[r][c] == d || p->type[nr][nc] == d_opp(d) || p->type[nr][nc] == T_WALL) return 0;
    return !occupied(p, nr, nc);
}

/* Slide piece k in direction d until the next step is refused. Returns 0 when it cannot start. */
static int slide(Puzzle *p, int k, int d)
{
    if (!may_step(p, k, d)) return 0;
    do {
        p->pr[k] += d_dr(d);
        p->pc[k] += d_dc(d);
    } while (may_step(p, k, d));
    return 1;
}

static int is_solved(const Puzzle *p)
{
    for (int k = 0; k < p->np; ++k)
        if (p->type[p->pr[k]][p->pc[k]] != k + 1) return 0;
    return 1;
}

static uint64_t key_of(const Puzzle *p)
{
    uint64_t v = 0;
    for (int k = 0; k < p->np; ++k) v = (v << 6) | (uint64_t)(p->pr[k] * 8 + p->pc[k]);
    return v;
}

#define MAX_STATES 6000000
#define HASH_BITS 24
#define MAX_PATH 4096
typedef struct { uint64_t key; int parent; int8_t piece; int16_t dir; } Node;

static int load_puzzle(const uint8_t *body, Puzzle *p)
{
    memset(p, 0, sizeof *p);
    p->rows = rd16(body, O_ROWS);
    p->cols = rd16(body, O_COLS);
    p->np = rd16(body, O_PIECES);
    if (p->rows < 1 || p->rows > 8 || p->cols < 1 || p->cols > 8 || p->np < 1 || p->np > 10) return 0;
    for (int a = 0; a < p->rows; ++a)
        for (int b = 0; b < p->cols; ++b) p->type[a][b] = rd16(body, O_TYPES + (size_t)a * 16u + (size_t)b * 2u);
    for (int k = 0; k < p->np; ++k) {
        p->pc[k] = rd16(body, O_START + (size_t)k * 4u);
        p->pr[k] = rd16(body, O_START + 2u + (size_t)k * 4u);
        if (p->pr[k] < 0 || p->pr[k] >= p->rows || p->pc[k] < 0 || p->pc[k] >= p->cols) return 0;
    }
    return 1;
}

/* Breadth-first search; returns the number of moves of the shortest solution (written to piece[]/dir[]), or -1. States are
 * stored as packed positions (6 bits per piece); the static grid is shared. */
static void unpack(const Puzzle *base, uint64_t key, Puzzle *p)
{
    *p = *base;
    for (int k = base->np - 1; k >= 0; --k) {
        p->pr[k] = (int)((key & 63u) / 8u);
        p->pc[k] = (int)((key & 63u) % 8u);
        key >>= 6;
    }
}

static uint32_t hash_of(uint64_t key) { return (uint32_t)(key * 11400714819323198485ull >> (64 - HASH_BITS)); }

/* Shortest number of single-cell steps of piece k to its target cell, ignoring the other pieces and slides: a weak guide for
 * the weighted search (it needs no admissibility, the played solution is verified move by move through the binding). */
static void guide_table(const Puzzle *p, int dist[10][64])
{
    for (int k = 0; k < p->np; ++k) {
        int tr = -1, tc = -1;
        for (int a = 0; a < p->rows; ++a)
            for (int c = 0; c < p->cols; ++c)
                if (p->type[a][c] == k + 1) { tr = a; tc = c; }
        for (int i = 0; i < 64; ++i) dist[k][i] = 1000;
        if (tr < 0) continue;
        dist[k][tr * 8 + tc] = 0;
        for (int round = 0; round < 80; ++round)
            for (int a = 0; a < p->rows; ++a)
                for (int c = 0; c < p->cols; ++c)
                    for (int di = 0; di < 4; ++di) {
                        const int d = DIRS[di], na = a + d_dr(d), nc = c + d_dc(d);
                        if (na < 0 || nc < 0 || na >= p->rows || nc >= p->cols) continue;
                        if (p->type[a][c] == d || p->type[na][nc] == d_opp(d) || p->type[na][nc] == T_WALL) continue;
                        if (dist[k][na * 8 + nc] + 1 < dist[k][a * 8 + c]) dist[k][a * 8 + c] = dist[k][na * 8 + nc] + 1;
                    }
    }
}

static int heuristic(const Puzzle *p, int dist[10][64])
{
    int h = 0;
    for (int k = 0; k < p->np; ++k) h += dist[k][p->pr[k] * 8 + p->pc[k]];
    return h;
}

typedef struct { int f, node; } HeapItem;
static void heap_push(HeapItem *heap, int *n, HeapItem it)
{
    int i = (*n)++;
    while (i > 0 && heap[(i - 1) / 2].f > it.f) { heap[i] = heap[(i - 1) / 2]; i = (i - 1) / 2; }
    heap[i] = it;
}
static HeapItem heap_pop(HeapItem *heap, int *n)
{
    HeapItem top = heap[0], last = heap[--(*n)];
    int i = 0;
    for (;;) {
        int c = 2 * i + 1;
        if (c >= *n) break;
        if (c + 1 < *n && heap[c + 1].f < heap[c].f) ++c;
        if (heap[c].f >= last.f) break;
        heap[i] = heap[c];
        i = c;
    }
    heap[i] = last;
    return top;
}

/* Weighted best-first search (f = depth + 4 * guide); returns the number of moves of a solution found (written to
 * piece[]/dir[]), or -1 when the state budget runs out. */
static int solve(const Puzzle *start, int *piece, int *dir, int cap)
{
    const uint32_t mask = (1u << HASH_BITS) - 1u;
    Node *nodes = (Node *)malloc(sizeof(Node) * MAX_STATES);
    int32_t *depth = (int32_t *)malloc(sizeof(int32_t) * MAX_STATES);
    HeapItem *heap = (HeapItem *)malloc(sizeof(HeapItem) * MAX_STATES);
    uint64_t *table = (uint64_t *)malloc(sizeof(uint64_t) * (1u << HASH_BITS));
    uint8_t *seen = (uint8_t *)calloc(1u << HASH_BITS, 1);
    int dist[10][64];
    int tail = 0, heap_n = 0, found = -1, result = -1;
    if (nodes == NULL || depth == NULL || heap == NULL || seen == NULL || table == NULL) {
        free(nodes); free(depth); free(heap); free(seen); free(table);
        return -1;
    }
    guide_table(start, dist);
    nodes[0].key = key_of(start);
    nodes[0].parent = -1;
    depth[0] = 0;
    {
        uint32_t h = hash_of(nodes[0].key);
        seen[h] = 1;
        table[h] = nodes[0].key;
    }
    tail = 1;
    {
        HeapItem it = {0, 0};
        heap_push(heap, &heap_n, it);
    }
    while (heap_n > 0 && found < 0) {
        const int cur = heap_pop(heap, &heap_n).node;
        Puzzle here;
        unpack(start, nodes[cur].key, &here);
        if (is_solved(&here)) { found = cur; break; }
        for (int k = 0; k < here.np; ++k)
            for (int di = 0; di < 4; ++di) {
                Puzzle n = here;
                uint64_t key;
                uint32_t h;
                HeapItem it;
                if (!slide(&n, k, DIRS[di])) continue;
                key = key_of(&n);
                h = hash_of(key);
                while (seen[h] && table[h] != key) h = (h + 1u) & mask;
                if (seen[h]) continue;
                if (tail >= MAX_STATES) goto done;
                seen[h] = 1;
                table[h] = key;
                nodes[tail].key = key;
                nodes[tail].parent = cur;
                nodes[tail].piece = (int8_t)k;
                nodes[tail].dir = (int16_t)DIRS[di];
                depth[tail] = depth[cur] + 1;
                it.f = depth[tail] + 4 * heuristic(&n, dist);
                it.node = tail;
                heap_push(heap, &heap_n, it);
                ++tail;
            }
    }
done:
    if (found >= 0) {
        int n = 0;
        for (int i = found; nodes[i].parent >= 0; i = nodes[i].parent) ++n;
        if (n <= cap) {
            int at = n;
            for (int i = found; nodes[i].parent >= 0; i = nodes[i].parent) {
                --at;
                piece[at] = nodes[i].piece;
                dir[at] = nodes[i].dir;
            }
            result = n;
        }
    }
    if (getenv("D3_DEBUG") != NULL) fprintf(stderr, "solve: states=%d found=%d moves=%d\n", tail, found, result);
    free(nodes); free(depth); free(heap); free(seen); free(table);
    return result;
}

typedef struct { SessionAd3Binding *b; const SceneActionInfo *info; size_t row; uint32_t phase; unsigned long visits, renders, blits; } Run;

static int visit(Run *r, int *completed)
{
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    CpzRenderResult rr;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = r->phase;
    if (session_ad3_handler(r->b, r->row, r->info, &st, &out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out.phase;
    r->visits++;
    *completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
    if (!*completed) {
        if (session_ad3_render(r->b, &rr) != CPZ_OK || !rr.valid) return 0;
        r->renders++;
        r->blits += rr.count;
    }
    return 1;
}

/* View-relative pointer position inside the edge zone of the piece cell (r, c) for direction d. */
static int zone_point(const uint8_t *body, int r, int c, int d, int32_t *x, int32_t *y)
{
    const int32_t cw = rd32(body, O_PIECE_SRC + 8) - rd32(body, O_PIECE_SRC), ch = rd32(body, O_PIECE_SRC + 12) - rd32(body, O_PIECE_SRC + 4);
    const int32_t gap = rd16(body, O_GAP), q = cw / 4, hh = ch / 2;
    const int32_t left = gap * c + rd32(body, O_ORIGIN_X) + c * cw, top = gap * r + rd32(body, O_ORIGIN_Y) + r * ch;
    const int32_t right = left + cw, bottom = top + ch;
    if (q < 2 || hh < 2) return 0;
    switch (d) {
    case D_LEFT: *x = left + q / 2; *y = (top + bottom) / 2; break;
    case D_RIGHT: *x = right - q / 2; *y = (top + bottom) / 2; break;
    case D_UP: *x = (left + right) / 2; *y = top + hh / 2; break;
    default: *x = (left + right) / 2; *y = bottom - hh / 2; break;
    }
    return 1;
}

static int cand_of(int d) { return d == D_LEFT ? CPZ_CANDIDATE_LEFT : d == D_UP ? CPZ_CANDIDATE_UP : d == D_DOWN ? CPZ_CANDIDATE_DOWN : CPZ_CANDIDATE_RIGHT; }

/* Compare the world with the independent model: pieces and their cells. */
static int world_matches(const SessionAd3Binding *b, const Puzzle *p)
{
    const CpzWorld *w = session_ad3_world(b);
    for (int a = 0; a < p->rows; ++a)
        for (int c = 0; c < p->cols; ++c) {
            int expect = 0;
            for (int k = 0; k < p->np; ++k)
                if (p->pr[k] == a && p->pc[k] == c) expect = k + 1;
            if (w->cell[a][c].piece != expect || w->cell[a][c].type != p->type[a][c]) return 0;
        }
    return 1;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAd3Host host;
    unsigned long rows = 0, solved = 0, canceled = 0, error = 0, scenes = 0, moves = 0, probes_open = 0, probes_shut = 0, unsolvable = 0;
    unsigned long dir_moves[4] = {0, 0, 0, 0}, dir_open[4] = {0, 0, 0, 0}, visits = 0, renders = 0, blits = 0, stubs = 0;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.alloc_slot = alloc_slot;
    host.kernel.register_slot = register_slot;
    host.kernel.load_surface = load_surface;
    host.kernel.set_slot_surface = set_slot_surface;
    host.kernel.release_surface = release_surface;
    host.kernel.release_slot = release_slot;
    host.kernel.mark_dirty = mark_dirty;
    host.kernel.view_origin = view_origin;
    host.kernel.clear_pending_item = clear_item;
    host.kernel.sound_prepare = sound_prepare;
    host.kernel.sound_stop = sound_stop;
    host.kernel.sound_play = sound_play;
    host.kernel.sound_busy = sound_busy;
    host.kernel.tick = tick;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, d3rows = 0;
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        bytes = (unsigned char *)malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) { fclose(f); free(bytes); continue; }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene == NULL) { free(bytes); continue; }
        count = scene_resource_action_count(scene);
        for (size_t i = 0; i < count; ++i) {
            SceneActionInfo info;
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AD3_TYPE) ++d3rows;
        }
        if (d3rows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAd3Binding *binding = session_ad3_create(&host);
            if (binding == NULL || session_ad3_begin_scene(binding, scene) != CPZ_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_ad3_failure(binding) : "create");
                if (pass == 0) { error += d3rows; rows += d3rows; }
                session_ad3_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                Run run;
                Puzzle puz;
                int good = 1, completed = 0;
                const char *why = "phase0";
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AD3_TYPE) continue;
                if (pass == 0) ++rows;
                memset(&run, 0, sizeof run);
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.phase = 0u;
                good = load_puzzle(info.typed_body, &puz) && visit(&run, &completed) && run.phase == 1u && !completed &&
                       session_ad3_object(binding)->active != 0 && world_matches(binding, &puz);
                if (pass == 0) {
                    static int piece[MAX_PATH], dir[MAX_PATH];
                    int nmoves = good ? solve(&puz, piece, dir, MAX_PATH) : -1;
                    why = "probe";
                    /* every piece/direction probe against the independent move rules */
                    for (int k = 0; good && k < puz.np; ++k)
                        for (int di = 0; good && di < 4; ++di) {
                            CpzPointerResult pr;
                            int32_t x, y;
                            const int open = may_step(&puz, k, DIRS[di]);
                            if (!zone_point(info.typed_body, puz.pr[k], puz.pc[k], DIRS[di], &x, &y)) { ++stubs; continue; }
                            good = session_ad3_pointer_move(binding, x, y, &pr) == CPZ_OK;
                            if (good && open) good = pr.hit && pr.candidate == cand_of(DIRS[di]) && pr.cursor_written;
                            if (good && !open) {
                                /* a closed direction never claims the pointer for the piece; only the cancel rectangle can */
                                const int32_t l = rd32(info.typed_body, O_CANCEL_RECT), t = rd32(info.typed_body, O_CANCEL_RECT + 4),
                                              r2 = rd32(info.typed_body, O_CANCEL_RECT + 8), b2 = rd32(info.typed_body, O_CANCEL_RECT + 12);
                                const int in_cancel = l <= x && x <= r2 && t <= y && y <= b2;
                                good = in_cancel ? (pr.hit && pr.candidate == CPZ_CANDIDATE_CANCEL) : (!pr.hit && pr.candidate == -1);
                            }
                            if (!good && getenv("D3_DEBUG") != NULL)
                                fprintf(stderr, "probe piece=%d dir=%x open=%d at r%d c%d point %d,%d hit=%d cand=%x\n", k + 1, DIRS[di], open, puz.pr[k], puz.pc[k], x, y, pr.hit, pr.candidate);
                            if (open) { ++probes_open; ++dir_open[di]; } else ++probes_shut;
                        }
                    if (good && nmoves < 0) { ++unsolvable; good = 0; why = "no-solution"; }
                    if (good) why = "moves";
                    for (int m = 0; good && m < nmoves; ++m) {
                        CpzPointerResult pr;
                        CpzClickResult cr;
                        int32_t x, y;
                        int guard = 0;
                        const int d = dir[m], k = piece[m];
                        if (!zone_point(info.typed_body, puz.pr[k], puz.pc[k], d, &x, &y)) { good = 0; break; }
                        good = session_ad3_pointer_move(binding, x, y, &pr) == CPZ_OK && pr.hit && pr.candidate == cand_of(d) &&
                               session_ad3_click(binding, run.phase, pr.candidate, 1, &cr) == CPZ_OK && cr.move_started && !cr.cancel_asked &&
                               cr.new_phase == run.phase;
                        good = good && session_ad3_object(binding)->state == CPZ_STATE_MOVING;
                        while (good && session_ad3_object(binding)->state == CPZ_STATE_MOVING && guard++ < 400)
                            good = visit(&run, &completed) && !completed;
                        good = good && guard < 400 && slide(&puz, k, d) && world_matches(binding, &puz) &&
                               session_ad3_object(binding)->state == CPZ_STATE_IDLE;
                        if (good) { ++moves; ++dir_moves[d == D_LEFT ? 0 : d == D_UP ? 1 : d == D_DOWN ? 2 : 3]; }
                    }
                    if (good) why = "finish";
                    /* solved scan, delay, final sound, phase 2 */
                    for (int v = 0; good && v < 200 && !completed; ++v) good = visit(&run, &completed);
                    good = good && completed && run.phase == 0u && session_ad3_object(binding)->active == 0 && is_solved(&puz);
                    if (good) ++solved;
                } else {
                    CpzPointerResult pr;
                    CpzClickResult cr;
                    const int32_t cx = (rd32(info.typed_body, O_CANCEL_RECT) + rd32(info.typed_body, O_CANCEL_RECT + 8)) / 2;
                    const int32_t cy = (rd32(info.typed_body, O_CANCEL_RECT + 4) + rd32(info.typed_body, O_CANCEL_RECT + 12)) / 2;
                    /* one move first when any piece can start one, so the cancel happens on a changed grid */
                    int mp = -1, md = 0;
                    for (int k = 0; mp < 0 && k < puz.np; ++k)
                        for (int di = 0; mp < 0 && di < 4; ++di)
                            if (may_step(&puz, k, DIRS[di])) { mp = k; md = DIRS[di]; }
                    if (good && mp >= 0) {
                        int32_t x, y, guard = 0;
                        if (!zone_point(info.typed_body, puz.pr[mp], puz.pc[mp], md, &x, &y)) good = 0;
                        good = good && session_ad3_pointer_move(binding, x, y, &pr) == CPZ_OK && pr.hit &&
                               session_ad3_click(binding, run.phase, pr.candidate, 1, &cr) == CPZ_OK && cr.move_started;
                        while (good && session_ad3_object(binding)->state == CPZ_STATE_MOVING && guard++ < 400)
                            good = visit(&run, &completed) && !completed;
                        good = good && guard < 400 && slide(&puz, mp, md) && world_matches(binding, &puz);
                    }
                    good = good && session_ad3_pointer_move(binding, cx, cy, &pr) == CPZ_OK && pr.hit && pr.candidate == CPZ_CANDIDATE_CANCEL &&
                           pr.cursor_kind == CPZ_CURSOR_CANCEL &&
                           session_ad3_click(binding, run.phase, pr.candidate, 1, &cr) == CPZ_OK && cr.cancel_asked && cr.new_phase == 2u;
                    run.phase = cr.new_phase;
                    good = good && visit(&run, &completed) && completed && run.phase == 0u && session_ad3_object(binding)->active == 0;
                    if (good) ++canceled;
                }
                visits += run.visits;
                renders += run.renders;
                blits += run.blits;
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d stage=%s %s\n", argv[a], i, pass, why, session_ad3_failure(binding));
                }
            }
            session_ad3_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu solved=%lu canceled=%lu error=%lu moves=%lu moves_left=%lu moves_up=%lu moves_down=%lu moves_right=%lu "
           "open=%lu shut=%lu open_left=%lu open_up=%lu open_down=%lu open_right=%lu unsolvable=%lu stubs=%lu visits=%lu renders=%lu blits=%lu "
           "loads=%d releases=%d plays=%d transitions=%d flag_stores=%d registers=%d\n",
           scenes, rows, solved, canceled, error, moves, dir_moves[0], dir_moves[1], dir_moves[2], dir_moves[3], probes_open, probes_shut,
           dir_open[0], dir_open[1], dir_open[2], dir_open[3], unsolvable, stubs, visits, renders, blits, ctx.loads, ctx.releases,
           ctx.plays, ctx.transitions, ctx.flag_stores, ctx.registers);
    return error == 0 ? 0 : 1;
}
