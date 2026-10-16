# FUN_004b7110
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7110
# extent:       0x004b7110-0x004b7177 (103 code bytes)
# span:         0x004b7110-0x004b7177 (code 103, tables 0, padding 0)
# sha256:       7d2a9fe1e1835f5d78919dfc445b584fa80b0251fd23861771dc0b42037d68e9
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b7110
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004b7187
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004b7187, .text + (0x004b7187 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004b7110 - 0x401000
.globl FUN_004b7110
FUN_004b7110:
    # block 0x004b7110: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004b7152 (forward)
    push ebp                                     # 004b7110
    {load} mov ebp, esp                          # 004b7111
    push -0x1                                    # 004b7113
    push 0x52876a                                # 004b7115
    mov eax, dword ptr fs:[0x0]                  # 004b711a
    push eax                                     # 004b7120
    mov dword ptr fs:[0x0], esp                  # 004b7121
    sub esp, 0xc                                 # 004b7128
    push 0x3c                                    # 004b712b
    call FUN_0051dc43                            # 004b712d
    add esp, 0x4                                 # 004b7132
    mov dword ptr [ebp - local_14], eax          # 004b7135
    mov dword ptr [ebp - local_4], 0x0           # 004b7138
    cmp dword ptr [ebp - local_14], 0x0          # 004b713f
    je.d8 L_004b7152                             # 004b7143
    # block 0x004b7145: entered by fall-through of je at 0x004b7143, 4 instruction(s), calls FUN_004b7187, ends with forward jump to 0x004b7159
    mov ecx, dword ptr [ebp - local_14]          # 004b7145
    call FUN_004b7187                            # 004b7148
    mov dword ptr [ebp - local_18], eax          # 004b714d
    jmp.d8 L_004b7159                            # 004b7150
L_004b7152:
    # block 0x004b7152: entered by je at 0x004b7143, 1 instruction(s), falls into the block at 0x004b7159
    mov dword ptr [ebp - local_18], 0x0          # 004b7152
L_004b7159:
    # block 0x004b7159: entered by jmp at 0x004b7150, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004b7159
    mov dword ptr [ebp - local_10], eax          # 004b715c
    mov dword ptr [ebp - local_4], 0xffffffff    # 004b715f
    mov eax, dword ptr [ebp - local_10]          # 004b7166
    mov ecx, dword ptr [ebp - local_c]           # 004b7169
    mov dword ptr fs:[0x0], ecx                  # 004b716c
    {load} mov esp, ebp                          # 004b7173
    pop ebp                                      # 004b7175
    ret                                          # 004b7176

