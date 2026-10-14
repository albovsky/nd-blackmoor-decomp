# FUN_00434814
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434814
# extent:       0x00434814-0x00434879 (101 code bytes)
# span:         0x00434814-0x00434880 (code 101, tables 0, padding 7)
# sha256:       24d15307938eee361cee2f2c48ae37053efa935dfc2e292fe2cd60e1bbb48acf
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         CHiff::copy_fourcc_static
# arguments:    thiscall: ecx=this (spilled, unused); [ebp+8]=arg_src pointer to a four-byte ID field; callee pops 4 (ret 4); returns eax = 0x0063a590, the address of the static buffer holding the copy
# locals:       [ebp-4]=signed 16-bit loop index; [ebp-8]=saved this
# fields:       0x0063a590: static 5-byte name buffer (global) written with up to four copied bytes followed by a NUL; this is not touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/hiff.c:copy_fourcc
# unverified:   the byte count limit 4 is a signed 16-bit compare (cmp ecx,4 / jge) and a NUL byte at any of the four positions ends the copy early, so the buffer holds a shorter string; whether any caller depends on the stale bytes left beyond the new NUL in the shared static buffer is not analysed; the class name and thiscall form are inferred from callers; the Track N copy_fourcc additionally zero fills the tail, which the original does not
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_index, 0x4  # [ebp - 0x4]
.equ local_saved_this, 0x8  # [ebp - 0x8]
.equ arg_src, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x00434814 - 0x401000
.globl FUN_00434814
FUN_00434814:
    # block 0x00434814: function entry: build frame, spill this, 16-bit index = 0, jump to L_loop_test
    push ebp                                     # 00434814
    {load} mov ebp, esp                          # 00434815
    sub esp, 0x8                                 # 00434817
    mov dword ptr [ebp - local_saved_this], ecx           # 0043481a
    mov word ptr [ebp - local_index], 0x0            # 0043481d
    jmp.d8 L_loop_test                            # 00434823
L_next_byte:
    # block 0x00434825: L_next_byte: increment the 16-bit index
    mov ax, word ptr [ebp - local_index]             # 00434825
    .insn 0x66, 0x05, 0x0001{:u16}               # 00434829
    mov word ptr [ebp - local_index], ax             # 0043482d
L_loop_test:
    # block 0x00434831: L_loop_test: signed compare of the sign-extended index with 4; index >= 4 goes to L_terminate
    movsx ecx, word ptr [ebp - local_index]          # 00434831
    cmp ecx, 0x4                                 # 00434835
    jge.d8 L_terminate                            # 00434838
    # block 0x0043483a: load arg_src[index] (movsx); a zero byte goes to L_stop_at_nul
    movsx edx, word ptr [ebp - local_index]          # 0043483a
    mov eax, dword ptr [ebp + arg_src]             # 0043483e
    movsx ecx, byte ptr [eax + edx]              # 00434841
    test ecx, ecx                                # 00434845
    je.d8 L_stop_at_nul                             # 00434847
    # block 0x00434849: non-zero byte: store it to the static buffer 0x63a590[index], jump to L_loop_back
    movsx edx, word ptr [ebp - local_index]          # 00434849
    movsx eax, word ptr [ebp - local_index]          # 0043484d
    mov ecx, dword ptr [ebp + arg_src]             # 00434851
    mov dl, byte ptr [ecx + edx]                 # 00434854
    mov byte ptr [eax + 0x63a590], dl            # 00434857
    jmp.d8 L_loop_back                            # 0043485d
L_stop_at_nul:
    # block 0x0043485f: L_stop_at_nul: NUL found before four bytes, jump to L_terminate
    jmp.d8 L_terminate                            # 0043485f
L_loop_back:
    # block 0x00434861: L_loop_back: jump to L_next_byte
    jmp.d8 L_next_byte                            # 00434861
L_terminate:
    # block 0x00434863: L_terminate: store 0 at 0x63a590[index], return eax = 0x63a590, tear down the frame, ret 4
    movsx eax, word ptr [ebp - local_index]          # 00434863
    mov byte ptr [eax + 0x63a590], 0x0           # 00434867
    mov eax, 0x63a590                            # 0043486e
    {load} mov esp, ebp                          # 00434873
    pop ebp                                      # 00434875
    ret 0x4                                      # 00434876

# --- data items (not part of the function) -------------------------
.org 0x00434879 - 0x401000
PAD_00434879:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc
