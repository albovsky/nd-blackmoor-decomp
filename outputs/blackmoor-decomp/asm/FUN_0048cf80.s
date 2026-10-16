# FUN_0048cf80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048cf80
# extent:       0x0048cf80-0x0048cfe7 (103 code bytes)
# span:         0x0048cf80-0x0048cfe7 (code 103, tables 0, padding 0)
# sha256:       ec94b83e25bfe3e83a337548636d0d0829a670afcf280689355cd115590fd1c4
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048cf80
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0048cff7
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
.set FUN_0048cff7, .text + (0x0048cff7 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0048cf80 - 0x401000
.globl FUN_0048cf80
FUN_0048cf80:
    # block 0x0048cf80: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0048cfc2 (forward)
    push ebp                                     # 0048cf80
    {load} mov ebp, esp                          # 0048cf81
    push -0x1                                    # 0048cf83
    push 0x5284ba                                # 0048cf85
    mov eax, dword ptr fs:[0x0]                  # 0048cf8a
    push eax                                     # 0048cf90
    mov dword ptr fs:[0x0], esp                  # 0048cf91
    sub esp, 0xc                                 # 0048cf98
    push 0x5c                                    # 0048cf9b
    call FUN_0051dc43                            # 0048cf9d
    add esp, 0x4                                 # 0048cfa2
    mov dword ptr [ebp - local_14], eax          # 0048cfa5
    mov dword ptr [ebp - local_4], 0x0           # 0048cfa8
    cmp dword ptr [ebp - local_14], 0x0          # 0048cfaf
    je.d8 L_0048cfc2                             # 0048cfb3
    # block 0x0048cfb5: entered by fall-through of je at 0x0048cfb3, 4 instruction(s), calls FUN_0048cff7, ends with forward jump to 0x0048cfc9
    mov ecx, dword ptr [ebp - local_14]          # 0048cfb5
    call FUN_0048cff7                            # 0048cfb8
    mov dword ptr [ebp - local_18], eax          # 0048cfbd
    jmp.d8 L_0048cfc9                            # 0048cfc0
L_0048cfc2:
    # block 0x0048cfc2: entered by je at 0x0048cfb3, 1 instruction(s), falls into the block at 0x0048cfc9
    mov dword ptr [ebp - local_18], 0x0          # 0048cfc2
L_0048cfc9:
    # block 0x0048cfc9: entered by jmp at 0x0048cfc0, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0048cfc9
    mov dword ptr [ebp - local_10], eax          # 0048cfcc
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048cfcf
    mov eax, dword ptr [ebp - local_10]          # 0048cfd6
    mov ecx, dword ptr [ebp - local_c]           # 0048cfd9
    mov dword ptr fs:[0x0], ecx                  # 0048cfdc
    {load} mov esp, ebp                          # 0048cfe3
    pop ebp                                      # 0048cfe5
    ret                                          # 0048cfe6

