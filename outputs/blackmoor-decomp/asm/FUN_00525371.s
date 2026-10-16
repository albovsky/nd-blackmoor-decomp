# FUN_00525371
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525371
# extent:       0x00525371-0x00525397 (38 code bytes)
# span:         0x00525371-0x00525397 (code 38, tables 0, padding 0)
# sha256:       c30ca597643a85bf72ad2b63f339bf9e158150d7426d8c4ae3a781a34ea323d5
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525371
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4
# callees:      calls FUN_00525b0f, FUN_00525bd1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x00525371 - 0x401000
.globl FUN_00525371
FUN_00525371:
    # block 0x00525371: entry, 6 instruction(s), calls FUN_00525b0f, ends with jne to 0x00525396 (forward)
    push 0x52496c                                # 00525371
    mov ecx, 0x63c444                            # 00525376
    call FUN_00525b0f                            # 0052537b
    mov eax, dword ptr [eax + field_4]           # 00525380
    test eax, eax                                # 00525383
    jne.d8 L_00525396                            # 00525385
    # block 0x00525387: entered by fall-through of jne at 0x00525385, 3 instruction(s), calls FUN_00525bd1, falls into the block at 0x00525396
    push 0x5253e3                                # 00525387
    mov ecx, 0x63c440                            # 0052538c
    call FUN_00525bd1                            # 00525391
L_00525396:
    # block 0x00525396: entered by jne at 0x00525385, 1 instruction(s), ends with ret
    ret                                          # 00525396

