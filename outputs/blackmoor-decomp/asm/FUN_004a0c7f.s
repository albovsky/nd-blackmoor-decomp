# FUN_004a0c7f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a0c7f
# extent:       0x004a0c7f-0x004a0cea (107 code bytes)
# span:         0x004a0c7f-0x004a0cea (code 107, tables 0, padding 0)
# sha256:       3db0b57b0efada80f5778898439f4fa942e41dac0474e54338d6cf0b52284143
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a0c7f_count_nonempty
# naming:       native port src/original_methods_fl39f.c:m4a0c7f_count_nonempty (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Counts in dword [self+0xe18] the 10 records (stride 0x15e from +0x2c) whose string is not empty; masks of empty/non-empty records; both outcomes of the length test and the loop jump; All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_2c, field_e18; [ecx + n] field_e18
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4a0c7f_count_nonempty (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2c, 0x2c  # offset +0x2c
.equ field_e18, 0xe18  # offset +0xe18

# --- external targets -----------------------------------------------

.org 0x004a0c7f - 0x401000
.globl FUN_004a0c7f
FUN_004a0c7f:
    # block 0x004a0c7f: entry, 9 instruction(s), ends with forward jump to 0x004a0ca8
    push ebp                                     # 004a0c7f
    {load} mov ebp, esp                          # 004a0c80
    sub esp, 0x8                                 # 004a0c82
    push edi                                     # 004a0c85
    mov dword ptr [ebp - local_8], ecx           # 004a0c86
    mov eax, dword ptr [ebp - local_8]           # 004a0c89
    mov dword ptr [eax + field_e18], 0x0         # 004a0c8c
    mov dword ptr [ebp - local_4], 0x0           # 004a0c96
    jmp.d8 L_004a0ca8                            # 004a0c9d
L_004a0c9f:
    # block 0x004a0c9f: entered by jmp at 0x004a0ce3, 3 instruction(s), falls into the block at 0x004a0ca8
    mov ecx, dword ptr [ebp - local_4]           # 004a0c9f
    add ecx, 0x1                                 # 004a0ca2
    mov dword ptr [ebp - local_4], ecx           # 004a0ca5
L_004a0ca8:
    # block 0x004a0ca8: entered by jmp at 0x004a0c9d, 2 instruction(s), ends with jge to 0x004a0ce5 (forward)
    cmp dword ptr [ebp - local_4], 0xa           # 004a0ca8
    jge.d8 L_004a0ce5                            # 004a0cac
    # block 0x004a0cae: entered by fall-through of jge at 0x004a0cac, 11 instruction(s), ends with jbe to 0x004a0ce3 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a0cae
    imul edx, edx, 0x15e                         # 004a0cb1
    mov eax, dword ptr [ebp - local_8]           # 004a0cb7
    lea edi, [eax + edx + field_2c]              # 004a0cba
    or ecx, -0x1                                 # 004a0cbe
    {load} xor eax, eax                          # 004a0cc1
    repne scasb al, byte ptr es:[edi]            # 004a0cc3
    not ecx                                      # 004a0cc5
    add ecx, -0x1                                # 004a0cc7
    test ecx, ecx                                # 004a0cca
    jbe.d8 L_004a0ce3                            # 004a0ccc
    # block 0x004a0cce: entered by fall-through of jbe at 0x004a0ccc, 5 instruction(s), falls into the block at 0x004a0ce3
    mov ecx, dword ptr [ebp - local_8]           # 004a0cce
    mov edx, dword ptr [ecx + field_e18]         # 004a0cd1
    add edx, 0x1                                 # 004a0cd7
    mov eax, dword ptr [ebp - local_8]           # 004a0cda
    mov dword ptr [eax + field_e18], edx         # 004a0cdd
L_004a0ce3:
    # block 0x004a0ce3: entered by jbe at 0x004a0ccc, 1 instruction(s), ends with backward jump to 0x004a0c9f
    jmp.d8 L_004a0c9f                            # 004a0ce3
L_004a0ce5:
    # block 0x004a0ce5: entered by jge at 0x004a0cac, 4 instruction(s), ends with ret
    pop edi                                      # 004a0ce5
    {load} mov esp, ebp                          # 004a0ce6
    pop ebp                                      # 004a0ce8
    ret                                          # 004a0ce9

