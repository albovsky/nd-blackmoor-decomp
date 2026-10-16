# FUN_0046b73e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b73e
# extent:       0x0046b73e-0x0046b75b (29 code bytes)
# span:         0x0046b73e-0x0046b75b (code 29, tables 0, padding 0)
# sha256:       c2a9fc131176380512e1f121105dc4b8a5ae1671d98e2dceae99dbc34cd2aea9
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046b73e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0046b73e - 0x401000
.globl FUN_0046b73e
FUN_0046b73e:
    # block 0x0046b73e: entry, 9 instruction(s), ends with ret
    push ebp                                     # 0046b73e
    {load} mov ebp, esp                          # 0046b73f
    push ecx                                     # 0046b741
    mov dword ptr [ebp - local_4], ecx           # 0046b742
    mov word ptr [0x5a14db], 0x0                 # 0046b745
    mov word ptr [0x5a14dd], 0x270f              # 0046b74e
    {load} mov esp, ebp                          # 0046b757
    pop ebp                                      # 0046b759
    ret                                          # 0046b75a

