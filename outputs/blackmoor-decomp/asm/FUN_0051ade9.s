# FUN_0051ade9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ade9
# extent:       0x0051ade9-0x0051ae25 (60 code bytes)
# span:         0x0051ade9-0x0051ae25 (code 60, tables 0, padding 0)
# sha256:       fc18dcaa4d61f1a38cbb33e250de47aa9e9a59786890df2a02150df25d0db69b
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Catch@0051ade9
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated C++ catch handler funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_14, field_minus_14, field_minus_20, field_minus_40, field_minus_44, field_minus_48, field_minus_4c; [edx + n] field_6c
# callees:      calls FUN_0051ec6f, FUN_0051f636; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_20, 0x20  # offset -0x20
.equ field_minus_40, 0x40  # offset -0x40
.equ field_minus_44, 0x44  # offset -0x44
.equ field_minus_48, 0x48  # offset -0x48
.equ field_minus_4c, 0x4c  # offset -0x4c
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_0051f636, .text + (0x0051f636 - 0x401000)

.org 0x0051ade9 - 0x401000
.globl FUN_0051ade9
FUN_0051ade9:
    # block 0x0051ade9: entry, 20 instruction(s), calls FUN_0051ec6f, indirect dword ptr [edx + 0x6c], FUN_0051f636, ends with ret
    mov eax, dword ptr [ebp + field_8]           # 0051ade9
    mov dword ptr [ebp - field_minus_4c], eax    # 0051adec
    mov eax, dword ptr [ebp + field_c]           # 0051adef
    mov dword ptr [ebp - field_minus_48], eax    # 0051adf2
    mov eax, dword ptr [ebp + field_10]          # 0051adf5
    mov dword ptr [ebp - field_minus_44], eax    # 0051adf8
    mov eax, dword ptr [ebp + field_14]          # 0051adfb
    mov dword ptr [ebp - field_minus_40], eax    # 0051adfe
    call FUN_0051ec6f                            # 0051ae01
    mov edx, dword ptr [eax]                     # 0051ae06
    lea ecx, [ebp - field_minus_4c]              # 0051ae08
    push ecx                                     # 0051ae0b
    {load} mov ecx, eax                          # 0051ae0c
    push dword ptr [ebp - field_minus_20]        # 0051ae0e
    call dword ptr [edx + field_6c]              # 0051ae11
    mov ecx, dword ptr [ebp - field_minus_20]    # 0051ae14
    mov dword ptr [ebp - field_minus_14], eax    # 0051ae17
    call FUN_0051f636                            # 0051ae1a
    mov eax, 0x51ad57                            # 0051ae1f
    ret                                          # 0051ae24

