# FUN_00501e90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501e90
# extent:       0x00501e90-0x00501ea7 (23 code bytes)
# span:         0x00501e90-0x00501eb0 (code 23, tables 0, padding 9)
# sha256:       8cf034dfca7adf86479dcd5ebe8ade03c1762c9a606f9bf1a725fec457981fea
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501e90
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00501e90 - 0x401000
.globl FUN_00501e90
FUN_00501e90:
    # block 0x00501e90: entry, 6 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00501e90
    and eax, 0xbf800000                          # 00501e94
    or eax, 0x3f800000                           # 00501e99
    mov dword ptr [esp + stk_4], eax             # 00501e9e
    fld dword ptr [esp + stk_4]                  # 00501ea2
    ret                                          # 00501ea6

# --- data items (not part of the function) -------------------------
.org 0x00501ea7 - 0x401000
PAD_00501ea7:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

