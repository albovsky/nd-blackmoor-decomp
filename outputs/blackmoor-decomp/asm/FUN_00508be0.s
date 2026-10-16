# FUN_00508be0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00508be0
# extent:       0x00508be0-0x00508bff (31 code bytes)
# span:         0x00508be0-0x00508c00 (code 31, tables 0, padding 1)
# sha256:       55ff83caa0323196771855079f5cff469cde8ac88c5227a7e9794857e7001354
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508bc0 (+0x20)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00508be0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00508c00
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00508be0 - 0x401000
.globl FUN_00508be0
FUN_00508be0:
    # block 0x00508be0: entry, 3 instruction(s), ends with je to 0x00508bfe (forward)
    mov edx, dword ptr [esp + stk_4]             # 00508be0
    test edx, edx                                # 00508be4
    je.d8 L_00508bfe                             # 00508be6
    # block 0x00508be8: entered by fall-through of je at 0x00508be6, 9 instruction(s), calls FUN_0050e936, falls into the block at 0x00508bfe
    push edi                                     # 00508be8
    mov ecx, 0x148                               # 00508be9
    {load} xor eax, eax                          # 00508bee
    {load} mov edi, edx                          # 00508bf0
    rep stosd dword ptr es:[edi], eax            # 00508bf2
    push edx                                     # 00508bf4
    call FUN_0050e936                            # 00508bf5
    add esp, 0x4                                 # 00508bfa
    pop edi                                      # 00508bfd
L_00508bfe:
    # block 0x00508bfe: entered by je at 0x00508be6, 1 instruction(s), ends with ret
    ret                                          # 00508bfe

# --- data items (not part of the function) -------------------------
.org 0x00508bff - 0x401000
PAD_00508bff:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

