# FUN_004fe640
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe640
# extent:       0x004fe640-0x004fe652 (18 code bytes)
# span:         0x004fe640-0x004fe660 (code 18, tables 0, padding 14)
# sha256:       661afd5c6af785b2f4e08dd517fa5b1a3141cfa92802d06892ca7c97073522b5
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe640
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8, field_c; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004fe640 - 0x401000
.globl FUN_004fe640
FUN_004fe640:
    # block 0x004fe640: entry, 7 instruction(s), ends with ret
    mov ecx, dword ptr [esp + stk_4]             # 004fe640
    {load} xor eax, eax                          # 004fe644
    mov dword ptr [ecx], eax                     # 004fe646
    mov dword ptr [ecx + field_4], eax           # 004fe648
    mov dword ptr [ecx + field_8], eax           # 004fe64b
    mov dword ptr [ecx + field_c], eax           # 004fe64e
    ret                                          # 004fe651

# --- data items (not part of the function) -------------------------
.org 0x004fe652 - 0x401000
PAD_004fe652:  # 14 byte(s) of nop padding
    .fill 14, 1, 0x90

