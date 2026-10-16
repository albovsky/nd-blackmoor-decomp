# FUN_00509210
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509210
# extent:       0x00509210-0x00509225 (21 code bytes)
# span:         0x00509210-0x00509230 (code 21, tables 0, padding 11)
# sha256:       f810d8994d1814fc2a7f02263c7d817b26ace41df1e148bc4f854e4e5ac64827
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00508bc0 (+0x650)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509210
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00509210 - 0x401000
.globl FUN_00509210
FUN_00509210:
    # block 0x00509210: entry, 9 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00509210
    mov edx, dword ptr [esp + stk_8]             # 00509214
    mov ecx, dword ptr [eax]                     # 00509218
    mov eax, dword ptr [edx]                     # 0050921a
    mov ecx, dword ptr [ecx]                     # 0050921c
    mov edx, dword ptr [eax]                     # 0050921e
    {load} sub ecx, edx                          # 00509220
    {load} mov eax, ecx                          # 00509222
    ret                                          # 00509224

# --- data items (not part of the function) -------------------------
.org 0x00509225 - 0x401000
PAD_00509225:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

