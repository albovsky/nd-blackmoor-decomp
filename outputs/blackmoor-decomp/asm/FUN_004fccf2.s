# FUN_004fccf2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fccf2
# extent:       0x004fccf2-0x004fcd4d (91 code bytes)
# span:         0x004fccf2-0x004fcd4d (code 91, tables 0, padding 0)
# sha256:       076b72ed4cb5aa88182dda67619a38e3aaadaf0462696a5b8f357e375f5a3cfc
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fcb5c, .text + (0x004fcb5c - 0x401000)

.org 0x004fccf2 - 0x401000
.globl FUN_004fccf2
FUN_004fccf2:
    # block 0x004fccf2: <unfilled>
    push ebp                                     # 004fccf2
    {load} mov ebp, esp                          # 004fccf3
    sub esp, 0xc                                 # 004fccf5
    mov dword ptr [ebp - local_4], ecx           # 004fccf8
    movsx eax, word ptr [0x63a4cd]               # 004fccfb
    test eax, eax                                # 004fcd02
    je.d8 L_004fcd13                             # 004fcd04
    # block 0x004fcd06: <unfilled>
    push 0x5609d4                                # 004fcd06
    call FUN_0044a2b7                            # 004fcd0b
    add esp, 0x4                                 # 004fcd10
L_004fcd13:
    # block 0x004fcd13: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004fcd13
    and ecx, 0xffff                              # 004fcd16
    mov dword ptr [ebp - local_8], ecx           # 004fcd1c
    fild dword ptr [ebp - local_8]               # 004fcd1f
    fstp dword ptr [ebp - local_c]               # 004fcd22
    fld dword ptr [ebp - local_c]                # 004fcd25
    fdiv dword ptr [0x52cbec]                    # 004fcd28
    mov edx, dword ptr [ebp + arg_c]             # 004fcd2e
    mov eax, dword ptr [ebp - local_4]           # 004fcd31
    fstp dword ptr [eax + 4*edx + 0xb764]        # 004fcd34
    mov ecx, dword ptr [ebp + arg_c]             # 004fcd3b
    push ecx                                     # 004fcd3e
    mov ecx, dword ptr [ebp - local_4]           # 004fcd3f
    call FUN_004fcb5c                            # 004fcd42
    {load} mov esp, ebp                          # 004fcd47
    pop ebp                                      # 004fcd49
    ret 0x8                                      # 004fcd4a
