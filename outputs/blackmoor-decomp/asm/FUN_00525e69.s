# FUN_00525e69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525e69
# extent:       0x00525e69-0x00525e8c (35 code bytes)
# span:         0x00525e69-0x00525e8c (code 35, tables 0, padding 0)
# sha256:       f361988dda1ca8c0fdac8cfbf1552ecf9cd43b2d6ed237249e660a00fcf88f07
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525e69
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetOEMCP, KERNEL32.dll!GetCPInfo
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00525e8c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------

.org 0x00525e69 - 0x401000
.globl FUN_00525e69
FUN_00525e69:
    # block 0x00525e69: entry, 15 instruction(s), calls KERNEL32.dll!GetOEMCP, KERNEL32.dll!GetCPInfo, ends with ret
    push ebp                                     # 00525e69
    {load} mov ebp, esp                          # 00525e6a
    sub esp, 0x14                                # 00525e6c
    lea eax, [ebp - local_14]                    # 00525e6f
    push eax                                     # 00525e72
    call dword ptr [0x52a0ec]                    # 00525e73
    push eax                                     # 00525e79
    call dword ptr [0x52a0e8]                    # 00525e7a
    push 0x1                                     # 00525e80
    pop eax                                      # 00525e82
    cmp eax, dword ptr [ebp - local_14]          # 00525e83
    {load} sbb eax, eax                          # 00525e86
    neg eax                                      # 00525e88
    leave                                        # 00525e8a
    ret                                          # 00525e8b

