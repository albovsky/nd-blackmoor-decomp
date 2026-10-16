# FUN_00521756
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521756
# extent:       0x00521756-0x0052178e (56 code bytes)
# span:         0x00521756-0x0052178e (code 56, tables 0, padding 0)
# sha256:       fae58bd531f97a7cbd4c6d0ffc9bd21823170bdb69f233bf5d9aca105aa336e1
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521756
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051b414, FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051b414, .text + (0x0051b414 - 0x401000)

.org 0x00521756 - 0x401000
.globl FUN_00521756
FUN_00521756:
    # block 0x00521756: entry, 17 instruction(s), calls FUN_0050f978, FUN_0051b414, FUN_0051b257, ends with ret
    mov eax, 0x528c50                            # 00521756
    call FUN_0050f978                            # 0052175b
    push ecx                                     # 00521760
    push esi                                     # 00521761
    {load} mov esi, ecx                          # 00521762
    mov dword ptr [ebp - field_minus_10], esi    # 00521764
    mov dword ptr [esi], 0x52ed6c                # 00521767
    and dword ptr [ebp - field_minus_4], 0x0     # 0052176d
    call FUN_0051b414                            # 00521771
    or dword ptr [ebp - field_minus_4], -0x1     # 00521776
    {load} mov ecx, esi                          # 0052177a
    call FUN_0051b257                            # 0052177c
    mov ecx, dword ptr [ebp - field_minus_c]     # 00521781
    pop esi                                      # 00521784
    mov dword ptr fs:[0x0], ecx                  # 00521785
    leave                                        # 0052178c
    ret                                          # 0052178d

