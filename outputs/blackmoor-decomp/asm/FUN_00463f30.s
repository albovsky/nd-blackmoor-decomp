# FUN_00463f30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463f30
# extent:       0x00463f30-0x00463f9a (106 code bytes)
# span:         0x00463f30-0x00463f9a (code 106, tables 0, padding 0)
# sha256:       8726da32f9684ecd1f718b94a15cd4d3f57d8ef6644e1cd9c45c8bf38f926c2b
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00463f30
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00463faa
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
.set FUN_00463faa, .text + (0x00463faa - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00463f30 - 0x401000
.globl FUN_00463f30
FUN_00463f30:
    # block 0x00463f30: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00463f75 (forward)
    push ebp                                     # 00463f30
    {load} mov ebp, esp                          # 00463f31
    push -0x1                                    # 00463f33
    push 0x52814a                                # 00463f35
    mov eax, dword ptr fs:[0x0]                  # 00463f3a
    push eax                                     # 00463f40
    mov dword ptr fs:[0x0], esp                  # 00463f41
    sub esp, 0xc                                 # 00463f48
    push 0xda                                    # 00463f4b
    call FUN_0051dc43                            # 00463f50
    add esp, 0x4                                 # 00463f55
    mov dword ptr [ebp - local_14], eax          # 00463f58
    mov dword ptr [ebp - local_4], 0x0           # 00463f5b
    cmp dword ptr [ebp - local_14], 0x0          # 00463f62
    je.d8 L_00463f75                             # 00463f66
    # block 0x00463f68: entered by fall-through of je at 0x00463f66, 4 instruction(s), calls FUN_00463faa, ends with forward jump to 0x00463f7c
    mov ecx, dword ptr [ebp - local_14]          # 00463f68
    call FUN_00463faa                            # 00463f6b
    mov dword ptr [ebp - local_18], eax          # 00463f70
    jmp.d8 L_00463f7c                            # 00463f73
L_00463f75:
    # block 0x00463f75: entered by je at 0x00463f66, 1 instruction(s), falls into the block at 0x00463f7c
    mov dword ptr [ebp - local_18], 0x0          # 00463f75
L_00463f7c:
    # block 0x00463f7c: entered by jmp at 0x00463f73, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00463f7c
    mov dword ptr [ebp - local_10], eax          # 00463f7f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00463f82
    mov eax, dword ptr [ebp - local_10]          # 00463f89
    mov ecx, dword ptr [ebp - local_c]           # 00463f8c
    mov dword ptr fs:[0x0], ecx                  # 00463f8f
    {load} mov esp, ebp                          # 00463f96
    pop ebp                                      # 00463f98
    ret                                          # 00463f99

