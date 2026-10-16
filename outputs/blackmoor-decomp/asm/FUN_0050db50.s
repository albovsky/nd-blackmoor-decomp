# FUN_0050db50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050db50
# extent:       0x0050db50-0x0050db77 (39 code bytes)
# span:         0x0050db50-0x0050db77 (code 39, tables 0, padding 0)
# sha256:       61e62304347e294cb52e76f3b5cc064b748e44dd24d48e3550c00e35746640a3
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050db50
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050db50 - 0x401000
.globl FUN_0050db50
FUN_0050db50:
    # block 0x0050db50: entry, 16 instruction(s), ends with je to 0x0050db71 (forward)
    push ebp                                     # 0050db50
    {load} mov ebp, esp                          # 0050db51
    push edi                                     # 0050db53
    mov edi, dword ptr [ebp + arg_8]             # 0050db54
    {load} xor eax, eax                          # 0050db57
    or ecx, -0x1                                 # 0050db59
    repne scasb al, byte ptr es:[edi]            # 0050db5c
    inc ecx                                      # 0050db5e
    neg ecx                                      # 0050db5f
    dec edi                                      # 0050db61
    mov al, byte ptr [ebp + arg_c]               # 0050db62
    std                                          # 0050db65
    repne scasb al, byte ptr es:[edi]            # 0050db66
    inc edi                                      # 0050db68
    cmp byte ptr [edi], al                       # 0050db69
    je.d8 L_0050db71                             # 0050db6b
    # block 0x0050db6d: entered by fall-through of je at 0x0050db6b, 2 instruction(s), ends with forward jump to 0x0050db73
    {load} xor eax, eax                          # 0050db6d
    jmp.d8 L_0050db73                            # 0050db6f
L_0050db71:
    # block 0x0050db71: entered by je at 0x0050db6b, 1 instruction(s), falls into the block at 0x0050db73
    {load} mov eax, edi                          # 0050db71
L_0050db73:
    # block 0x0050db73: entered by jmp at 0x0050db6f, 4 instruction(s), ends with ret
    cld                                          # 0050db73
    pop edi                                      # 0050db74
    leave                                        # 0050db75
    ret                                          # 0050db76

