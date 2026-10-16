# FUN_0051e3c8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e3c8
# extent:       0x0051e3c8-0x0051e42d (101 code bytes)
# span:         0x0051e3c8-0x0051e42d (code 101, tables 0, padding 0)
# sha256:       38e937b41170ca9cadf266088e5902aed456070a9043c837f99f6ab5a8c9b309
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e3c8
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_40, field_4c
# callees:      calls FUN_0051cd70, FUN_0051cd20, FUN_0051cab3, FUN_0051e2a0, FUN_0051d462, FUN_0051e36f, FUN_0051d630
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_40, 0x40  # offset +0x40
.equ field_4c, 0x4c  # offset +0x4c

# --- external targets -----------------------------------------------
.set FUN_0051cab3, .text + (0x0051cab3 - 0x401000)
.set FUN_0051cd20, .text + (0x0051cd20 - 0x401000)
.set FUN_0051cd70, .text + (0x0051cd70 - 0x401000)
.set FUN_0051d462, .text + (0x0051d462 - 0x401000)
.set FUN_0051d630, .text + (0x0051d630 - 0x401000)
.set FUN_0051e2a0, .text + (0x0051e2a0 - 0x401000)
.set FUN_0051e36f, .text + (0x0051e36f - 0x401000)

.org 0x0051e3c8 - 0x401000
.globl FUN_0051e3c8
FUN_0051e3c8:
    # block 0x0051e3c8: entry, 5 instruction(s), ends with je to 0x0051e3da (forward)
    push esi                                     # 0051e3c8
    {load} mov esi, ecx                          # 0051e3c9
    mov eax, dword ptr [esi + field_4c]          # 0051e3cb
    test eax, eax                                # 0051e3ce
    je.d8 L_0051e3da                             # 0051e3d0
    # block 0x0051e3d2: entered by fall-through of je at 0x0051e3d0, 3 instruction(s), calls FUN_0051cd70, ends with forward jump to 0x0051e3e4
    push eax                                     # 0051e3d2
    call FUN_0051cd70                            # 0051e3d3
    jmp.d8 L_0051e3e4                            # 0051e3d8
L_0051e3da:
    # block 0x0051e3da: entered by je at 0x0051e3d0, 3 instruction(s), calls FUN_0051cd20, falls into the block at 0x0051e3e4
    push dword ptr [esi + field_40]              # 0051e3da
    {load} mov ecx, esi                          # 0051e3dd
    call FUN_0051cd20                            # 0051e3df
L_0051e3e4:
    # block 0x0051e3e4: entered by jmp at 0x0051e3d8, 2 instruction(s), ends with je to 0x0051e3f5 (forward)
    test eax, eax                                # 0051e3e4
    je.d8 L_0051e3f5                             # 0051e3e6
    # block 0x0051e3e8: entered by fall-through of je at 0x0051e3e6, 5 instruction(s), calls FUN_0051cab3, ends with jne to 0x0051e402 (forward)
    push 0x0                                     # 0051e3e8
    {load} mov ecx, esi                          # 0051e3ea
    call FUN_0051cab3                            # 0051e3ec
    test eax, eax                                # 0051e3f1
    jne.d8 L_0051e402                            # 0051e3f3
L_0051e3f5:
    # block 0x0051e3f5: entered by je at 0x0051e3e6; fall-through of jne at 0x0051e3f3, 6 instruction(s), calls FUN_0051e2a0, ends with ret
    push -0x1                                    # 0051e3f5
    {load} mov ecx, esi                          # 0051e3f7
    call FUN_0051e2a0                            # 0051e3f9
    {load} xor eax, eax                          # 0051e3fe
    pop esi                                      # 0051e400
    ret                                          # 0051e401
L_0051e402:
    # block 0x0051e402: entered by jne at 0x0051e3f3, 6 instruction(s), calls FUN_0051d462, ends with je to 0x0051e428 (forward)
    push 0xe146                                  # 0051e402
    {load} mov ecx, esi                          # 0051e407
    call FUN_0051d462                            # 0051e409
    {load} mov esi, eax                          # 0051e40e
    test esi, esi                                # 0051e410
    je.d8 L_0051e428                             # 0051e412
    # block 0x0051e414: entered by fall-through of je at 0x0051e412, 7 instruction(s), calls FUN_0051e36f, FUN_0051d630, falls into the block at 0x0051e428
    call FUN_0051e36f                            # 0051e414
    neg eax                                      # 0051e419
    {load} sbb eax, eax                          # 0051e41b
    {load} mov ecx, esi                          # 0051e41d
    and eax, 0x5                                 # 0051e41f
    push eax                                     # 0051e422
    call FUN_0051d630                            # 0051e423
L_0051e428:
    # block 0x0051e428: entered by je at 0x0051e412, 4 instruction(s), ends with ret
    push 0x1                                     # 0051e428
    pop eax                                      # 0051e42a
    pop esi                                      # 0051e42b
    ret                                          # 0051e42c

