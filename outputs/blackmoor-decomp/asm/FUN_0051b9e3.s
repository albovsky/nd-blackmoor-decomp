# FUN_0051b9e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b9e3
# extent:       0x0051b9e3-0x0051ba27 (68 code bytes)
# span:         0x0051b9e3-0x0051ba27 (code 68, tables 0, padding 0)
# sha256:       e2385cc26759cacd220c09e382ac50c77fa01fdcb5bb0ac1747221641b9d8fe4
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b9e3
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_9c, field_a0
# callees:      none direct; 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_9c, 0x9c  # offset +0x9c
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------

.org 0x0051b9e3 - 0x401000
.globl FUN_0051b9e3
FUN_0051b9e3:
    # block 0x0051b9e3: entry, 16 instruction(s), calls indirect dword ptr [eax + 0x9c], ends with jne to 0x0051ba1f (forward)
    push ebp                                     # 0051b9e3
    {load} mov ebp, esp                          # 0051b9e4
    push ecx                                     # 0051b9e6
    push esi                                     # 0051b9e7
    {load} mov esi, ecx                          # 0051b9e8
    lea ecx, [ebp - local_4]                     # 0051b9ea
    and dword ptr [ebp - local_4], 0x0           # 0051b9ed
    mov eax, dword ptr [esi]                     # 0051b9f1
    push ecx                                     # 0051b9f3
    push dword ptr [ebp + arg_10]                # 0051b9f4
    {load} mov ecx, esi                          # 0051b9f7
    push dword ptr [ebp + arg_c]                 # 0051b9f9
    push dword ptr [ebp + arg_8]                 # 0051b9fc
    call dword ptr [eax + field_9c]              # 0051b9ff
    test eax, eax                                # 0051ba05
    jne.d8 L_0051ba1f                            # 0051ba07
    # block 0x0051ba09: entered by fall-through of jne at 0x0051ba07, 7 instruction(s), calls indirect dword ptr [eax + 0xa0], falls into the block at 0x0051ba1f
    push dword ptr [ebp + arg_10]                # 0051ba09
    mov eax, dword ptr [esi]                     # 0051ba0c
    {load} mov ecx, esi                          # 0051ba0e
    push dword ptr [ebp + arg_c]                 # 0051ba10
    push dword ptr [ebp + arg_8]                 # 0051ba13
    call dword ptr [eax + field_a0]              # 0051ba16
    mov dword ptr [ebp - local_4], eax           # 0051ba1c
L_0051ba1f:
    # block 0x0051ba1f: entered by jne at 0x0051ba07, 4 instruction(s), ends with ret 0xc
    mov eax, dword ptr [ebp - local_4]           # 0051ba1f
    pop esi                                      # 0051ba22
    leave                                        # 0051ba23
    ret 0xc                                      # 0051ba24

