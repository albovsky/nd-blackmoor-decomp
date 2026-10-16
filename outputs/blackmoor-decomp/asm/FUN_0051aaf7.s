# FUN_0051aaf7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051aaf7
# extent:       0x0051aaf7-0x0051ab16 (31 code bytes)
# span:         0x0051aaf7-0x0051ab16 (code 31, tables 0, padding 0)
# sha256:       7b156c956bc239f8e5cb56f654aafac894966254312ff05f4a1cf263b9714fec
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051aaf7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x14 (callee pops 20 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_18, field_minus_c, field_minus_40; [ebx + n] field_34
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_40, 0x40  # offset -0x40
.equ field_18, 0x18  # offset +0x18
.equ field_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------

.org 0x0051aaf7 - 0x401000
.globl FUN_0051aaf7
FUN_0051aaf7:
    # block 0x0051aaf7: entry, 13 instruction(s), ends with ret 0x14
    push 0x7                                     # 0051aaf7
    mov eax, dword ptr [ebp + field_18]          # 0051aaf9
    lea edi, [ebx + field_34]                    # 0051aafc
    pop ecx                                      # 0051aaff
    lea esi, [ebp - field_minus_40]              # 0051ab00
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0051ab03
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051ab05
    pop edi                                      # 0051ab08
    pop esi                                      # 0051ab09
    mov dword ptr fs:[0x0], ecx                  # 0051ab0a
    pop ebx                                      # 0051ab11
    leave                                        # 0051ab12
    ret 0x14                                     # 0051ab13

