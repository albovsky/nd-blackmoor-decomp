# FUN_0050a440
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050a440
# extent:       0x0050a440-0x0050a450 (16 code bytes)
# span:         0x0050a440-0x0050a450 (code 16, tables 0, padding 0)
# sha256:       3c0af53442dd274c4330af4a2d96f4e14ee436ee9a28cd707da60e15655ff36a
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050a440
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

.org 0x0050a440 - 0x401000
.globl FUN_0050a440
FUN_0050a440:
    # block 0x0050a440: entry, 4 instruction(s), ends with je to 0x0050a44f (forward)
    mov ecx, dword ptr [esp + stk_4]             # 0050a440
    {load} xor eax, eax                          # 0050a444
    test ecx, ecx                                # 0050a446
    je.d8 L_0050a44f                             # 0050a448
L_0050a44a:
    # block 0x0050a44a: entered by jne at 0x0050a44d; fall-through of je at 0x0050a448, 3 instruction(s), ends with jne to 0x0050a44a (backward)
    inc eax                                      # 0050a44a
    shr ecx                                      # 0050a44b
    jne.d8 L_0050a44a                            # 0050a44d
L_0050a44f:
    # block 0x0050a44f: entered by je at 0x0050a448; fall-through of jne at 0x0050a44d, 1 instruction(s), ends with ret
    ret                                          # 0050a44f

