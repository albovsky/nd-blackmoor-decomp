# FUN_00525ab6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525ab6
# extent:       0x00525ab6-0x00525b0f (89 code bytes)
# span:         0x00525ab6-0x00525b0f (code 89, tables 0, padding 0)
# sha256:       6a54e67a020ba0cf56beba9d2592db27b792daf047f6b710473d8e02e72b9ba7
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525ab6
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_14, field_1c; [esp + n] stk_c, stk_10
# callees:      calls KERNEL32.dll!EnterCriticalSection, KERNEL32.dll!TlsGetValue, FUN_00525a1d, KERNEL32.dll!LeaveCriticalSection
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_00525a1d, .text + (0x00525a1d - 0x401000)

.org 0x00525ab6 - 0x401000
.globl FUN_00525ab6
FUN_00525ab6:
    # block 0x00525ab6: entry, 8 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with jne to 0x00525ae5 (forward)
    push ebx                                     # 00525ab6
    push esi                                     # 00525ab7
    {load} mov esi, ecx                          # 00525ab8
    lea ebx, [esi + field_1c]                    # 00525aba
    push ebx                                     # 00525abd
    call dword ptr [0x52a0d0]                    # 00525abe
    cmp dword ptr [esp + stk_10], 0x0            # 00525ac4
    jne.d8 L_00525ae5                            # 00525ac9
    # block 0x00525acb: entered by fall-through of jne at 0x00525ac9, 4 instruction(s), calls KERNEL32.dll!TlsGetValue, ends with je to 0x00525b03 (forward)
    push dword ptr [esi]                         # 00525acb
    call dword ptr [0x52a0dc]                    # 00525acd
    test eax, eax                                # 00525ad3
    je.d8 L_00525b03                             # 00525ad5
    # block 0x00525ad7: entered by fall-through of je at 0x00525ad5, 5 instruction(s), calls FUN_00525a1d, ends with forward jump to 0x00525b03
    push dword ptr [esp + stk_c]                 # 00525ad7
    {load} mov ecx, esi                          # 00525adb
    push eax                                     # 00525add
    call FUN_00525a1d                            # 00525ade
    jmp.d8 L_00525b03                            # 00525ae3
L_00525ae5:
    # block 0x00525ae5: entered by jne at 0x00525ac9, 3 instruction(s), ends with je to 0x00525b03 (forward)
    mov eax, dword ptr [esi + field_14]          # 00525ae5
    test eax, eax                                # 00525ae8
    je.d8 L_00525b03                             # 00525aea
    # block 0x00525aec: entered by fall-through of je at 0x00525aea, 1 instruction(s), falls into the block at 0x00525aed
    push edi                                     # 00525aec
L_00525aed:
    # block 0x00525aed: entered by jne at 0x00525b00, 8 instruction(s), calls FUN_00525a1d, ends with jne to 0x00525aed (backward)
    push dword ptr [esp + stk_10]                # 00525aed
    mov edi, dword ptr [eax + field_4]           # 00525af1
    {load} mov ecx, esi                          # 00525af4
    push eax                                     # 00525af6
    call FUN_00525a1d                            # 00525af7
    test edi, edi                                # 00525afc
    {load} mov eax, edi                          # 00525afe
    jne.d8 L_00525aed                            # 00525b00
    # block 0x00525b02: entered by fall-through of jne at 0x00525b00, 1 instruction(s), falls into the block at 0x00525b03
    pop edi                                      # 00525b02
L_00525b03:
    # block 0x00525b03: entered by je at 0x00525ad5; jmp at 0x00525ae3; je at 0x00525aea, 5 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret 0x8
    push ebx                                     # 00525b03
    call dword ptr [0x52a0c8]                    # 00525b04
    pop esi                                      # 00525b0a
    pop ebx                                      # 00525b0b
    ret 0x8                                      # 00525b0c

