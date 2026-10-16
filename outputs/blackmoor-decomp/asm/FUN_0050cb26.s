# FUN_0050cb26
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cb26
# extent:       0x0050cb26-0x0050cb90 (106 code bytes)
# span:         0x0050cb26-0x0050cb90 (code 106, tables 0, padding 0)
# sha256:       d3077161bd468bd15e12794c6a0d8ffe0a32535c54b3b52be03c434d87413a89
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cb26
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x14 (callee pops 20 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_10, local_1c, local_20
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cb90; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050cb90, .text + (0x0050cb90 - 0x401000)

.org 0x0050cb26 - 0x401000
.globl FUN_0050cb26
FUN_0050cb26:
    # block 0x0050cb26: entry, 16 instruction(s), falls into the block at 0x0050cb54
    push ebp                                     # 0050cb26
    {load} mov ebp, esp                          # 0050cb27
    push -0x1                                    # 0050cb29
    push 0x530228                                # 0050cb2b
    push 0x511930                                # 0050cb30
    mov eax, dword ptr fs:[0x0]                  # 0050cb35
    push eax                                     # 0050cb3b
    mov dword ptr fs:[0x0], esp                  # 0050cb3c
    sub esp, 0x10                                # 0050cb43
    push ebx                                     # 0050cb46
    push esi                                     # 0050cb47
    push edi                                     # 0050cb48
    {load} xor eax, eax                          # 0050cb49
    mov dword ptr [ebp - local_20], eax          # 0050cb4b
    mov dword ptr [ebp - local_4], eax           # 0050cb4e
    mov dword ptr [ebp - local_1c], eax          # 0050cb51
L_0050cb54:
    # block 0x0050cb54: entered by jmp at 0x0050cb6d, 3 instruction(s), ends with jge to 0x0050cb6f (forward)
    mov eax, dword ptr [ebp - local_1c]          # 0050cb54
    cmp eax, dword ptr [ebp + arg_10]            # 0050cb57
    jge.d8 L_0050cb6f                            # 0050cb5a
    # block 0x0050cb5c: entered by fall-through of jge at 0x0050cb5a, 7 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with backward jump to 0x0050cb54
    mov esi, dword ptr [ebp + arg_8]             # 0050cb5c
    {load} mov ecx, esi                          # 0050cb5f
    call dword ptr [ebp + arg_14]                # 0050cb61
    add esi, dword ptr [ebp + arg_c]             # 0050cb64
    mov dword ptr [ebp + arg_8], esi             # 0050cb67
    inc dword ptr [ebp - local_1c]               # 0050cb6a
    jmp.d8 L_0050cb54                            # 0050cb6d
L_0050cb6f:
    # block 0x0050cb6f: entered by jge at 0x0050cb5a, 10 instruction(s), calls FUN_0050cb90, ends with ret 0x14
    mov dword ptr [ebp - local_20], 0x1          # 0050cb6f
    or dword ptr [ebp - local_4], -0x1           # 0050cb76
    call FUN_0050cb90                            # 0050cb7a
    mov ecx, dword ptr [ebp - local_10]          # 0050cb7f
    mov dword ptr fs:[0x0], ecx                  # 0050cb82
    pop edi                                      # 0050cb89
    pop esi                                      # 0050cb8a
    pop ebx                                      # 0050cb8b
    leave                                        # 0050cb8c
    ret 0x14                                     # 0050cb8d

