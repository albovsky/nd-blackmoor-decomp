# FUN_0051ec6f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ec6f
# extent:       0x0051ec6f-0x0051ec84 (21 code bytes)
# span:         0x0051ec6f-0x0051ec84 (code 21, tables 0, padding 0)
# sha256:       26f1c55cb7f7d1d411966af24cfb1b2b569c5fec991560f87f461d732f0afa87
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ec6f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      calls FUN_00525397, FUN_00525371
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x0051ec6f - 0x401000
.globl FUN_0051ec6f
FUN_0051ec6f:
    # block 0x0051ec6f: entry, 4 instruction(s), calls FUN_00525397, ends with jne to 0x0051ec83 (forward)
    call FUN_00525397                            # 0051ec6f
    mov eax, dword ptr [eax + field_4]           # 0051ec74
    test eax, eax                                # 0051ec77
    jne.d8 L_0051ec83                            # 0051ec79
    # block 0x0051ec7b: entered by fall-through of jne at 0x0051ec79, 2 instruction(s), calls FUN_00525371, falls into the block at 0x0051ec83
    call FUN_00525371                            # 0051ec7b
    mov eax, dword ptr [eax + field_4]           # 0051ec80
L_0051ec83:
    # block 0x0051ec83: entered by jne at 0x0051ec79, 1 instruction(s), ends with ret
    ret                                          # 0051ec83

