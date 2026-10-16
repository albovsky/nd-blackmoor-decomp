# FUN_0051d699
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d699
# extent:       0x0051d699-0x0051d6ba (33 code bytes)
# span:         0x0051d699-0x0051d6ba (code 33, tables 0, padding 0)
# sha256:       f70a309b50aac338b2d6aefd0fea584764e1934ce05fe5ef1d8083f860022132
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d699
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_ac
# callees:      calls USER32.dll!SetFocus, FUN_0051abe4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)

.org 0x0051d699 - 0x401000
.globl FUN_0051d699
FUN_0051d699:
    # block 0x0051d699: entry, 3 instruction(s), ends with jne to 0x0051d6b0 (forward)
    mov eax, dword ptr [ecx + field_38]          # 0051d699
    test eax, eax                                # 0051d69c
    jne.d8 L_0051d6b0                            # 0051d69e
    # block 0x0051d6a0: entered by fall-through of jne at 0x0051d69e, 5 instruction(s), calls USER32.dll!SetFocus, FUN_0051abe4, ends with ret
    push dword ptr [ecx + field_1c]              # 0051d6a0
    call dword ptr [0x52a2fc]                    # 0051d6a3
    push eax                                     # 0051d6a9
    call FUN_0051abe4                            # 0051d6aa
    ret                                          # 0051d6af
L_0051d6b0:
    # block 0x0051d6b0: entered by jne at 0x0051d69e, 3 instruction(s), ends with indirect jump dword ptr [edx + 0xac]
    mov edx, dword ptr [eax]                     # 0051d6b0
    {load} mov ecx, eax                          # 0051d6b2
    jmp dword ptr [edx + field_ac]               # 0051d6b4

