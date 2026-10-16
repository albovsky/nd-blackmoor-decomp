# FUN_00525565
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525565
# extent:       0x00525565-0x0052558e (41 code bytes)
# span:         0x00525565-0x0052558e (code 41, tables 0, padding 0)
# sha256:       fd2d98199c20ccaf41a5dca974f0f5e5aeef4dd3e5f136bf85657fd9991500a3
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525565
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_00520ffe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052558e
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

.org 0x00525565 - 0x401000
.globl FUN_00525565
FUN_00525565:
    # block 0x00525565: entry, 11 instruction(s), calls FUN_0050f978, FUN_00520ffe, ends with ret
    mov eax, 0x52904c                            # 00525565
    call FUN_0050f978                            # 0052556a
    push ecx                                     # 0052556f
    mov dword ptr [ebp - field_minus_10], ecx    # 00525570
    mov dword ptr [ecx], 0x52fcf8                # 00525573
    and dword ptr [ebp - field_minus_4], 0x0     # 00525579
    call FUN_00520ffe                            # 0052557d
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525582
    mov dword ptr fs:[0x0], ecx                  # 00525585
    leave                                        # 0052558c
    ret                                          # 0052558d

