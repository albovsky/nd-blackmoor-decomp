# FUN_0052694b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052694b
# extent:       0x0052694b-0x00526978 (45 code bytes)
# span:         0x0052694b-0x00526978 (code 45, tables 0, padding 0)
# sha256:       bb6308b3bdb22d2a2742be38b1d31a7d2cd828b1b08fd1277508227cb94663fd
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052694b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0052116f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0052116f, .text + (0x0052116f - 0x401000)

.org 0x0052694b - 0x401000
.globl FUN_0052694b
FUN_0052694b:
    # block 0x0052694b: entry, 13 instruction(s), calls FUN_0050f978, FUN_0052116f, ends with ret
    mov eax, 0x528e44                            # 0052694b
    call FUN_0050f978                            # 00526950
    push ecx                                     # 00526955
    mov dword ptr [ebp - field_minus_10], ecx    # 00526956
    mov dword ptr [ecx], 0x52f50c                # 00526959
    and dword ptr [ebp - field_minus_4], 0x0     # 0052695f
    add ecx, 0x4                                 # 00526963
    push ecx                                     # 00526966
    call FUN_0052116f                            # 00526967
    mov ecx, dword ptr [ebp - field_minus_c]     # 0052696c
    mov dword ptr fs:[0x0], ecx                  # 0052696f
    leave                                        # 00526976
    ret                                          # 00526977

