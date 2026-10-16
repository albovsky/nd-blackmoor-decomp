# FUN_005230ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005230ff
# extent:       0x005230ff-0x0052314e (79 code bytes)
# span:         0x005230ff-0x0052314e (code 79, tables 0, padding 0)
# sha256:       32081d044c5b9b60b16be7da4d96b4bd7b1fbb2631e90f9cdfa48844c9ae5759
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005230ff
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c8, field_dc; [esi + n] field_1c; [esp + n] stk_c
# callees:      calls FUN_0051ab4b, USER32.dll!PostMessageA; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_c8, 0xc8  # offset +0xc8
.equ field_dc, 0xdc  # offset +0xdc

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x005230ff - 0x401000
.globl FUN_005230ff
FUN_005230ff:
    # block 0x005230ff: entry, 5 instruction(s), calls FUN_0051ab4b, ends with je to 0x00523122 (forward)
    push esi                                     # 005230ff
    {load} mov esi, ecx                          # 00523100
    call FUN_0051ab4b                            # 00523102
    cmp eax, -0x1                                # 00523107
    je.d8 L_00523122                             # 0052310a
    # block 0x0052310c: entered by fall-through of je at 0x0052310a, 7 instruction(s), calls indirect dword ptr [eax + 0xdc], ends with jne to 0x00523127 (forward)
    push dword ptr [esp + stk_c]                 # 0052310c
    mov eax, dword ptr [esi]                     # 00523110
    {load} mov ecx, esi                          # 00523112
    push dword ptr [esp + stk_c]                 # 00523114
    call dword ptr [eax + field_dc]              # 00523118
    test eax, eax                                # 0052311e
    jne.d8 L_00523127                            # 00523120
L_00523122:
    # block 0x00523122: entered by je at 0x0052310a; fall-through of jne at 0x00523120, 2 instruction(s), ends with forward jump to 0x0052314a
    or eax, -0x1                                 # 00523122
    jmp.d8 L_0052314a                            # 00523125
L_00523127:
    # block 0x00523127: entered by jne at 0x00523120, 10 instruction(s), calls USER32.dll!PostMessageA, indirect dword ptr [eax + 0xc8], falls into the block at 0x0052314a
    push 0x0                                     # 00523127
    push 0xe001                                  # 00523129
    push 0x362                                   # 0052312e
    push dword ptr [esi + field_1c]              # 00523133
    call dword ptr [0x52a31c]                    # 00523136
    mov eax, dword ptr [esi]                     # 0052313c
    push 0x1                                     # 0052313e
    {load} mov ecx, esi                          # 00523140
    call dword ptr [eax + field_c8]              # 00523142
    {load} xor eax, eax                          # 00523148
L_0052314a:
    # block 0x0052314a: entered by jmp at 0x00523125, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 0052314a
    ret 0x8                                      # 0052314b

