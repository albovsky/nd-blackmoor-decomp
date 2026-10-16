# FUN_0044c479
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c479
# extent:       0x0044c479-0x0044c4ab (50 code bytes)
# span:         0x0044c479-0x0044c4ab (code 50, tables 0, padding 0)
# sha256:       54c215e74ea4051a44fbcde7dd6a5d1412ae20c4c8a2d0a2d814175ddbd3d377
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c479
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!Sleep
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:convo3f_cel_reader_iteration (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0044c479 - 0x401000
.globl FUN_0044c479
FUN_0044c479:
    # block 0x0044c479: entry, 2 instruction(s), falls into the block at 0x0044c47c
    push ebp                                     # 0044c479
    {load} mov ebp, esp                          # 0044c47a
L_0044c47c:
    # block 0x0044c47c: entered by jmp at 0x0044c48c, 3 instruction(s), ends with jne to 0x0044c48e (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0044c47c
    cmp dword ptr [eax], 0x1                     # 0044c47f
    jne.d8 L_0044c48e                            # 0044c482
    # block 0x0044c484: entered by fall-through of jne at 0x0044c482, 3 instruction(s), calls KERNEL32.dll!Sleep, ends with backward jump to 0x0044c47c
    push 0x1                                     # 0044c484
    call dword ptr [0x52a2b0]                    # 0044c486
    jmp.d8 L_0044c47c                            # 0044c48c
L_0044c48e:
    # block 0x0044c48e: entered by jne at 0x0044c482, 3 instruction(s), ends with jne to 0x0044c49c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0044c48e
    cmp dword ptr [ecx], 0x2                     # 0044c491
    jne.d8 L_0044c49c                            # 0044c494
    # block 0x0044c496: entered by fall-through of jne at 0x0044c494, 2 instruction(s), ends with forward jump to 0x0044c4a9
    mov ax, 0x2                                  # 0044c496
    jmp.d8 L_0044c4a9                            # 0044c49a
L_0044c49c:
    # block 0x0044c49c: entered by jne at 0x0044c494, 3 instruction(s), falls into the block at 0x0044c4a9
    mov edx, dword ptr [ebp + arg_8]             # 0044c49c
    mov dword ptr [edx], 0x1                     # 0044c49f
    mov ax, 0x1                                  # 0044c4a5
L_0044c4a9:
    # block 0x0044c4a9: entered by jmp at 0x0044c49a, 2 instruction(s), ends with ret
    pop ebp                                      # 0044c4a9
    ret                                          # 0044c4aa

