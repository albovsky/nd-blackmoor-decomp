# FUN_00420737
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00420737
# extent:       0x00420737-0x004209e8 (689 code bytes)
# span:         0x00420737-0x004209e8 (code 689, tables 0, padding 0)
# sha256:       c7e6effcb4220a2b50265636f2c37f7c05d99e857e40b5995cfaca88f63cf77b
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# name:         ConditionRecords::all_groups_satisfied
# arguments:    thiscall: ecx=this (only spilled to local_this, never read again; the caller 0x4205c1 passes its own this, 0x420a64 and 0x4225d7 not inspected); [ebp+8]=arg_records pointer to an array of 5-byte records; [ebp+0xc]=arg_count int16 number of records; [ebp+0x10]=arg_flags pointer to a byte buffer of at least arg_count bytes that receives one 0/1 flag per record; callee pops 0xc (ret 0xc); returns ax=1 when every flag ends up set (also when arg_count is 0) else ax=0 (only ax is written, the upper half of eax is not set; callers use movsx eax, ax); ebx is saved and restored
# locals:       frame 0xc bytes plus saved ebx: local_index [ebp-4] = int16 record index used by every loop (16-bit increments); local_changed [ebp-8] = int16 flag, 1 when the last propagation pass set at least one flag; local_this [ebp-0xc] = this spilled from ecx
# fields:       record (5 bytes, base arg_records + 5*i): record+0 byte kind (1 or 2), record+1 int16 index (sign-extended), record+3 byte expected value, record+4 byte link (1 means joined with the next record); flags buffer arg_flags: byte i written 0 then 1; globals: 0x00585801 (dword table indexed by int16 record index times 4, read for kind 1; the event flag table of world-init-recovery.md), 0x00583bd5 (dword table indexed by int16 record index times 4, read for kind 2; the inventory presence table of world-init-recovery.md); no object fields of this are touched
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N function corresponds: scene-conditions-recovery.md covers the nested dependency tree whose leaf evaluator is 0x424346 with opcode 1 = inventory (0x583bd5) and opcode 2 = event flags (0x585801), the opposite numbering of the record kinds here (kind 1 reads 0x585801, kind 2 reads 0x583bd5), so this routine works on a different record format and must not be merged with those opcodes. The name ConditionRecords::all_groups_satisfied and the field names are my labels. The meaning of the link byte (records chained by link==1 behave as one OR group: any satisfied member sets every flag of the chain) is what the propagation loop does by its control flow, not a confirmed game rule. The only caller examined is 0x4205c1 (pseudocode and call bytes): it passes the dword at entry+2 as arg_records, the int16 at entry+0 as arg_count and this+0x78e as arg_flags for entries of stride 0x1d1; the other two callers (0x420a64 in 0x4209e8, 0x4225d7 in 0x420c17) were not read. Unsafe original behaviour: record index is sign-extended int16 used as a dword table index with no bound check (negative or large values read outside 0x585801 or 0x583bd5), arg_flags capacity is not checked, and a negative arg_count skips every loop and returns 1; a native port must reject these explicitly. Terminates because flags are only ever set from 0 to 1. The compare is the full table dword against the zero-extended byte rec_value.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ flag_prev_delta, 0x1  # flags buffer + i - 1 (written as a minus): flag of the previous record
.equ local_index, 0x4  # [ebp - 0x4]: int16 record index of the current loop
.equ local_changed, 0x8  # [ebp - 0x8]: int16 flag, 1 when a propagation pass set a flag
.equ local_this, 0xc  # [ebp - 0xc]: this, spilled from ecx and never read again
.equ rec_index_id, 0x1  # record+1: int16 table index of the record (sign-extended)
.equ flag_next_delta, 0x1  # flags buffer + i + 1: flag of the next record
.equ rec_value, 0x3  # record+3: byte expected value, compared with the zero-extended table dword
.equ rec_link, 0x4  # record+4: byte, 1 means this record is joined to the next one
.equ arg_records, 0x8  # [ebp + 0x8]: pointer to the 5-byte records
.equ arg_count, 0xc  # [ebp + 0xc]: int16 number of records
.equ arg_flags, 0x10  # [ebp + 0x10]: pointer to the per-record result byte buffer

# --- external targets -----------------------------------------------

.org 0x00420737 - 0x401000
.globl FUN_00420737
FUN_00420737:
    # block 0x00420737: entry: save ebx, spill this; sign-extend int16 arg_count; if it is not zero go to L_clear_init (jne), else fall into the empty case
    push ebp                                     # 00420737
    {load} mov ebp, esp                          # 00420738
    sub esp, 0xc                                 # 0042073a
    push ebx                                     # 0042073d
    mov dword ptr [ebp - local_this], ecx           # 0042073e
    movsx eax, word ptr [ebp + arg_count]            # 00420741
    test eax, eax                                # 00420745
    jne.d8 L_clear_init                            # 00420747
    # block 0x00420749: arg_count == 0: ax = 1 (16-bit move) and jump to L_return
    mov ax, 0x1                                  # 00420749
    jmp.d32 L_return                           # 0042074d
L_clear_init:
    # block 0x00420752: clear loop start (L_clear_init): local_index = 0, jump to the test
    mov word ptr [ebp - local_index], 0x0            # 00420752
    jmp.d8 L_clear_test                            # 00420758
L_clear_step:
    # block 0x0042075a: clear loop step (L_clear_step): local_index = local_index + 1 as a 16-bit add
    mov cx, word ptr [ebp - local_index]             # 0042075a
    add cx, 0x1                                  # 0042075e
    mov word ptr [ebp - local_index], cx             # 00420762
L_clear_test:
    # block 0x00420766: clear loop test: if signed local_index >= signed arg_count go to L_seed_init (jge)
    movsx edx, word ptr [ebp - local_index]          # 00420766
    movsx eax, word ptr [ebp + arg_count]            # 0042076a
    {load} cmp edx, eax                          # 0042076e
    jge.d8 L_seed_init                            # 00420770
    # block 0x00420772: clear body: arg_flags[local_index] = 0, jump to the step
    movsx ecx, word ptr [ebp - local_index]          # 00420772
    mov edx, dword ptr [ebp + arg_flags]            # 00420776
    mov byte ptr [edx + ecx], 0x0                # 00420779
    jmp.d8 L_clear_step                            # 0042077d
L_seed_init:
    # block 0x0042077f: seed loop start (L_seed_init): local_index = 0, jump to the test
    mov word ptr [ebp - local_index], 0x0            # 0042077f
    jmp.d8 L_seed_test                            # 00420785
L_seed_step:
    # block 0x00420787: seed loop step: local_index = local_index + 1 as a 16-bit add (assembled with .insn 66 05 imm16)
    mov ax, word ptr [ebp - local_index]             # 00420787
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042078b
    mov word ptr [ebp - local_index], ax             # 0042078f
L_seed_test:
    # block 0x00420793: seed loop test: if signed local_index >= signed arg_count go to L_pass_start (jge)
    movsx ecx, word ptr [ebp - local_index]          # 00420793
    movsx edx, word ptr [ebp + arg_count]            # 00420797
    {load} cmp ecx, edx                          # 0042079b
    jge.d32 L_pass_start                           # 0042079d
    # block 0x004207a3: record kind check: zero-extend byte at arg_records + 5*local_index; if it is not 1 go to L_seed_kind2 (jne)
    movsx eax, word ptr [ebp - local_index]          # 004207a3
    imul eax, eax, 0x5                           # 004207a7
    mov ecx, dword ptr [ebp + arg_records]             # 004207aa
    {load} xor edx, edx                          # 004207ad
    mov dl, byte ptr [ecx + eax]                 # 004207af
    cmp edx, 0x1                                 # 004207b2
    jne.d8 L_seed_kind2                            # 004207b5
    # block 0x004207b7: kind 1: compare dword [0x585801 + 4*int16 rec_index_id] with zero-extended byte rec_value; equal goes to L_seed_set (je), else fall through to the kind 2 check
    movsx eax, word ptr [ebp - local_index]          # 004207b7
    imul eax, eax, 0x5                           # 004207bb
    mov ecx, dword ptr [ebp + arg_records]             # 004207be
    movsx edx, word ptr [ecx + eax + rec_index_id]    # 004207c1
    movsx eax, word ptr [ebp - local_index]          # 004207c6
    imul eax, eax, 0x5                           # 004207ca
    mov ecx, dword ptr [ebp + arg_records]             # 004207cd
    {load} xor ebx, ebx                          # 004207d0
    mov bl, byte ptr [ecx + eax + rec_value]       # 004207d2
    cmp dword ptr [4*edx + 0x585801], ebx        # 004207d6
    je.d8 L_seed_set                             # 004207dd
L_seed_kind2:
    # block 0x004207df: kind 2 check (L_seed_kind2): if byte kind of the record is not 2 go to L_seed_next (jne)
    movsx edx, word ptr [ebp - local_index]          # 004207df
    imul edx, edx, 0x5                           # 004207e3
    mov eax, dword ptr [ebp + arg_records]             # 004207e6
    {load} xor ecx, ecx                          # 004207e9
    mov cl, byte ptr [eax + edx]                 # 004207eb
    cmp ecx, 0x2                                 # 004207ee
    jne.d8 L_seed_next                            # 004207f1
    # block 0x004207f3: kind 2: compare dword [0x583bd5 + 4*int16 rec_index_id] with zero-extended byte rec_value; not equal goes to L_seed_next (jne), equal falls into L_seed_set
    movsx edx, word ptr [ebp - local_index]          # 004207f3
    imul edx, edx, 0x5                           # 004207f7
    mov eax, dword ptr [ebp + arg_records]             # 004207fa
    movsx ecx, word ptr [eax + edx + rec_index_id]    # 004207fd
    movsx edx, word ptr [ebp - local_index]          # 00420802
    imul edx, edx, 0x5                           # 00420806
    mov eax, dword ptr [ebp + arg_records]             # 00420809
    {load} xor ebx, ebx                          # 0042080c
    mov bl, byte ptr [eax + edx + rec_value]       # 0042080e
    cmp dword ptr [4*ecx + 0x583bd5], ebx        # 00420812
    jne.d8 L_seed_next                            # 00420819
L_seed_set:
    # block 0x0042081b: seed hit (L_seed_set): arg_flags[local_index] = 1
    movsx ecx, word ptr [ebp - local_index]          # 0042081b
    mov edx, dword ptr [ebp + arg_flags]            # 0042081f
    mov byte ptr [edx + ecx], 0x1                # 00420822
L_seed_next:
    # block 0x00420826: seed next (L_seed_next): jump to the seed step
    jmp.d32 L_seed_step                           # 00420826
L_pass_start:
    # block 0x0042082b: propagation pass start (L_pass_start): local_changed = 0, local_index = 0, jump to the test
    mov word ptr [ebp - local_changed], 0x0            # 0042082b
    mov word ptr [ebp - local_index], 0x0            # 00420831
    jmp.d8 L_pass_test                            # 00420837
L_pass_step:
    # block 0x00420839: propagation step (L_pass_step): local_index = local_index + 1 as a 16-bit add (.insn 66 05 imm16)
    mov ax, word ptr [ebp - local_index]             # 00420839
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042083d
    mov word ptr [ebp - local_index], ax             # 00420841
L_pass_test:
    # block 0x00420845: propagation test: if signed local_index >= signed arg_count go to L_pass_end (jge)
    movsx ecx, word ptr [ebp - local_index]          # 00420845
    movsx edx, word ptr [ebp + arg_count]            # 00420849
    {load} cmp ecx, edx                          # 0042084d
    jge.d32 L_pass_end                           # 0042084f
    # block 0x00420855: link check: if byte rec_link of record i is not 1 go to L_unlinked (jne)
    movsx eax, word ptr [ebp - local_index]          # 00420855
    imul eax, eax, 0x5                           # 00420859
    mov ecx, dword ptr [ebp + arg_records]             # 0042085c
    {load} xor edx, edx                          # 0042085f
    mov dl, byte ptr [ecx + eax + rec_link]       # 00420861
    cmp edx, 0x1                                 # 00420865
    jne.d32 L_unlinked                           # 00420868
    # block 0x0042086e: record i is linked to i+1: if arg_flags[i] is zero skip the forward step (je L_linked_backward)
    movsx eax, word ptr [ebp - local_index]          # 0042086e
    mov ecx, dword ptr [ebp + arg_flags]            # 00420872
    {load} xor edx, edx                          # 00420875
    mov dl, byte ptr [ecx + eax]                 # 00420877
    test edx, edx                                # 0042087a
    je.d8 L_linked_backward                             # 0042087c
    # block 0x0042087e: forward step condition 2: if i + 1 >= arg_count (signed) skip it (jge L_linked_backward)
    movsx eax, word ptr [ebp - local_index]          # 0042087e
    add eax, 0x1                                 # 00420882
    movsx ecx, word ptr [ebp + arg_count]            # 00420885
    {load} cmp eax, ecx                          # 00420889
    jge.d8 L_linked_backward                            # 0042088b
    # block 0x0042088d: forward step condition 3: if arg_flags[i + 1] (flag_next_delta) is already set skip it (jne L_linked_backward)
    movsx edx, word ptr [ebp - local_index]          # 0042088d
    mov eax, dword ptr [ebp + arg_flags]            # 00420891
    {load} xor ecx, ecx                          # 00420894
    mov cl, byte ptr [eax + edx + flag_next_delta]       # 00420896
    test ecx, ecx                                # 0042089a
    jne.d8 L_linked_backward                            # 0042089c
    # block 0x0042089e: forward step: arg_flags[i + 1] = 1 and local_changed = 1
    movsx edx, word ptr [ebp - local_index]          # 0042089e
    mov eax, dword ptr [ebp + arg_flags]            # 004208a2
    mov byte ptr [eax + edx + flag_next_delta], 0x1      # 004208a5
    mov word ptr [ebp - local_changed], 0x1            # 004208aa
L_linked_backward:
    # block 0x004208b0: backward step for a linked record (L_linked_backward): compute i - 1; if it is negative skip to L_linked_done (jl)
    movsx ecx, word ptr [ebp - local_index]          # 004208b0
    sub ecx, 0x1                                 # 004208b4
    test ecx, ecx                                # 004208b7
    jl.d8 L_linked_done                             # 004208b9
    # block 0x004208bb: backward condition 2: if arg_flags[i] is zero skip to L_linked_done (je)
    movsx edx, word ptr [ebp - local_index]          # 004208bb
    mov eax, dword ptr [ebp + arg_flags]            # 004208bf
    {load} xor ecx, ecx                          # 004208c2
    mov cl, byte ptr [eax + edx]                 # 004208c4
    test ecx, ecx                                # 004208c7
    je.d8 L_linked_done                             # 004208c9
    # block 0x004208cb: backward condition 3: if rec_link of record i - 1 is not 1 skip to L_linked_done (jne)
    movsx edx, word ptr [ebp - local_index]          # 004208cb
    sub edx, 0x1                                 # 004208cf
    imul edx, edx, 0x5                           # 004208d2
    mov eax, dword ptr [ebp + arg_records]             # 004208d5
    {load} xor ecx, ecx                          # 004208d8
    mov cl, byte ptr [eax + edx + rec_link]       # 004208da
    cmp ecx, 0x1                                 # 004208de
    jne.d8 L_linked_done                            # 004208e1
    # block 0x004208e3: backward condition 4: if arg_flags[i - 1] (flag_prev_delta) is already set skip to L_linked_done (jne)
    movsx edx, word ptr [ebp - local_index]          # 004208e3
    mov eax, dword ptr [ebp + arg_flags]            # 004208e7
    {load} xor ecx, ecx                          # 004208ea
    mov cl, byte ptr [eax + edx - flag_prev_delta] # 004208ec
    test ecx, ecx                                # 004208f0
    jne.d8 L_linked_done                            # 004208f2
    # block 0x004208f4: backward step: arg_flags[i - 1] = 1 and local_changed = 1
    movsx edx, word ptr [ebp - local_index]          # 004208f4
    mov eax, dword ptr [ebp + arg_flags]            # 004208f8
    mov byte ptr [eax + edx - flag_prev_delta], 0x1 # 004208fb
    mov word ptr [ebp - local_changed], 0x1            # 00420900
L_linked_done:
    # block 0x00420906: linked record done (L_linked_done): jump to L_pass_next
    jmp.d32 L_pass_next                           # 00420906
L_unlinked:
    # block 0x0042090b: record i is not linked forward (L_unlinked): if i - 1 is negative go to L_pass_next (jl)
    movsx ecx, word ptr [ebp - local_index]          # 0042090b
    sub ecx, 0x1                                 # 0042090f
    test ecx, ecx                                # 00420912
    jl.d8 L_pass_next                             # 00420914
    # block 0x00420916: if rec_link of record i - 1 is not 1 go to L_pass_next (jne)
    movsx edx, word ptr [ebp - local_index]          # 00420916
    sub edx, 0x1                                 # 0042091a
    imul edx, edx, 0x5                           # 0042091d
    mov eax, dword ptr [ebp + arg_records]             # 00420920
    {load} xor ecx, ecx                          # 00420923
    mov cl, byte ptr [eax + edx + rec_link]       # 00420925
    cmp ecx, 0x1                                 # 00420929
    jne.d8 L_pass_next                            # 0042092c
    # block 0x0042092e: records i - 1 and i are joined: if arg_flags[i] is zero try the other direction at L_unlinked_second (je)
    movsx edx, word ptr [ebp - local_index]          # 0042092e
    mov eax, dword ptr [ebp + arg_flags]            # 00420932
    {load} xor ecx, ecx                          # 00420935
    mov cl, byte ptr [eax + edx]                 # 00420937
    test ecx, ecx                                # 0042093a
    je.d8 L_unlinked_second                             # 0042093c
    # block 0x0042093e: arg_flags[i] is set: if arg_flags[i - 1] is also set go to L_unlinked_second (jne)
    movsx edx, word ptr [ebp - local_index]          # 0042093e
    mov eax, dword ptr [ebp + arg_flags]            # 00420942
    {load} xor ecx, ecx                          # 00420945
    mov cl, byte ptr [eax + edx - flag_prev_delta] # 00420947
    test ecx, ecx                                # 0042094b
    jne.d8 L_unlinked_second                            # 0042094d
    # block 0x0042094f: copy backward: arg_flags[i - 1] = 1, local_changed = 1, jump to L_pass_next
    movsx edx, word ptr [ebp - local_index]          # 0042094f
    mov eax, dword ptr [ebp + arg_flags]            # 00420953
    mov byte ptr [eax + edx - flag_prev_delta], 0x1 # 00420956
    mov word ptr [ebp - local_changed], 0x1            # 0042095b
    jmp.d8 L_pass_next                            # 00420961
L_unlinked_second:
    # block 0x00420963: second direction (L_unlinked_second): if arg_flags[i - 1] is zero go to L_pass_next (je)
    movsx ecx, word ptr [ebp - local_index]          # 00420963
    mov edx, dword ptr [ebp + arg_flags]            # 00420967
    {load} xor eax, eax                          # 0042096a
    mov al, byte ptr [edx + ecx - flag_prev_delta] # 0042096c
    test eax, eax                                # 00420970
    je.d8 L_pass_next                             # 00420972
    # block 0x00420974: arg_flags[i - 1] is set: if arg_flags[i] is also set go to L_pass_next (jne)
    movsx ecx, word ptr [ebp - local_index]          # 00420974
    mov edx, dword ptr [ebp + arg_flags]            # 00420978
    {load} xor eax, eax                          # 0042097b
    mov al, byte ptr [edx + ecx]                 # 0042097d
    test eax, eax                                # 00420980
    jne.d8 L_pass_next                            # 00420982
    # block 0x00420984: copy forward: arg_flags[i] = 1 and local_changed = 1
    movsx ecx, word ptr [ebp - local_index]          # 00420984
    mov edx, dword ptr [ebp + arg_flags]            # 00420988
    mov byte ptr [edx + ecx], 0x1                # 0042098b
    mov word ptr [ebp - local_changed], 0x1            # 0042098f
L_pass_next:
    # block 0x00420995: pass next (L_pass_next): jump to L_pass_step
    jmp.d32 L_pass_step                           # 00420995
L_pass_end:
    # block 0x0042099a: pass end (L_pass_end): if int16 local_changed is non-zero run another pass at L_pass_start (jne)
    movsx eax, word ptr [ebp - local_changed]          # 0042099a
    test eax, eax                                # 0042099e
    jne.d32 L_pass_start                           # 004209a0
    # block 0x004209a6: final scan start: local_index = 0, jump to the test
    mov word ptr [ebp - local_index], 0x0            # 004209a6
    jmp.d8 L_final_test                            # 004209ac
L_final_step:
    # block 0x004209ae: final scan step (L_final_step): local_index = local_index + 1 as a 16-bit add
    mov cx, word ptr [ebp - local_index]             # 004209ae
    add cx, 0x1                                  # 004209b2
    mov word ptr [ebp - local_index], cx             # 004209b6
L_final_test:
    # block 0x004209ba: final scan test (L_final_test): if signed local_index >= signed arg_count go to L_all_set (jge)
    movsx edx, word ptr [ebp - local_index]          # 004209ba
    movsx eax, word ptr [ebp + arg_count]            # 004209be
    {load} cmp edx, eax                          # 004209c2
    jge.d8 L_all_set                            # 004209c4
    # block 0x004209c6: final scan body: zero-extend arg_flags[local_index]; if it is non-zero continue at L_final_next (jne), else fall through to the failure
    movsx ecx, word ptr [ebp - local_index]          # 004209c6
    mov edx, dword ptr [ebp + arg_flags]            # 004209ca
    {load} xor eax, eax                          # 004209cd
    mov al, byte ptr [edx + ecx]                 # 004209cf
    test eax, eax                                # 004209d2
    jne.d8 L_final_next                            # 004209d4
    # block 0x004209d6: a flag is clear: ax = 0 (xor ax, ax) and jump to L_return
    {load} xor ax, ax                            # 004209d6
    jmp.d8 L_return                            # 004209d9
L_final_next:
    # block 0x004209db: final scan next (L_final_next): jump to the step
    jmp.d8 L_final_step                            # 004209db
L_all_set:
    # block 0x004209dd: every flag is set (L_all_set): ax = 1
    mov ax, 0x1                                  # 004209dd
L_return:
    # block 0x004209e1: epilogue (L_return): restore ebx and the frame, return and pop the three arguments (ret 0xc)
    pop ebx                                      # 004209e1
    {load} mov esp, ebp                          # 004209e2
    pop ebp                                      # 004209e4
    ret 0xc                                      # 004209e5
