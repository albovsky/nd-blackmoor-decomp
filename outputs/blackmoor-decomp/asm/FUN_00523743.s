# FUN_00523743
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523743
# extent:       0x00523743-0x005237b5 (114 code bytes)
# span:         0x00523743-0x005237b5 (code 114, tables 0, padding 0)
# sha256:       43b9a5ff6d7efe3b80f54550ae3207c4c06dc68d024c94577ecfcdaf9fc4238e
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523743
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_108
# fields:       [eax + n] field_4, field_7c; [ecx + n] field_1c
# callees:      calls USER32.dll!SetActiveWindow, FUN_0051abe4, FUN_00525371, SHELL32.dll!DragFinish; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_108, 0x108  # offset -0x108
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_7c, 0x7c  # offset +0x7c

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00523743 - 0x401000
.globl FUN_00523743
FUN_00523743:
    # block 0x00523743: entry, 22 instruction(s), calls USER32.dll!SetActiveWindow, FUN_0051abe4, indirect esi, FUN_00525371, ends with jbe to 0x005237a5 (forward)
    push ebp                                     # 00523743
    {load} mov ebp, esp                          # 00523744
    sub esp, 0x108                               # 00523746
    push ebx                                     # 0052374c
    push esi                                     # 0052374d
    push edi                                     # 0052374e
    push dword ptr [ecx + field_1c]              # 0052374f
    call dword ptr [0x52a304]                    # 00523752
    push eax                                     # 00523758
    call FUN_0051abe4                            # 00523759
    mov esi, dword ptr [0x52a2d0]                # 0052375e
    {load} xor ebx, ebx                          # 00523764
    push ebx                                     # 00523766
    push ebx                                     # 00523767
    push -0x1                                    # 00523768
    push dword ptr [ebp + arg_8]                 # 0052376a
    call esi                                     # 0052376d
    mov dword ptr [ebp - local_4], eax           # 0052376f
    call FUN_00525371                            # 00523772
    cmp dword ptr [ebp - local_4], ebx           # 00523777
    mov edi, dword ptr [eax + field_4]           # 0052377a
    jbe.d8 L_005237a5                            # 0052377d
L_0052377f:
    # block 0x0052377f: entered by jb at 0x005237a3; fall-through of jbe at 0x0052377d, 14 instruction(s), calls indirect esi, indirect dword ptr [eax + 0x7c], ends with jb to 0x0052377f (backward)
    lea eax, [ebp - local_108]                   # 0052377f
    push 0x104                                   # 00523785
    push eax                                     # 0052378a
    push ebx                                     # 0052378b
    push dword ptr [ebp + arg_8]                 # 0052378c
    call esi                                     # 0052378f
    mov eax, dword ptr [edi]                     # 00523791
    lea ecx, [ebp - local_108]                   # 00523793
    push ecx                                     # 00523799
    {load} mov ecx, edi                          # 0052379a
    call dword ptr [eax + field_7c]              # 0052379c
    inc ebx                                      # 0052379f
    cmp ebx, dword ptr [ebp - local_4]           # 005237a0
    jb.d8 L_0052377f                             # 005237a3
L_005237a5:
    # block 0x005237a5: entered by jbe at 0x0052377d; fall-through of jb at 0x005237a3, 7 instruction(s), calls SHELL32.dll!DragFinish, ends with ret 0x4
    push dword ptr [ebp + arg_8]                 # 005237a5
    call dword ptr [0x52a2d4]                    # 005237a8
    pop edi                                      # 005237ae
    pop esi                                      # 005237af
    pop ebx                                      # 005237b0
    leave                                        # 005237b1
    ret 0x4                                      # 005237b2

