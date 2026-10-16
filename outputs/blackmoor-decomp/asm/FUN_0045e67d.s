# FUN_0045e67d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045e67d
# extent:       0x0045e67d-0x0045e6bd (64 code bytes)
# span:         0x0045e67d-0x0045e6bd (code 64, tables 0, padding 0)
# sha256:       a8bad2a8840ecb912e693981c04c6cbe29d2c4569c184872395c9550482ac4d6
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045e67d
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0045e67d - 0x401000
.globl FUN_0045e67d
FUN_0045e67d:
    # block 0x0045e67d: entry, 12 instruction(s), ends with je to 0x0045e6b3 (forward)
    push ebp                                     # 0045e67d
    {load} mov ebp, esp                          # 0045e67e
    push ecx                                     # 0045e680
    push esi                                     # 0045e681
    push edi                                     # 0045e682
    mov dword ptr [ebp - local_4], ecx           # 0045e683
    mov edi, 0x54af34                            # 0045e686
    mov esi, dword ptr [ebp + arg_8]             # 0045e68b
    mov ecx, 0x9                                 # 0045e68e
    {load} xor eax, eax                          # 0045e693
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045e695
    je.d8 L_0045e6b3                             # 0045e697
    # block 0x0045e699: entered by fall-through of je at 0x0045e697, 8 instruction(s), ends with jbe to 0x0045e6b3 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0045e699
    or ecx, -0x1                                 # 0045e69c
    {load} xor eax, eax                          # 0045e69f
    repne scasb al, byte ptr es:[edi]            # 0045e6a1
    not ecx                                      # 0045e6a3
    add ecx, -0x1                                # 0045e6a5
    test ecx, ecx                                # 0045e6a8
    jbe.d8 L_0045e6b3                            # 0045e6aa
    # block 0x0045e6ac: entered by fall-through of jbe at 0x0045e6aa, 2 instruction(s), ends with forward jump to 0x0045e6b5
    mov eax, 0x1                                 # 0045e6ac
    jmp.d8 L_0045e6b5                            # 0045e6b1
L_0045e6b3:
    # block 0x0045e6b3: entered by je at 0x0045e697; jbe at 0x0045e6aa, 1 instruction(s), falls into the block at 0x0045e6b5
    {load} xor eax, eax                          # 0045e6b3
L_0045e6b5:
    # block 0x0045e6b5: entered by jmp at 0x0045e6b1, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0045e6b5
    pop esi                                      # 0045e6b6
    {load} mov esp, ebp                          # 0045e6b7
    pop ebp                                      # 0045e6b9
    ret 0x4                                      # 0045e6ba

