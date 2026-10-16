# FUN_0048d119
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d119
# extent:       0x0048d119-0x0048d12d (20 code bytes)
# span:         0x0048d119-0x0048d12d (code 20, tables 0, padding 0)
# sha256:       8c62a9089891988c7c8a2be6d1860b142f8396ebfc65e3c599d3d07a27ea73f6
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048d119
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

.org 0x0048d119 - 0x401000
.globl FUN_0048d119
FUN_0048d119:
    # block 0x0048d119: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048d119
    {load} mov ebp, esp                          # 0048d11a
    push ecx                                     # 0048d11c
    mov dword ptr [ebp - local_4], ecx           # 0048d11d
    mov word ptr [0x594daf], 0x0                 # 0048d120
    {load} mov esp, ebp                          # 0048d129
    pop ebp                                      # 0048d12b
    ret                                          # 0048d12c

