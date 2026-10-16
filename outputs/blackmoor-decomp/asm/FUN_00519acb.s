# FUN_00519acb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519acb
# extent:       0x00519acb-0x00519b47 (124 code bytes)
# span:         0x00519acb-0x00519b47 (code 124, tables 0, padding 0)
# sha256:       5a65767d463688f38be2afc13dc6a098e088b102b54e7e1c8abec6b632393cf0
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519acb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_8; [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051e52f, FUN_0051e7e4, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e52f, .text + (0x0051e52f - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e7e4, .text + (0x0051e7e4 - 0x401000)

.org 0x00519acb - 0x401000
.globl FUN_00519acb
FUN_00519acb:
    # block 0x00519acb: entry, 7 instruction(s), calls FUN_0050f978, ends with jge to 0x00519ae3 (forward)
    mov eax, 0x528eab                            # 00519acb
    call FUN_0050f978                            # 00519ad0
    push ecx                                     # 00519ad5
    mov edx, dword ptr [ebp + field_c]           # 00519ad6
    and dword ptr [ebp - field_minus_10], 0x0    # 00519ad9
    test edx, edx                                # 00519add
    jge.d8 L_00519ae3                            # 00519adf
    # block 0x00519ae1: entered by fall-through of jge at 0x00519adf, 1 instruction(s), falls into the block at 0x00519ae3
    {load} xor edx, edx                          # 00519ae1
L_00519ae3:
    # block 0x00519ae3: entered by jge at 0x00519adf, 3 instruction(s), ends with jl to 0x00519af8 (forward)
    mov eax, dword ptr [ecx]                     # 00519ae3
    cmp edx, dword ptr [eax - field_minus_8]     # 00519ae5
    jl.d8 L_00519af8                             # 00519ae8
    # block 0x00519aea: entered by fall-through of jl at 0x00519ae8, 5 instruction(s), calls FUN_0051e52f, ends with forward jump to 0x00519b39
    push ecx                                     # 00519aea
    mov ecx, dword ptr [ebp + field_8]           # 00519aeb
    call FUN_0051e52f                            # 00519aee
    mov eax, dword ptr [ebp + field_8]           # 00519af3
    jmp.d8 L_00519b39                            # 00519af6
L_00519af8:
    # block 0x00519af8: entered by jl at 0x00519ae8, 24 instruction(s), calls FUN_0051e7e4, FUN_0051e52f, FUN_0051e7ba, falls into the block at 0x00519b39
    push esi                                     # 00519af8
    mov esi, dword ptr [0x5679b0]                # 00519af9
    mov dword ptr [ebp + field_c], esi           # 00519aff
    mov eax, dword ptr [eax - field_minus_8]     # 00519b02
    push 0x1                                     # 00519b05
    pop esi                                      # 00519b07
    {load} sub eax, edx                          # 00519b08
    push 0x0                                     # 00519b0a
    push eax                                     # 00519b0c
    lea eax, [ebp + field_c]                     # 00519b0d
    push edx                                     # 00519b10
    push eax                                     # 00519b11
    mov dword ptr [ebp - field_minus_4], esi     # 00519b12
    call FUN_0051e7e4                            # 00519b15
    mov ecx, dword ptr [ebp + field_8]           # 00519b1a
    lea eax, [ebp + field_c]                     # 00519b1d
    push eax                                     # 00519b20
    call FUN_0051e52f                            # 00519b21
    and byte ptr [ebp - field_minus_4], 0x0      # 00519b26
    lea ecx, [ebp + field_c]                     # 00519b2a
    mov dword ptr [ebp - field_minus_10], esi    # 00519b2d
    call FUN_0051e7ba                            # 00519b30
    mov eax, dword ptr [ebp + field_8]           # 00519b35
    pop esi                                      # 00519b38
L_00519b39:
    # block 0x00519b39: entered by jmp at 0x00519af6, 4 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - field_minus_c]     # 00519b39
    mov dword ptr fs:[0x0], ecx                  # 00519b3c
    leave                                        # 00519b43
    ret 0x8                                      # 00519b44

