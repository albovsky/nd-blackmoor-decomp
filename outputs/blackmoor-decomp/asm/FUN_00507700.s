# FUN_00507700
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507700
# extent:       0x00507700-0x0050771f (31 code bytes)
# span:         0x00507700-0x00507720 (code 31, tables 0, padding 1)
# sha256:       49e4852a0ea4dadc34127efca261e6498ebafbce48ede8b447e0567ddb799962
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507700
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

.org 0x00507700 - 0x401000
.globl FUN_00507700
FUN_00507700:
    # block 0x00507700: entry, 3 instruction(s), ends with je to 0x0050771e (forward)
    mov edx, dword ptr [esp + stk_4]             # 00507700
    test edx, edx                                # 00507704
    je.d8 L_0050771e                             # 00507706
    # block 0x00507708: entered by fall-through of je at 0x00507706, 9 instruction(s), calls FUN_0050e936, falls into the block at 0x0050771e
    push edi                                     # 00507708
    mov ecx, 0x1c5                               # 00507709
    {load} xor eax, eax                          # 0050770e
    {load} mov edi, edx                          # 00507710
    rep stosd dword ptr es:[edi], eax            # 00507712
    push edx                                     # 00507714
    call FUN_0050e936                            # 00507715
    add esp, 0x4                                 # 0050771a
    pop edi                                      # 0050771d
L_0050771e:
    # block 0x0050771e: entered by je at 0x00507706, 1 instruction(s), ends with ret
    ret                                          # 0050771e

# --- data items (not part of the function) -------------------------
.org 0x0050771f - 0x401000
PAD_0050771f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

