# FUN_0040175a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040175a
# extent:       0x0040175a-0x00401777 (29 code bytes)
# span:         0x0040175a-0x00401777 (code 29, tables 0, padding 0)
# sha256:       d2c027eea05b0b3fe0634503450364e62975ed65d597c9a83716611731b111a8
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040175a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x0040175a - 0x401000
.globl FUN_0040175a
FUN_0040175a:
    # block 0x0040175a: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 0040175a
    {load} mov ebp, esp                          # 0040175b
    push ecx                                     # 0040175d
    mov dword ptr [ebp - local_4], ecx           # 0040175e
    mov dword ptr [0x569138], 0x7                # 00401761
    mov ecx, dword ptr [ebp - local_4]           # 0040176b
    call FUN_00401526                            # 0040176e
    {load} mov esp, ebp                          # 00401773
    pop ebp                                      # 00401775
    ret                                          # 00401776

