# FUN_005214f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005214f0
# extent:       0x005214f0-0x00521522 (50 code bytes)
# span:         0x005214f0-0x00521522 (code 50, tables 0, padding 0)
# sha256:       0d469e4a02f9ab860184bcb6d383a21c0598a5d8d95ff5ce69aa3716edf988e8
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005214f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [esi + n] field_1c
# callees:      calls FUN_0051d630, USER32.dll!ShowOwnedPopups, FUN_0051d5e1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051d5e1, .text + (0x0051d5e1 - 0x401000)
.set FUN_0051d630, .text + (0x0051d630 - 0x401000)

.org 0x005214f0 - 0x401000
.globl FUN_005214f0
FUN_005214f0:
    # block 0x005214f0: entry, 22 instruction(s), calls FUN_0051d630, USER32.dll!ShowOwnedPopups, FUN_0051d5e1, ends with ret
    push esi                                     # 005214f0
    push edi                                     # 005214f1
    {load} mov esi, ecx                          # 005214f2
    {load} xor edi, edi                          # 005214f4
    push edi                                     # 005214f6
    mov ecx, dword ptr [esi + field_1c]          # 005214f7
    call FUN_0051d630                            # 005214fa
    mov eax, dword ptr [esi + field_1c]          # 005214ff
    push edi                                     # 00521502
    push dword ptr [eax + field_1c]              # 00521503
    call dword ptr [0x52a370]                    # 00521506
    mov ecx, dword ptr [esi + field_1c]          # 0052150c
    push 0x13                                    # 0052150f
    push edi                                     # 00521511
    push edi                                     # 00521512
    push edi                                     # 00521513
    push edi                                     # 00521514
    push 0x63c2d8                                # 00521515
    call FUN_0051d5e1                            # 0052151a
    pop edi                                      # 0052151f
    pop esi                                      # 00521520
    ret                                          # 00521521

