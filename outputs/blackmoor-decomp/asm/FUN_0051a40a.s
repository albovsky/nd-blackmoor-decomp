# FUN_0051a40a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a40a
# extent:       0x0051a40a-0x0051a431 (39 code bytes)
# span:         0x0051a40a-0x0051a431 (code 39, tables 0, padding 0)
# sha256:       5eb6786b3309402f133d6f08d20087f64d28fd18f2a74c27b4b99642600ad32f
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CMap<>
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0051a40a - 0x401000
.globl FUN_0051a40a
FUN_0051a40a:
    # block 0x0051a40a: entry, 11 instruction(s), ends with ret 0x4
    {load} mov eax, ecx                          # 0051a40a
    {load} xor ecx, ecx                          # 0051a40c
    mov dword ptr [eax + field_4], ecx           # 0051a40e
    mov dword ptr [eax + field_c], ecx           # 0051a411
    mov dword ptr [eax + field_10], ecx          # 0051a414
    mov dword ptr [eax + field_14], ecx          # 0051a417
    mov ecx, dword ptr [esp + stk_4]             # 0051a41a
    mov dword ptr [eax], 0x52febc                # 0051a41e
    mov dword ptr [eax + field_8], 0x11          # 0051a424
    mov dword ptr [eax + field_18], ecx          # 0051a42b
    ret 0x4                                      # 0051a42e

