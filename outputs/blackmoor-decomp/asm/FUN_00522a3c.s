# FUN_00522a3c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522a3c
# extent:       0x00522a3c-0x00522a5d (33 code bytes)
# span:         0x00522a3c-0x00522a5d (code 33, tables 0, padding 0)
# sha256:       fd5d6dca39284147e17e5fa9a86b04083cb722399f985b4904685e0ea68d1e3d
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522a3c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_70; [esi + n] field_68
# callees:      calls FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x00522a5d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_68, 0x68  # offset +0x68
.equ field_70, 0x70  # offset +0x70

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x00522a3c - 0x401000
.globl FUN_00522a3c
FUN_00522a3c:
    # block 0x00522a3c: entry, 5 instruction(s), ends with je to 0x00522a54 (forward)
    push esi                                     # 00522a3c
    {load} mov esi, ecx                          # 00522a3d
    mov ecx, dword ptr [esi + field_68]          # 00522a3f
    test ecx, ecx                                # 00522a42
    je.d8 L_00522a54                             # 00522a44
    # block 0x00522a46: entered by fall-through of je at 0x00522a44, 4 instruction(s), calls indirect dword ptr [eax + 0x70], ends with je to 0x00522a54 (forward)
    mov eax, dword ptr [ecx]                     # 00522a46
    call dword ptr [eax + field_70]              # 00522a48
    test eax, eax                                # 00522a4b
    je.d8 L_00522a54                             # 00522a4d
    # block 0x00522a4f: entered by fall-through of je at 0x00522a4d, 4 instruction(s), ends with ret
    push 0x1                                     # 00522a4f
    pop eax                                      # 00522a51
    pop esi                                      # 00522a52
    ret                                          # 00522a53
L_00522a54:
    # block 0x00522a54: entered by je at 0x00522a44; je at 0x00522a4d, 4 instruction(s), calls FUN_0051ab4b, ends with ret
    {load} mov ecx, esi                          # 00522a54
    call FUN_0051ab4b                            # 00522a56
    pop esi                                      # 00522a5b
    ret                                          # 00522a5c

