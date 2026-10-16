# FUN_00503b80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00503b80
# extent:       0x00503b80-0x00503b95 (21 code bytes)
# span:         0x00503b80-0x00503ba0 (code 21, tables 0, padding 11)
# sha256:       267f47ba5b5bae6dabea3e837edc77b1107df0a8125fdb02af652a120727d032
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00503b80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_40; [ecx + n] field_64; [edx + n] field_4c; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_40, 0x40  # offset +0x40
.equ field_4c, 0x4c  # offset +0x4c
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------

.org 0x00503b80 - 0x401000
.globl FUN_00503b80
FUN_00503b80:
    # block 0x00503b80: entry, 8 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 00503b80
    mov ecx, dword ptr [eax + field_40]          # 00503b84
    {load} xor eax, eax                          # 00503b87
    mov edx, dword ptr [ecx + field_64]          # 00503b89
    mov ecx, dword ptr [edx + field_4c]          # 00503b8c
    test ecx, ecx                                # 00503b8f
    setne al                                     # 00503b91
    ret                                          # 00503b94

# --- data items (not part of the function) -------------------------
.org 0x00503b95 - 0x401000
PAD_00503b95:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

