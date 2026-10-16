# FUN_0050b4b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b4b0
# extent:       0x0050b4b0-0x0050b4c6 (22 code bytes)
# span:         0x0050b4b0-0x0050b4d0 (code 22, tables 0, padding 10)
# sha256:       d9e78ee2906fe96f00d9eec776967530272e9bd98d6f78ce3f68924bd43947a3
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b4b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050b4b0 - 0x401000
.globl FUN_0050b4b0
FUN_0050b4b0:
    # block 0x0050b4b0: entry, 4 instruction(s), ends with je to 0x0050b4c2 (forward)
    push edi                                     # 0050b4b0
    mov edi, dword ptr [esp + stk_8]             # 0050b4b1
    test edi, edi                                # 0050b4b5
    je.d8 L_0050b4c2                             # 0050b4b7
    # block 0x0050b4b9: entered by fall-through of je at 0x0050b4b7, 3 instruction(s), falls into the block at 0x0050b4c2
    mov ecx, 0x7                                 # 0050b4b9
    {load} xor eax, eax                          # 0050b4be
    rep stosd dword ptr es:[edi], eax            # 0050b4c0
L_0050b4c2:
    # block 0x0050b4c2: entered by je at 0x0050b4b7, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050b4c2
    pop edi                                      # 0050b4c4
    ret                                          # 0050b4c5

# --- data items (not part of the function) -------------------------
.org 0x0050b4c6 - 0x401000
PAD_0050b4c6:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

