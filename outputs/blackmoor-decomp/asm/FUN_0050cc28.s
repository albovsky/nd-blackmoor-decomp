# FUN_0050cc28
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cc28
# extent:       0x0050cc28-0x0050cc86 (94 code bytes)
# span:         0x0050cc28-0x0050cc86 (code 94, tables 0, padding 0)
# sha256:       d195cea6a5403972e3fb64a5cfd0d657e4aa76b3485b5fde4113070d01c447b6
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cc28
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_4, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cc86; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         unreachable_code_entry:0x0050cc64
# note:         unreachable_code_entry:0x0050cc6e
# note:         further_unindexed_code_at:0x0050cc86
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050cc86, .text + (0x0050cc86 - 0x401000)

.org 0x0050cc28 - 0x401000
.globl FUN_0050cc28
FUN_0050cc28:
    # block 0x0050cc28: entry, 15 instruction(s), falls into the block at 0x0050cc51
    push ebp                                     # 0050cc28
    {load} mov ebp, esp                          # 0050cc29
    push -0x1                                    # 0050cc2b
    push 0x530248                                # 0050cc2d
    push 0x511930                                # 0050cc32
    mov eax, dword ptr fs:[0x0]                  # 0050cc37
    push eax                                     # 0050cc3d
    mov dword ptr fs:[0x0], esp                  # 0050cc3e
    push ecx                                     # 0050cc45
    push ecx                                     # 0050cc46
    push ebx                                     # 0050cc47
    push esi                                     # 0050cc48
    push edi                                     # 0050cc49
    mov dword ptr [ebp - local_18], esp          # 0050cc4a
    and dword ptr [ebp - local_4], 0x0           # 0050cc4d
L_0050cc51:
    # block 0x0050cc51: entered by jmp at 0x0050cc62, 2 instruction(s), ends with js to 0x0050cc71 (forward)
    dec dword ptr [ebp + arg_10]                 # 0050cc51
    js.d8 L_0050cc71                             # 0050cc54
    # block 0x0050cc56: entered by fall-through of js at 0x0050cc54, 5 instruction(s), calls indirect dword ptr [ebp + 0x14], ends with backward jump to 0x0050cc51
    mov ecx, dword ptr [ebp + arg_8]             # 0050cc56
    sub ecx, dword ptr [ebp + arg_c]             # 0050cc59
    mov dword ptr [ebp + arg_8], ecx             # 0050cc5c
    call dword ptr [ebp + arg_14]                # 0050cc5f
    jmp.d8 L_0050cc51                            # 0050cc62
    # block 0x0050cc64: entered by follows jmp at 0x0050cc62, 4 instruction(s), calls FUN_0050cc86, ends with ret
    push dword ptr [ebp - local_14]              # 0050cc64
    call FUN_0050cc86                            # 0050cc67
    pop ecx                                      # 0050cc6c
    ret                                          # 0050cc6d
    # block 0x0050cc6e: entered by follows ret at 0x0050cc6d, 1 instruction(s), falls into the block at 0x0050cc71
    mov esp, dword ptr [ebp - local_18]          # 0050cc6e
L_0050cc71:
    # block 0x0050cc71: entered by js at 0x0050cc54, 8 instruction(s), ends with ret 0x10
    or dword ptr [ebp - local_4], -0x1           # 0050cc71
    mov ecx, dword ptr [ebp - local_10]          # 0050cc75
    mov dword ptr fs:[0x0], ecx                  # 0050cc78
    pop edi                                      # 0050cc7f
    pop esi                                      # 0050cc80
    pop ebx                                      # 0050cc81
    leave                                        # 0050cc82
    ret 0x10                                     # 0050cc83

