# FUN_0047e170
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e170
# extent:       0x0047e170-0x0047e1da (106 code bytes)
# span:         0x0047e170-0x0047e1da (code 106, tables 0, padding 0)
# sha256:       4c142a3f5cc87d8e3d3f3b1d228b0e4f0af7c17c4d2c459b059f454cb7b5d380
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047e170
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0047e1ea
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
.set FUN_0047e1ea, .text + (0x0047e1ea - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0047e170 - 0x401000
.globl FUN_0047e170
FUN_0047e170:
    # block 0x0047e170: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0047e1b5 (forward)
    push ebp                                     # 0047e170
    {load} mov ebp, esp                          # 0047e171
    push -0x1                                    # 0047e173
    push 0x52837a                                # 0047e175
    mov eax, dword ptr fs:[0x0]                  # 0047e17a
    push eax                                     # 0047e180
    mov dword ptr fs:[0x0], esp                  # 0047e181
    sub esp, 0xc                                 # 0047e188
    push 0x144d                                  # 0047e18b
    call FUN_0051dc43                            # 0047e190
    add esp, 0x4                                 # 0047e195
    mov dword ptr [ebp - local_14], eax          # 0047e198
    mov dword ptr [ebp - local_4], 0x0           # 0047e19b
    cmp dword ptr [ebp - local_14], 0x0          # 0047e1a2
    je.d8 L_0047e1b5                             # 0047e1a6
    # block 0x0047e1a8: entered by fall-through of je at 0x0047e1a6, 4 instruction(s), calls FUN_0047e1ea, ends with forward jump to 0x0047e1bc
    mov ecx, dword ptr [ebp - local_14]          # 0047e1a8
    call FUN_0047e1ea                            # 0047e1ab
    mov dword ptr [ebp - local_18], eax          # 0047e1b0
    jmp.d8 L_0047e1bc                            # 0047e1b3
L_0047e1b5:
    # block 0x0047e1b5: entered by je at 0x0047e1a6, 1 instruction(s), falls into the block at 0x0047e1bc
    mov dword ptr [ebp - local_18], 0x0          # 0047e1b5
L_0047e1bc:
    # block 0x0047e1bc: entered by jmp at 0x0047e1b3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0047e1bc
    mov dword ptr [ebp - local_10], eax          # 0047e1bf
    mov dword ptr [ebp - local_4], 0xffffffff    # 0047e1c2
    mov eax, dword ptr [ebp - local_10]          # 0047e1c9
    mov ecx, dword ptr [ebp - local_c]           # 0047e1cc
    mov dword ptr fs:[0x0], ecx                  # 0047e1cf
    {load} mov esp, ebp                          # 0047e1d6
    pop ebp                                      # 0047e1d8
    ret                                          # 0047e1d9

