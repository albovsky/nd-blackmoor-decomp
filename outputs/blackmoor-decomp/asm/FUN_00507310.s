# FUN_00507310
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507310
# extent:       0x00507310-0x00507331 (33 code bytes)
# span:         0x00507310-0x00507340 (code 33, tables 0, padding 15)
# sha256:       c753e57679e01e0645031aff1d00240119e012b1e524f43b5a1d90fa022b3819
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507310
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00507310 - 0x401000
.globl FUN_00507310
FUN_00507310:
    # block 0x00507310: entry, 8 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00507310
    mov ecx, dword ptr [eax]                     # 00507314
    and ecx, 0x7fffffff                          # 00507316
    mov dword ptr [esp + stk_4], ecx             # 0050731c
    fild dword ptr [esp + stk_4]                 # 00507320
    fmul dword ptr [0x52e61c]                    # 00507324
    fsub dword ptr [0x52e618]                    # 0050732a
    ret                                          # 00507330

# --- data items (not part of the function) -------------------------
.org 0x00507331 - 0x401000
PAD_00507331:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

