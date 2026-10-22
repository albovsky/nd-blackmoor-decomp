# FUN_004ccd25
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccd25
# extent:       0x004ccd25-0x004ccd35 (16 code bytes)
# span:         0x004ccd25-0x004ccd40 (code 16, tables 0, padding 11)
# sha256:       e57567670df6301f4e129f5444f2fc1f19ab13eb8c567f54e6ffd95a16b7886b
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ccd25_get_constant
# naming:       native port src/original_methods_fl39e.c:m4ccd25_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52e258 (loaded into eax); self is saved and ignored, nothing is called or written. No jumps; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4ccd25_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004ccd25 - 0x401000
.globl FUN_004ccd25
FUN_004ccd25:
    # block 0x004ccd25: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004ccd25
    {load} mov ebp, esp                          # 004ccd26
    push ecx                                     # 004ccd28
    mov dword ptr [ebp - local_4], ecx           # 004ccd29
    mov eax, 0x52e258                            # 004ccd2c
    {load} mov esp, ebp                          # 004ccd31
    pop ebp                                      # 004ccd33
    ret                                          # 004ccd34

# --- data items (not part of the function) -------------------------
.org 0x004ccd35 - 0x401000
PAD_004ccd35:  # 11 byte(s) of int3 padding
    .fill 11, 1, 0xcc

