# FUN_0050bf30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bf30
# extent:       0x0050bf30-0x0050bf48 (24 code bytes)
# span:         0x0050bf30-0x0050bf50 (code 24, tables 0, padding 8)
# sha256:       41161b16ab6a945d61d3c8576fed2f7fc40f568598f756c4d9043b3cdbc85e5d
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bf30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0050bf30 - 0x401000
.globl FUN_0050bf30
FUN_0050bf30:
    # block 0x0050bf30: entry, 10 instruction(s), ends with ret
    mov ecx, dword ptr [esp + stk_4]             # 0050bf30
    mov eax, dword ptr [ecx + field_4]           # 0050bf34
    add eax, 0x7                                 # 0050bf37
    cdq                                          # 0050bf3a
    and edx, 0x7                                 # 0050bf3b
    {load} add eax, edx                          # 0050bf3e
    mov edx, dword ptr [ecx]                     # 0050bf40
    sar eax, 0x3                                 # 0050bf42
    {load} add eax, edx                          # 0050bf45
    ret                                          # 0050bf47

# --- data items (not part of the function) -------------------------
.org 0x0050bf48 - 0x401000
PAD_0050bf48:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

