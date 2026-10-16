# FUN_005028f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005028f0
# extent:       0x005028f0-0x0050290d (29 code bytes)
# span:         0x005028f0-0x00502910 (code 29, tables 0, padding 3)
# sha256:       804aebc83287caff9afddc6aceec4457ce28c79eacbe15ca1dd5edfae8e10d3a
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005028f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_30; [esp + n] stk_8
# callees:      calls FUN_00502820, FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_00502820, .text + (0x00502820 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x005028f0 - 0x401000
.globl FUN_005028f0
FUN_005028f0:
    # block 0x005028f0: entry, 5 instruction(s), ends with je to 0x0050290b (forward)
    push esi                                     # 005028f0
    mov esi, dword ptr [esp + stk_8]             # 005028f1
    mov eax, dword ptr [esi + field_30]          # 005028f5
    test eax, eax                                # 005028f8
    je.d8 L_0050290b                             # 005028fa
    # block 0x005028fc: entered by fall-through of je at 0x005028fa, 5 instruction(s), calls FUN_00502820, FUN_0050e936, falls into the block at 0x0050290b
    push esi                                     # 005028fc
    call FUN_00502820                            # 005028fd
    push esi                                     # 00502902
    call FUN_0050e936                            # 00502903
    add esp, 0x8                                 # 00502908
L_0050290b:
    # block 0x0050290b: entered by je at 0x005028fa, 2 instruction(s), ends with ret
    pop esi                                      # 0050290b
    ret                                          # 0050290c

# --- data items (not part of the function) -------------------------
.org 0x0050290d - 0x401000
PAD_0050290d:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

