# FUN_00434773
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434773
# extent:       0x00434773-0x004347b8 (69 code bytes)
# span:         0x00434773-0x004347b8 (code 69, tables 0, padding 0)
# sha256:       de3d170c384fb01b34ae6780aeeb5299e927e5d60330ef7c20a33819ede91ad1
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         CHiff::is_data_signature
# arguments:    thiscall: ecx=this (spilled, unused); [ebp+8]=arg_ptr pointer to four bytes to test; callee pops 4 (ret 4); returns eax = 1 when the bytes are the ASCII characters D, A, T, A in order, otherwise 0
# locals:       [ebp-4]=saved this (the single push ecx slot)
# fields:       none (no fields touched); reads four bytes at arg_ptr
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/hiff.c:scan_data_records  (the same four-byte DATA test is an inlined memcmp in index_chunks)
# unverified:   the four compares use sign-extended bytes against 0x44, 0x41, 0x54, 0x41 (D, A, T, A); the class name and thiscall form are inferred from callers that load ecx = this; the native code folds this test into the memcmp inside scan_data_records and index_chunks rather than having a separate function; the pointer is not bounds checked
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_saved_this, 0x4  # [ebp - 0x4]
.equ arg_ptr, 0x8  # [ebp + 0x8]

.equ sig_byte_1, 0x1  # arg_ptr+1: second signature byte, compared with 0x41
.equ sig_byte_2, 0x2  # arg_ptr+2: third signature byte, compared with 0x54
.equ sig_byte_3, 0x3  # arg_ptr+3: fourth signature byte, compared with 0x41

# --- external targets -----------------------------------------------

.org 0x00434773 - 0x401000
.globl FUN_00434773
FUN_00434773:
    # block 0x00434773: function entry: build frame, spill this, test the first byte at arg_ptr (movsx) against 0x44 ('D'); mismatch goes to L_not_data
    push ebp                                     # 00434773
    {load} mov ebp, esp                          # 00434774
    push ecx                                     # 00434776
    mov dword ptr [ebp - local_saved_this], ecx           # 00434777
    mov eax, dword ptr [ebp + arg_ptr]             # 0043477a
    movsx ecx, byte ptr [eax]                    # 0043477d
    cmp ecx, 0x44                                # 00434780
    jne.d8 L_not_data                            # 00434783
    # block 0x00434785: second byte against 0x41 ('A'); mismatch goes to L_not_data
    mov edx, dword ptr [ebp + arg_ptr]             # 00434785
    movsx eax, byte ptr [edx + sig_byte_1]              # 00434788
    cmp eax, 0x41                                # 0043478c
    jne.d8 L_not_data                            # 0043478f
    # block 0x00434791: third byte against 0x54 ('T'); mismatch goes to L_not_data
    mov ecx, dword ptr [ebp + arg_ptr]             # 00434791
    movsx edx, byte ptr [ecx + sig_byte_2]              # 00434794
    cmp edx, 0x54                                # 00434798
    jne.d8 L_not_data                            # 0043479b
    # block 0x0043479d: fourth byte against 0x41 ('A'); equal goes to L_is_data, otherwise falls into L_not_data
    mov eax, dword ptr [ebp + arg_ptr]             # 0043479d
    movsx ecx, byte ptr [eax + sig_byte_3]              # 004347a0
    cmp ecx, 0x41                                # 004347a4
    je.d8 L_is_data                             # 004347a7
L_not_data:
    # block 0x004347a9: L_not_data: eax = 0, jump to L_return
    {load} xor eax, eax                          # 004347a9
    jmp.d8 L_return                            # 004347ab
L_is_data:
    # block 0x004347ad: L_is_data: eax = 1
    mov eax, 0x1                                 # 004347ad
L_return:
    # block 0x004347b2: L_return: tear down the frame, ret 4
    {load} mov esp, ebp                          # 004347b2
    pop ebp                                      # 004347b4
    ret 0x4                                      # 004347b5
