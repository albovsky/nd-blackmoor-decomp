# FUN_00433bd2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00433bd2
# extent:       0x00433bd2-0x00433c51 (127 code bytes)
# span:         0x00433bd2-0x00433c60 (code 127, tables 0, padding 15)
# sha256:       db8c89e9e4980d3c69054cb2fb40ccb3f9adfc9abdf1d99fb730e40fc3c7b8a0
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         time_record_init
# arguments:    cdecl-style (plain ret, caller cleans the stack): [ebp+8]=record pointer (262-byte record, 0x106 bytes); a null pointer skips the whole body; no return value (eax is left as scratch); ebp/esi/edi are saved and restored, ecx/edx/eax are scratch
# locals:       [ebp-local_index] = dword loop index (the pushed ecx slot) for the ten 0xffff sentinel stores; esi and edi are pushed after it (saved at ebp-8 and ebp-0xc) and popped on exit
# fields:       record+0x000..0x105: zeroed (dword rep stosd with ecx=0x41 = 0x104 bytes, then one word store of zero at +0x104); record+0x0de+4*i for i = 0..9 (signed compare i < 0x0a): word set to 0xffff, the high word of each dword keeps the zero from the clear; record+0x00: dword set to 0 again; record+0x28: the NUL-terminated string at global 0x00545dd4 is copied (strlen+1 bytes: repne scasb length, rep movsd of (len+1)>>2 dwords, then rep movsb of (len+1)&3 bytes); the source global 0x00545dd4 is read only (the file image holds the 8-char text NO SOUND plus NUL)
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/world_init.c:initialize_time_record
# unverified:   String instructions assume the direction flag is clear on entry (there is no cld in this routine). The copy length comes from the runtime string at 0x00545dd4; the original file image holds NO SOUND, but nothing here proves the global is never changed, and the copy is not bounded by the record size. The Ghidra label spells the string with an underscore, the file bytes and world_clock.c use a space. The record meaning (time record) comes from world-init-recovery.md; the 0xde+4*i word pairs are not named by these bytes. The helper callers (0x4381f4 loop of ten records and the runtime completion path named by world_clock.c) were not re-traced here. The 'caller pops' claim rests on the plain ret only. The field symbol rec_sentinel_word_base is a descriptive label only; the meaning of the ten word pairs at +0xde is not established.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_index, 0x4  # [ebp - 0x4]
.equ arg_record, 0x8  # [ebp + 0x8]

.equ rec_sentinel_word_base, 0xde  # record+0xde: base of ten dwords [4*i]; low word set to 0xffff

# --- external targets -----------------------------------------------

.org 0x00433bd2 - 0x401000
.globl FUN_00433bd2
FUN_00433bd2:
    # block 0x00433bd2: entry: save ebp, reserve the local slot, save esi and edi; if arg_record != 0 continue at L_init_record (jne), otherwise fall into the skip jump
    push ebp                                     # 00433bd2
    {load} mov ebp, esp                          # 00433bd3
    push ecx                                     # 00433bd5
    push esi                                     # 00433bd6
    push edi                                     # 00433bd7
    cmp dword ptr [ebp + arg_record], 0x0             # 00433bd8
    jne.d8 L_init_record                            # 00433bdc
    # block 0x00433bde: arg_record == 0: jump straight to the epilogue, nothing written
    jmp.d8 L_epilogue                            # 00433bde
L_init_record:
    # block 0x00433be0: clear the record: ecx = 0x41, eax = 0, edi = arg_record; rep stosd (0x104 bytes) then stosw (2 bytes); then local_index = 0 and jump to the sentinel-loop test
    mov ecx, 0x41                                # 00433be0
    {load} xor eax, eax                          # 00433be5
    mov edi, dword ptr [ebp + arg_record]             # 00433be7
    rep stosd dword ptr es:[edi], eax            # 00433bea
    stosw word ptr es:[edi], ax                  # 00433bec
    mov dword ptr [ebp - local_index], 0x0           # 00433bee
    jmp.d8 L_test_sentinel                            # 00433bf5
L_next_sentinel:
    # block 0x00433bf7: sentinel loop step: local_index = local_index + 1
    mov eax, dword ptr [ebp - local_index]           # 00433bf7
    add eax, 0x1                                 # 00433bfa
    mov dword ptr [ebp - local_index], eax           # 00433bfd
L_test_sentinel:
    # block 0x00433c00: sentinel loop test: if local_index >= 0x0a (signed jge) go to L_copy_name
    cmp dword ptr [ebp - local_index], 0xa           # 00433c00
    jge.d8 L_copy_name                            # 00433c04
    # block 0x00433c06: sentinel loop body: word [arg_record + 4*local_index + 0xde] = 0xffff, jump back to the step
    mov ecx, dword ptr [ebp - local_index]           # 00433c06
    mov edx, dword ptr [ebp + arg_record]             # 00433c09
    mov word ptr [edx + 4*ecx + rec_sentinel_word_base], 0xffff    # 00433c0c
    jmp.d8 L_next_sentinel                            # 00433c16
L_copy_name:
    # block 0x00433c18: dword [arg_record] = 0; strlen of the string at 0x545dd4 (repne scasb with ecx=-1, ecx = ~ecx = length+1); copy length+1 bytes to arg_record+0x28: rep movsd (count>>2 dwords) then rep movsb (count&3 bytes)
    mov eax, dword ptr [ebp + arg_record]             # 00433c18
    mov dword ptr [eax], 0x0                     # 00433c1b
    mov edi, 0x545dd4                            # 00433c21
    mov ecx, dword ptr [ebp + arg_record]             # 00433c26
    add ecx, 0x28                                # 00433c29
    {load} mov edx, ecx                          # 00433c2c
    or ecx, -0x1                                 # 00433c2e
    {load} xor eax, eax                          # 00433c31
    repne scasb al, byte ptr es:[edi]            # 00433c33
    not ecx                                      # 00433c35
    {load} sub edi, ecx                          # 00433c37
    {load} mov esi, edi                          # 00433c39
    {load} mov eax, ecx                          # 00433c3b
    {load} mov edi, edx                          # 00433c3d
    shr ecx, 0x2                                 # 00433c3f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00433c42
    {load} mov ecx, eax                          # 00433c44
    and ecx, 0x3                                 # 00433c46
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00433c49
L_epilogue:
    # block 0x00433c4b: epilogue: restore edi, esi, esp and ebp, return with a plain ret (also the target of the null-pointer skip)
    pop edi                                      # 00433c4b
    pop esi                                      # 00433c4c
    {load} mov esp, ebp                          # 00433c4d
    pop ebp                                      # 00433c4f
    ret                                          # 00433c50

# --- data items (not part of the function) -------------------------
.org 0x00433c51 - 0x401000
PAD_00433c51:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc
