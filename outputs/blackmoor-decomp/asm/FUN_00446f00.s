# FUN_00446f00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446f00
# extent:       0x00446f00-0x00446f67 (103 code bytes)
# span:         0x00446f00-0x00446f67 (code 103, tables 0, padding 0)
# sha256:       56eabb5b512037b92edc3bc91cac33a89fecd5a29c04f3121800859c95cf5a08
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00446f00
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00446f77
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
.set FUN_00446f77, .text + (0x00446f77 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00446f00 - 0x401000
.globl FUN_00446f00
FUN_00446f00:
    # block 0x00446f00: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00446f42 (forward)
    push ebp                                     # 00446f00
    {load} mov ebp, esp                          # 00446f01
    push -0x1                                    # 00446f03
    push 0x527eca                                # 00446f05
    mov eax, dword ptr fs:[0x0]                  # 00446f0a
    push eax                                     # 00446f10
    mov dword ptr fs:[0x0], esp                  # 00446f11
    sub esp, 0xc                                 # 00446f18
    push 0x5e                                    # 00446f1b
    call FUN_0051dc43                            # 00446f1d
    add esp, 0x4                                 # 00446f22
    mov dword ptr [ebp - local_14], eax          # 00446f25
    mov dword ptr [ebp - local_4], 0x0           # 00446f28
    cmp dword ptr [ebp - local_14], 0x0          # 00446f2f
    je.d8 L_00446f42                             # 00446f33
    # block 0x00446f35: entered by fall-through of je at 0x00446f33, 4 instruction(s), calls FUN_00446f77, ends with forward jump to 0x00446f49
    mov ecx, dword ptr [ebp - local_14]          # 00446f35
    call FUN_00446f77                            # 00446f38
    mov dword ptr [ebp - local_18], eax          # 00446f3d
    jmp.d8 L_00446f49                            # 00446f40
L_00446f42:
    # block 0x00446f42: entered by je at 0x00446f33, 1 instruction(s), falls into the block at 0x00446f49
    mov dword ptr [ebp - local_18], 0x0          # 00446f42
L_00446f49:
    # block 0x00446f49: entered by jmp at 0x00446f40, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00446f49
    mov dword ptr [ebp - local_10], eax          # 00446f4c
    mov dword ptr [ebp - local_4], 0xffffffff    # 00446f4f
    mov eax, dword ptr [ebp - local_10]          # 00446f56
    mov ecx, dword ptr [ebp - local_c]           # 00446f59
    mov dword ptr fs:[0x0], ecx                  # 00446f5c
    {load} mov esp, ebp                          # 00446f63
    pop ebp                                      # 00446f65
    ret                                          # 00446f66

