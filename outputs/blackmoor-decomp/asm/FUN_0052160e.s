# FUN_0052160e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052160e
# extent:       0x0052160e-0x00521641 (51 code bytes)
# span:         0x0052160e-0x00521641 (code 51, tables 0, padding 0)
# sha256:       0e0e44ffe0bc6e23a5aba73f7c5ce2ffbe857faf179984fd1037ab00667fd8b5
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005215bc (+0x52)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052160e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_minus_e110; [ecx + n] field_a8; [edx + n] field_7c; [esp + n] stk_4
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_e110, 0xe110  # offset -0xe110
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_7c, 0x7c  # offset +0x7c
.equ field_a8, 0xa8  # offset +0xa8

# --- external targets -----------------------------------------------

.org 0x0052160e - 0x401000
.globl FUN_0052160e
FUN_0052160e:
    # block 0x0052160e: entry, 13 instruction(s), calls indirect dword ptr [edx + 0x7c], ends with jne to 0x00521639 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0052160e
    push esi                                     # 00521612
    lea esi, [ecx + field_a8]                    # 00521613
    push edi                                     # 00521619
    lea edi, [eax - field_minus_e110]            # 0052161a
    mov edx, dword ptr [ecx]                     # 00521620
    mov eax, dword ptr [esi]                     # 00521622
    mov eax, dword ptr [eax + field_8]           # 00521624
    mov eax, dword ptr [eax + 4*edi]             # 00521627
    push eax                                     # 0052162a
    call dword ptr [edx + field_7c]              # 0052162b
    test eax, eax                                # 0052162e
    jne.d8 L_00521639                            # 00521630
    # block 0x00521632: entered by fall-through of jne at 0x00521630, 4 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x00521639
    mov ecx, dword ptr [esi]                     # 00521632
    push edi                                     # 00521634
    mov eax, dword ptr [ecx]                     # 00521635
    call dword ptr [eax]                         # 00521637
L_00521639:
    # block 0x00521639: entered by jne at 0x00521630, 5 instruction(s), ends with ret 0x4
    push 0x1                                     # 00521639
    pop eax                                      # 0052163b
    pop edi                                      # 0052163c
    pop esi                                      # 0052163d
    ret 0x4                                      # 0052163e

