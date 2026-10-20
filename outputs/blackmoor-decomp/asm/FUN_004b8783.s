# FUN_004b8783
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8783
# extent:       0x004b8783-0x004b8a27 (676 code bytes)
# span:         0x004b8783-0x004b8a27 (code 676, tables 0, padding 0)
# sha256:       4e3035a2264fbf65ebc477c25ef1ee7021babcf5a55826d0bf545d7f5e53ceeb
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         first_wave
# naming:       native port src/action_family_f5_runtime.c:first_wave (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with first_wave (count, clear, per-balloon draws, text centring). Shares place_balloon with more_balloons (not credited here). Aggregate oracle.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_23, field_66, field_6b, field_6f, field_7b; [ecx + n] field_8, field_48, field_4a, field_5a, field_5e, field_62, field_6a, field_77, field_7d, field_452, field_454, field_456; [edi + n] field_5a, field_5e; [edx + n] field_4, field_8, field_c, field_21, field_5a, field_62, field_66, field_452, field_456, field_458; [esi + n] field_62, field_66, field_175
# callees:      calls FUN_0050cd50, FUN_004b866e, FUN_004b85f6, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:first_wave (function ledger class native_oracle_verified; also place_balloon; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 201 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_48, 0x48  # offset +0x48
.equ field_4a, 0x4a  # offset +0x4a
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_62, 0x62  # offset +0x62
.equ field_66, 0x66  # offset +0x66
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6b, 0x6b  # offset +0x6b
.equ field_6f, 0x6f  # offset +0x6f
.equ field_77, 0x77  # offset +0x77
.equ field_7b, 0x7b  # offset +0x7b
.equ field_7d, 0x7d  # offset +0x7d
.equ field_175, 0x175  # offset +0x175
.equ field_452, 0x452  # offset +0x452
.equ field_454, 0x454  # offset +0x454
.equ field_456, 0x456  # offset +0x456
.equ field_458, 0x458  # offset +0x458

# --- external targets -----------------------------------------------
.set FUN_004b85f6, .text + (0x004b85f6 - 0x401000)
.set FUN_004b866e, .text + (0x004b866e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004b8783 - 0x401000
.globl FUN_004b8783
FUN_004b8783:
    # block 0x004b8783: entry, 30 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x004b87ee
    push ebp                                     # 004b8783
    {load} mov ebp, esp                          # 004b8784
    sub esp, 0xc                                 # 004b8786
    push esi                                     # 004b8789
    push edi                                     # 004b878a
    mov dword ptr [ebp - local_c], ecx           # 004b878b
    call FUN_0050cd50                            # 004b878e
    mov ecx, dword ptr [ebp - local_c]           # 004b8793
    mov edx, dword ptr [ecx + field_8]           # 004b8796
    movsx ecx, word ptr [edx + field_458]        # 004b8799
    add ecx, 0x1                                 # 004b87a0
    mov edx, dword ptr [ebp - local_c]           # 004b87a3
    mov edx, dword ptr [edx + field_8]           # 004b87a6
    movsx edx, word ptr [edx + field_456]        # 004b87a9
    {load} sub ecx, edx                          # 004b87b0
    cdq                                          # 004b87b2
    idiv ecx                                     # 004b87b3
    mov eax, dword ptr [ebp - local_c]           # 004b87b5
    mov ecx, dword ptr [eax + field_8]           # 004b87b8
    movsx eax, word ptr [ecx + field_456]        # 004b87bb
    {load} add edx, eax                          # 004b87c2
    mov ecx, dword ptr [ebp - local_c]           # 004b87c4
    mov word ptr [ecx + field_48], dx            # 004b87c7
    mov ecx, 0x113                               # 004b87cb
    {load} xor eax, eax                          # 004b87d0
    mov edi, dword ptr [ebp - local_c]           # 004b87d2
    add edi, 0x4a                                # 004b87d5
    rep stosd dword ptr es:[edi], eax            # 004b87d8
    mov word ptr [ebp - local_8], 0x0            # 004b87da
    jmp.d8 L_004b87ee                            # 004b87e0
L_004b87e2:
    # block 0x004b87e2: entered by jmp at 0x004b8a1c, 3 instruction(s), falls into the block at 0x004b87ee
    mov dx, word ptr [ebp - local_8]             # 004b87e2
    add dx, 0x1                                  # 004b87e6
    mov word ptr [ebp - local_8], dx             # 004b87ea
L_004b87ee:
    # block 0x004b87ee: entered by jmp at 0x004b87e0, 5 instruction(s), ends with jge to 0x004b8a21 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b87ee
    mov ecx, dword ptr [ebp - local_c]           # 004b87f2
    movsx edx, word ptr [ecx + field_48]         # 004b87f5
    {load} cmp eax, edx                          # 004b87f9
    jge.d32 L_004b8a21                           # 004b87fb
    # block 0x004b8801: entered by fall-through of jge at 0x004b87fb, 158 instruction(s), calls FUN_004b866e, FUN_0050cd50, FUN_004b85f6, KERNEL32.dll!GetTickCount, ends with backward jump to 0x004b87e2
    mov eax, dword ptr [ebp - local_c]           # 004b8801
    mov esi, dword ptr [eax + field_8]           # 004b8804
    mov ecx, dword ptr [ebp - local_c]           # 004b8807
    call FUN_004b866e                            # 004b880a
    movsx ecx, ax                                # 004b880f
    shl ecx, 0x4                                 # 004b8812
    lea edx, [esi + ecx + field_175]             # 004b8815
    movsx eax, word ptr [ebp - local_8]          # 004b881c
    imul eax, eax, 0x37                          # 004b8820
    mov ecx, dword ptr [ebp - local_c]           # 004b8823
    lea eax, [ecx + eax + field_5a]              # 004b8826
    mov ecx, dword ptr [edx]                     # 004b882a
    mov dword ptr [eax], ecx                     # 004b882c
    mov ecx, dword ptr [edx + field_4]           # 004b882e
    mov dword ptr [eax + field_4], ecx           # 004b8831
    mov ecx, dword ptr [edx + field_8]           # 004b8834
    mov dword ptr [eax + field_8], ecx           # 004b8837
    mov edx, dword ptr [edx + field_c]           # 004b883a
    mov dword ptr [eax + field_c], edx           # 004b883d
    movsx eax, word ptr [ebp - local_8]          # 004b8840
    imul eax, eax, 0x37                          # 004b8844
    mov ecx, dword ptr [ebp - local_c]           # 004b8847
    mov edx, dword ptr [ecx + eax + field_5e]    # 004b884a
    add edx, dword ptr [0x58318a]                # 004b884e
    movsx eax, word ptr [ebp - local_8]          # 004b8854
    imul eax, eax, 0x37                          # 004b8858
    mov ecx, dword ptr [ebp - local_c]           # 004b885b
    mov dword ptr [ecx + eax + field_5e], edx    # 004b885e
    movsx edx, word ptr [ebp - local_8]          # 004b8862
    imul edx, edx, 0x37                          # 004b8866
    mov eax, dword ptr [ebp - local_c]           # 004b8869
    mov ecx, dword ptr [eax + edx + field_66]    # 004b886c
    add ecx, dword ptr [0x58318a]                # 004b8870
    movsx edx, word ptr [ebp - local_8]          # 004b8876
    imul edx, edx, 0x37                          # 004b887a
    mov eax, dword ptr [ebp - local_c]           # 004b887d
    mov dword ptr [eax + edx + field_66], ecx    # 004b8880
    movsx ecx, word ptr [ebp - local_8]          # 004b8884
    imul ecx, ecx, 0x37                          # 004b8888
    mov edx, dword ptr [ebp - local_c]           # 004b888b
    mov eax, dword ptr [edx + ecx + field_5a]    # 004b888e
    add eax, dword ptr [0x583186]                # 004b8892
    movsx ecx, word ptr [ebp - local_8]          # 004b8898
    imul ecx, ecx, 0x37                          # 004b889c
    mov edx, dword ptr [ebp - local_c]           # 004b889f
    mov dword ptr [edx + ecx + field_5a], eax    # 004b88a2
    movsx eax, word ptr [ebp - local_8]          # 004b88a6
    imul eax, eax, 0x37                          # 004b88aa
    mov ecx, dword ptr [ebp - local_c]           # 004b88ad
    mov edx, dword ptr [ecx + eax + field_62]    # 004b88b0
    add edx, dword ptr [0x583186]                # 004b88b4
    movsx eax, word ptr [ebp - local_8]          # 004b88ba
    imul eax, eax, 0x37                          # 004b88be
    mov ecx, dword ptr [ebp - local_c]           # 004b88c1
    mov dword ptr [ecx + eax + field_62], edx    # 004b88c4
    movsx ecx, word ptr [ebp - local_8]          # 004b88c8
    imul ecx, ecx, 0x37                          # 004b88cc
    movsx edx, word ptr [ebp - local_8]          # 004b88cf
    imul edx, edx, 0x37                          # 004b88d3
    movsx eax, word ptr [ebp - local_8]          # 004b88d6
    imul eax, eax, 0x37                          # 004b88da
    mov esi, dword ptr [ebp - local_c]           # 004b88dd
    mov edi, dword ptr [ebp - local_c]           # 004b88e0
    mov edx, dword ptr [esi + edx + field_66]    # 004b88e3
    sub edx, dword ptr [edi + eax + field_5e]    # 004b88e7
    {load} mov eax, edx                          # 004b88eb
    cdq                                          # 004b88ed
    {load} sub eax, edx                          # 004b88ee
    sar eax                                      # 004b88f0
    mov edx, dword ptr [ebp - local_c]           # 004b88f2
    mov ecx, dword ptr [edx + ecx + field_66]    # 004b88f5
    {load} sub ecx, eax                          # 004b88f9
    add ecx, 0x6                                 # 004b88fb
    movsx edx, word ptr [ebp - local_8]          # 004b88fe
    imul edx, edx, 0x37                          # 004b8902
    mov eax, dword ptr [ebp - local_c]           # 004b8905
    mov dword ptr [eax + edx + field_6f], ecx    # 004b8908
    movsx ecx, word ptr [ebp - local_8]          # 004b890c
    imul ecx, ecx, 0x37                          # 004b8910
    movsx edx, word ptr [ebp - local_8]          # 004b8913
    imul edx, edx, 0x37                          # 004b8917
    movsx eax, word ptr [ebp - local_8]          # 004b891a
    imul eax, eax, 0x37                          # 004b891e
    mov esi, dword ptr [ebp - local_c]           # 004b8921
    mov edi, dword ptr [ebp - local_c]           # 004b8924
    mov edx, dword ptr [esi + edx + field_62]    # 004b8927
    sub edx, dword ptr [edi + eax + field_5a]    # 004b892b
    {load} mov eax, edx                          # 004b892f
    cdq                                          # 004b8931
    {load} sub eax, edx                          # 004b8932
    sar eax                                      # 004b8934
    mov edx, dword ptr [ebp - local_c]           # 004b8936
    mov ecx, dword ptr [edx + ecx + field_62]    # 004b8939
    {load} sub ecx, eax                          # 004b893d
    sub ecx, 0x8                                 # 004b893f
    movsx edx, word ptr [ebp - local_8]          # 004b8942
    imul edx, edx, 0x37                          # 004b8946
    mov eax, dword ptr [ebp - local_c]           # 004b8949
    mov dword ptr [eax + edx + field_6b], ecx    # 004b894c
    call FUN_0050cd50                            # 004b8950
    mov ecx, dword ptr [ebp - local_c]           # 004b8955
    mov edx, dword ptr [ecx + field_8]           # 004b8958
    movsx ecx, word ptr [edx + field_21]         # 004b895b
    cdq                                          # 004b895f
    idiv ecx                                     # 004b8960
    mov word ptr [ebp - local_4], dx             # 004b8962
    mov edx, dword ptr [ebp - local_c]           # 004b8966
    mov eax, dword ptr [edx + field_8]           # 004b8969
    movsx ecx, word ptr [ebp - local_4]          # 004b896c
    shl ecx, 0x4                                 # 004b8970
    lea edx, [eax + ecx + field_23]              # 004b8973
    movsx eax, word ptr [ebp - local_8]          # 004b8977
    imul eax, eax, 0x37                          # 004b897b
    mov ecx, dword ptr [ebp - local_c]           # 004b897e
    lea eax, [ecx + eax + field_4a]              # 004b8981
    mov ecx, dword ptr [edx]                     # 004b8985
    mov dword ptr [eax], ecx                     # 004b8987
    mov ecx, dword ptr [edx + field_4]           # 004b8989
    mov dword ptr [eax + field_4], ecx           # 004b898c
    mov ecx, dword ptr [edx + field_8]           # 004b898f
    mov dword ptr [eax + field_8], ecx           # 004b8992
    mov edx, dword ptr [edx + field_c]           # 004b8995
    mov dword ptr [eax + field_c], edx           # 004b8998
    movsx eax, word ptr [ebp - local_8]          # 004b899b
    imul eax, eax, 0x37                          # 004b899f
    mov ecx, dword ptr [ebp - local_c]           # 004b89a2
    mov dword ptr [ecx + eax + field_7d], 0x1    # 004b89a5
    mov ecx, dword ptr [ebp - local_c]           # 004b89ad
    call FUN_004b85f6                            # 004b89b0
    movsx edx, word ptr [ebp - local_8]          # 004b89b5
    imul edx, edx, 0x37                          # 004b89b9
    mov ecx, dword ptr [ebp - local_c]           # 004b89bc
    mov byte ptr [ecx + edx + field_6a], al      # 004b89bf
    call dword ptr [0x52a23c]                    # 004b89c3
    movsx edx, word ptr [ebp - local_8]          # 004b89c9
    imul edx, edx, 0x37                          # 004b89cd
    mov ecx, dword ptr [ebp - local_c]           # 004b89d0
    mov dword ptr [ecx + edx + field_77], eax    # 004b89d3
    call FUN_0050cd50                            # 004b89d7
    mov edx, dword ptr [ebp - local_c]           # 004b89dc
    mov ecx, dword ptr [edx + field_8]           # 004b89df
    movsx ecx, word ptr [ecx + field_454]        # 004b89e2
    add ecx, 0x1                                 # 004b89e9
    mov edx, dword ptr [ebp - local_c]           # 004b89ec
    mov edx, dword ptr [edx + field_8]           # 004b89ef
    movsx edx, word ptr [edx + field_452]        # 004b89f2
    {load} sub ecx, edx                          # 004b89f9
    cdq                                          # 004b89fb
    idiv ecx                                     # 004b89fc
    mov eax, dword ptr [ebp - local_c]           # 004b89fe
    mov ecx, dword ptr [eax + field_8]           # 004b8a01
    movsx eax, word ptr [ecx + field_452]        # 004b8a04
    {load} add edx, eax                          # 004b8a0b
    movsx ecx, word ptr [ebp - local_8]          # 004b8a0d
    imul ecx, ecx, 0x37                          # 004b8a11
    mov eax, dword ptr [ebp - local_c]           # 004b8a14
    mov word ptr [eax + ecx + field_7b], dx      # 004b8a17
    jmp.d32 L_004b87e2                           # 004b8a1c
L_004b8a21:
    # block 0x004b8a21: entered by jge at 0x004b87fb, 5 instruction(s), ends with ret
    pop edi                                      # 004b8a21
    pop esi                                      # 004b8a22
    {load} mov esp, ebp                          # 004b8a23
    pop ebp                                      # 004b8a25
    ret                                          # 004b8a26

