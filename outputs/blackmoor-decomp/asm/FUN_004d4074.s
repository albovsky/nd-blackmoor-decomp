# FUN_004d4074
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4074
# extent:       0x004d4074-0x004d4192 (286 code bytes)
# span:         0x004d4074-0x004d4192 (code 286, tables 0, padding 0)
# sha256:       25d690c87a23f9c118959f387b60c92ac95e5babed2aaad148e6e33bb32052bd
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_clock_hands_draw
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4d4074.c.txt, not original source) refers to the data labelled s_clock_hands_0055a4c4
# name-note:    Picks a quarter from the minute value and draws the clock hands images for hour and minute positions, tagged clock_hands.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_2a0, field_2e0; [edx + n] field_120, field_1e0
# callees:      calls FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 77 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_120, 0x120  # offset +0x120
.equ field_1e0, 0x1e0  # offset +0x1e0
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2e0, 0x2e0  # offset +0x2e0

# --- external targets -----------------------------------------------
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004d4074 - 0x401000
.globl FUN_004d4074
FUN_004d4074:
    # block 0x004d4074: entry, 12 instruction(s), ends with jl to 0x004d40af (forward)
    push ebp                                     # 004d4074
    {load} mov ebp, esp                          # 004d4075
    sub esp, 0xc                                 # 004d4077
    mov dword ptr [ebp - local_c], ecx           # 004d407a
    movsx eax, word ptr [0x585d51]               # 004d407d
    cdq                                          # 004d4084
    mov ecx, 0xc                                 # 004d4085
    idiv ecx                                     # 004d408a
    mov word ptr [ebp - local_4], dx             # 004d408c
    movsx edx, word ptr [0x585d4f]               # 004d4090
    test edx, edx                                # 004d4097
    jl.d8 L_004d40af                             # 004d4099
    # block 0x004d409b: entered by fall-through of jl at 0x004d4099, 3 instruction(s), ends with jg to 0x004d40af (forward)
    movsx eax, word ptr [0x585d4f]               # 004d409b
    cmp eax, 0xf                                 # 004d40a2
    jg.d8 L_004d40af                             # 004d40a5
    # block 0x004d40a7: entered by fall-through of jg at 0x004d40a5, 2 instruction(s), ends with forward jump to 0x004d410d
    mov word ptr [ebp - local_8], 0x0            # 004d40a7
    jmp.d8 L_004d410d                            # 004d40ad
L_004d40af:
    # block 0x004d40af: entered by jl at 0x004d4099; jg at 0x004d40a5, 3 instruction(s), ends with jl to 0x004d40cf (forward)
    movsx ecx, word ptr [0x585d4f]               # 004d40af
    cmp ecx, 0x10                                # 004d40b6
    jl.d8 L_004d40cf                             # 004d40b9
    # block 0x004d40bb: entered by fall-through of jl at 0x004d40b9, 3 instruction(s), ends with jg to 0x004d40cf (forward)
    movsx edx, word ptr [0x585d4f]               # 004d40bb
    cmp edx, 0x1e                                # 004d40c2
    jg.d8 L_004d40cf                             # 004d40c5
    # block 0x004d40c7: entered by fall-through of jg at 0x004d40c5, 2 instruction(s), ends with forward jump to 0x004d410d
    mov word ptr [ebp - local_8], 0x1            # 004d40c7
    jmp.d8 L_004d410d                            # 004d40cd
L_004d40cf:
    # block 0x004d40cf: entered by jl at 0x004d40b9; jg at 0x004d40c5, 3 instruction(s), ends with jl to 0x004d40ef (forward)
    movsx eax, word ptr [0x585d4f]               # 004d40cf
    cmp eax, 0x1f                                # 004d40d6
    jl.d8 L_004d40ef                             # 004d40d9
    # block 0x004d40db: entered by fall-through of jl at 0x004d40d9, 3 instruction(s), ends with jg to 0x004d40ef (forward)
    movsx ecx, word ptr [0x585d4f]               # 004d40db
    cmp ecx, 0x2d                                # 004d40e2
    jg.d8 L_004d40ef                             # 004d40e5
    # block 0x004d40e7: entered by fall-through of jg at 0x004d40e5, 2 instruction(s), ends with forward jump to 0x004d410d
    mov word ptr [ebp - local_8], 0x2            # 004d40e7
    jmp.d8 L_004d410d                            # 004d40ed
L_004d40ef:
    # block 0x004d40ef: entered by jl at 0x004d40d9; jg at 0x004d40e5, 3 instruction(s), ends with jl to 0x004d410d (forward)
    movsx edx, word ptr [0x585d4f]               # 004d40ef
    cmp edx, 0x2e                                # 004d40f6
    jl.d8 L_004d410d                             # 004d40f9
    # block 0x004d40fb: entered by fall-through of jl at 0x004d40f9, 3 instruction(s), ends with jg to 0x004d410d (forward)
    movsx eax, word ptr [0x585d4f]               # 004d40fb
    cmp eax, 0x3b                                # 004d4102
    jg.d8 L_004d410d                             # 004d4105
    # block 0x004d4107: entered by fall-through of jg at 0x004d4105, 1 instruction(s), falls into the block at 0x004d410d
    mov word ptr [ebp - local_8], 0x3            # 004d4107
L_004d410d:
    # block 0x004d410d: entered by jmp at 0x004d40ad; jmp at 0x004d40cd; jmp at 0x004d40ed; jl at 0x004d40f9; more, 37 instruction(s), calls FUN_004c5d4b, ends with ret
    push 0x55a4c4                                # 004d410d
    movsx ecx, word ptr [ebp - local_4]          # 004d4112
    shl ecx, 0x4                                 # 004d4116
    mov edx, dword ptr [ebp - local_c]           # 004d4119
    lea eax, [edx + ecx + field_1e0]             # 004d411c
    push eax                                     # 004d4123
    movsx ecx, word ptr [ebp - local_4]          # 004d4124
    shl ecx, 0x4                                 # 004d4128
    mov edx, dword ptr [ebp - local_c]           # 004d412b
    lea eax, [edx + ecx + field_120]             # 004d412e
    push eax                                     # 004d4135
    mov ecx, dword ptr [0x5cf665]                # 004d4136
    push ecx                                     # 004d413c
    mov edx, dword ptr [0x5d1c3f]                # 004d413d
    push edx                                     # 004d4143
    mov ecx, 0x5cf659                            # 004d4144
    call FUN_004c5d4b                            # 004d4149
    push 0x55a4d0                                # 004d414e
    movsx eax, word ptr [ebp - local_8]          # 004d4153
    shl eax, 0x4                                 # 004d4157
    mov ecx, dword ptr [ebp - local_c]           # 004d415a
    lea edx, [ecx + eax + field_2e0]             # 004d415d
    push edx                                     # 004d4164
    movsx eax, word ptr [ebp - local_8]          # 004d4165
    shl eax, 0x4                                 # 004d4169
    mov ecx, dword ptr [ebp - local_c]           # 004d416c
    lea edx, [ecx + eax + field_2a0]             # 004d416f
    push edx                                     # 004d4176
    mov eax, dword ptr [0x5cf665]                # 004d4177
    push eax                                     # 004d417c
    mov ecx, dword ptr [0x5d1c3f]                # 004d417d
    push ecx                                     # 004d4183
    mov ecx, 0x5cf659                            # 004d4184
    call FUN_004c5d4b                            # 004d4189
    {load} mov esp, ebp                          # 004d418e
    pop ebp                                      # 004d4190
    ret                                          # 004d4191

