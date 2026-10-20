# FUN_004b8520
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8520
# extent:       0x004b8520-0x004b85f6 (214 code bytes)
# span:         0x004b8520-0x004b85f6 (code 214, tables 0, padding 0)
# sha256:       b67c66550ce730fbe200b7058d50d3ee97158db07115c7a034e9442ffefd69aa
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         char_allowed
# naming:       native port src/action_family_f5_runtime.c:char_allowed (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with char_allowed (letters, digits if the body's digits flag is set, or one of the body's extra characters). The typed body is a parameter, not the pointer the original reads through obj + 8.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_8; [ecx + n] field_8, field_434; [edx + n] field_432
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:char_allowed (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 68 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_432, 0x432  # offset +0x432
.equ field_434, 0x434  # offset +0x434

# --- external targets -----------------------------------------------

.org 0x004b8520 - 0x401000
.globl FUN_004b8520
FUN_004b8520:
    # block 0x004b8520: entry, 9 instruction(s), ends with jl to 0x004b8545 (forward)
    push ebp                                     # 004b8520
    {load} mov ebp, esp                          # 004b8521
    sub esp, 0x8                                 # 004b8523
    push ebx                                     # 004b8526
    mov dword ptr [ebp - local_8], ecx           # 004b8527
    mov eax, dword ptr [ebp + arg_8]             # 004b852a
    and eax, 0xff                                # 004b852d
    cmp eax, 0x41                                # 004b8532
    jl.d8 L_004b8545                             # 004b8535
    # block 0x004b8537: entered by fall-through of jl at 0x004b8535, 4 instruction(s), ends with jle to 0x004b858e (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004b8537
    and ecx, 0xff                                # 004b853a
    cmp ecx, 0x5a                                # 004b8540
    jle.d8 L_004b858e                            # 004b8543
L_004b8545:
    # block 0x004b8545: entered by jl at 0x004b8535; fall-through of jle at 0x004b8543, 4 instruction(s), ends with jl to 0x004b8560 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004b8545
    and edx, 0xff                                # 004b8548
    cmp edx, 0x61                                # 004b854e
    jl.d8 L_004b8560                             # 004b8551
    # block 0x004b8553: entered by fall-through of jl at 0x004b8551, 4 instruction(s), ends with jle to 0x004b858e (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004b8553
    and eax, 0xff                                # 004b8556
    cmp eax, 0x7a                                # 004b855b
    jle.d8 L_004b858e                            # 004b855e
L_004b8560:
    # block 0x004b8560: entered by jl at 0x004b8551; fall-through of jle at 0x004b855e, 6 instruction(s), ends with je to 0x004b8595 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b8560
    mov edx, dword ptr [ecx + field_8]           # 004b8563
    {load} xor eax, eax                          # 004b8566
    mov al, byte ptr [edx + field_432]           # 004b8568
    test eax, eax                                # 004b856e
    je.d8 L_004b8595                             # 004b8570
    # block 0x004b8572: entered by fall-through of je at 0x004b8570, 4 instruction(s), ends with jl to 0x004b8595 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004b8572
    and ecx, 0xff                                # 004b8575
    cmp ecx, 0x30                                # 004b857b
    jl.d8 L_004b8595                             # 004b857e
    # block 0x004b8580: entered by fall-through of jl at 0x004b857e, 4 instruction(s), ends with jg to 0x004b8595 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004b8580
    and edx, 0xff                                # 004b8583
    cmp edx, 0x39                                # 004b8589
    jg.d8 L_004b8595                             # 004b858c
L_004b858e:
    # block 0x004b858e: entered by jle at 0x004b8543; jle at 0x004b855e; fall-through of jg at 0x004b858c, 2 instruction(s), ends with forward jump to 0x004b85ef
    mov eax, 0x1                                 # 004b858e
    jmp.d8 L_004b85ef                            # 004b8593
L_004b8595:
    # block 0x004b8595: entered by je at 0x004b8570; jl at 0x004b857e; jg at 0x004b858c, 6 instruction(s), ends with je to 0x004b85ed (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b8595
    mov ecx, dword ptr [eax + field_8]           # 004b8598
    {load} xor edx, edx                          # 004b859b
    mov dl, byte ptr [ecx + field_434]           # 004b859d
    test edx, edx                                # 004b85a3
    je.d8 L_004b85ed                             # 004b85a5
    # block 0x004b85a7: entered by fall-through of je at 0x004b85a5, 2 instruction(s), ends with forward jump to 0x004b85bb
    mov word ptr [ebp - local_4], 0x0            # 004b85a7
    jmp.d8 L_004b85bb                            # 004b85ad
L_004b85af:
    # block 0x004b85af: entered by jmp at 0x004b85eb, 3 instruction(s), falls into the block at 0x004b85bb
    mov ax, word ptr [ebp - local_4]             # 004b85af
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b85b3
    mov word ptr [ebp - local_4], ax             # 004b85b7
L_004b85bb:
    # block 0x004b85bb: entered by jmp at 0x004b85ad, 3 instruction(s), ends with jge to 0x004b85ed (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b85bb
    cmp ecx, 0x1e                                # 004b85bf
    jge.d8 L_004b85ed                            # 004b85c2
    # block 0x004b85c4: entered by fall-through of jge at 0x004b85c2, 9 instruction(s), ends with jne to 0x004b85eb (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004b85c4
    and edx, 0xff                                # 004b85c7
    mov eax, dword ptr [ebp - local_8]           # 004b85cd
    mov ecx, dword ptr [eax + field_8]           # 004b85d0
    movsx eax, word ptr [ebp - local_4]          # 004b85d3
    {load} xor ebx, ebx                          # 004b85d7
    mov bl, byte ptr [ecx + eax + field_434]     # 004b85d9
    {load} cmp edx, ebx                          # 004b85e0
    jne.d8 L_004b85eb                            # 004b85e2
    # block 0x004b85e4: entered by fall-through of jne at 0x004b85e2, 2 instruction(s), ends with forward jump to 0x004b85ef
    mov eax, 0x1                                 # 004b85e4
    jmp.d8 L_004b85ef                            # 004b85e9
L_004b85eb:
    # block 0x004b85eb: entered by jne at 0x004b85e2, 1 instruction(s), ends with backward jump to 0x004b85af
    jmp.d8 L_004b85af                            # 004b85eb
L_004b85ed:
    # block 0x004b85ed: entered by je at 0x004b85a5; jge at 0x004b85c2, 1 instruction(s), falls into the block at 0x004b85ef
    {load} xor eax, eax                          # 004b85ed
L_004b85ef:
    # block 0x004b85ef: entered by jmp at 0x004b8593; jmp at 0x004b85e9, 4 instruction(s), ends with ret 0x4
    pop ebx                                      # 004b85ef
    {load} mov esp, ebp                          # 004b85f0
    pop ebp                                      # 004b85f2
    ret 0x4                                      # 004b85f3

