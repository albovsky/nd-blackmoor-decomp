# FUN_00465a20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465a20
# extent:       0x00465a20-0x00465a87 (103 code bytes)
# span:         0x00465a20-0x00465a87 (code 103, tables 0, padding 0)
# sha256:       001140e638cb2a4735b09dcb9cfcdbd50c16d911654ed0cea64a2af272aa04a8
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00465a20
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00465a97
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
.set FUN_00465a97, .text + (0x00465a97 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00465a20 - 0x401000
.globl FUN_00465a20
FUN_00465a20:
    # block 0x00465a20: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00465a62 (forward)
    push ebp                                     # 00465a20
    {load} mov ebp, esp                          # 00465a21
    push -0x1                                    # 00465a23
    push 0x52817a                                # 00465a25
    mov eax, dword ptr fs:[0x0]                  # 00465a2a
    push eax                                     # 00465a30
    mov dword ptr fs:[0x0], esp                  # 00465a31
    sub esp, 0xc                                 # 00465a38
    push 0x56                                    # 00465a3b
    call FUN_0051dc43                            # 00465a3d
    add esp, 0x4                                 # 00465a42
    mov dword ptr [ebp - local_14], eax          # 00465a45
    mov dword ptr [ebp - local_4], 0x0           # 00465a48
    cmp dword ptr [ebp - local_14], 0x0          # 00465a4f
    je.d8 L_00465a62                             # 00465a53
    # block 0x00465a55: entered by fall-through of je at 0x00465a53, 4 instruction(s), calls FUN_00465a97, ends with forward jump to 0x00465a69
    mov ecx, dword ptr [ebp - local_14]          # 00465a55
    call FUN_00465a97                            # 00465a58
    mov dword ptr [ebp - local_18], eax          # 00465a5d
    jmp.d8 L_00465a69                            # 00465a60
L_00465a62:
    # block 0x00465a62: entered by je at 0x00465a53, 1 instruction(s), falls into the block at 0x00465a69
    mov dword ptr [ebp - local_18], 0x0          # 00465a62
L_00465a69:
    # block 0x00465a69: entered by jmp at 0x00465a60, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00465a69
    mov dword ptr [ebp - local_10], eax          # 00465a6c
    mov dword ptr [ebp - local_4], 0xffffffff    # 00465a6f
    mov eax, dword ptr [ebp - local_10]          # 00465a76
    mov ecx, dword ptr [ebp - local_c]           # 00465a79
    mov dword ptr fs:[0x0], ecx                  # 00465a7c
    {load} mov esp, ebp                          # 00465a83
    pop ebp                                      # 00465a85
    ret                                          # 00465a86

