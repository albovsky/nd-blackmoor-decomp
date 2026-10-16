# FUN_00481ca9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00481ca9
# extent:       0x00481ca9-0x00481cb9 (16 code bytes)
# span:         0x00481ca9-0x00481cb9 (code 16, tables 0, padding 0)
# sha256:       b582d2727b41a4e70cf358a7e0faf0a55429e9e6bc14650e37a20a87a9e5bfbf
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00481ca9
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

.org 0x00481ca9 - 0x401000
.globl FUN_00481ca9
FUN_00481ca9:
    # block 0x00481ca9: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00481ca9
    {load} mov ebp, esp                          # 00481caa
    push ecx                                     # 00481cac
    mov dword ptr [ebp - local_4], ecx           # 00481cad
    mov eax, 0x52d610                            # 00481cb0
    {load} mov esp, ebp                          # 00481cb5
    pop ebp                                      # 00481cb7
    ret                                          # 00481cb8

