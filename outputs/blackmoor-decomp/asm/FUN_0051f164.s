# FUN_0051f164
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f164
# extent:       0x0051f164-0x0051f1bc (88 code bytes)
# span:         0x0051f164-0x0051f1bc (code 88, tables 0, padding 0)
# sha256:       9e34263aab2f3477206151b686f39ade8957c6c2af027c1b5995aef13d820143
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051f13f (+0x25)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f164
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14, field_30; [edx + n] field_70; [esp + n] stk_8, stk_10
# callees:      calls FUN_00525371, FUN_0051ec6f, FUN_00525b0f, USER32.dll!CallNextHookEx; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_30, 0x30  # offset +0x30
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051f164 - 0x401000
.globl FUN_0051f164
FUN_0051f164:
    # block 0x0051f164: entry, 5 instruction(s), calls FUN_00525371, ends with jne to 0x0051f197 (forward)
    push esi                                     # 0051f164
    call FUN_00525371                            # 0051f165
    cmp byte ptr [eax + field_14], 0x0           # 0051f16a
    mov esi, dword ptr [esp + stk_8]             # 0051f16e
    jne.d8 L_0051f197                            # 0051f172
    # block 0x0051f174: entered by fall-through of jne at 0x0051f172, 2 instruction(s), ends with jge to 0x0051f180 (forward)
    test esi, esi                                # 0051f174
    jge.d8 L_0051f180                            # 0051f176
    # block 0x0051f178: entered by fall-through of jge at 0x0051f176, 2 instruction(s), ends with jne to 0x0051f197 (forward)
    cmp esi, 0x8001                              # 0051f178
    jne.d8 L_0051f197                            # 0051f17e
L_0051f180:
    # block 0x0051f180: entered by jge at 0x0051f176; fall-through of jne at 0x0051f17e, 3 instruction(s), calls FUN_0051ec6f, ends with je to 0x0051f197 (forward)
    call FUN_0051ec6f                            # 0051f180
    test eax, eax                                # 0051f185
    je.d8 L_0051f197                             # 0051f187
    # block 0x0051f189: entered by fall-through of je at 0x0051f187, 6 instruction(s), calls indirect dword ptr [edx + 0x70], ends with forward jump to 0x0051f1b8
    push dword ptr [esp + stk_10]                # 0051f189
    mov edx, dword ptr [eax]                     # 0051f18d
    {load} mov ecx, eax                          # 0051f18f
    push esi                                     # 0051f191
    call dword ptr [edx + field_70]              # 0051f192
    jmp.d8 L_0051f1b8                            # 0051f195
L_0051f197:
    # block 0x0051f197: entered by jne at 0x0051f172; jne at 0x0051f17e; je at 0x0051f187, 8 instruction(s), calls FUN_00525b0f, USER32.dll!CallNextHookEx, falls into the block at 0x0051f1b8
    push 0x52496c                                # 0051f197
    mov ecx, 0x63c444                            # 0051f19c
    call FUN_00525b0f                            # 0051f1a1
    push dword ptr [esp + stk_10]                # 0051f1a6
    push dword ptr [esp + stk_10]                # 0051f1aa
    push esi                                     # 0051f1ae
    push dword ptr [eax + field_30]              # 0051f1af
    call dword ptr [0x52a420]                    # 0051f1b2
L_0051f1b8:
    # block 0x0051f1b8: entered by jmp at 0x0051f195, 2 instruction(s), ends with ret 0xc
    pop esi                                      # 0051f1b8
    ret 0xc                                      # 0051f1b9

