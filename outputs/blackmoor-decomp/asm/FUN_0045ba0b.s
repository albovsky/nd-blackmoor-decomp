# FUN_0045ba0b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045ba0b
# extent:       0x0045ba0b-0x0045bbd8 (461 code bytes)
# span:         0x0045ba0b-0x0045bbd8 (code 461, tables 0, padding 0)
# sha256:       bda1fb6e9941f00ef4c139013cff48b674f6f19034c345b3b7dc570a2453d506
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# name:         Puzzle::copy_template_records_into_state
# arguments:    thiscall: ecx=this; no stack arguments; plain ret; no return value (eax is left as 0 by the last block)
# locals:       this_ptr = this spilled from ecx; tmpl_ptr = template pointer loaded from the dword table at 0x005bb5e5 (stride 0x8d) indexed by the signed word this+0x1e; copy_idx = word loop counter 0..3 (signed word compare with 4, used by both copy loops)
# fields:       this+0x1e: signed word template index; this+0x28..0x34: cleared at the end (three dwords at +0x28,+0x2c,+0x30 and a word at +0x34); this+0x36: four 16-byte records (copy A); this+0x76: four 16-byte records (copy B, same source as A); this+0xba: word cleared; this+0xbc and this+0xcc: one 16-byte record each; this+0xec and this+0xfc: one 16-byte record each; this+0x178 and this+0x17a: signed words taken from template+0x29 and template+0x2b; template+0x29, +0x2b: words; template+0xad: array of 16-byte records indexed by (word-1); template+0x36d: array of 32-byte entries whose first 16 bytes are copied (four entries); template+0x3ed and +0x3fd: 16-byte records; absolute global 0x005bb5e5: table of template pointers, stride 0x8d, indexed by this+0x1e
# callees:      none
# track-n:      host-adapter: none
# unverified:   What the object is (puzzle, with the template table at 0x5bb5e5) is only a label: the caller in the pseudocode, FUN_0045c18f, sets this+0x1e to its argument just before calling this routine and uses the identifiers BUL_PUZZLE_OVERLAYS and Bul_Puzzle_Surface, and I did not re-verify that caller from the bytes. The meanings of every copied record (what the four 16-byte entries at +0x36 and +0x76 are, why both get the same source) are not established; the names are offsets only. The 16-byte copies are done as four dword moves, so their field meaning (rectangle, four numbers, ...) is not known. The counts at +0x178/+0x17a are used as one-based indexes (minus one before the shift by four) without any range check against the template, and the template index at +0x1e is not range checked either; no guard was found in this routine. The template pointer may be zero if the table entry is unset, which would fault; I did not check the callers' guarantee. The method and class names are my labels, not recovered identifiers.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ tmpl_ptr, 0x4  # template pointer = dword at 0x005bb5e5 + [this+0x1e]*0x8d
.equ copy_idx, 0x8  # word loop counter 0..3 for the two copy loops
.equ this_ptr, 0xc  # this, spilled from ecx
.equ rec_dword1, 0x4  # 16-byte record, second dword (+0x04); used on both the template source and the state destination
.equ rec_dword2, 0x8  # 16-byte record, third dword (+0x08); used on both source and destination
.equ rec_dword3, 0xc  # 16-byte record, fourth dword (+0x0c); used on both source and destination
.equ this_tmpl_index, 0x1e  # this+0x1e: signed word template index
.equ tmpl_word_29, 0x29  # template+0x29: word copied to this+0x178
.equ tmpl_word_2b, 0x2b  # template+0x2b: word copied to this+0x17a
.equ this_copy_a, 0x36  # this+0x36: four 16-byte records, copy A
.equ this_copy_b, 0x76  # this+0x76: four 16-byte records, copy B
.equ tmpl_records_ad, 0xad  # template+0xad: array of 16-byte records indexed by (count-1)
.equ this_word_ba, 0xba  # this+0xba: word cleared to 0
.equ this_count_178, 0x178  # this+0x178: signed word copied from template+0x29; one-based index into template+0xad
.equ this_count_17a, 0x17a  # this+0x17a: signed word copied from template+0x2b; one-based index into template+0xad
.equ tmpl_entries_36d, 0x36d  # template+0x36d: four 32-byte entries, first 16 bytes of each copied
.equ blk28_dword1, 0x4  # this+0x28 block, second dword (this+0x2c), cleared at the end
.equ blk28_dword2, 0x8  # this+0x28 block, third dword (this+0x30), cleared at the end
.equ blk28_word3, 0xc  # this+0x28 block, word at +0x0c (this+0x34), cleared at the end

# --- external targets -----------------------------------------------

.org 0x0045ba0b - 0x401000
.globl FUN_0045ba0b
FUN_0045ba0b:
    # block 0x0045ba0b: entry: spill this; tmpl_ptr = dword at 0x005bb5e5 + (signed word this+0x1e)*0x8d; copy_idx = 0; jump to copy A test
    push ebp                                     # 0045ba0b
    {load} mov ebp, esp                          # 0045ba0c
    sub esp, 0xc                                 # 0045ba0e
    mov dword ptr [ebp - this_ptr], ecx           # 0045ba11
    mov eax, dword ptr [ebp - this_ptr]           # 0045ba14
    movsx ecx, word ptr [eax + this_tmpl_index]         # 0045ba17
    imul ecx, ecx, 0x8d                          # 0045ba1b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045ba21
    mov dword ptr [ebp - tmpl_ptr], edx           # 0045ba27
    mov word ptr [ebp - copy_idx], 0x0            # 0045ba2a
    jmp.d8 copy_a_test                            # 0045ba30
copy_a_next:
    # block 0x0045ba32: copy_a_next: copy_idx = copy_idx + 1 (16-bit add)
    mov ax, word ptr [ebp - copy_idx]             # 0045ba32
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045ba36
    mov word ptr [ebp - copy_idx], ax             # 0045ba3a
copy_a_test:
    # block 0x0045ba3e: copy_a_test: if (signed word) copy_idx >= 4 go to copy_b_start
    movsx ecx, word ptr [ebp - copy_idx]          # 0045ba3e
    cmp ecx, 0x4                                 # 0045ba42
    jge.d8 copy_b_start                            # 0045ba45
    # block 0x0045ba47: copy A body: copy the 16 bytes (four dwords) at tmpl+0x36d+copy_idx*0x20 to this+0x36+copy_idx*0x10, then loop
    movsx edx, word ptr [ebp - copy_idx]          # 0045ba47
    shl edx, 0x5                                 # 0045ba4b
    mov eax, dword ptr [ebp - tmpl_ptr]           # 0045ba4e
    lea ecx, [eax + edx + tmpl_entries_36d]             # 0045ba51
    movsx edx, word ptr [ebp - copy_idx]          # 0045ba58
    shl edx, 0x4                                 # 0045ba5c
    mov eax, dword ptr [ebp - this_ptr]           # 0045ba5f
    lea edx, [eax + edx + this_copy_a]              # 0045ba62
    mov eax, dword ptr [ecx]                     # 0045ba66
    mov dword ptr [edx], eax                     # 0045ba68
    mov eax, dword ptr [ecx + rec_dword1]           # 0045ba6a
    mov dword ptr [edx + rec_dword1], eax           # 0045ba6d
    mov eax, dword ptr [ecx + rec_dword2]           # 0045ba70
    mov dword ptr [edx + rec_dword2], eax           # 0045ba73
    mov ecx, dword ptr [ecx + rec_dword3]           # 0045ba76
    mov dword ptr [edx + rec_dword3], ecx           # 0045ba79
    jmp.d8 copy_a_next                            # 0045ba7c
copy_b_start:
    # block 0x0045ba7e: copy_b_start: copy_idx = 0; jump to copy B test
    mov word ptr [ebp - copy_idx], 0x0            # 0045ba7e
    jmp.d8 copy_b_test                            # 0045ba84
copy_b_next:
    # block 0x0045ba86: copy_b_next: copy_idx = copy_idx + 1 (16-bit add)
    mov dx, word ptr [ebp - copy_idx]             # 0045ba86
    add dx, 0x1                                  # 0045ba8a
    mov word ptr [ebp - copy_idx], dx             # 0045ba8e
copy_b_test:
    # block 0x0045ba92: copy_b_test: if (signed word) copy_idx >= 4 go to copy_singles
    movsx eax, word ptr [ebp - copy_idx]          # 0045ba92
    cmp eax, 0x4                                 # 0045ba96
    jge.d8 copy_singles                            # 0045ba99
    # block 0x0045ba9b: copy B body: copy the same 16 bytes at tmpl+0x36d+copy_idx*0x20 to this+0x76+copy_idx*0x10, then loop
    movsx ecx, word ptr [ebp - copy_idx]          # 0045ba9b
    shl ecx, 0x5                                 # 0045ba9f
    mov edx, dword ptr [ebp - tmpl_ptr]           # 0045baa2
    lea eax, [edx + ecx + tmpl_entries_36d]             # 0045baa5
    movsx ecx, word ptr [ebp - copy_idx]          # 0045baac
    shl ecx, 0x4                                 # 0045bab0
    mov edx, dword ptr [ebp - this_ptr]           # 0045bab3
    lea ecx, [edx + ecx + this_copy_b]              # 0045bab6
    mov edx, dword ptr [eax]                     # 0045baba
    mov dword ptr [ecx], edx                     # 0045babc
    mov edx, dword ptr [eax + rec_dword1]           # 0045babe
    mov dword ptr [ecx + rec_dword1], edx           # 0045bac1
    mov edx, dword ptr [eax + rec_dword2]           # 0045bac4
    mov dword ptr [ecx + rec_dword2], edx           # 0045bac7
    mov eax, dword ptr [eax + rec_dword3]           # 0045baca
    mov dword ptr [ecx + rec_dword3], eax           # 0045bacd
    jmp.d8 copy_b_next                            # 0045bad0
copy_singles:
    # block 0x0045bad2: copy_singles: this+0x178 = word at tmpl+0x29, this+0x17a = word at tmpl+0x2b, this+0xba = 0; copy the record at tmpl+0xad+(this+0x178 - 1)*16 to this+0xbc and the record at tmpl+0xad+(this+0x17a - 1)*16 to this+0xcc; copy 16 bytes at tmpl+0x3ed to this+0xec and 16 bytes at tmpl+0x3fd to this+0xfc; clear this+0x28 (dword), this+0x2c (dword), this+0x30 (dword), this+0x34 (word); return
    mov ecx, dword ptr [ebp - this_ptr]           # 0045bad2
    mov edx, dword ptr [ebp - tmpl_ptr]           # 0045bad5
    mov ax, word ptr [edx + tmpl_word_29]            # 0045bad8
    mov word ptr [ecx + this_count_178], ax           # 0045badc
    mov ecx, dword ptr [ebp - this_ptr]           # 0045bae3
    mov edx, dword ptr [ebp - tmpl_ptr]           # 0045bae6
    mov ax, word ptr [edx + tmpl_word_2b]            # 0045bae9
    mov word ptr [ecx + this_count_17a], ax           # 0045baed
    mov ecx, dword ptr [ebp - this_ptr]           # 0045baf4
    mov word ptr [ecx + this_word_ba], 0x0           # 0045baf7
    mov edx, dword ptr [ebp - this_ptr]           # 0045bb00
    movsx eax, word ptr [edx + this_count_178]        # 0045bb03
    sub eax, 0x1                                 # 0045bb0a
    shl eax, 0x4                                 # 0045bb0d
    mov ecx, dword ptr [ebp - tmpl_ptr]           # 0045bb10
    lea edx, [ecx + eax + tmpl_records_ad]              # 0045bb13
    mov eax, dword ptr [ebp - this_ptr]           # 0045bb1a
    add eax, 0xbc                                # 0045bb1d
    mov ecx, dword ptr [edx]                     # 0045bb22
    mov dword ptr [eax], ecx                     # 0045bb24
    mov ecx, dword ptr [edx + rec_dword1]           # 0045bb26
    mov dword ptr [eax + rec_dword1], ecx           # 0045bb29
    mov ecx, dword ptr [edx + rec_dword2]           # 0045bb2c
    mov dword ptr [eax + rec_dword2], ecx           # 0045bb2f
    mov edx, dword ptr [edx + rec_dword3]           # 0045bb32
    mov dword ptr [eax + rec_dword3], edx           # 0045bb35
    mov eax, dword ptr [ebp - this_ptr]           # 0045bb38
    movsx ecx, word ptr [eax + this_count_17a]        # 0045bb3b
    sub ecx, 0x1                                 # 0045bb42
    shl ecx, 0x4                                 # 0045bb45
    mov edx, dword ptr [ebp - tmpl_ptr]           # 0045bb48
    lea eax, [edx + ecx + tmpl_records_ad]              # 0045bb4b
    mov ecx, dword ptr [ebp - this_ptr]           # 0045bb52
    add ecx, 0xcc                                # 0045bb55
    mov edx, dword ptr [eax]                     # 0045bb5b
    mov dword ptr [ecx], edx                     # 0045bb5d
    mov edx, dword ptr [eax + rec_dword1]           # 0045bb5f
    mov dword ptr [ecx + rec_dword1], edx           # 0045bb62
    mov edx, dword ptr [eax + rec_dword2]           # 0045bb65
    mov dword ptr [ecx + rec_dword2], edx           # 0045bb68
    mov eax, dword ptr [eax + rec_dword3]           # 0045bb6b
    mov dword ptr [ecx + rec_dword3], eax           # 0045bb6e
    mov ecx, dword ptr [ebp - tmpl_ptr]           # 0045bb71
    add ecx, 0x3ed                               # 0045bb74
    mov edx, dword ptr [ebp - this_ptr]           # 0045bb7a
    add edx, 0xec                                # 0045bb7d
    mov eax, dword ptr [ecx]                     # 0045bb83
    mov dword ptr [edx], eax                     # 0045bb85
    mov eax, dword ptr [ecx + rec_dword1]           # 0045bb87
    mov dword ptr [edx + rec_dword1], eax           # 0045bb8a
    mov eax, dword ptr [ecx + rec_dword2]           # 0045bb8d
    mov dword ptr [edx + rec_dword2], eax           # 0045bb90
    mov ecx, dword ptr [ecx + rec_dword3]           # 0045bb93
    mov dword ptr [edx + rec_dword3], ecx           # 0045bb96
    mov edx, dword ptr [ebp - tmpl_ptr]           # 0045bb99
    add edx, 0x3fd                               # 0045bb9c
    mov eax, dword ptr [ebp - this_ptr]           # 0045bba2
    add eax, 0xfc                                # 0045bba5
    mov ecx, dword ptr [edx]                     # 0045bbaa
    mov dword ptr [eax], ecx                     # 0045bbac
    mov ecx, dword ptr [edx + rec_dword1]           # 0045bbae
    mov dword ptr [eax + rec_dword1], ecx           # 0045bbb1
    mov ecx, dword ptr [edx + rec_dword2]           # 0045bbb4
    mov dword ptr [eax + rec_dword2], ecx           # 0045bbb7
    mov edx, dword ptr [edx + rec_dword3]           # 0045bbba
    mov dword ptr [eax + rec_dword3], edx           # 0045bbbd
    {load} xor eax, eax                          # 0045bbc0
    mov ecx, dword ptr [ebp - this_ptr]           # 0045bbc2
    add ecx, 0x28                                # 0045bbc5
    mov dword ptr [ecx], eax                     # 0045bbc8
    mov dword ptr [ecx + blk28_dword1], eax           # 0045bbca
    mov dword ptr [ecx + blk28_dword2], eax           # 0045bbcd
    mov word ptr [ecx + blk28_word3], ax             # 0045bbd0
    {load} mov esp, ebp                          # 0045bbd4
    pop ebp                                      # 0045bbd6
    ret                                          # 0045bbd7
