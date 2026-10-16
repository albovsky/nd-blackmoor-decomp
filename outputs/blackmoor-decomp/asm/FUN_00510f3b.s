# FUN_00510f3b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510f3b
# extent:       0x00510f3b-0x00510f91 (86 code bytes)
# span:         0x00510f3b-0x00510f91 (code 86, tables 0, padding 0)
# sha256:       8469dae18be92a5109903d3b5ab4a67ec72d3a59b4a10b996e7ea2b7e8ac7b79
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510f3b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       2 ebp-relative slot(s): local_4, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls LOC_00510f8c, tail jump FUN_00510eda; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         unreachable_code_entry:0x00510f78
# note:         unreachable_code_entry:0x00510f7c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_00510eda, .text + (0x00510eda - 0x401000)

.org 0x00510f3b - 0x401000
.globl FUN_00510f3b
FUN_00510f3b:
    # block 0x00510f3b: entry, 18 instruction(s), ends with je to 0x00510f83 (forward)
    push ebp                                     # 00510f3b
    {load} mov ebp, esp                          # 00510f3c
    push -0x1                                    # 00510f3e
    push 0x530420                                # 00510f40
    push 0x511930                                # 00510f45
    mov eax, dword ptr fs:[0x0]                  # 00510f4a
    push eax                                     # 00510f50
    mov dword ptr fs:[0x0], esp                  # 00510f51
    push ecx                                     # 00510f58
    push ecx                                     # 00510f59
    push ebx                                     # 00510f5a
    push esi                                     # 00510f5b
    push edi                                     # 00510f5c
    mov dword ptr [ebp - local_18], esp          # 00510f5d
    and dword ptr [ebp - local_4], 0x0           # 00510f60
    mov eax, dword ptr [0x5681f4]                # 00510f64
    test eax, eax                                # 00510f69
    je.d8 L_00510f83                             # 00510f6b
    # block 0x00510f6d: entered by fall-through of je at 0x00510f6b, 3 instruction(s), calls indirect eax, ends with forward jump to 0x00510f7f
    mov dword ptr [ebp - local_4], 0x1           # 00510f6d
    call eax                                     # 00510f74
    jmp.d8 L_00510f7f                            # 00510f76
    # block 0x00510f78: entered by follows jmp at 0x00510f76, 3 instruction(s), ends with ret
    push 0x1                                     # 00510f78
    pop eax                                      # 00510f7a
    ret                                          # 00510f7b
    # block 0x00510f7c: entered by follows ret at 0x00510f7b, 1 instruction(s), falls into the block at 0x00510f7f
    mov esp, dword ptr [ebp - local_18]          # 00510f7c
L_00510f7f:
    # block 0x00510f7f: entered by jmp at 0x00510f76, 1 instruction(s), falls into the block at 0x00510f83
    and dword ptr [ebp - local_4], 0x0           # 00510f7f
L_00510f83:
    # block 0x00510f83: entered by je at 0x00510f6b, 2 instruction(s), calls LOC_00510f8c, falls into the block at 0x00510f8c
    or dword ptr [ebp - local_4], -0x1           # 00510f83
    call L_00510f8c                              # 00510f87
L_00510f8c:
    # block 0x00510f8c: entered by fall-through, 1 instruction(s), ends with backward jump to 0x00510eda
    jmp.d32 FUN_00510eda                         # 00510f8c

