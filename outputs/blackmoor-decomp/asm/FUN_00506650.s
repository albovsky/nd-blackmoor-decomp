# FUN_00506650
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00506650
# extent:       0x00506650-0x0050666f (31 code bytes)
# span:         0x00506650-0x00506670 (code 31, tables 0, padding 1)
# sha256:       4c101266b7712d1c16fb1d6f99421e0ca3f96efa372cfcca541dd8a0aa2a1b5b
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00506650
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00506650 - 0x401000
.globl FUN_00506650
FUN_00506650:
    # block 0x00506650: entry, 3 instruction(s), ends with je to 0x0050666e (forward)
    mov edx, dword ptr [esp + stk_4]             # 00506650
    test edx, edx                                # 00506654
    je.d8 L_0050666e                             # 00506656
    # block 0x00506658: entered by fall-through of je at 0x00506656, 9 instruction(s), calls FUN_0050e936, falls into the block at 0x0050666e
    push edi                                     # 00506658
    mov ecx, 0x322                               # 00506659
    {load} xor eax, eax                          # 0050665e
    {load} mov edi, edx                          # 00506660
    rep stosd dword ptr es:[edi], eax            # 00506662
    push edx                                     # 00506664
    call FUN_0050e936                            # 00506665
    add esp, 0x4                                 # 0050666a
    pop edi                                      # 0050666d
L_0050666e:
    # block 0x0050666e: entered by je at 0x00506656, 1 instruction(s), ends with ret
    ret                                          # 0050666e

# --- data items (not part of the function) -------------------------
.org 0x0050666f - 0x401000
PAD_0050666f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

