# FUN_00502da0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502da0
# extent:       0x00502da0-0x00502e00 (96 code bytes)
# span:         0x00502da0-0x00502e00 (code 96, tables 0, padding 0)
# sha256:       781015b1d192efc8d6307a31c4e99e39b9c2ee5e27cc4e045c536ad3f625376f
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502da0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00502e00
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00502da0 - 0x401000
.globl FUN_00502da0
FUN_00502da0:
    # block 0x00502da0: entry, 30 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00502da0
    {load} mov ecx, eax                          # 00502da4
    shr ecx, 0x10                                # 00502da6
    shl eax, 0x10                                # 00502da9
    {load} or ecx, eax                           # 00502dac
    {load} mov eax, ecx                          # 00502dae
    and ah, 0x0                                  # 00502db0
    shr ecx, 0x8                                 # 00502db3
    shl eax, 0x8                                 # 00502db6
    and ecx, 0xff00ff                            # 00502db9
    {load} or eax, ecx                           # 00502dbf
    {load} mov ecx, eax                          # 00502dc1
    and ecx, 0xff0f0f0f                          # 00502dc3
    shr eax, 0x4                                 # 00502dc9
    shl ecx, 0x4                                 # 00502dcc
    and eax, 0xf0f0f0f                           # 00502dcf
    {load} or ecx, eax                           # 00502dd4
    {load} mov edx, ecx                          # 00502dd6
    and edx, 0xf3333333                          # 00502dd8
    shr ecx, 0x2                                 # 00502dde
    shl edx, 0x2                                 # 00502de1
    and ecx, 0x33333333                          # 00502de4
    {load} or edx, ecx                           # 00502dea
    {load} mov eax, edx                          # 00502dec
    and edx, 0xd5555555                          # 00502dee
    shr eax                                      # 00502df4
    and eax, 0x55555555                          # 00502df6
    shl edx                                      # 00502dfb
    {load} or eax, edx                           # 00502dfd
    ret                                          # 00502dff

