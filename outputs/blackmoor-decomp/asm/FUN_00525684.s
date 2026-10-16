# FUN_00525684
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525684
# extent:       0x00525684-0x00525697 (19 code bytes)
# span:         0x00525684-0x00525697 (code 19, tables 0, padding 0)
# sha256:       8aa23e79b029b1c31ea25a2d2cd2033435937f9f688ceb5eff2cf0aa96a45c7d
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525684
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00525684 - 0x401000
.globl FUN_00525684
FUN_00525684:
    # block 0x00525684: entry, 8 instruction(s), ends with ret 0x4
    mov edx, dword ptr [ecx + field_4]           # 00525684
    mov eax, dword ptr [esp + stk_4]             # 00525687
    push esi                                     # 0052568b
    mov esi, dword ptr [ecx]                     # 0052568c
    mov dword ptr [edx + eax], esi               # 0052568e
    mov dword ptr [ecx], eax                     # 00525691
    pop esi                                      # 00525693
    ret 0x4                                      # 00525694

