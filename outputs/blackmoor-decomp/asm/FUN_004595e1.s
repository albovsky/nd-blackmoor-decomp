# FUN_004595e1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004595e1
# extent:       0x004595e1-0x004595f1 (16 code bytes)
# span:         0x004595e1-0x004595f1 (code 16, tables 0, padding 0)
# sha256:       06f16c30841859e5c284e5d522391532ab604a0d802dd7005a2e3d4194cd0a44
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004595e1
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

.org 0x004595e1 - 0x401000
.globl FUN_004595e1
FUN_004595e1:
    # block 0x004595e1: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004595e1
    {load} mov ebp, esp                          # 004595e2
    push ecx                                     # 004595e4
    mov dword ptr [ebp - local_4], ecx           # 004595e5
    mov eax, 0x52ce40                            # 004595e8
    {load} mov esp, ebp                          # 004595ed
    pop ebp                                      # 004595ef
    ret                                          # 004595f0

