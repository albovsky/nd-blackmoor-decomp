# FUN_00502370
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502370
# extent:       0x00502370-0x005023d5 (101 code bytes)
# span:         0x00502370-0x005023e0 (code 101, tables 0, padding 11)
# sha256:       6f2f70101386f3b6e6866a02ad7adcbd14d9df0a1b1ec7ae2ae9c0756a0c3876
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502370
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_10, stk_18
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 39 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x00502370 - 0x401000
.globl FUN_00502370
FUN_00502370:
    # block 0x00502370: entry, 39 instruction(s), ends with ret
    push ebx                                     # 00502370
    push esi                                     # 00502371
    mov esi, dword ptr [esp + stk_10]            # 00502372
    push edi                                     # 00502376
    mov edi, dword ptr [esp + stk_18]            # 00502377
    {load} xor ecx, ecx                          # 0050237b
    {load} cmp esi, edi                          # 0050237d
    {load} mov eax, esi                          # 0050237f
    setg cl                                      # 00502381
    {load} sub eax, edi                          # 00502384
    dec ecx                                      # 00502386
    cdq                                          # 00502387
    {load} mov ebx, eax                          # 00502388
    mov eax, 0x1f                                # 0050238a
    {load} xor ebx, edx                          # 0050238f
    {load} sub ebx, edx                          # 00502391
    {load} mov edx, ecx                          # 00502393
    not edx                                      # 00502395
    {load} and edx, esi                          # 00502397
    {load} and ecx, edi                          # 00502399
    {load} sub eax, ebx                          # 0050239b
    {load} or edx, ecx                           # 0050239d
    {load} xor ecx, ecx                          # 0050239f
    pop edi                                      # 005023a1
    test eax, eax                                # 005023a2
    setl cl                                      # 005023a4
    dec ecx                                      # 005023a7
    pop esi                                      # 005023a8
    {load} and ecx, eax                          # 005023a9
    mov eax, dword ptr [esp + stk_18]            # 005023ab
    pop ebx                                      # 005023af
    fld dword ptr [4*ecx + 0x566960]             # 005023b0
    fadd dword ptr [0x52cbf4]                    # 005023b7
    fmul dword ptr [4*edx + 0x566560]            # 005023bd
    mov edx, dword ptr [esp + stk_10]            # 005023c4
    fmul dword ptr [esp + stk_4]                 # 005023c8
    fstp dword ptr [edx]                         # 005023cc
    mov dword ptr [eax], 0x0                     # 005023ce
    ret                                          # 005023d4

# --- data items (not part of the function) -------------------------
.org 0x005023d5 - 0x401000
PAD_005023d5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

