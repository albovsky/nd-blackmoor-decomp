# FUN_0051f9c5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f9c5
# extent:       0x0051f9c5-0x0051fa37 (114 code bytes)
# span:         0x0051f9c5-0x0051fa37 (code 114, tables 0, padding 0)
# sha256:       b52dfcf4f673835d45f4d6de6cea5622b941961ed7df24aa0d11c6e3051cb524
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f9c5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_minus_4, field_minus_c; [esi + n] field_18
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
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc31, .text + (0x0051dc31 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051f7a0, .text + (0x0051f7a0 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x0051f9c5 - 0x401000
.globl FUN_0051f9c5
FUN_0051f9c5:
    # block 0x0051f9c5: entry, 7 instruction(s), calls FUN_0050f978, FUN_00525397, ends with jne to 0x0051fa25 (forward)
    mov eax, 0x52910a                            # 0051f9c5
    call FUN_0050f978                            # 0051f9ca
    push esi                                     # 0051f9cf
    call FUN_00525397                            # 0051f9d0
    {load} mov esi, eax                          # 0051f9d5
    cmp dword ptr [esi + field_18], 0x0          # 0051f9d7
    jne.d8 L_0051fa25                            # 0051f9db
    # block 0x0051f9dd: entered by fall-through of jne at 0x0051f9db, 2 instruction(s), ends with je to 0x0051fa25 (forward)
    cmp dword ptr [ebp + field_8], 0x0           # 0051f9dd
    je.d8 L_0051fa25                             # 0051f9e1
    # block 0x0051f9e3: entered by fall-through of je at 0x0051f9e1, 12 instruction(s), calls FUN_0051dc31, FUN_0051dc43, ends with je to 0x0051fa15 (forward)
    push ebx                                     # 0051f9e3
    push 0x521235                                # 0051f9e4
    call FUN_0051dc31                            # 0051f9e9
    push 0x48                                    # 0051f9ee
    {load} mov ebx, eax                          # 0051f9f0
    call FUN_0051dc43                            # 0051f9f2
    pop ecx                                      # 0051f9f7
    {load} mov ecx, eax                          # 0051f9f8
    mov dword ptr [ebp + field_8], ecx           # 0051f9fa
    and dword ptr [ebp - field_minus_4], 0x0     # 0051f9fd
    test ecx, ecx                                # 0051fa01
    je.d8 L_0051fa15                             # 0051fa03
    # block 0x0051fa05: entered by fall-through of je at 0x0051fa03, 5 instruction(s), calls FUN_0051f7a0, ends with forward jump to 0x0051fa17
    push 0x1                                     # 0051fa05
    push 0x4                                     # 0051fa07
    push 0x52fec8                                # 0051fa09
    call FUN_0051f7a0                            # 0051fa0e
    jmp.d8 L_0051fa17                            # 0051fa13
L_0051fa15:
    # block 0x0051fa15: entered by je at 0x0051fa03, 1 instruction(s), falls into the block at 0x0051fa17
    {load} xor eax, eax                          # 0051fa15
L_0051fa17:
    # block 0x0051fa17: entered by jmp at 0x0051fa13, 5 instruction(s), calls FUN_0051dc31, falls into the block at 0x0051fa25
    or dword ptr [ebp - field_minus_4], -0x1     # 0051fa17
    push ebx                                     # 0051fa1b
    mov dword ptr [esi + field_18], eax          # 0051fa1c
    call FUN_0051dc31                            # 0051fa1f
    pop ebx                                      # 0051fa24
L_0051fa25:
    # block 0x0051fa25: entered by jne at 0x0051f9db; je at 0x0051f9e1, 6 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051fa25
    mov eax, dword ptr [esi + field_18]          # 0051fa28
    pop esi                                      # 0051fa2b
    mov dword ptr fs:[0x0], ecx                  # 0051fa2c
    leave                                        # 0051fa33
    ret 0x4                                      # 0051fa34

