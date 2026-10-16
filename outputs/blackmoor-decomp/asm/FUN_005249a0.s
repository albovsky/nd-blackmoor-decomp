# FUN_005249a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005249a0
# extent:       0x005249a0-0x005249d1 (49 code bytes)
# span:         0x005249a0-0x005249d1 (code 49, tables 0, padding 0)
# sha256:       ec30bef163878adc822f8d63580c26137e1090e7aa477f4259a5be470668120e
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005249a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_005256dd, FUN_00524c35
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005249d1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00524c35, .text + (0x00524c35 - 0x401000)
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x005249a0 - 0x401000
.globl FUN_005249a0
FUN_005249a0:
    # block 0x005249a0: entry, 11 instruction(s), calls FUN_0050f978, FUN_005256dd, ends with je to 0x005249c5 (forward)
    mov eax, 0x528c29                            # 005249a0
    call FUN_0050f978                            # 005249a5
    push ecx                                     # 005249aa
    push 0x10                                    # 005249ab
    call FUN_005256dd                            # 005249ad
    {load} mov ecx, eax                          # 005249b2
    mov dword ptr [ebp - field_minus_10], ecx    # 005249b4
    {load} xor eax, eax                          # 005249b7
    {load} cmp ecx, eax                          # 005249b9
    mov dword ptr [ebp - field_minus_4], eax     # 005249bb
    je.d8 L_005249c5                             # 005249be
    # block 0x005249c0: entered by fall-through of je at 0x005249be, 1 instruction(s), calls FUN_00524c35, falls into the block at 0x005249c5
    call FUN_00524c35                            # 005249c0
L_005249c5:
    # block 0x005249c5: entered by je at 0x005249be, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 005249c5
    mov dword ptr fs:[0x0], ecx                  # 005249c8
    leave                                        # 005249cf
    ret                                          # 005249d0

