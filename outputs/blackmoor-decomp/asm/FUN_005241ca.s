# FUN_005241ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005241ca
# extent:       0x005241ca-0x005242c7 (253 code bytes)
# span:         0x005241ca-0x005242c7 (code 253, tables 0, padding 0)
# sha256:       05e147c75b9e8ef877ca4f09dde23a95209bb1e9933898a4df7f9de4bb29f796
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005241ca
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_204
# fields:       [esi + n] field_1c, field_40, field_ac
# callees:      calls FUN_0051d526, KERNEL32.dll!lstrcpyA, KERNEL32.dll!lstrlenA, USER32.dll!wsprintfA, FUN_00521117; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 73 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_204, 0x204  # offset -0x204
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_40, 0x40  # offset +0x40
.equ field_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_00521117, .text + (0x00521117 - 0x401000)

.org 0x005241ca - 0x401000
.globl FUN_005241ca
FUN_005241ca:
    # block 0x005241ca: entry, 9 instruction(s), calls FUN_0051d526, ends with je to 0x0052424e (forward)
    push ebp                                     # 005241ca
    {load} mov ebp, esp                          # 005241cb
    sub esp, 0x204                               # 005241cd
    push esi                                     # 005241d3
    push edi                                     # 005241d4
    {load} mov esi, ecx                          # 005241d5
    call FUN_0051d526                            # 005241d7
    test ah, 0x40                                # 005241dc
    je.d8 L_0052424e                             # 005241df
    # block 0x005241e1: entered by fall-through of je at 0x005241df, 4 instruction(s), ends with je to 0x0052423d (forward)
    and byte ptr [ebp - local_204], 0x0          # 005241e1
    cmp dword ptr [ebp + arg_8], 0x0             # 005241e8
    mov edi, dword ptr [0x52a228]                # 005241ec
    je.d8 L_0052423d                             # 005241f2
    # block 0x005241f4: entered by fall-through of je at 0x005241f2, 7 instruction(s), calls KERNEL32.dll!lstrcpyA, ends with jle to 0x0052422f (forward)
    push dword ptr [ebp + arg_8]                 # 005241f4
    lea eax, [ebp - local_204]                   # 005241f7
    push eax                                     # 005241fd
    call dword ptr [0x52a244]                    # 005241fe
    mov eax, dword ptr [esi + field_40]          # 00524204
    test eax, eax                                # 00524207
    jle.d8 L_0052422f                            # 00524209
    # block 0x0052420b: entered by fall-through of jle at 0x00524209, 9 instruction(s), calls KERNEL32.dll!lstrlenA, USER32.dll!wsprintfA, falls into the block at 0x0052422f
    push eax                                     # 0052420b
    lea eax, [ebp - local_204]                   # 0052420c
    push 0x52fb54                                # 00524212
    push eax                                     # 00524217
    call dword ptr [0x52a1f8]                    # 00524218
    lea eax, [ebp + eax - local_204]             # 0052421e
    push eax                                     # 00524225
    call dword ptr [0x52a3e8]                    # 00524226
    add esp, 0xc                                 # 0052422c
L_0052422f:
    # block 0x0052422f: entered by jle at 0x00524209, 4 instruction(s), calls indirect edi, falls into the block at 0x0052423d
    lea eax, [ebp - local_204]                   # 0052422f
    push 0x52fb50                                # 00524235
    push eax                                     # 0052423a
    call edi                                     # 0052423b
L_0052423d:
    # block 0x0052423d: entered by je at 0x005241f2, 5 instruction(s), calls indirect edi, ends with forward jump to 0x005242b2
    push dword ptr [esi + field_ac]              # 0052423d
    lea eax, [ebp - local_204]                   # 00524243
    push eax                                     # 00524249
    call edi                                     # 0052424a
    jmp.d8 L_005242b2                            # 0052424c
L_0052424e:
    # block 0x0052424e: entered by je at 0x005241df, 6 instruction(s), calls KERNEL32.dll!lstrcpyA, ends with je to 0x005242b2 (forward)
    push dword ptr [esi + field_ac]              # 0052424e
    lea eax, [ebp - local_204]                   # 00524254
    push eax                                     # 0052425a
    call dword ptr [0x52a244]                    # 0052425b
    cmp dword ptr [ebp + arg_8], 0x0             # 00524261
    je.d8 L_005242b2                             # 00524265
    # block 0x00524267: entered by fall-through of je at 0x00524265, 12 instruction(s), calls indirect edi, ends with jle to 0x005242b2 (forward)
    mov edi, dword ptr [0x52a228]                # 00524267
    lea eax, [ebp - local_204]                   # 0052426d
    push 0x52fb50                                # 00524273
    push eax                                     # 00524278
    call edi                                     # 00524279
    push dword ptr [ebp + arg_8]                 # 0052427b
    lea eax, [ebp - local_204]                   # 0052427e
    push eax                                     # 00524284
    call edi                                     # 00524285
    mov eax, dword ptr [esi + field_40]          # 00524287
    test eax, eax                                # 0052428a
    jle.d8 L_005242b2                            # 0052428c
    # block 0x0052428e: entered by fall-through of jle at 0x0052428c, 9 instruction(s), calls KERNEL32.dll!lstrlenA, USER32.dll!wsprintfA, falls into the block at 0x005242b2
    push eax                                     # 0052428e
    lea eax, [ebp - local_204]                   # 0052428f
    push 0x52fb54                                # 00524295
    push eax                                     # 0052429a
    call dword ptr [0x52a1f8]                    # 0052429b
    lea eax, [ebp + eax - local_204]             # 005242a1
    push eax                                     # 005242a8
    call dword ptr [0x52a3e8]                    # 005242a9
    add esp, 0xc                                 # 005242af
L_005242b2:
    # block 0x005242b2: entered by jmp at 0x0052424c; je at 0x00524265; jle at 0x0052428c, 8 instruction(s), calls FUN_00521117, ends with ret 0x4
    lea eax, [ebp - local_204]                   # 005242b2
    push eax                                     # 005242b8
    push dword ptr [esi + field_1c]              # 005242b9
    call FUN_00521117                            # 005242bc
    pop edi                                      # 005242c1
    pop esi                                      # 005242c2
    leave                                        # 005242c3
    ret 0x4                                      # 005242c4

