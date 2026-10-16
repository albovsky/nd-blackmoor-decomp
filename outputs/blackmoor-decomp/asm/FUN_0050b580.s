# FUN_0050b580
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b580
# extent:       0x0050b580-0x0050b59e (30 code bytes)
# span:         0x0050b580-0x0050b5a0 (code 30, tables 0, padding 2)
# sha256:       7bae870184f7d207198f8ddcec926a8f5775df0dd542a225ada7cf887bea924e
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b580
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8; [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0050b580 - 0x401000
.globl FUN_0050b580
FUN_0050b580:
    # block 0x0050b580: entry, 7 instruction(s), ends with jle to 0x0050b598 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0050b580
    mov edx, dword ptr [esp + stk_8]             # 0050b584
    mov ecx, dword ptr [eax + field_8]           # 0050b588
    {load} add ecx, edx                          # 0050b58b
    mov edx, dword ptr [eax + field_4]           # 0050b58d
    {load} cmp ecx, edx                          # 0050b590
    jle.d8 L_0050b598                            # 0050b592
    # block 0x0050b594: entered by fall-through of jle at 0x0050b592, 2 instruction(s), ends with ret
    or eax, -0x1                                 # 0050b594
    ret                                          # 0050b597
L_0050b598:
    # block 0x0050b598: entered by jle at 0x0050b592, 3 instruction(s), ends with ret
    mov dword ptr [eax + field_8], ecx           # 0050b598
    {load} xor eax, eax                          # 0050b59b
    ret                                          # 0050b59d

# --- data items (not part of the function) -------------------------
.org 0x0050b59e - 0x401000
PAD_0050b59e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

