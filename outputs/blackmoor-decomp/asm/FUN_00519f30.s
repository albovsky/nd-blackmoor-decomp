# FUN_00519f30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519f30
# extent:       0x00519f30-0x00519f40 (16 code bytes)
# span:         0x00519f30-0x00519f40 (code 16, tables 0, padding 0)
# sha256:       629e84b77459a48827d2889ae062a3fbce4088a8b9e3a4dfff027a7a0c5521ed
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519f30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_15; [ecx + n] field_5c
# callees:      calls FUN_00519a3c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_15, 0x15  # offset +0x15
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_00519a3c, .text + (0x00519a3c - 0x401000)

.org 0x00519f30 - 0x401000
.globl FUN_00519f30
FUN_00519f30:
    # block 0x00519f30: entry, 5 instruction(s), calls FUN_00519a3c, ends with ret
    mov eax, dword ptr [ecx + field_5c]          # 00519f30
    or byte ptr [eax + field_15], 0x4            # 00519f33
    push dword ptr [ecx + field_5c]              # 00519f37
    call FUN_00519a3c                            # 00519f3a
    ret                                          # 00519f3f

