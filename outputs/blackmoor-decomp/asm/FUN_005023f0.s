# FUN_005023f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005023f0
# extent:       0x005023f0-0x0050243f (79 code bytes)
# span:         0x005023f0-0x00502440 (code 79, tables 0, padding 1)
# sha256:       54ec1222082750f190c627c189ffe2320c68cb99efddd2d3a44d7f00c9225c64
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005023f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_c
# callees:      calls FUN_0050f253
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050f253, .text + (0x0050f253 - 0x401000)

.org 0x005023f0 - 0x401000
.globl FUN_005023f0
FUN_005023f0:
    # block 0x005023f0: entry, 12 instruction(s), ends with je to 0x00502426 (forward)
    sub esp, 0x8                                 # 005023f0
    mov ecx, dword ptr [esp + stk_c]             # 005023f3
    {load} mov eax, ecx                          # 005023f7
    and eax, 0x1fffff                            # 005023f9
    mov dword ptr [esp + stk_c], eax             # 005023fe
    {load} mov eax, ecx                          # 00502402
    fild dword ptr [esp + stk_c]                 # 00502404
    sar eax, 0x15                                # 00502408
    and eax, 0x3ff                               # 0050240b
    {disp8} fstp qword ptr [esp]                 # 00502410
    test ecx, 0x80000000                         # 00502414
    je.d8 L_00502426                             # 0050241a
    # block 0x0050241c: entered by fall-through of je at 0x0050241a, 3 instruction(s), falls into the block at 0x00502426
    {disp8} fld qword ptr [esp]                  # 0050241c
    fchs                                         # 00502420
    {disp8} fstp qword ptr [esp]                 # 00502422
L_00502426:
    # block 0x00502426: entered by je at 0x0050241a, 9 instruction(s), calls FUN_0050f253, ends with ret
    mov ecx, dword ptr [esp + stk_4]             # 00502426
    {disp8} mov edx, dword ptr [esp]             # 0050242a
    add eax, 0xfffffcec                          # 0050242e
    push eax                                     # 00502433
    push ecx                                     # 00502434
    push edx                                     # 00502435
    call FUN_0050f253                            # 00502436
    add esp, 0x14                                # 0050243b
    ret                                          # 0050243e

# --- data items (not part of the function) -------------------------
.org 0x0050243f - 0x401000
PAD_0050243f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

