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
# name:         m481ca9_get_constant
# naming:       native port src/original_methods_fl36b.c:m481ca9_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d610u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m481ca9_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

