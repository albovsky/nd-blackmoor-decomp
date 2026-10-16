# FUN_0044c4ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c4ab
# extent:       0x0044c4ab-0x0044c4c1 (22 code bytes)
# span:         0x0044c4ab-0x0044c4c1 (code 22, tables 0, padding 0)
# sha256:       20a525f4e4af04f5ad5548f1023fd4864472cabd7bcccc9fecae0b90781c0b93
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c4ab
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:convo3f_cel_reader_iteration (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0044c4ab - 0x401000
.globl FUN_0044c4ab
FUN_0044c4ab:
    # block 0x0044c4ab: entry, 5 instruction(s), ends with je to 0x0044c4bf (forward)
    push ebp                                     # 0044c4ab
    {load} mov ebp, esp                          # 0044c4ac
    mov eax, dword ptr [ebp + arg_8]             # 0044c4ae
    cmp dword ptr [eax], 0x2                     # 0044c4b1
    je.d8 L_0044c4bf                             # 0044c4b4
    # block 0x0044c4b6: entered by fall-through of je at 0x0044c4b4, 2 instruction(s), falls into the block at 0x0044c4bf
    mov ecx, dword ptr [ebp + arg_8]             # 0044c4b6
    mov dword ptr [ecx], 0x0                     # 0044c4b9
L_0044c4bf:
    # block 0x0044c4bf: entered by je at 0x0044c4b4, 2 instruction(s), ends with ret
    pop ebp                                      # 0044c4bf
    ret                                          # 0044c4c0

