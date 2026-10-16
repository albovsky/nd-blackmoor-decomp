# FUN_00503c00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503c00
# extent:       0x00503c00-0x00503c26 (38 code bytes)
# span:         0x00503c00-0x00503c30 (code 38, tables 0, padding 10)
# sha256:       da452ae5ce5283fe6b564c4f742236aafa3bd71a6f42926e0bd600c779e60bdd
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503c00
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_4, field_8; [esp + n] stk_4, stk_14
# callees:      calls FUN_00503c30
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00503c30, .text + (0x00503c30 - 0x401000)

.org 0x00503c00 - 0x401000
.globl FUN_00503c00
FUN_00503c00:
    # block 0x00503c00: entry, 4 instruction(s), ends with je to 0x00503c25 (forward)
    mov edx, dword ptr [esp + stk_4]             # 00503c00
    mov eax, dword ptr [edx]                     # 00503c04
    cmp eax, 0x1                                 # 00503c06
    je.d8 L_00503c25                             # 00503c09
    # block 0x00503c0b: entered by fall-through of je at 0x00503c09, 11 instruction(s), calls FUN_00503c30, falls into the block at 0x00503c25
    mov ecx, dword ptr [edx + field_4]           # 00503c0b
    mov edx, dword ptr [edx + field_8]           # 00503c0e
    push edx                                     # 00503c11
    lea edx, [ecx + 4*eax]                       # 00503c12
    push edx                                     # 00503c15
    push ecx                                     # 00503c16
    mov ecx, dword ptr [esp + stk_14]            # 00503c17
    push ecx                                     # 00503c1b
    push eax                                     # 00503c1c
    call FUN_00503c30                            # 00503c1d
    add esp, 0x14                                # 00503c22
L_00503c25:
    # block 0x00503c25: entered by je at 0x00503c09, 1 instruction(s), ends with ret
    ret                                          # 00503c25

# --- data items (not part of the function) -------------------------
.org 0x00503c26 - 0x401000
PAD_00503c26:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

