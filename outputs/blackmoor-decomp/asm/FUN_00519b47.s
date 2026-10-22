# FUN_00519b47
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519b47
# extent:       0x00519b47-0x00519bbf (120 code bytes)
# span:         0x00519b47-0x00519bbf (code 120, tables 0, padding 0)
# sha256:       d3985c79ee2b43f0691512903bd5882cb51aef794eedfa97be8e9573b425008c
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519b47
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10; [edx + n] field_minus_8
# callees:      calls FUN_0050f978, FUN_0051e52f, FUN_0051e7e4, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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

.org 0x00519b47 - 0x401000
.globl FUN_00519b47
FUN_00519b47:
    # block 0x00519b47: entry, 7 instruction(s), calls FUN_0050f978, ends with jge to 0x00519b5f (forward)
    mov eax, 0x528ed7                            # 00519b47
    call FUN_0050f978                            # 00519b4c
    push ecx                                     # 00519b51
    mov eax, dword ptr [ebp + field_c]           # 00519b52
    and dword ptr [ebp - field_minus_10], 0x0    # 00519b55
    test eax, eax                                # 00519b59
    jge.d8 L_00519b5f                            # 00519b5b
    # block 0x00519b5d: entered by fall-through of jge at 0x00519b5b, 1 instruction(s), falls into the block at 0x00519b5f
    {load} xor eax, eax                          # 00519b5d
L_00519b5f:
    # block 0x00519b5f: entered by jge at 0x00519b5b, 3 instruction(s), ends with jl to 0x00519b74 (forward)
    mov edx, dword ptr [ecx]                     # 00519b5f
    cmp eax, dword ptr [edx - field_minus_8]     # 00519b61
    jl.d8 L_00519b74                             # 00519b64
    # block 0x00519b66: entered by fall-through of jl at 0x00519b64, 5 instruction(s), calls FUN_0051e52f, ends with forward jump to 0x00519bb1
    push ecx                                     # 00519b66
    mov ecx, dword ptr [ebp + field_8]           # 00519b67
    call FUN_0051e52f                            # 00519b6a
    mov eax, dword ptr [ebp + field_8]           # 00519b6f
    jmp.d8 L_00519bb1                            # 00519b72
L_00519b74:
    # block 0x00519b74: entered by jl at 0x00519b64, 22 instruction(s), calls FUN_0051e7e4, FUN_0051e52f, FUN_0051e7ba, falls into the block at 0x00519bb1
    mov edx, dword ptr [0x5679b0]                # 00519b74
    push esi                                     # 00519b7a
    mov dword ptr [ebp + field_c], edx           # 00519b7b
    push 0x1                                     # 00519b7e
    pop esi                                      # 00519b80
    push 0x0                                     # 00519b81
    push 0x0                                     # 00519b83
    push eax                                     # 00519b85
    lea eax, [ebp + field_c]                     # 00519b86
    push eax                                     # 00519b89
    mov dword ptr [ebp - field_minus_4], esi     # 00519b8a
    call FUN_0051e7e4                            # 00519b8d
    mov ecx, dword ptr [ebp + field_8]           # 00519b92
    lea eax, [ebp + field_c]                     # 00519b95
    push eax                                     # 00519b98
    call FUN_0051e52f                            # 00519b99
    and byte ptr [ebp - field_minus_4], 0x0      # 00519b9e
    lea ecx, [ebp + field_c]                     # 00519ba2
    mov dword ptr [ebp - field_minus_10], esi    # 00519ba5
    call FUN_0051e7ba                            # 00519ba8
    mov eax, dword ptr [ebp + field_8]           # 00519bad
    pop esi                                      # 00519bb0
L_00519bb1:
    # block 0x00519bb1: entered by jmp at 0x00519b72, 4 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - field_minus_c]     # 00519bb1
    mov dword ptr fs:[0x0], ecx                  # 00519bb4
    leave                                        # 00519bbb
    ret 0x8                                      # 00519bbc

