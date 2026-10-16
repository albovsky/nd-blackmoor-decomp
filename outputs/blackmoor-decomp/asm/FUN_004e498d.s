# FUN_004e498d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e498d
# extent:       0x004e498d-0x004e49e2 (85 code bytes)
# span:         0x004e498d-0x004e49e2 (code 85, tables 0, padding 0)
# sha256:       298cee4302b6b7a2c0fad28f824b2ab44e7260e6b45235e4dfd67ae463a222bb
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e498d
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004e498d - 0x401000
.globl FUN_004e498d
FUN_004e498d:
    # block 0x004e498d: entry, 35 instruction(s), ends with ret 0x4
    push ebp                                     # 004e498d
    {load} mov ebp, esp                          # 004e498e
    push ecx                                     # 004e4990
    push esi                                     # 004e4991
    push edi                                     # 004e4992
    mov dword ptr [ebp - local_4], ecx           # 004e4993
    mov esi, dword ptr [ebp - local_4]           # 004e4996
    add esi, 0xa80                               # 004e4999
    mov edi, dword ptr [ebp - local_4]           # 004e499f
    add edi, 0x453c                              # 004e49a2
    mov ecx, 0xc                                 # 004e49a8
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e49ad
    movsb byte ptr es:[edi], byte ptr [esi]      # 004e49af
    mov edi, dword ptr [ebp + arg_8]             # 004e49b0
    mov eax, dword ptr [ebp - local_4]           # 004e49b3
    add eax, 0x453c                              # 004e49b6
    {load} mov edx, eax                          # 004e49bb
    or ecx, -0x1                                 # 004e49bd
    {load} xor eax, eax                          # 004e49c0
    repne scasb al, byte ptr es:[edi]            # 004e49c2
    not ecx                                      # 004e49c4
    {load} sub edi, ecx                          # 004e49c6
    {load} mov esi, edi                          # 004e49c8
    {load} mov eax, ecx                          # 004e49ca
    {load} mov edi, edx                          # 004e49cc
    shr ecx, 0x2                                 # 004e49ce
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e49d1
    {load} mov ecx, eax                          # 004e49d3
    and ecx, 0x3                                 # 004e49d5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e49d8
    pop edi                                      # 004e49da
    pop esi                                      # 004e49db
    {load} mov esp, ebp                          # 004e49dc
    pop ebp                                      # 004e49de
    ret 0x4                                      # 004e49df

