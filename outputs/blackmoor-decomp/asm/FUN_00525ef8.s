# FUN_00525ef8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525ef8
# extent:       0x00525ef8-0x00525f21 (41 code bytes)
# span:         0x00525ef8-0x00525f21 (code 41, tables 0, padding 0)
# sha256:       6099e69e39ff38ebc47e1a0800e381be7fadf2c678f67d74f9271930f3b4c0d8
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525ef8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051fa94
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525f21
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051fa94, .text + (0x0051fa94 - 0x401000)

.org 0x00525ef8 - 0x401000
.globl FUN_00525ef8
FUN_00525ef8:
    # block 0x00525ef8: entry, 11 instruction(s), calls FUN_0050f978, FUN_0051fa94, ends with ret
    mov eax, 0x52911c                            # 00525ef8
    call FUN_0050f978                            # 00525efd
    push ecx                                     # 00525f02
    mov dword ptr [ebp - field_minus_10], ecx    # 00525f03
    mov dword ptr [ecx], 0x52ff14                # 00525f06
    and dword ptr [ebp - field_minus_4], 0x0     # 00525f0c
    call FUN_0051fa94                            # 00525f10
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525f15
    mov dword ptr fs:[0x0], ecx                  # 00525f18
    leave                                        # 00525f1f
    ret                                          # 00525f20

