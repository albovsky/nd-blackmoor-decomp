# FUN_0051d657
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d657
# extent:       0x0051d657-0x0051d672 (27 code bytes)
# span:         0x0051d657-0x0051d672 (code 27, tables 0, padding 0)
# sha256:       ecb93b00fb4091147c332efee3bb5d58a04ff54a4c53cfc572223561ac1a5079
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d657
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_a4
# callees:      calls USER32.dll!IsWindowEnabled; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_a4, 0xa4  # offset +0xa4

# --- external targets -----------------------------------------------

.org 0x0051d657 - 0x401000
.globl FUN_0051d657
FUN_0051d657:
    # block 0x0051d657: entry, 3 instruction(s), ends with jne to 0x0051d668 (forward)
    mov eax, dword ptr [ecx + field_38]          # 0051d657
    test eax, eax                                # 0051d65a
    jne.d8 L_0051d668                            # 0051d65c
    # block 0x0051d65e: entered by fall-through of jne at 0x0051d65c, 3 instruction(s), calls USER32.dll!IsWindowEnabled, ends with ret
    push dword ptr [ecx + field_1c]              # 0051d65e
    call dword ptr [0x52a330]                    # 0051d661
    ret                                          # 0051d667
L_0051d668:
    # block 0x0051d668: entered by jne at 0x0051d65c, 3 instruction(s), ends with indirect jump dword ptr [edx + 0xa4]
    mov edx, dword ptr [eax]                     # 0051d668
    {load} mov ecx, eax                          # 0051d66a
    jmp dword ptr [edx + field_a4]               # 0051d66c

