# FUN_0049026c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049026c
# extent:       0x0049026c-0x0049027c (16 code bytes)
# span:         0x0049026c-0x0049027c (code 16, tables 0, padding 0)
# sha256:       565fc161bf5c56051c613fad6bd2751f2054636c2e15be761998d32120031fea
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049026c
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

.org 0x0049026c - 0x401000
.globl FUN_0049026c
FUN_0049026c:
    # block 0x0049026c: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0049026c
    {load} mov ebp, esp                          # 0049026d
    push ecx                                     # 0049026f
    mov dword ptr [ebp - local_4], ecx           # 00490270
    mov eax, 0x52da50                            # 00490273
    {load} mov esp, ebp                          # 00490278
    pop ebp                                      # 0049027a
    ret                                          # 0049027b

