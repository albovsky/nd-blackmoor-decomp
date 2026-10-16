# FUN_005274eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005274eb
# extent:       0x005274eb-0x005274fa (15 code bytes)
# span:         0x005274eb-0x005274fa (code 15, tables 0, padding 0)
# sha256:       d9d68131b4cb76f4da2a833c549b829de3e02cd33ad13648da86aee0dc6046cc
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005274eb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0043ef27
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0043ef27, .text + (0x0043ef27 - 0x401000)

.org 0x005274eb - 0x401000
.globl FUN_005274eb
FUN_005274eb:
    # block 0x005274eb: entry, 4 instruction(s), calls FUN_0043ef27, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005274eb
    add ecx, 0x62ba5                             # 005274ee
    call FUN_0043ef27                            # 005274f4
    ret                                          # 005274f9

