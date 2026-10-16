# FUN_0051a0ee
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a0ee
# extent:       0x0051a0ee-0x0051a105 (23 code bytes)
# span:         0x0051a0ee-0x0051a105 (code 23, tables 0, padding 0)
# sha256:       37202715f6470da39210e8519436890777e9c64cf8723a46449f4258376b4e85
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a0ee
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0051a0ee - 0x401000
.globl FUN_0051a0ee
FUN_0051a0ee:
    # block 0x0051a0ee: entry, 8 instruction(s), ends with ret
    {load} mov eax, ecx                          # 0051a0ee
    {load} xor ecx, ecx                          # 0051a0f0
    mov dword ptr [eax], 0x52ff78                # 0051a0f2
    mov dword ptr [eax + field_4], ecx           # 0051a0f8
    mov dword ptr [eax + field_10], ecx          # 0051a0fb
    mov dword ptr [eax + field_c], ecx           # 0051a0fe
    mov dword ptr [eax + field_8], ecx           # 0051a101
    ret                                          # 0051a104

