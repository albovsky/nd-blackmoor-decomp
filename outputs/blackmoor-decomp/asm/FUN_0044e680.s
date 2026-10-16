# FUN_0044e680
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e680
# extent:       0x0044e680-0x0044e6e7 (103 code bytes)
# span:         0x0044e680-0x0044e6e7 (code 103, tables 0, padding 0)
# sha256:       de7e81ce90424972af6760302bc74b81b59d227022beabfe50ae1d878da33095
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044e680
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0044e6f7
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
.set FUN_0044e6f7, .text + (0x0044e6f7 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0044e680 - 0x401000
.globl FUN_0044e680
FUN_0044e680:
    # block 0x0044e680: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0044e6c2 (forward)
    push ebp                                     # 0044e680
    {load} mov ebp, esp                          # 0044e681
    push -0x1                                    # 0044e683
    push 0x527fca                                # 0044e685
    mov eax, dword ptr fs:[0x0]                  # 0044e68a
    push eax                                     # 0044e690
    mov dword ptr fs:[0x0], esp                  # 0044e691
    sub esp, 0xc                                 # 0044e698
    push 0x6f                                    # 0044e69b
    call FUN_0051dc43                            # 0044e69d
    add esp, 0x4                                 # 0044e6a2
    mov dword ptr [ebp - local_14], eax          # 0044e6a5
    mov dword ptr [ebp - local_4], 0x0           # 0044e6a8
    cmp dword ptr [ebp - local_14], 0x0          # 0044e6af
    je.d8 L_0044e6c2                             # 0044e6b3
    # block 0x0044e6b5: entered by fall-through of je at 0x0044e6b3, 4 instruction(s), calls FUN_0044e6f7, ends with forward jump to 0x0044e6c9
    mov ecx, dword ptr [ebp - local_14]          # 0044e6b5
    call FUN_0044e6f7                            # 0044e6b8
    mov dword ptr [ebp - local_18], eax          # 0044e6bd
    jmp.d8 L_0044e6c9                            # 0044e6c0
L_0044e6c2:
    # block 0x0044e6c2: entered by je at 0x0044e6b3, 1 instruction(s), falls into the block at 0x0044e6c9
    mov dword ptr [ebp - local_18], 0x0          # 0044e6c2
L_0044e6c9:
    # block 0x0044e6c9: entered by jmp at 0x0044e6c0, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0044e6c9
    mov dword ptr [ebp - local_10], eax          # 0044e6cc
    mov dword ptr [ebp - local_4], 0xffffffff    # 0044e6cf
    mov eax, dword ptr [ebp - local_10]          # 0044e6d6
    mov ecx, dword ptr [ebp - local_c]           # 0044e6d9
    mov dword ptr fs:[0x0], ecx                  # 0044e6dc
    {load} mov esp, ebp                          # 0044e6e3
    pop ebp                                      # 0044e6e5
    ret                                          # 0044e6e6

