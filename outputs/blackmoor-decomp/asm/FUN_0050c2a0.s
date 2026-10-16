# FUN_0050c2a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c2a0
# extent:       0x0050c2a0-0x0050c2c9 (41 code bytes)
# span:         0x0050c2a0-0x0050c2c9 (code 41, tables 0, padding 0)
# sha256:       b8a3faf5bb0c307f65ad8a94e9ae6cb5ea9e02c5b1a56f4487587cbcc6fdd457
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c2a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_00520ffe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050c2c9
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00520ffe, .text + (0x00520ffe - 0x401000)

.org 0x0050c2a0 - 0x401000
.globl FUN_0050c2a0
FUN_0050c2a0:
    # block 0x0050c2a0: entry, 11 instruction(s), calls FUN_0050f978, FUN_00520ffe, ends with ret
    mov eax, 0x529060                            # 0050c2a0
    call FUN_0050f978                            # 0050c2a5
    push ecx                                     # 0050c2aa
    mov dword ptr [ebp - field_minus_10], ecx    # 0050c2ab
    mov dword ptr [ecx], 0x52fcf8                # 0050c2ae
    and dword ptr [ebp - field_minus_4], 0x0     # 0050c2b4
    call FUN_00520ffe                            # 0050c2b8
    mov ecx, dword ptr [ebp - field_minus_c]     # 0050c2bd
    mov dword ptr fs:[0x0], ecx                  # 0050c2c0
    leave                                        # 0050c2c7
    ret                                          # 0050c2c8

