# FUN_00507890
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00507890
# extent:       0x00507890-0x005078a6 (22 code bytes)
# span:         0x00507890-0x005078b0 (code 22, tables 0, padding 10)
# sha256:       c4d6859141f0d62b925488f6a650ea2d2e06c28b4dbfd89c52b20d3e2455e6eb
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00507890
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005078b0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00507890 - 0x401000
.globl FUN_00507890
FUN_00507890:
    # block 0x00507890: entry, 4 instruction(s), ends with je to 0x005078a5 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 00507890
    {load} xor eax, eax                          # 00507894
    test ecx, ecx                                # 00507896
    je.d8 L_005078a5                             # 00507898
L_0050789a:
    # block 0x0050789a: entered by jne at 0x005078a3; fall-through of je at 0x00507898, 5 instruction(s), ends with jne to 0x0050789a (backward)
    {load} mov edx, ecx                          # 0050789a
    and edx, 0x1                                 # 0050789c
    {load} add eax, edx                          # 0050789f
    shr ecx                                      # 005078a1
    jne.d8 L_0050789a                            # 005078a3
L_005078a5:
    # block 0x005078a5: entered by je at 0x00507898; fall-through of jne at 0x005078a3, 1 instruction(s), ends with ret
    ret                                          # 005078a5

# --- data items (not part of the function) -------------------------
.org 0x005078a6 - 0x401000
PAD_005078a6:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

