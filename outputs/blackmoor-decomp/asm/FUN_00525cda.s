# FUN_00525cda
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525cda
# extent:       0x00525cda-0x00525d10 (54 code bytes)
# span:         0x00525cda-0x00525d10 (code 54, tables 0, padding 0)
# sha256:       5fa75c5a8c3e8d24d0f0b655f5b3b8e0c3a0d5f3777bc892c7403bdb3f6f48ca
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525cda
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_18; [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00525d10
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)

.org 0x00525cda - 0x401000
.globl FUN_00525cda
FUN_00525cda:
    # block 0x00525cda: entry, 9 instruction(s), calls FUN_0050f978, ends with je to 0x00525d04 (forward)
    mov eax, 0x5290f4                            # 00525cda
    call FUN_0050f978                            # 00525cdf
    push ecx                                     # 00525ce4
    mov dword ptr [ebp - field_minus_10], ecx    # 00525ce5
    mov dword ptr [ecx], 0x52f440                # 00525ce8
    mov eax, dword ptr [0x63c740]                # 00525cee
    and dword ptr [ebp - field_minus_4], 0x0     # 00525cf3
    test eax, eax                                # 00525cf7
    je.d8 L_00525d04                             # 00525cf9
    # block 0x00525cfb: entered by fall-through of je at 0x00525cf9, 3 instruction(s), ends with je to 0x00525d04 (forward)
    mov eax, dword ptr [eax + field_18]          # 00525cfb
    test eax, eax                                # 00525cfe
    je.d8 L_00525d04                             # 00525d00
    # block 0x00525d02: entered by fall-through of je at 0x00525d00, 1 instruction(s), calls indirect eax, falls into the block at 0x00525d04
    call eax                                     # 00525d02
L_00525d04:
    # block 0x00525d04: entered by je at 0x00525cf9; je at 0x00525d00, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525d04
    mov dword ptr fs:[0x0], ecx                  # 00525d07
    leave                                        # 00525d0e
    ret                                          # 00525d0f

