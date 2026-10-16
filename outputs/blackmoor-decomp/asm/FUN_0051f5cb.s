# FUN_0051f5cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f5cb
# extent:       0x0051f5cb-0x0051f603 (56 code bytes)
# span:         0x0051f5cb-0x0051f603 (code 56, tables 0, padding 0)
# sha256:       7fe2be82b3e9065ca7b61a20f9daee8d1245f9f0f831d1bf342c816a88226204
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f5cb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10, field_minus_14; [ecx + n] field_c
# callees:      calls FUN_0050f978; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)

.org 0x0051f5cb - 0x401000
.globl FUN_0051f5cb
FUN_0051f5cb:
    # block 0x0051f5cb: entry, 10 instruction(s), calls FUN_0050f978, ends with je to 0x0051f5f4 (forward)
    mov eax, 0x528fb4                            # 0051f5cb
    call FUN_0050f978                            # 0051f5d0
    sub esp, 0xc                                 # 0051f5d5
    push ebx                                     # 0051f5d8
    push esi                                     # 0051f5d9
    {load} xor eax, eax                          # 0051f5da
    push edi                                     # 0051f5dc
    cmp dword ptr [ecx + field_c], eax           # 0051f5dd
    mov dword ptr [ebp - field_minus_10], esp    # 0051f5e0
    je.d8 L_0051f5f4                             # 0051f5e3
    # block 0x0051f5e5: entered by fall-through of je at 0x0051f5e3, 5 instruction(s), calls indirect dword ptr [ecx + 0xc], falls into the block at 0x0051f5f4
    mov dword ptr [ebp - field_minus_14], eax    # 0051f5e5
    mov dword ptr [ebp - field_minus_4], eax     # 0051f5e8
    call dword ptr [ecx + field_c]               # 0051f5eb
    mov dword ptr [ebp - field_minus_14], eax    # 0051f5ee
    mov eax, dword ptr [ebp - field_minus_14]    # 0051f5f1
L_0051f5f4:
    # block 0x0051f5f4: entered by je at 0x0051f5e3, 7 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051f5f4
    pop edi                                      # 0051f5f7
    pop esi                                      # 0051f5f8
    mov dword ptr fs:[0x0], ecx                  # 0051f5f9
    pop ebx                                      # 0051f600
    leave                                        # 0051f601
    ret                                          # 0051f602

