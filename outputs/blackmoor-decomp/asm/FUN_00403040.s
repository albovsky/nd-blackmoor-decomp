# FUN_00403040
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00403040
# extent:       0x00403040-0x004030aa (106 code bytes)
# span:         0x00403040-0x004030aa (code 106, tables 0, padding 0)
# sha256:       91ee1f8e7d0a7f64025cb777ca9cb8e4da2a24083aa40303787c634be821c67a
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00403040
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004030ba
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
.set FUN_004030ba, .text + (0x004030ba - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00403040 - 0x401000
.globl FUN_00403040
FUN_00403040:
    # block 0x00403040: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00403085 (forward)
    push ebp                                     # 00403040
    {load} mov ebp, esp                          # 00403041
    push -0x1                                    # 00403043
    push 0x526b2a                                # 00403045
    mov eax, dword ptr fs:[0x0]                  # 0040304a
    push eax                                     # 00403050
    mov dword ptr fs:[0x0], esp                  # 00403051
    sub esp, 0xc                                 # 00403058
    push 0x4b4                                   # 0040305b
    call FUN_0051dc43                            # 00403060
    add esp, 0x4                                 # 00403065
    mov dword ptr [ebp - local_14], eax          # 00403068
    mov dword ptr [ebp - local_4], 0x0           # 0040306b
    cmp dword ptr [ebp - local_14], 0x0          # 00403072
    je.d8 L_00403085                             # 00403076
    # block 0x00403078: entered by fall-through of je at 0x00403076, 4 instruction(s), calls FUN_004030ba, ends with forward jump to 0x0040308c
    mov ecx, dword ptr [ebp - local_14]          # 00403078
    call FUN_004030ba                            # 0040307b
    mov dword ptr [ebp - local_18], eax          # 00403080
    jmp.d8 L_0040308c                            # 00403083
L_00403085:
    # block 0x00403085: entered by je at 0x00403076, 1 instruction(s), falls into the block at 0x0040308c
    mov dword ptr [ebp - local_18], 0x0          # 00403085
L_0040308c:
    # block 0x0040308c: entered by jmp at 0x00403083, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0040308c
    mov dword ptr [ebp - local_10], eax          # 0040308f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00403092
    mov eax, dword ptr [ebp - local_10]          # 00403099
    mov ecx, dword ptr [ebp - local_c]           # 0040309c
    mov dword ptr fs:[0x0], ecx                  # 0040309f
    {load} mov esp, ebp                          # 004030a6
    pop ebp                                      # 004030a8
    ret                                          # 004030a9

