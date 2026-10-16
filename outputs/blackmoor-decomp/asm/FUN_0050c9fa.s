# FUN_0050c9fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c9fa
# extent:       0x0050c9fa-0x0050ca1d (35 code bytes)
# span:         0x0050c9fa-0x0050ca1d (code 35, tables 0, padding 0)
# sha256:       f76d4762309bc99cca09c362e23186ea946e381371e2c32604976b615a4e92e4
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c9fa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8, field_c; [edx + n] field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050c9fa - 0x401000
.globl FUN_0050c9fa
FUN_0050c9fa:
    # block 0x0050c9fa: entry, 4 instruction(s), ends with jne to 0x0050ca1c (forward)
    {load} xor eax, eax                          # 0050c9fa
    mov ecx, dword ptr fs:[0x0]                  # 0050c9fc
    cmp dword ptr [ecx + field_4], 0x50c970      # 0050ca03
    jne.d8 L_0050ca1c                            # 0050ca0a
    # block 0x0050ca0c: entered by fall-through of jne at 0x0050ca0a, 4 instruction(s), ends with jne to 0x0050ca1c (forward)
    mov edx, dword ptr [ecx + field_c]           # 0050ca0c
    mov edx, dword ptr [edx + field_c]           # 0050ca0f
    cmp dword ptr [ecx + field_8], edx           # 0050ca12
    jne.d8 L_0050ca1c                            # 0050ca15
    # block 0x0050ca17: entered by fall-through of jne at 0x0050ca15, 1 instruction(s), falls into the block at 0x0050ca1c
    mov eax, 0x1                                 # 0050ca17
L_0050ca1c:
    # block 0x0050ca1c: entered by jne at 0x0050ca0a; jne at 0x0050ca15, 1 instruction(s), ends with ret
    ret                                          # 0050ca1c

