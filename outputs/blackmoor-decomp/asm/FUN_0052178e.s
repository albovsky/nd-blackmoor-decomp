# FUN_0052178e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052178e
# extent:       0x0052178e-0x005217be (48 code bytes)
# span:         0x0052178e-0x005217be (code 48, tables 0, padding 0)
# sha256:       8bed6900840e82bc3eefe0b5ba4e4705b36480f29b0cfa2ce913ca71f861d861
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052178e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ebp + n] field_c, field_10, field_minus_4, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051b097, tail jump LOC_005217cd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_10, 0x10  # offset -0x10
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051b097, .text + (0x0051b097 - 0x401000)
.set LOC_005217c6, .text + (0x005217c6 - 0x401000)
.set LOC_005217cb, .text + (0x005217cb - 0x401000)
.set LOC_005217cd, .text + (0x005217cd - 0x401000)

.org 0x0052178e - 0x401000
.globl FUN_0052178e
FUN_0052178e:
    # block 0x0052178e: entry, 11 instruction(s), calls FUN_0050f978, ends with je to 0x005217c6 (forward)
    mov eax, 0x528c5c                            # 0052178e
    call FUN_0050f978                            # 00521793
    push ecx                                     # 00521798
    push ecx                                     # 00521799
    mov eax, dword ptr [ebp + field_c]           # 0052179a
    push ebx                                     # 0052179d
    push esi                                     # 0052179e
    push edi                                     # 0052179f
    dec eax                                      # 005217a0
    mov dword ptr [ebp - field_minus_10], esp    # 005217a1
    je.d8 . + (34)  # -> LOC_005217c6            # 005217a4
    # block 0x005217a6: entered by fall-through of je at 0x005217a4, 2 instruction(s), ends with jne to 0x005217cb (forward)
    dec eax                                      # 005217a6
    jne.d8 . + (36)  # -> LOC_005217cb           # 005217a7
    # block 0x005217a9: entered by fall-through of jne at 0x005217a7, 8 instruction(s), calls FUN_0051b097, ends with forward jump to 0x005217cd
    mov eax, dword ptr [ebp + field_10]          # 005217a9
    and dword ptr [ebp - field_minus_4], 0x0     # 005217ac
    mov eax, dword ptr [eax + field_1c]          # 005217b0
    push eax                                     # 005217b3
    call FUN_0051b097                            # 005217b4
    push 0x1                                     # 005217b9
    pop eax                                      # 005217bb
    jmp.d8 . + (17)  # -> LOC_005217cd           # 005217bc

