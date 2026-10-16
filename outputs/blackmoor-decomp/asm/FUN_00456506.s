# FUN_00456506
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456506
# extent:       0x00456506-0x00456516 (16 code bytes)
# span:         0x00456506-0x00456516 (code 16, tables 0, padding 0)
# sha256:       f50439c8147f7e621e6ef300878f8e9007ff54b8c157450da5d1a52b283e0711
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00456506
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00456506 - 0x401000
.globl FUN_00456506
FUN_00456506:
    # block 0x00456506: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00456506
    {load} mov ebp, esp                          # 00456507
    push ecx                                     # 00456509
    mov dword ptr [ebp - local_4], ecx           # 0045650a
    mov eax, 0x52cd30                            # 0045650d
    {load} mov esp, ebp                          # 00456512
    pop ebp                                      # 00456514
    ret                                          # 00456515

