# FUN_0051d672
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d672
# extent:       0x0051d672-0x0051d699 (39 code bytes)
# span:         0x0051d672-0x0051d699 (code 39, tables 0, padding 0)
# sha256:       62c5fcfd262c288dd67e12dda0575887d0fcc2977604564c39850ee1032990aa
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d672
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_a8; [esp + n] stk_4
# callees:      calls USER32.dll!EnableWindow; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------

.org 0x0051d672 - 0x401000
.globl FUN_0051d672
FUN_0051d672:
    # block 0x0051d672: entry, 3 instruction(s), ends with jne to 0x0051d688 (forward)
    mov eax, dword ptr [ecx + field_38]          # 0051d672
    test eax, eax                                # 0051d675
    jne.d8 L_0051d688                            # 0051d677
    # block 0x0051d679: entered by fall-through of jne at 0x0051d677, 4 instruction(s), calls USER32.dll!EnableWindow, ends with forward jump to 0x0051d696
    push dword ptr [esp + stk_4]                 # 0051d679
    push dword ptr [ecx + field_1c]              # 0051d67d
    call dword ptr [0x52a4d0]                    # 0051d680
    jmp.d8 L_0051d696                            # 0051d686
L_0051d688:
    # block 0x0051d688: entered by jne at 0x0051d677, 4 instruction(s), calls indirect dword ptr [edx + 0xa8], falls into the block at 0x0051d696
    mov edx, dword ptr [eax]                     # 0051d688
    push dword ptr [esp + stk_4]                 # 0051d68a
    {load} mov ecx, eax                          # 0051d68e
    call dword ptr [edx + field_a8]              # 0051d690
L_0051d696:
    # block 0x0051d696: entered by jmp at 0x0051d686, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051d696

