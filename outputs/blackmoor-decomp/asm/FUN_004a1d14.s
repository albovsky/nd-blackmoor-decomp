# FUN_004a1d14
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1d14
# extent:       0x004a1d14-0x004a1d3a (38 code bytes)
# span:         0x004a1d14-0x004a1d3a (code 38, tables 0, padding 0)
# sha256:       9be96760562199bbf414b1184e2a49f50f826d02c698415abedba527588ded60
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a1d14
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004a1d14 - 0x401000
.globl FUN_004a1d14
FUN_004a1d14:
    # block 0x004a1d14: entry, 15 instruction(s), ends with ret
    push ebp                                     # 004a1d14
    {load} mov ebp, esp                          # 004a1d15
    push ecx                                     # 004a1d17
    push edi                                     # 004a1d18
    mov dword ptr [ebp - local_4], ecx           # 004a1d19
    mov word ptr [0x594d80], 0x0                 # 004a1d1c
    mov ecx, 0xb                                 # 004a1d25
    or eax, -0x1                                 # 004a1d2a
    mov edi, 0x594d82                            # 004a1d2d
    rep stosd dword ptr es:[edi], eax            # 004a1d32
    stosb byte ptr es:[edi], al                  # 004a1d34
    pop edi                                      # 004a1d35
    {load} mov esp, ebp                          # 004a1d36
    pop ebp                                      # 004a1d38
    ret                                          # 004a1d39

