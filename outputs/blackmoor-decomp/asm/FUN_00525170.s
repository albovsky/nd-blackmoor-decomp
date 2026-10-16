# FUN_00525170
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525170
# extent:       0x00525170-0x005251d3 (99 code bytes)
# span:         0x00525170-0x005251d3 (code 99, tables 0, padding 0)
# sha256:       f89fb6e09ef7783da0dea723d4c12ca02ec9fc3323ad49b89b0b4dec0a2c2950
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525170
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14, field_18, field_1c, field_20, field_24, field_28, field_30, field_103c, field_1040, field_1048, field_104c; [ecx + n] field_4, field_8, field_1c, field_20; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_30, 0x30  # offset +0x30
.equ field_103c, 0x103c  # offset +0x103c
.equ field_1040, 0x1040  # offset +0x1040
.equ field_1048, 0x1048  # offset +0x1048
.equ field_104c, 0x104c  # offset +0x104c

# --- external targets -----------------------------------------------

.org 0x00525170 - 0x401000
.globl FUN_00525170
FUN_00525170:
    # block 0x00525170: entry, 23 instruction(s), ends with ret 0x4
    {load} mov eax, ecx                          # 00525170
    {load} xor edx, edx                          # 00525172
    lea ecx, [eax + field_103c]                  # 00525174
    mov dword ptr [eax + field_1c], edx          # 0052517a
    mov dword ptr [eax + field_20], edx          # 0052517d
    mov dword ptr [eax + field_24], edx          # 00525180
    mov dword ptr [eax + field_28], edx          # 00525183
    mov dword ptr [ecx], edx                     # 00525186
    mov dword ptr [ecx + field_4], edx           # 00525188
    or dword ptr [eax + field_104c], -0x1        # 0052518b
    lea ecx, [eax + field_1048]                  # 00525192
    mov dword ptr [ecx + field_8], edx           # 00525198
    mov dword ptr [ecx + field_1c], edx          # 0052519b
    mov dword ptr [ecx + field_20], edx          # 0052519e
    mov cl, byte ptr [esp + stk_4]               # 005251a1
    mov dword ptr [eax], 0x52fb84                # 005251a5
    mov dword ptr [eax + field_28], 0x1c         # 005251ab
    mov dword ptr [eax + field_20], 0x14         # 005251b2
    mov dword ptr [eax + field_18], edx          # 005251b9
    mov byte ptr [eax + field_14], cl            # 005251bc
    mov dword ptr [eax + field_30], 0x1          # 005251bf
    mov dword ptr [eax + field_1040], 0x18       # 005251c6
    ret 0x4                                      # 005251d0

