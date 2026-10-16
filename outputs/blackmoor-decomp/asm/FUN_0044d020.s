# FUN_0044d020
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d020
# extent:       0x0044d020-0x0044d087 (103 code bytes)
# span:         0x0044d020-0x0044d087 (code 103, tables 0, padding 0)
# sha256:       49076f3315f3ac88c251b5b0eb32ad710d026b3507cfb3dbb2dc8f8e3c67ffa2
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d020
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0044d097
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
.set FUN_0044d097, .text + (0x0044d097 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0044d020 - 0x401000
.globl FUN_0044d020
FUN_0044d020:
    # block 0x0044d020: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0044d062 (forward)
    push ebp                                     # 0044d020
    {load} mov ebp, esp                          # 0044d021
    push -0x1                                    # 0044d023
    push 0x527f9a                                # 0044d025
    mov eax, dword ptr fs:[0x0]                  # 0044d02a
    push eax                                     # 0044d030
    mov dword ptr fs:[0x0], esp                  # 0044d031
    sub esp, 0xc                                 # 0044d038
    push 0x53                                    # 0044d03b
    call FUN_0051dc43                            # 0044d03d
    add esp, 0x4                                 # 0044d042
    mov dword ptr [ebp - local_14], eax          # 0044d045
    mov dword ptr [ebp - local_4], 0x0           # 0044d048
    cmp dword ptr [ebp - local_14], 0x0          # 0044d04f
    je.d8 L_0044d062                             # 0044d053
    # block 0x0044d055: entered by fall-through of je at 0x0044d053, 4 instruction(s), calls FUN_0044d097, ends with forward jump to 0x0044d069
    mov ecx, dword ptr [ebp - local_14]          # 0044d055
    call FUN_0044d097                            # 0044d058
    mov dword ptr [ebp - local_18], eax          # 0044d05d
    jmp.d8 L_0044d069                            # 0044d060
L_0044d062:
    # block 0x0044d062: entered by je at 0x0044d053, 1 instruction(s), falls into the block at 0x0044d069
    mov dword ptr [ebp - local_18], 0x0          # 0044d062
L_0044d069:
    # block 0x0044d069: entered by jmp at 0x0044d060, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0044d069
    mov dword ptr [ebp - local_10], eax          # 0044d06c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044d06f
    mov eax, dword ptr [ebp - local_10]          # 0044d076
    mov ecx, dword ptr [ebp - local_c]           # 0044d079
    mov dword ptr fs:[0x0], ecx                  # 0044d07c
    {load} mov esp, ebp                          # 0044d083
    pop ebp                                      # 0044d085
    ret                                          # 0044d086

