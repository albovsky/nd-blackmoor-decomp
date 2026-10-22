# FUN_0049cf80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049cf80
# extent:       0x0049cf80-0x0049d039 (185 code bytes)
# span:         0x0049cf80-0x0049d039 (code 185, tables 0, padding 0)
# sha256:       103bdc45e05d003f3768442895b2532965d7c35b2e36746f911b56b8f138bc63
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49cf80_fill_cells
# naming:       native port src/original_methods_fl39f.c:m49cf80_fill_cells (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Zeroes 2*[self+0xdf4] bytes behind the pointer [self+0xde0], then or-es 0x0f into the low byte of each of the height x width words ([self+0xddc] x [self+0xdd8], signed compares; All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_dd8, field_df4; [ecx + n] field_dd8, field_ddc, field_de0; [edx + n] field_de0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m49cf80_fill_cells (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_dd8, 0xdd8  # offset +0xdd8
.equ field_ddc, 0xddc  # offset +0xddc
.equ field_de0, 0xde0  # offset +0xde0
.equ field_df4, 0xdf4  # offset +0xdf4

# --- external targets -----------------------------------------------

.org 0x0049cf80 - 0x401000
.globl FUN_0049cf80
FUN_0049cf80:
    # block 0x0049cf80: entry, 19 instruction(s), ends with forward jump to 0x0049cfc0
    push ebp                                     # 0049cf80
    {load} mov ebp, esp                          # 0049cf81
    sub esp, 0xc                                 # 0049cf83
    push edi                                     # 0049cf86
    mov dword ptr [ebp - local_c], ecx           # 0049cf87
    mov eax, dword ptr [ebp - local_c]           # 0049cf8a
    mov ecx, dword ptr [eax + field_df4]         # 0049cf8d
    shl ecx                                      # 0049cf93
    {load} xor eax, eax                          # 0049cf95
    mov edx, dword ptr [ebp - local_c]           # 0049cf97
    mov edi, dword ptr [edx + field_de0]         # 0049cf9a
    {load} mov edx, ecx                          # 0049cfa0
    shr ecx, 0x2                                 # 0049cfa2
    rep stosd dword ptr es:[edi], eax            # 0049cfa5
    {load} mov ecx, edx                          # 0049cfa7
    and ecx, 0x3                                 # 0049cfa9
    rep stosb byte ptr es:[edi], al              # 0049cfac
    mov dword ptr [ebp - local_8], 0x0           # 0049cfae
    jmp.d8 L_0049cfc0                            # 0049cfb5
L_0049cfb7:
    # block 0x0049cfb7: entered by jmp at 0x0049d032, 3 instruction(s), falls into the block at 0x0049cfc0
    mov eax, dword ptr [ebp - local_8]           # 0049cfb7
    add eax, 0x1                                 # 0049cfba
    mov dword ptr [ebp - local_8], eax           # 0049cfbd
L_0049cfc0:
    # block 0x0049cfc0: entered by jmp at 0x0049cfb5, 4 instruction(s), ends with jge to 0x0049d034 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0049cfc0
    mov edx, dword ptr [ebp - local_8]           # 0049cfc3
    cmp edx, dword ptr [ecx + field_ddc]         # 0049cfc6
    jge.d8 L_0049d034                            # 0049cfcc
    # block 0x0049cfce: entered by fall-through of jge at 0x0049cfcc, 2 instruction(s), ends with forward jump to 0x0049cfe0
    mov dword ptr [ebp - local_4], 0x0           # 0049cfce
    jmp.d8 L_0049cfe0                            # 0049cfd5
L_0049cfd7:
    # block 0x0049cfd7: entered by jmp at 0x0049d030, 3 instruction(s), falls into the block at 0x0049cfe0
    mov eax, dword ptr [ebp - local_4]           # 0049cfd7
    add eax, 0x1                                 # 0049cfda
    mov dword ptr [ebp - local_4], eax           # 0049cfdd
L_0049cfe0:
    # block 0x0049cfe0: entered by jmp at 0x0049cfd5, 4 instruction(s), ends with jge to 0x0049d032 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0049cfe0
    mov edx, dword ptr [ebp - local_4]           # 0049cfe3
    cmp edx, dword ptr [ecx + field_dd8]         # 0049cfe6
    jge.d8 L_0049d032                            # 0049cfec
    # block 0x0049cfee: entered by fall-through of jge at 0x0049cfec, 18 instruction(s), ends with backward jump to 0x0049cfd7
    mov eax, dword ptr [ebp - local_c]           # 0049cfee
    mov ecx, dword ptr [ebp - local_8]           # 0049cff1
    imul ecx, dword ptr [eax + field_dd8]        # 0049cff4
    mov edx, dword ptr [ebp - local_c]           # 0049cffb
    mov eax, dword ptr [edx + field_de0]         # 0049cffe
    lea ecx, [eax + 2*ecx]                       # 0049d004
    mov edx, dword ptr [ebp - local_4]           # 0049d007
    mov ax, word ptr [ecx + 2*edx]               # 0049d00a
    or al, 0xf                                   # 0049d00e
    mov ecx, dword ptr [ebp - local_c]           # 0049d010
    mov edx, dword ptr [ebp - local_8]           # 0049d013
    imul edx, dword ptr [ecx + field_dd8]        # 0049d016
    mov ecx, dword ptr [ebp - local_c]           # 0049d01d
    mov ecx, dword ptr [ecx + field_de0]         # 0049d020
    lea edx, [ecx + 2*edx]                       # 0049d026
    mov ecx, dword ptr [ebp - local_4]           # 0049d029
    mov word ptr [edx + 2*ecx], ax               # 0049d02c
    jmp.d8 L_0049cfd7                            # 0049d030
L_0049d032:
    # block 0x0049d032: entered by jge at 0x0049cfec, 1 instruction(s), ends with backward jump to 0x0049cfb7
    jmp.d8 L_0049cfb7                            # 0049d032
L_0049d034:
    # block 0x0049d034: entered by jge at 0x0049cfcc, 4 instruction(s), ends with ret
    pop edi                                      # 0049d034
    {load} mov esp, ebp                          # 0049d035
    pop ebp                                      # 0049d037
    ret                                          # 0049d038

