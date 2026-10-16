# FUN_00516a34
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516a34
# extent:       0x00516a34-0x00516a8a (86 code bytes)
# span:         0x00516a34-0x00516a8a (code 86, tables 0, padding 0)
# sha256:       8688b4905524a4c74f95431c3d437982d23dcd397e5ccbd0ddd21973adbe662d
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516a34
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_14
# callees:      calls FUN_00518bd5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00518bd5, .text + (0x00518bd5 - 0x401000)

.org 0x00516a34 - 0x401000
.globl FUN_00516a34
FUN_00516a34:
    # block 0x00516a34: entry, 27 instruction(s), calls FUN_00518bd5, ends with js to 0x00516a86 (forward)
    mov eax, dword ptr [esp + stk_8]             # 00516a34
    push ebx                                     # 00516a38
    push esi                                     # 00516a39
    push edi                                     # 00516a3a
    push 0x20                                    # 00516a3b
    mov ebx, dword ptr [esp + stk_14]            # 00516a3d
    cdq                                          # 00516a41
    pop ecx                                      # 00516a42
    idiv ecx                                     # 00516a43
    {load} mov esi, eax                          # 00516a45
    mov eax, dword ptr [esp + stk_14]            # 00516a47
    cdq                                          # 00516a4b
    idiv ecx                                     # 00516a4c
    lea edi, [ebx + 4*esi]                       # 00516a4e
    push edi                                     # 00516a51
    push 0x1f                                    # 00516a52
    pop ecx                                      # 00516a54
    push 0x1                                     # 00516a55
    pop eax                                      # 00516a57
    {load} sub ecx, edx                          # 00516a58
    shl eax, cl                                  # 00516a5a
    push eax                                     # 00516a5c
    push dword ptr [edi]                         # 00516a5d
    call FUN_00518bd5                            # 00516a5f
    add esp, 0xc                                 # 00516a64
    dec esi                                      # 00516a67
    js.d8 L_00516a86                             # 00516a68
    # block 0x00516a6a: entered by fall-through of js at 0x00516a68, 1 instruction(s), falls into the block at 0x00516a6d
    lea edi, [ebx + 4*esi]                       # 00516a6a
L_00516a6d:
    # block 0x00516a6d: entered by jge at 0x00516a84, 2 instruction(s), ends with je to 0x00516a86 (forward)
    test eax, eax                                # 00516a6d
    je.d8 L_00516a86                             # 00516a6f
    # block 0x00516a71: entered by fall-through of je at 0x00516a6f, 9 instruction(s), calls FUN_00518bd5, ends with jge to 0x00516a6d (backward)
    push edi                                     # 00516a71
    push 0x1                                     # 00516a72
    push dword ptr [edi]                         # 00516a74
    call FUN_00518bd5                            # 00516a76
    add esp, 0xc                                 # 00516a7b
    dec esi                                      # 00516a7e
    sub edi, 0x4                                 # 00516a7f
    test esi, esi                                # 00516a82
    jge.d8 L_00516a6d                            # 00516a84
L_00516a86:
    # block 0x00516a86: entered by js at 0x00516a68; je at 0x00516a6f; fall-through of jge at 0x00516a84, 4 instruction(s), ends with ret
    pop edi                                      # 00516a86
    pop esi                                      # 00516a87
    pop ebx                                      # 00516a88
    ret                                          # 00516a89

