# FUN_0050ca3e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ca3e
# extent:       0x0050ca3e-0x0050ca90 (82 code bytes)
# span:         0x0050ca3e-0x0050ca90 (code 82, tables 0, padding 0)
# sha256:       e38ee527f737dc4c39c3e4bf44ffc0e27aed605f503d9b00fed4e19973f97c73
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ca3e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_14, local_18, local_1c, local_20
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005110a9, FUN_00510f91
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20c.c:m412db8_wrap_text (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 32 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00510f91, .text + (0x00510f91 - 0x401000)
.set FUN_005110a9, .text + (0x005110a9 - 0x401000)

.org 0x0050ca3e - 0x401000
.globl FUN_0050ca3e
FUN_0050ca3e:
    # block 0x0050ca3e: entry, 19 instruction(s), calls FUN_005110a9, ends with js to 0x0050ca7e (forward)
    push ebp                                     # 0050ca3e
    {load} mov ebp, esp                          # 0050ca3f
    sub esp, 0x20                                # 0050ca41
    mov eax, dword ptr [ebp + arg_8]             # 0050ca44
    push esi                                     # 0050ca47
    mov dword ptr [ebp - local_18], eax          # 0050ca48
    mov dword ptr [ebp - local_20], eax          # 0050ca4b
    lea eax, [ebp + arg_10]                      # 0050ca4e
    mov dword ptr [ebp - local_14], 0x42         # 0050ca51
    push eax                                     # 0050ca58
    lea eax, [ebp - local_20]                    # 0050ca59
    push dword ptr [ebp + arg_c]                 # 0050ca5c
    mov dword ptr [ebp - local_1c], 0x7fffffff   # 0050ca5f
    push eax                                     # 0050ca66
    call FUN_005110a9                            # 0050ca67
    add esp, 0xc                                 # 0050ca6c
    dec dword ptr [ebp - local_1c]               # 0050ca6f
    {load} mov esi, eax                          # 0050ca72
    js.d8 L_0050ca7e                             # 0050ca74
    # block 0x0050ca76: entered by fall-through of js at 0x0050ca74, 3 instruction(s), ends with forward jump to 0x0050ca8b
    mov eax, dword ptr [ebp - local_20]          # 0050ca76
    and byte ptr [eax], 0x0                      # 0050ca79
    jmp.d8 L_0050ca8b                            # 0050ca7c
L_0050ca7e:
    # block 0x0050ca7e: entered by js at 0x0050ca74, 6 instruction(s), calls FUN_00510f91, falls into the block at 0x0050ca8b
    lea eax, [ebp - local_20]                    # 0050ca7e
    push eax                                     # 0050ca81
    push 0x0                                     # 0050ca82
    call FUN_00510f91                            # 0050ca84
    pop ecx                                      # 0050ca89
    pop ecx                                      # 0050ca8a
L_0050ca8b:
    # block 0x0050ca8b: entered by jmp at 0x0050ca7c, 4 instruction(s), ends with ret
    {load} mov eax, esi                          # 0050ca8b
    pop esi                                      # 0050ca8d
    leave                                        # 0050ca8e
    ret                                          # 0050ca8f

