# FUN_0051cb38
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051cb38
# extent:       0x0051cb38-0x0051cb55 (29 code bytes)
# span:         0x0051cb38-0x0051cb55 (code 29, tables 0, padding 0)
# sha256:       2dff8f1589eafa2050bfa9fade9b88f1d76bb02b69032fab59f224d852ae2d33
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051cb38
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_c, field_minus_18; [edi + n] field_b8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_18, 0x18  # offset -0x18
.equ field_8, 0x8  # offset +0x8
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------

.org 0x0051cb38 - 0x401000
.globl FUN_0051cb38
FUN_0051cb38:
    # block 0x0051cb38: entry, 10 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - field_minus_18]    # 0051cb38
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051cb3b
    mov dword ptr [edi + field_b8], eax          # 0051cb3e
    mov eax, dword ptr [ebp + field_8]           # 0051cb44
    pop edi                                      # 0051cb47
    pop esi                                      # 0051cb48
    mov dword ptr fs:[0x0], ecx                  # 0051cb49
    pop ebx                                      # 0051cb50
    leave                                        # 0051cb51
    ret 0x4                                      # 0051cb52

