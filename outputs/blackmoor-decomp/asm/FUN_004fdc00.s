# FUN_004fdc00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fdc00
# extent:       0x004fdc00-0x004fdc67 (103 code bytes)
# span:         0x004fdc00-0x004fdc70 (code 103, tables 0, padding 9)
# sha256:       fd05ec3e6ce20fe273c6d9954678d544ae1a7453b9b95aca62a89bd56154e8c0
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fdc00
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4, field_34, field_44, field_58; [edx + n] field_8, field_c; [esp + n] stk_8, stk_c
# callees:      calls FUN_004fdc00
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_34, 0x34  # offset +0x34
.equ field_44, 0x44  # offset +0x44
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------

.org 0x004fdc00 - 0x401000
.globl FUN_004fdc00
FUN_004fdc00:
L_004fdc00:
    # block 0x004fdc00: entry, 4 instruction(s), ends with jl to 0x004fdc5d (forward)
    push edi                                     # 004fdc00
    mov edi, dword ptr [esp + stk_8]             # 004fdc01
    cmp dword ptr [edi + field_58], 0x2          # 004fdc05
    jl.d8 L_004fdc5d                             # 004fdc09
    # block 0x004fdc0b: entered by fall-through of jl at 0x004fdc09, 3 instruction(s), ends with je to 0x004fdc5d (forward)
    mov eax, dword ptr [edi + field_4]           # 004fdc0b
    test eax, eax                                # 004fdc0e
    je.d8 L_004fdc5d                             # 004fdc10
    # block 0x004fdc12: entered by fall-through of je at 0x004fdc10, 4 instruction(s), ends with jge to 0x004fdc5d (forward)
    mov eax, dword ptr [edi + field_34]          # 004fdc12
    mov ecx, dword ptr [esp + stk_c]             # 004fdc15
    {load} cmp ecx, eax                          # 004fdc19
    jge.d8 L_004fdc5d                            # 004fdc1b
    # block 0x004fdc1d: entered by fall-through of jge at 0x004fdc1b, 2 instruction(s), ends with jge to 0x004fdc4d (forward)
    test ecx, ecx                                # 004fdc1d
    jge.d8 L_004fdc4d                            # 004fdc1f
    # block 0x004fdc21: entered by fall-through of jge at 0x004fdc1f, 8 instruction(s), ends with jle to 0x004fdc44 (forward)
    push ebx                                     # 004fdc21
    push ebp                                     # 004fdc22
    push esi                                     # 004fdc23
    {load} xor ebx, ebx                          # 004fdc24
    {load} xor ebp, ebp                          # 004fdc26
    {load} xor esi, esi                          # 004fdc28
    test eax, eax                                # 004fdc2a
    jle.d8 L_004fdc44                            # 004fdc2c
L_004fdc2e:
    # block 0x004fdc2e: entered by jl at 0x004fdc42; fall-through of jle at 0x004fdc2c, 10 instruction(s), calls FUN_004fdc00, ends with jl to 0x004fdc2e (backward)
    push esi                                     # 004fdc2e
    push edi                                     # 004fdc2f
    call L_004fdc00                              # 004fdc30
    add esp, 0x8                                 # 004fdc35
    {load} add ebx, eax                          # 004fdc38
    mov eax, dword ptr [edi + field_34]          # 004fdc3a
    {load} adc ebp, edx                          # 004fdc3d
    inc esi                                      # 004fdc3f
    {load} cmp esi, eax                          # 004fdc40
    jl.d8 L_004fdc2e                             # 004fdc42
L_004fdc44:
    # block 0x004fdc44: entered by jle at 0x004fdc2c; fall-through of jl at 0x004fdc42, 7 instruction(s), ends with ret
    {load} mov edx, ebp                          # 004fdc44
    pop esi                                      # 004fdc46
    {load} mov eax, ebx                          # 004fdc47
    pop ebp                                      # 004fdc49
    pop ebx                                      # 004fdc4a
    pop edi                                      # 004fdc4b
    ret                                          # 004fdc4c
L_004fdc4d:
    # block 0x004fdc4d: entered by jge at 0x004fdc1f, 6 instruction(s), ends with ret
    mov edx, dword ptr [edi + field_44]          # 004fdc4d
    pop edi                                      # 004fdc50
    shl ecx, 0x4                                 # 004fdc51
    mov eax, dword ptr [edx + ecx + field_8]     # 004fdc54
    mov edx, dword ptr [edx + ecx + field_c]     # 004fdc58
    ret                                          # 004fdc5c
L_004fdc5d:
    # block 0x004fdc5d: entered by jl at 0x004fdc09; je at 0x004fdc10; jge at 0x004fdc1b, 4 instruction(s), ends with ret
    mov eax, 0xffffff7d                          # 004fdc5d
    or edx, -0x1                                 # 004fdc62
    pop edi                                      # 004fdc65
    ret                                          # 004fdc66

# --- data items (not part of the function) -------------------------
.org 0x004fdc67 - 0x401000
PAD_004fdc67:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

