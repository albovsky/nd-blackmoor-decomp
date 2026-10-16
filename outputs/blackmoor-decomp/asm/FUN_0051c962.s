# FUN_0051c962
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c962
# extent:       0x0051c962-0x0051c9ac (74 code bytes)
# span:         0x0051c962-0x0051c9ac (code 74, tables 0, padding 0)
# sha256:       ab4698a34c812142e7eab6eb4b73e90c74e411ca0a32c9a3f93d65c9c5559638
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c962
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_1c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!DispatchMessageA, FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0051c962 - 0x401000
.globl FUN_0051c962
FUN_0051c962:
    # block 0x0051c962: entry, 15 instruction(s), falls into the block at 0x0051c982
    push ebp                                     # 0051c962
    {load} mov ebp, esp                          # 0051c963
    sub esp, 0x1c                                # 0051c965
    push ebx                                     # 0051c968
    push esi                                     # 0051c969
    push edi                                     # 0051c96a
    mov edi, dword ptr [0x52a4c0]                # 0051c96b
    mov esi, 0x121                               # 0051c971
    push 0x1                                     # 0051c976
    push esi                                     # 0051c978
    push esi                                     # 0051c979
    lea eax, [ebp - local_1c]                    # 0051c97a
    push 0x0                                     # 0051c97d
    {load} mov ebx, ecx                          # 0051c97f
    push eax                                     # 0051c981
L_0051c982:
    # block 0x0051c982: entered by jmp at 0x0051c99c, 3 instruction(s), calls indirect edi, ends with je to 0x0051c99e (forward)
    call edi                                     # 0051c982
    test eax, eax                                # 0051c984
    je.d8 L_0051c99e                             # 0051c986
    # block 0x0051c988: entered by fall-through of je at 0x0051c986, 10 instruction(s), calls USER32.dll!DispatchMessageA, ends with backward jump to 0x0051c982
    lea eax, [ebp - local_1c]                    # 0051c988
    push eax                                     # 0051c98b
    call dword ptr [0x52a30c]                    # 0051c98c
    push 0x1                                     # 0051c992
    push esi                                     # 0051c994
    push esi                                     # 0051c995
    lea eax, [ebp - local_1c]                    # 0051c996
    push 0x0                                     # 0051c999
    push eax                                     # 0051c99b
    jmp.d8 L_0051c982                            # 0051c99c
L_0051c99e:
    # block 0x0051c99e: entered by je at 0x0051c986, 7 instruction(s), calls FUN_0051ab4b, ends with ret 0x8
    {load} mov ecx, ebx                          # 0051c99e
    call FUN_0051ab4b                            # 0051c9a0
    pop edi                                      # 0051c9a5
    pop esi                                      # 0051c9a6
    pop ebx                                      # 0051c9a7
    leave                                        # 0051c9a8
    ret 0x8                                      # 0051c9a9

