# FUN_0051a28e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a28e
# extent:       0x0051a28e-0x0051a2b1 (35 code bytes)
# span:         0x0051a28e-0x0051a2b1 (code 35, tables 0, padding 0)
# sha256:       28d8a26ac9f424d428d5e1d2d903c9d011b94af83dc7183db73b7d7cce923a14
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a28e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x0051a28e - 0x401000
.globl FUN_0051a28e
FUN_0051a28e:
    # block 0x0051a28e: entry, 11 instruction(s), ends with ret 0x4
    {load} mov eax, ecx                          # 0051a28e
    {load} xor ecx, ecx                          # 0051a290
    mov dword ptr [eax + field_c], ecx           # 0051a292
    mov dword ptr [eax + field_10], ecx          # 0051a295
    mov dword ptr [eax + field_8], ecx           # 0051a298
    mov dword ptr [eax + field_4], ecx           # 0051a29b
    mov dword ptr [eax + field_14], ecx          # 0051a29e
    mov ecx, dword ptr [esp + stk_4]             # 0051a2a1
    mov dword ptr [eax], 0x530128                # 0051a2a5
    mov dword ptr [eax + field_18], ecx          # 0051a2ab
    ret 0x4                                      # 0051a2ae

