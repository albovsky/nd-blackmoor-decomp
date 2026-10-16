# FUN_0049192b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049192b
# extent:       0x0049192b-0x00491972 (71 code bytes)
# span:         0x0049192b-0x00491972 (code 71, tables 0, padding 0)
# sha256:       873722fd2ae6519ea5cdf768f4dd83fe3bdb62c2a69fa0cdb660dc5bb61f36c7
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049192b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_50f3, field_50fb; [ecx + n] field_50f7; [edx + n] field_50f3
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_50f3, 0x50f3  # offset +0x50f3
.equ field_50f7, 0x50f7  # offset +0x50f7
.equ field_50fb, 0x50fb  # offset +0x50fb

# --- external targets -----------------------------------------------

.org 0x0049192b - 0x401000
.globl FUN_0049192b
FUN_0049192b:
    # block 0x0049192b: entry, 8 instruction(s), ends with jne to 0x00491941 (forward)
    push ebp                                     # 0049192b
    {load} mov ebp, esp                          # 0049192c
    push ecx                                     # 0049192e
    push edi                                     # 0049192f
    mov dword ptr [ebp - local_4], ecx           # 00491930
    mov eax, dword ptr [ebp - local_4]           # 00491933
    cmp dword ptr [eax + field_50f3], 0x0        # 00491936
    jne.d8 L_00491941                            # 0049193d
    # block 0x0049193f: entered by fall-through of jne at 0x0049193d, 1 instruction(s), ends with forward jump to 0x0049196d
    jmp.d8 L_0049196d                            # 0049193f
L_00491941:
    # block 0x00491941: entered by jne at 0x0049193d, 13 instruction(s), falls into the block at 0x0049196d
    mov ecx, dword ptr [ebp - local_4]           # 00491941
    mov ecx, dword ptr [ecx + field_50f7]        # 00491944
    {load} xor eax, eax                          # 0049194a
    mov edx, dword ptr [ebp - local_4]           # 0049194c
    mov edi, dword ptr [edx + field_50f3]        # 0049194f
    {load} mov edx, ecx                          # 00491955
    shr ecx, 0x2                                 # 00491957
    rep stosd dword ptr es:[edi], eax            # 0049195a
    {load} mov ecx, edx                          # 0049195c
    and ecx, 0x3                                 # 0049195e
    rep stosb byte ptr es:[edi], al              # 00491961
    mov eax, dword ptr [ebp - local_4]           # 00491963
    mov byte ptr [eax + field_50fb], 0x0         # 00491966
L_0049196d:
    # block 0x0049196d: entered by jmp at 0x0049193f, 4 instruction(s), ends with ret
    pop edi                                      # 0049196d
    {load} mov esp, ebp                          # 0049196e
    pop ebp                                      # 00491970
    ret                                          # 00491971

