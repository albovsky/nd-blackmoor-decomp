# FUN_00508bc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508bc0
# extent:       0x00508bc0-0x00508bdf (31 code bytes)
# span:         0x00508bc0-0x00508be0 (code 31, tables 0, padding 1)
# sha256:       6246f6dae2b8b738fc2070ebd0f283d9529c4c2680672c515ffd31f5eff68792
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508bc0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00508be0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00508bc0 - 0x401000
.globl FUN_00508bc0
FUN_00508bc0:
    # block 0x00508bc0: entry, 3 instruction(s), ends with je to 0x00508bde (forward)
    mov edx, dword ptr [esp + stk_4]             # 00508bc0
    test edx, edx                                # 00508bc4
    je.d8 L_00508bde                             # 00508bc6
    # block 0x00508bc8: entered by fall-through of je at 0x00508bc6, 9 instruction(s), calls FUN_0050e936, falls into the block at 0x00508bde
    push edi                                     # 00508bc8
    mov ecx, 0x118                               # 00508bc9
    {load} xor eax, eax                          # 00508bce
    {load} mov edi, edx                          # 00508bd0
    rep stosd dword ptr es:[edi], eax            # 00508bd2
    push edx                                     # 00508bd4
    call FUN_0050e936                            # 00508bd5
    add esp, 0x4                                 # 00508bda
    pop edi                                      # 00508bdd
L_00508bde:
    # block 0x00508bde: entered by je at 0x00508bc6, 1 instruction(s), ends with ret
    ret                                          # 00508bde

# --- data items (not part of the function) -------------------------
.org 0x00508bdf - 0x401000
PAD_00508bdf:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

