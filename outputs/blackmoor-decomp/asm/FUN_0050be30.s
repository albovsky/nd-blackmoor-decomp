# FUN_0050be30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050be30
# extent:       0x0050be30-0x0050be5d (45 code bytes)
# span:         0x0050be30-0x0050be60 (code 45, tables 0, padding 3)
# sha256:       47a4fbac3e23e7d44de3ee341940b31d9dc3a13adefbe1912a26e2461b69132f
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050be30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_c; [esp + n] stk_4, stk_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050be30 - 0x401000
.globl FUN_0050be30
FUN_0050be30:
    # block 0x0050be30: entry, 19 instruction(s), ends with ret
    mov ecx, dword ptr [esp + stk_4]             # 0050be30
    push esi                                     # 0050be34
    mov esi, dword ptr [esp + stk_c]             # 0050be35
    add esi, dword ptr [ecx + field_4]           # 0050be39
    {load} mov eax, esi                          # 0050be3c
    and esi, 0x7                                 # 0050be3e
    cdq                                          # 0050be41
    and edx, 0x7                                 # 0050be42
    mov dword ptr [ecx + field_4], esi           # 0050be45
    {load} add eax, edx                          # 0050be48
    mov edx, dword ptr [ecx + field_c]           # 0050be4a
    sar eax, 0x3                                 # 0050be4d
    {load} add edx, eax                          # 0050be50
    pop esi                                      # 0050be52
    mov dword ptr [ecx + field_c], edx           # 0050be53
    mov edx, dword ptr [ecx]                     # 0050be56
    {load} add edx, eax                          # 0050be58
    mov dword ptr [ecx], edx                     # 0050be5a
    ret                                          # 0050be5c

# --- data items (not part of the function) -------------------------
.org 0x0050be5d - 0x401000
PAD_0050be5d:  # 3 byte(s) of nop padding
    .fill 3, 1, 0x90

