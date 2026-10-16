# FUN_00520f4d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520f4d
# extent:       0x00520f4d-0x00520fbf (114 code bytes)
# span:         0x00520f4d-0x00520fbf (code 114, tables 0, padding 0)
# sha256:       60941d001ef5f7932c9791273fec6a9178236bda27c43bbffcc03eb56367d380
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520f4d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_4, field_minus_c; [esi + n] field_20
# callees:      calls FUN_0050f978, FUN_00525397, FUN_0051dc31, FUN_0051dc43, FUN_0051f7a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_8, 0x8  # offset +0x8
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc31, .text + (0x0051dc31 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051f7a0, .text + (0x0051f7a0 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x00520f4d - 0x401000
.globl FUN_00520f4d
FUN_00520f4d:
    # block 0x00520f4d: entry, 7 instruction(s), calls FUN_0050f978, FUN_00525397, ends with jne to 0x00520fad (forward)
    mov eax, 0x52903a                            # 00520f4d
    call FUN_0050f978                            # 00520f52
    push esi                                     # 00520f57
    call FUN_00525397                            # 00520f58
    {load} mov esi, eax                          # 00520f5d
    cmp dword ptr [esi + field_20], 0x0          # 00520f5f
    jne.d8 L_00520fad                            # 00520f63
    # block 0x00520f65: entered by fall-through of jne at 0x00520f63, 2 instruction(s), ends with je to 0x00520fad (forward)
    cmp dword ptr [ebp + field_8], 0x0           # 00520f65
    je.d8 L_00520fad                             # 00520f69
    # block 0x00520f6b: entered by fall-through of je at 0x00520f69, 12 instruction(s), calls FUN_0051dc31, FUN_0051dc43, ends with je to 0x00520f9d (forward)
    push ebx                                     # 00520f6b
    push 0x521235                                # 00520f6c
    call FUN_0051dc31                            # 00520f71
    push 0x48                                    # 00520f76
    {load} mov ebx, eax                          # 00520f78
    call FUN_0051dc43                            # 00520f7a
    pop ecx                                      # 00520f7f
    {load} mov ecx, eax                          # 00520f80
    mov dword ptr [ebp + field_8], ecx           # 00520f82
    and dword ptr [ebp - field_minus_4], 0x0     # 00520f85
    test ecx, ecx                                # 00520f89
    je.d8 L_00520f9d                             # 00520f8b
    # block 0x00520f8d: entered by fall-through of je at 0x00520f8b, 5 instruction(s), calls FUN_0051f7a0, ends with forward jump to 0x00520f9f
    push 0x1                                     # 00520f8d
    push 0x4                                     # 00520f8f
    push 0x52fb98                                # 00520f91
    call FUN_0051f7a0                            # 00520f96
    jmp.d8 L_00520f9f                            # 00520f9b
L_00520f9d:
    # block 0x00520f9d: entered by je at 0x00520f8b, 1 instruction(s), falls into the block at 0x00520f9f
    {load} xor eax, eax                          # 00520f9d
L_00520f9f:
    # block 0x00520f9f: entered by jmp at 0x00520f9b, 5 instruction(s), calls FUN_0051dc31, falls into the block at 0x00520fad
    or dword ptr [ebp - field_minus_4], -0x1     # 00520f9f
    push ebx                                     # 00520fa3
    mov dword ptr [esi + field_20], eax          # 00520fa4
    call FUN_0051dc31                            # 00520fa7
    pop ebx                                      # 00520fac
L_00520fad:
    # block 0x00520fad: entered by jne at 0x00520f63; je at 0x00520f69, 6 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 00520fad
    mov eax, dword ptr [esi + field_20]          # 00520fb0
    pop esi                                      # 00520fb3
    mov dword ptr fs:[0x0], ecx                  # 00520fb4
    leave                                        # 00520fbb
    ret 0x4                                      # 00520fbc

