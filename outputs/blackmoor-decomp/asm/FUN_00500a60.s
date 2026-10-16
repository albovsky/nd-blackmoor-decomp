# FUN_00500a60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00500a60
# extent:       0x00500a60-0x00500ac0 (96 code bytes)
# span:         0x00500a60-0x00500ac0 (code 96, tables 0, padding 0)
# sha256:       18ce2bfaacb677de335df0ddd43f0c18a7c4d8a5952eaa85e4af98c6fbb06a81
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00500a60
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [esi + n] field_minus_4; [esp + n] stk_4, stk_10, stk_14, stk_18, stk_1c, stk_20
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_4, 0x4  # offset +0x4
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x00500a60 - 0x401000
.globl FUN_00500a60
FUN_00500a60:
    # block 0x00500a60: entry, 9 instruction(s), ends with jle to 0x00500a77 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00500a60
    push ebx                                     # 00500a64
    push ebp                                     # 00500a65
    push edi                                     # 00500a66
    mov ecx, dword ptr [eax]                     # 00500a67
    mov edi, dword ptr [esp + stk_20]            # 00500a69
    {load} cmp edi, ecx                          # 00500a6d
    mov dword ptr [esp + stk_10], ecx            # 00500a6f
    jle.d8 L_00500a77                            # 00500a73
    # block 0x00500a75: entered by fall-through of jle at 0x00500a73, 1 instruction(s), falls into the block at 0x00500a77
    {load} mov edi, ecx                          # 00500a75
L_00500a77:
    # block 0x00500a77: entered by jle at 0x00500a73, 4 instruction(s), ends with jle to 0x00500aae (forward)
    mov ebp, dword ptr [esp + stk_1c]            # 00500a77
    {load} xor ebx, ebx                          # 00500a7b
    test edi, edi                                # 00500a7d
    jle.d8 L_00500aae                            # 00500a7f
    # block 0x00500a81: entered by fall-through of jle at 0x00500a7f, 7 instruction(s), falls into the block at 0x00500a92
    mov eax, dword ptr [esp + stk_14]            # 00500a81
    mov edx, dword ptr [esp + stk_18]            # 00500a85
    push esi                                     # 00500a89
    {load} mov esi, ebp                          # 00500a8a
    {load} sub edx, eax                          # 00500a8c
    {load} sub esi, eax                          # 00500a8e
    {load} mov ebx, edi                          # 00500a90
L_00500a92:
    # block 0x00500a92: entered by jne at 0x00500aa7, 7 instruction(s), ends with jne to 0x00500a92 (backward)
    mov ecx, dword ptr [edx + eax]               # 00500a92
    add eax, 0x4                                 # 00500a95
    dec edi                                      # 00500a98
    fld dword ptr [4*ecx + 0x566560]             # 00500a99
    fmul dword ptr [eax - field_minus_4]         # 00500aa0
    fstp dword ptr [esi + eax - field_minus_4]   # 00500aa3
    jne.d8 L_00500a92                            # 00500aa7
    # block 0x00500aa9: entered by fall-through of jne at 0x00500aa7, 2 instruction(s), falls into the block at 0x00500aae
    mov ecx, dword ptr [esp + stk_14]            # 00500aa9
    pop esi                                      # 00500aad
L_00500aae:
    # block 0x00500aae: entered by jle at 0x00500a7f, 2 instruction(s), ends with jge to 0x00500abc (forward)
    {load} cmp ebx, ecx                          # 00500aae
    jge.d8 L_00500abc                            # 00500ab0
    # block 0x00500ab2: entered by fall-through of jge at 0x00500ab0, 4 instruction(s), falls into the block at 0x00500abc
    {load} sub ecx, ebx                          # 00500ab2
    {disp8} lea edi, [ebp + 4*ebx]               # 00500ab4
    {load} xor eax, eax                          # 00500ab8
    rep stosd dword ptr es:[edi], eax            # 00500aba
L_00500abc:
    # block 0x00500abc: entered by jge at 0x00500ab0, 4 instruction(s), ends with ret
    pop edi                                      # 00500abc
    pop ebp                                      # 00500abd
    pop ebx                                      # 00500abe
    ret                                          # 00500abf

