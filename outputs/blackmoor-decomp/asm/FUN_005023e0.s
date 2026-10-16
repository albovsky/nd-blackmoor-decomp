# FUN_005023e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005023e0
# extent:       0x005023e0-0x005023f0 (16 code bytes)
# span:         0x005023e0-0x005023f0 (code 16, tables 0, padding 0)
# sha256:       3c0af53442dd274c4330af4a2d96f4e14ee436ee9a28cd707da60e15655ff36a
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005023e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x005023e0 - 0x401000
.globl FUN_005023e0
FUN_005023e0:
    # block 0x005023e0: entry, 4 instruction(s), ends with je to 0x005023ef (forward)
    mov ecx, dword ptr [esp + stk_4]             # 005023e0
    {load} xor eax, eax                          # 005023e4
    test ecx, ecx                                # 005023e6
    je.d8 L_005023ef                             # 005023e8
L_005023ea:
    # block 0x005023ea: entered by jne at 0x005023ed; fall-through of je at 0x005023e8, 3 instruction(s), ends with jne to 0x005023ea (backward)
    inc eax                                      # 005023ea
    shr ecx                                      # 005023eb
    jne.d8 L_005023ea                            # 005023ed
L_005023ef:
    # block 0x005023ef: entered by je at 0x005023e8; fall-through of jne at 0x005023ed, 1 instruction(s), ends with ret
    ret                                          # 005023ef

