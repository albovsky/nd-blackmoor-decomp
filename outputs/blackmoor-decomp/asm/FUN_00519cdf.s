# FUN_00519cdf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519cdf
# extent:       0x00519cdf-0x00519d8e (175 code bytes)
# span:         0x00519cdf-0x00519d8e (code 175, tables 0, padding 0)
# sha256:       780cb44df73236639894357b31cae5fe58c5cd0699a333b100033912d5f44f2d
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519cdf
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14, field_15; [ebp + n] field_8, field_c, field_10, field_minus_4, field_minus_c, field_minus_10; [ecx + n] field_2a, field_2e; [esi + n] field_3c, field_5c, field_60
# callees:      calls FUN_0050f978, FUN_0051e08b, FUN_0050f920, FUN_0051e36f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_15, 0x15  # offset +0x15
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_3c, 0x3c  # offset +0x3c
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e08b, .text + (0x0051e08b - 0x401000)
.set FUN_0051e36f, .text + (0x0051e36f - 0x401000)

.org 0x00519cdf - 0x401000
.globl FUN_00519cdf
FUN_00519cdf:
    # block 0x00519cdf: entry, 27 instruction(s), calls FUN_0050f978, FUN_0051e08b, FUN_0050f920, ends with jne to 0x00519d52 (forward)
    mov eax, 0x529164                            # 00519cdf
    call FUN_0050f978                            # 00519ce4
    push ecx                                     # 00519ce9
    push ebx                                     # 00519cea
    push esi                                     # 00519ceb
    push dword ptr [ebp + field_10]              # 00519cec
    {load} xor ebx, ebx                          # 00519cef
    {load} mov esi, ecx                          # 00519cf1
    push ebx                                     # 00519cf3
    mov dword ptr [ebp - field_minus_10], esi    # 00519cf4
    call FUN_0051e08b                            # 00519cf7
    lea eax, [esi + field_60]                    # 00519cfc
    push 0x42                                    # 00519cff
    push ebx                                     # 00519d01
    push eax                                     # 00519d02
    mov dword ptr [ebp - field_minus_4], ebx     # 00519d03
    mov dword ptr [esi + field_5c], eax          # 00519d06
    mov dword ptr [esi], 0x52ffec                # 00519d09
    call FUN_0050f920                            # 00519d0f
    mov eax, dword ptr [esi + field_5c]          # 00519d14
    mov ecx, dword ptr [ebp + field_c]           # 00519d17
    add esp, 0xc                                 # 00519d1a
    mov dword ptr [eax], 0x42                    # 00519d1d
    mov eax, dword ptr [esi + field_5c]          # 00519d23
    mov dword ptr [eax + field_14], ecx          # 00519d26
    cmp dword ptr [0x63c7a4], ebx                # 00519d29
    jne.d8 L_00519d52                            # 00519d2f
    # block 0x00519d31: entered by fall-through of jne at 0x00519d2f, 3 instruction(s), calls FUN_0051e36f, ends with je to 0x00519d52 (forward)
    call FUN_0051e36f                            # 00519d31
    test eax, eax                                # 00519d36
    je.d8 L_00519d52                             # 00519d38
    # block 0x00519d3a: entered by fall-through of je at 0x00519d38, 7 instruction(s), falls into the block at 0x00519d52
    mov eax, dword ptr [esi + field_5c]          # 00519d3a
    or byte ptr [eax + field_15], 0x38           # 00519d3d
    mov ecx, dword ptr [esi + field_5c]          # 00519d41
    mov eax, 0x519f40                            # 00519d44
    mov dword ptr [ecx + field_2a], eax          # 00519d49
    mov ecx, dword ptr [esi + field_5c]          # 00519d4c
    mov dword ptr [ecx + field_2e], eax          # 00519d4f
L_00519d52:
    # block 0x00519d52: entered by jne at 0x00519d2f; je at 0x00519d38, 2 instruction(s), ends with je to 0x00519d67 (forward)
    cmp dword ptr [ebp + field_8], ebx           # 00519d52
    je.d8 L_00519d67                             # 00519d55
    # block 0x00519d57: entered by fall-through of je at 0x00519d55, 4 instruction(s), ends with forward jump to 0x00519d75
    mov eax, dword ptr [esi + field_5c]          # 00519d57
    mov dword ptr [esi + field_3c], 0x7009       # 00519d5a
    or dword ptr [eax + field_14], 0x40          # 00519d61
    jmp.d8 L_00519d75                            # 00519d65
L_00519d67:
    # block 0x00519d67: entered by je at 0x00519d55, 3 instruction(s), falls into the block at 0x00519d75
    mov eax, dword ptr [esi + field_5c]          # 00519d67
    mov dword ptr [esi + field_3c], 0x7008       # 00519d6a
    or byte ptr [eax + field_15], 0x1            # 00519d71
L_00519d75:
    # block 0x00519d75: entered by jmp at 0x00519d65, 9 instruction(s), ends with ret 0xc
    mov eax, dword ptr [esi + field_5c]          # 00519d75
    mov ecx, dword ptr [ebp - field_minus_c]     # 00519d78
    and byte ptr [eax + field_15], -0x3          # 00519d7b
    {load} mov eax, esi                          # 00519d7f
    pop esi                                      # 00519d81
    pop ebx                                      # 00519d82
    mov dword ptr fs:[0x0], ecx                  # 00519d83
    leave                                        # 00519d8a
    ret 0xc                                      # 00519d8b

