# FUN_005237da
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005237da
# extent:       0x005237da-0x00523812 (56 code bytes)
# span:         0x005237da-0x00523812 (code 56, tables 0, padding 0)
# sha256:       b2e19b40665ff4c2e8936a8d20e07e625f70fda48e264fbc859fd70328857c59
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005237b5 (+0x25)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005237da
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_68; [esi + n] field_1c; [esp + n] stk_4
# callees:      calls FUN_00525371, FUN_00524871, FUN_005215bc; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_005215bc, .text + (0x005215bc - 0x401000)
.set FUN_00524871, .text + (0x00524871 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x005237da - 0x401000
.globl FUN_005237da
FUN_005237da:
    # block 0x005237da: entry, 5 instruction(s), ends with je to 0x0052380d (forward)
    cmp dword ptr [esp + stk_4], 0x0             # 005237da
    push esi                                     # 005237df
    push edi                                     # 005237e0
    {load} mov edi, ecx                          # 005237e1
    je.d8 L_0052380d                             # 005237e3
    # block 0x005237e5: entered by fall-through of je at 0x005237e3, 4 instruction(s), calls FUN_00525371, ends with je to 0x0052380d (forward)
    call FUN_00525371                            # 005237e5
    mov esi, dword ptr [eax + field_4]           # 005237ea
    test esi, esi                                # 005237ed
    je.d8 L_0052380d                             # 005237ef
    # block 0x005237f1: entered by fall-through of je at 0x005237ef, 2 instruction(s), ends with jne to 0x0052380d (forward)
    cmp dword ptr [esi + field_1c], edi          # 005237f1
    jne.d8 L_0052380d                            # 005237f4
    # block 0x005237f6: entered by fall-through of jne at 0x005237f4, 8 instruction(s), calls FUN_00524871, FUN_005215bc, indirect dword ptr [eax + 0x68], falls into the block at 0x0052380d
    push 0x1                                     # 005237f6
    call FUN_00524871                            # 005237f8
    push 0x1                                     # 005237fd
    {load} mov ecx, esi                          # 005237ff
    call FUN_005215bc                            # 00523801
    mov eax, dword ptr [esi]                     # 00523806
    {load} mov ecx, esi                          # 00523808
    call dword ptr [eax + field_68]              # 0052380a
L_0052380d:
    # block 0x0052380d: entered by je at 0x005237e3; je at 0x005237ef; jne at 0x005237f4, 3 instruction(s), ends with ret 0x4
    pop edi                                      # 0052380d
    pop esi                                      # 0052380e
    ret 0x4                                      # 0052380f

