# FUN_0051d716
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d716
# extent:       0x0051d716-0x0051d730 (26 code bytes)
# span:         0x0051d716-0x0051d730 (code 26, tables 0, padding 0)
# sha256:       b2952fb9bbf25153cb8e6d24f5c9eee94fc6c333cd75d20d4b4f7ad945e8d2fb
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d716
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0051d716 - 0x401000
.globl FUN_0051d716
FUN_0051d716:
    # block 0x0051d716: entry, 11 instruction(s), ends with ret
    {load} mov eax, ecx                          # 0051d716
    push 0x1                                     # 0051d718
    pop ecx                                      # 0051d71a
    {load} xor edx, edx                          # 0051d71b
    mov dword ptr [eax + field_4], ecx           # 0051d71d
    mov dword ptr [eax + field_8], edx           # 0051d720
    mov dword ptr [eax + field_c], edx           # 0051d723
    mov dword ptr [eax + field_10], edx          # 0051d726
    mov dword ptr [eax + field_14], ecx          # 0051d729
    mov dword ptr [eax + field_18], edx          # 0051d72c
    ret                                          # 0051d72f

