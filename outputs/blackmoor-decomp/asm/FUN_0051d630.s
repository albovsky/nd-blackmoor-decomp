# FUN_0051d630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d630
# extent:       0x0051d630-0x0051d657 (39 code bytes)
# span:         0x0051d630-0x0051d657 (code 39, tables 0, padding 0)
# sha256:       43e290ff60df60b4dded64dd34acdf0c450590d86aca4f047f52bf93f006eee3
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d630
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_a0; [esp + n] stk_4
# callees:      calls USER32.dll!ShowWindow; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------

.org 0x0051d630 - 0x401000
.globl FUN_0051d630
FUN_0051d630:
    # block 0x0051d630: entry, 3 instruction(s), ends with jne to 0x0051d646 (forward)
    mov eax, dword ptr [ecx + field_38]          # 0051d630
    test eax, eax                                # 0051d633
    jne.d8 L_0051d646                            # 0051d635
    # block 0x0051d637: entered by fall-through of jne at 0x0051d635, 4 instruction(s), calls USER32.dll!ShowWindow, ends with forward jump to 0x0051d654
    push dword ptr [esp + stk_4]                 # 0051d637
    push dword ptr [ecx + field_1c]              # 0051d63b
    call dword ptr [0x52a32c]                    # 0051d63e
    jmp.d8 L_0051d654                            # 0051d644
L_0051d646:
    # block 0x0051d646: entered by jne at 0x0051d635, 4 instruction(s), calls indirect dword ptr [edx + 0xa0], falls into the block at 0x0051d654
    mov edx, dword ptr [eax]                     # 0051d646
    push dword ptr [esp + stk_4]                 # 0051d648
    {load} mov ecx, eax                          # 0051d64c
    call dword ptr [edx + field_a0]              # 0051d64e
L_0051d654:
    # block 0x0051d654: entered by jmp at 0x0051d644, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051d654

