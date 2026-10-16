# FUN_0051d392
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d392
# extent:       0x0051d392-0x0051d3d5 (67 code bytes)
# span:         0x0051d392-0x0051d3d5 (code 67, tables 0, padding 0)
# sha256:       61768eb27edb7200fbce612d2d77a1bac16ab7d646fa0e4715075a0af6387295
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d392
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_50, field_80; [esp + n] stk_8, stk_10
# callees:      calls FUN_0051ac29, FUN_0051acc0, USER32.dll!SetWindowLongA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_50, 0x50  # offset +0x50
.equ field_80, 0x80  # offset +0x80

# --- external targets -----------------------------------------------
.set FUN_0051ac29, .text + (0x0051ac29 - 0x401000)
.set FUN_0051acc0, .text + (0x0051acc0 - 0x401000)

.org 0x0051d392 - 0x401000
.globl FUN_0051d392
FUN_0051d392:
    # block 0x0051d392: entry, 6 instruction(s), calls FUN_0051ac29, ends with je to 0x0051d3d1 (forward)
    push esi                                     # 0051d392
    {load} mov esi, ecx                          # 0051d393
    push dword ptr [esp + stk_8]                 # 0051d395
    call FUN_0051ac29                            # 0051d399
    test eax, eax                                # 0051d39e
    je.d8 L_0051d3d1                             # 0051d3a0
    # block 0x0051d3a2: entered by fall-through of je at 0x0051d3a0, 14 instruction(s), calls indirect dword ptr [eax + 0x50], indirect dword ptr [eax + 0x80], FUN_0051acc0, USER32.dll!SetWin..., ends with jne to 0x0051d3ce (forward)
    mov eax, dword ptr [esi]                     # 0051d3a2
    {load} mov ecx, esi                          # 0051d3a4
    call dword ptr [eax + field_50]              # 0051d3a6
    mov eax, dword ptr [esi]                     # 0051d3a9
    {load} mov ecx, esi                          # 0051d3ab
    call dword ptr [eax + field_80]              # 0051d3ad
    {load} mov esi, eax                          # 0051d3b3
    call FUN_0051acc0                            # 0051d3b5
    push eax                                     # 0051d3ba
    push -0x4                                    # 0051d3bb
    push dword ptr [esp + stk_10]                # 0051d3bd
    call dword ptr [0x52a458]                    # 0051d3c1
    cmp dword ptr [esi], 0x0                     # 0051d3c7
    jne.d8 L_0051d3ce                            # 0051d3ca
    # block 0x0051d3cc: entered by fall-through of jne at 0x0051d3ca, 1 instruction(s), falls into the block at 0x0051d3ce
    mov dword ptr [esi], eax                     # 0051d3cc
L_0051d3ce:
    # block 0x0051d3ce: entered by jne at 0x0051d3ca, 2 instruction(s), falls into the block at 0x0051d3d1
    push 0x1                                     # 0051d3ce
    pop eax                                      # 0051d3d0
L_0051d3d1:
    # block 0x0051d3d1: entered by je at 0x0051d3a0, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051d3d1
    ret 0x4                                      # 0051d3d2

