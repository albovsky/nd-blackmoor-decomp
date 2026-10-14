# FUN_0041a19c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a19c
# extent:       0x0041a19c-0x0041a216 (122 code bytes)
# span:         0x0041a19c-0x0041a216 (code 122, tables 0, padding 0)
# sha256:       67a80d476025b579f23ef3efee6ffd156e77e69629eb16a11efdc197e4a77d19
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# name:         cif_name_hash
# arguments:    thiscall-style: ecx=this (stored to a frame slot, never read again); [ebp+8]=NUL-terminated name string pointer; callee pops 4 (ret 4); result in ax (signed 16-bit bucket index)
# locals:       [ebp-4]=signed 16-bit loop index; [ebp-8]=signed 16-bit result copy; [ebp-0xc]=signed 16-bit running character sum; [ebp-0x10]=saved ecx (this, unused); edi saved/restored around the inline strlen
# fields:       none (no fields touched; this in ecx is only spilled)
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/cif_archive.c:name_hash
# unverified:   upper 16 bits of eax on return come from the movsx of the 16-bit strlen and are not part of the bucket value (callers use ax); the stored ecx/this is never consumed so its meaning is not verified; behaviour for names whose strlen exceeds 32767 (16-bit truncation of the length) is not analysed; the unused-this thiscall form is inferred from the spill only
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_index, 0x4  # [ebp - 0x4]
.equ local_result, 0x8  # [ebp - 0x8]
.equ local_sum, 0xc  # [ebp - 0xc]
.equ local_saved_this, 0x10  # [ebp - 0x10]
.equ arg_name, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x0041a19c - 0x401000
.globl FUN_0041a19c
FUN_0041a19c:
    # block 0x0041a19c: function entry: build frame, spill ecx to local_saved_this, zero local_sum and local_index (16-bit), jump to loop test
    push ebp                                     # 0041a19c
    {load} mov ebp, esp                          # 0041a19d
    sub esp, 0x10                                # 0041a19f
    push edi                                     # 0041a1a2
    mov dword ptr [ebp - local_saved_this], ecx          # 0041a1a3
    mov word ptr [ebp - local_sum], 0x0            # 0041a1a6
    mov word ptr [ebp - local_index], 0x0            # 0041a1ac
    jmp.d8 L_loop_test                            # 0041a1b2
L_next_char:
    # block 0x0041a1b4: L_next_char: increment the 16-bit loop index by one
    mov ax, word ptr [ebp - local_index]             # 0041a1b4
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041a1b8
    mov word ptr [ebp - local_index], ax             # 0041a1bc
L_loop_test:
    # block 0x0041a1c0: L_loop_test: inline strlen of arg_name via repne scasb (16-bit truncated length, sign-extended); compare signed index against length, exit to L_mod_1024 when index >= length
    movsx edx, word ptr [ebp - local_index]          # 0041a1c0
    mov edi, dword ptr [ebp + arg_name]             # 0041a1c4
    or ecx, -0x1                                 # 0041a1c7
    {load} xor eax, eax                          # 0041a1ca
    repne scasb al, byte ptr es:[edi]            # 0041a1cc
    not ecx                                      # 0041a1ce
    add ecx, -0x1                                # 0041a1d0
    movsx eax, cx                                # 0041a1d3
    {load} cmp edx, eax                          # 0041a1d6
    jge.d8 L_mod_1024                            # 0041a1d8
    # block 0x0041a1da: loop body: sign-extend byte arg_name[index] to 16 bits (movsx ax, byte) and add it into the 16-bit local_sum, then loop back to L_next_char
    movsx ecx, word ptr [ebp - local_index]          # 0041a1da
    mov edx, dword ptr [ebp + arg_name]             # 0041a1de
    movsx ax, byte ptr [edx + ecx]               # 0041a1e1
    mov cx, word ptr [ebp - local_sum]             # 0041a1e6
    {load} add cx, ax                            # 0041a1ea
    mov word ptr [ebp - local_sum], cx             # 0041a1ed
    jmp.d8 L_next_char                            # 0041a1f1
L_mod_1024:
    # block 0x0041a1f3: L_mod_1024: sign-extend local_sum, mask with 0x800003ff (low 10 bits plus sign), branch to L_store_result when non-negative
    movsx edx, word ptr [ebp - local_sum]          # 0041a1f3
    and edx, 0x800003ff                          # 0041a1f7
    jns.d8 L_store_result                            # 0041a1fd
    # block 0x0041a1ff: negative sum: dec, or 0xfffffc00, inc, the C signed remainder by 1024 sequence yielding a value in -1023..0
    dec edx                                      # 0041a1ff
    or edx, 0xfffffc00                           # 0041a200
    inc edx                                      # 0041a206
L_store_result:
    # block 0x0041a207: L_store_result: store low 16 bits as result, return it in ax, restore edi and frame, ret 4
    mov word ptr [ebp - local_result], dx             # 0041a207
    mov ax, word ptr [ebp - local_result]             # 0041a20b
    pop edi                                      # 0041a20f
    {load} mov esp, ebp                          # 0041a210
    pop ebp                                      # 0041a212
    ret 0x4                                      # 0041a213
