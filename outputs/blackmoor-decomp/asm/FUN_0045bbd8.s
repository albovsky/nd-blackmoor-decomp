# FUN_0045bbd8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045bbd8
# extent:       0x0045bbd8-0x0045bcc1 (233 code bytes)
# span:         0x0045bbd8-0x0045bcc1 (code 233, tables 0, padding 0)
# sha256:       693b45f27e4f2d89d3e316c71cddaf5aef0b77f050d85313405545f901f26df1
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45bbd8_lifted
# naming:       native port src/original_methods_fl40.c:m45bbd8_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 69/69 instructions, 10/10 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_1e; [ecx + n] field_36; [edx + n] field_4, field_8, field_c, field_36d
# callees:      calls FUN_0050cd50
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45bbd8_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_36, 0x36  # offset +0x36
.equ field_36d, 0x36d  # offset +0x36d

# --- external targets -----------------------------------------------
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0045bbd8 - 0x401000
.globl FUN_0045bbd8
FUN_0045bbd8:
    # block 0x0045bbd8: entry, 12 instruction(s), ends with forward jump to 0x0045bc11
    push ebp                                     # 0045bbd8
    {load} mov ebp, esp                          # 0045bbd9
    sub esp, 0x18                                # 0045bbdb
    mov dword ptr [ebp - local_18], ecx          # 0045bbde
    mov word ptr [ebp - local_14], 0x0           # 0045bbe1
    mov eax, dword ptr [ebp - local_18]          # 0045bbe7
    movsx ecx, word ptr [eax + field_1e]         # 0045bbea
    imul ecx, ecx, 0x8d                          # 0045bbee
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045bbf4
    mov dword ptr [ebp - local_4], edx           # 0045bbfa
    mov word ptr [ebp - local_8], 0x0            # 0045bbfd
    jmp.d8 L_0045bc11                            # 0045bc03
L_0045bc05:
    # block 0x0045bc05: entered by jmp at 0x0045bca4, 3 instruction(s), falls into the block at 0x0045bc11
    mov ax, word ptr [ebp - local_8]             # 0045bc05
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045bc09
    mov word ptr [ebp - local_8], ax             # 0045bc0d
L_0045bc11:
    # block 0x0045bc11: entered by jmp at 0x0045bc03, 3 instruction(s), ends with jge to 0x0045bca9 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0045bc11
    cmp ecx, 0x4                                 # 0045bc15
    jge.d32 L_0045bca9                           # 0045bc18
    # block 0x0045bc1e: entered by fall-through of jge at 0x0045bc18, 3 instruction(s), calls FUN_0050cd50, ends with jns to 0x0045bc2f (forward)
    call FUN_0050cd50                            # 0045bc1e
    and eax, 0x80000001                          # 0045bc23
    jns.d8 L_0045bc2f                            # 0045bc28
    # block 0x0045bc2a: entered by fall-through of jns at 0x0045bc28, 3 instruction(s), falls into the block at 0x0045bc2f
    dec eax                                      # 0045bc2a
    or eax, -0x2                                 # 0045bc2b
    inc eax                                      # 0045bc2e
L_0045bc2f:
    # block 0x0045bc2f: entered by jns at 0x0045bc28, 4 instruction(s), ends with jne to 0x0045bc48 (forward)
    mov word ptr [ebp - local_10], ax            # 0045bc2f
    movsx edx, word ptr [ebp - local_10]         # 0045bc33
    cmp edx, 0x1                                 # 0045bc37
    jne.d8 L_0045bc48                            # 0045bc3a
    # block 0x0045bc3c: entered by fall-through of jne at 0x0045bc3a, 3 instruction(s), falls into the block at 0x0045bc48
    mov ax, word ptr [ebp - local_14]            # 0045bc3c
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045bc40
    mov word ptr [ebp - local_14], ax            # 0045bc44
L_0045bc48:
    # block 0x0045bc48: entered by jne at 0x0045bc3a, 3 instruction(s), calls FUN_0050cd50, ends with jns to 0x0045bc59 (forward)
    call FUN_0050cd50                            # 0045bc48
    and eax, 0x80000003                          # 0045bc4d
    jns.d8 L_0045bc59                            # 0045bc52
    # block 0x0045bc54: entered by fall-through of jns at 0x0045bc52, 3 instruction(s), falls into the block at 0x0045bc59
    dec eax                                      # 0045bc54
    or eax, -0x4                                 # 0045bc55
    inc eax                                      # 0045bc58
L_0045bc59:
    # block 0x0045bc59: entered by jns at 0x0045bc52, 24 instruction(s), ends with backward jump to 0x0045bc05
    mov word ptr [ebp - local_c], ax             # 0045bc59
    movsx ecx, word ptr [ebp - local_c]          # 0045bc5d
    shl ecx, 0x5                                 # 0045bc61
    mov edx, dword ptr [ebp - local_4]           # 0045bc64
    lea eax, [edx + ecx + field_36d]             # 0045bc67
    movsx ecx, word ptr [ebp - local_10]         # 0045bc6e
    shl ecx, 0x4                                 # 0045bc72
    {load} add eax, ecx                          # 0045bc75
    movsx edx, word ptr [ebp + arg_8]            # 0045bc77
    shl edx, 0x6                                 # 0045bc7b
    mov ecx, dword ptr [ebp - local_18]          # 0045bc7e
    lea edx, [ecx + edx + field_36]              # 0045bc81
    movsx ecx, word ptr [ebp - local_8]          # 0045bc85
    shl ecx, 0x4                                 # 0045bc89
    {load} add edx, ecx                          # 0045bc8c
    mov ecx, dword ptr [eax]                     # 0045bc8e
    mov dword ptr [edx], ecx                     # 0045bc90
    mov ecx, dword ptr [eax + field_4]           # 0045bc92
    mov dword ptr [edx + field_4], ecx           # 0045bc95
    mov ecx, dword ptr [eax + field_8]           # 0045bc98
    mov dword ptr [edx + field_8], ecx           # 0045bc9b
    mov eax, dword ptr [eax + field_c]           # 0045bc9e
    mov dword ptr [edx + field_c], eax           # 0045bca1
    jmp.d32 L_0045bc05                           # 0045bca4
L_0045bca9:
    # block 0x0045bca9: entered by jge at 0x0045bc18, 3 instruction(s), ends with jne to 0x0045bcb7 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 0045bca9
    test ecx, ecx                                # 0045bcad
    jne.d8 L_0045bcb7                            # 0045bcaf
    # block 0x0045bcb1: entered by fall-through of jne at 0x0045bcaf, 1 instruction(s), falls into the block at 0x0045bcb7
    mov word ptr [ebp - local_14], 0x5           # 0045bcb1
L_0045bcb7:
    # block 0x0045bcb7: entered by jne at 0x0045bcaf, 4 instruction(s), ends with ret 0x4
    mov ax, word ptr [ebp - local_14]            # 0045bcb7
    {load} mov esp, ebp                          # 0045bcbb
    pop ebp                                      # 0045bcbd
    ret 0x4                                      # 0045bcbe

