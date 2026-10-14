# FUN_00434025
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434025
# extent:       0x00434025-0x0043423d (536 code bytes)
# span:         0x00434025-0x0043423d (code 536, tables 0, padding 0)
# sha256:       1c8b47dd0818cbee7e5cf51258be5e791f8dcf6f991b0dc31cec6646c63067e1
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]
.equ local_10, 0x10  # [ebp - 0x10]
.equ local_14, 0x14  # [ebp - 0x14]
.equ local_18, 0x18  # [ebp - 0x18]
.equ local_1c, 0x1c  # [ebp - 0x1c]
.equ local_20, 0x20  # [ebp - 0x20]

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_00434773, .text + (0x00434773 - 0x401000)
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x00434025 - 0x401000
.globl FUN_00434025
FUN_00434025:
    # block 0x00434025: <unfilled>
    push ebp                                     # 00434025
    {load} mov ebp, esp                          # 00434026
    sub esp, 0x20                                # 00434028
    push edi                                     # 0043402b
    mov dword ptr [ebp - local_20], ecx          # 0043402c
    mov eax, dword ptr [ebp - local_20]          # 0043402f
    mov dword ptr [eax + 0x5f68], 0x0            # 00434032
    mov dword ptr [ebp - local_4], 0x0           # 0043403c
    mov dword ptr [ebp - local_14], 0x0          # 00434043
    jmp.d8 L_00434055                            # 0043404a
L_0043404c:
    # block 0x0043404c: <unfilled>
    mov ecx, dword ptr [ebp - local_14]          # 0043404c
    add ecx, 0x1                                 # 0043404f
    mov dword ptr [ebp - local_14], ecx          # 00434052
L_00434055:
    # block 0x00434055: <unfilled>
    mov edx, dword ptr [ebp - local_20]          # 00434055
    mov eax, dword ptr [ebp - local_14]          # 00434058
    cmp eax, dword ptr [edx + 0x5f64]            # 0043405b
    jge.d32 L_00434238                           # 00434061
    # block 0x00434067: <unfilled>
    mov ecx, dword ptr [ebp - local_14]          # 00434067
    mov edx, dword ptr [ebp - local_20]          # 0043406a
    mov eax, dword ptr [edx + 4*ecx + 0x1144]    # 0043406d
    mov dword ptr [ebp - local_18], eax          # 00434074
    mov edi, 0x545e7c                            # 00434077
    or ecx, -0x1                                 # 0043407c
    {load} xor eax, eax                          # 0043407f
    repne scasb al, byte ptr es:[edi]            # 00434081
    not ecx                                      # 00434083
    add ecx, -0x1                                # 00434085
    mov edx, dword ptr [ebp - local_18]          # 00434088
    {load} add edx, ecx                          # 0043408b
    mov dword ptr [ebp - local_18], edx          # 0043408d
    mov eax, dword ptr [ebp - local_18]          # 00434090
    push eax                                     # 00434093
    mov ecx, dword ptr [ebp - local_20]          # 00434094
    call FUN_004347b8                            # 00434097
    mov dword ptr [ebp - local_8], eax           # 0043409c
    cmp dword ptr [ebp - local_8], 0x8           # 0043409f
    ja.d8 L_004340c3                             # 004340a3
    # block 0x004340a5: <unfilled>
    push 0x545e84                                # 004340a5
    push 0x545e98                                # 004340aa
    mov ecx, 0x583979                            # 004340af
    call FUN_0042639d                            # 004340b4
    mov ecx, 0x5cf659                            # 004340b9
    call FUN_004c97b4                            # 004340be
L_004340c3:
    # block 0x004340c3: <unfilled>
    mov ecx, dword ptr [ebp - local_18]          # 004340c3
    add ecx, 0x4                                 # 004340c6
    mov dword ptr [ebp - local_18], ecx          # 004340c9
    mov edx, dword ptr [ebp - local_18]          # 004340cc
    add edx, 0x4                                 # 004340cf
    mov dword ptr [ebp - local_18], edx          # 004340d2
    mov dword ptr [ebp - local_1c], 0x5          # 004340d5
L_004340dc:
    # block 0x004340dc: <unfilled>
    mov eax, 0x1                                 # 004340dc
    test eax, eax                                # 004340e1
    je.d32 L_00434233                            # 004340e3
    # block 0x004340e9: <unfilled>
    mov ecx, dword ptr [ebp - local_18]          # 004340e9
    push ecx                                     # 004340ec
    mov ecx, dword ptr [ebp - local_20]          # 004340ed
    call FUN_00434773                            # 004340f0
    cmp eax, 0x1                                 # 004340f5
    jne.d8 L_00434173                            # 004340f8
    # block 0x004340fa: <unfilled>
    mov dword ptr [ebp - local_10], 0x0          # 004340fa
    jmp.d8 L_0043410c                            # 00434101
L_00434103:
    # block 0x00434103: <unfilled>
    mov edx, dword ptr [ebp - local_10]          # 00434103
    add edx, 0x1                                 # 00434106
    mov dword ptr [ebp - local_10], edx          # 00434109
L_0043410c:
    # block 0x0043410c: <unfilled>
    mov eax, dword ptr [ebp - local_20]          # 0043410c
    mov ecx, dword ptr [ebp - local_10]          # 0043410f
    cmp ecx, dword ptr [eax + 0x5f64]            # 00434112
    jge.d8 L_00434140                            # 00434118
    # block 0x0043411a: <unfilled>
    mov edx, dword ptr [ebp - local_10]          # 0043411a
    cmp edx, dword ptr [ebp - local_14]          # 0043411d
    jne.d8 L_00434124                            # 00434120
    # block 0x00434122: <unfilled>
    jmp.d8 L_00434103                            # 00434122
L_00434124:
    # block 0x00434124: <unfilled>
    mov eax, dword ptr [ebp - local_10]          # 00434124
    mov ecx, dword ptr [ebp - local_20]          # 00434127
    mov edx, dword ptr [ecx + 4*eax + 0x1144]    # 0043412a
    cmp edx, dword ptr [ebp - local_18]          # 00434131
    jne.d8 L_0043413e                            # 00434134
    # block 0x00434136: <unfilled>
    mov eax, dword ptr [ebp - local_10]          # 00434136
    mov dword ptr [ebp - local_4], eax           # 00434139
    jmp.d8 L_00434140                            # 0043413c
L_0043413e:
    # block 0x0043413e: <unfilled>
    jmp.d8 L_00434103                            # 0043413e
L_00434140:
    # block 0x00434140: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 00434140
    mov edx, dword ptr [ebp - local_20]          # 00434143
    mov eax, dword ptr [ebp - local_18]          # 00434146
    add eax, dword ptr [edx + 4*ecx + 0x3084]    # 00434149
    mov dword ptr [ebp - local_18], eax          # 00434150
    mov ecx, dword ptr [ebp - local_4]           # 00434153
    mov edx, dword ptr [ebp - local_20]          # 00434156
    mov eax, dword ptr [ebp - local_1c]          # 00434159
    add eax, dword ptr [edx + 4*ecx + 0x3084]    # 0043415c
    mov dword ptr [ebp - local_1c], eax          # 00434163
    mov ecx, dword ptr [ebp - local_1c]          # 00434166
    cmp ecx, dword ptr [ebp - local_8]           # 00434169
    jb.d8 L_00434173                             # 0043416c
    # block 0x0043416e: <unfilled>
    jmp.d32 L_00434233                           # 0043416e
L_00434173:
    # block 0x00434173: <unfilled>
    mov edx, dword ptr [ebp - local_20]          # 00434173
    cmp dword ptr [edx + 0x5f68], 0x3e6          # 00434176
    jle.d8 L_004341a0                            # 00434180
    # block 0x00434182: <unfilled>
    push 0x545ebc                                # 00434182
    push 0x545ed0                                # 00434187
    mov ecx, 0x583979                            # 0043418c
    call FUN_0042639d                            # 00434191
    mov ecx, 0x5cf659                            # 00434196
    call FUN_004c97b4                            # 0043419b
L_004341a0:
    # block 0x004341a0: <unfilled>
    mov eax, dword ptr [ebp - local_20]          # 004341a0
    mov ecx, dword ptr [eax + 0x5f68]            # 004341a3
    mov edx, dword ptr [ebp - local_20]          # 004341a9
    mov eax, dword ptr [ebp - local_18]          # 004341ac
    mov dword ptr [edx + 4*ecx + 0x20e4], eax    # 004341af
    mov ecx, dword ptr [ebp - local_20]          # 004341b6
    mov edx, dword ptr [ecx + 0x5f68]            # 004341b9
    add edx, 0x1                                 # 004341bf
    mov eax, dword ptr [ebp - local_20]          # 004341c2
    mov dword ptr [eax + 0x5f68], edx            # 004341c5
    mov ecx, dword ptr [ebp - local_18]          # 004341cb
    add ecx, 0x4                                 # 004341ce
    mov dword ptr [ebp - local_18], ecx          # 004341d1
    mov edx, dword ptr [ebp - local_1c]          # 004341d4
    add edx, 0x4                                 # 004341d7
    mov dword ptr [ebp - local_1c], edx          # 004341da
    mov eax, dword ptr [ebp - local_18]          # 004341dd
    push eax                                     # 004341e0
    mov ecx, dword ptr [ebp - local_20]          # 004341e1
    call FUN_004347b8                            # 004341e4
    mov dword ptr [ebp - local_c], eax           # 004341e9
    mov ecx, dword ptr [ebp - local_c]           # 004341ec
    and ecx, 0x1                                 # 004341ef
    cmp ecx, 0x1                                 # 004341f2
    jne.d8 L_00434200                            # 004341f5
    # block 0x004341f7: <unfilled>
    mov edx, dword ptr [ebp - local_c]           # 004341f7
    add edx, 0x1                                 # 004341fa
    mov dword ptr [ebp - local_c], edx           # 004341fd
L_00434200:
    # block 0x00434200: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 00434200
    add eax, 0x4                                 # 00434203
    mov dword ptr [ebp - local_18], eax          # 00434206
    mov ecx, dword ptr [ebp - local_1c]          # 00434209
    add ecx, 0x4                                 # 0043420c
    mov dword ptr [ebp - local_1c], ecx          # 0043420f
    mov edx, dword ptr [ebp - local_18]          # 00434212
    add edx, dword ptr [ebp - local_c]           # 00434215
    mov dword ptr [ebp - local_18], edx          # 00434218
    mov eax, dword ptr [ebp - local_1c]          # 0043421b
    add eax, dword ptr [ebp - local_c]           # 0043421e
    mov dword ptr [ebp - local_1c], eax          # 00434221
    mov ecx, dword ptr [ebp - local_1c]          # 00434224
    cmp ecx, dword ptr [ebp - local_8]           # 00434227
    jbe.d8 L_0043422e                            # 0043422a
    # block 0x0043422c: <unfilled>
    jmp.d8 L_00434233                            # 0043422c
L_0043422e:
    # block 0x0043422e: <unfilled>
    jmp.d32 L_004340dc                           # 0043422e
L_00434233:
    # block 0x00434233: <unfilled>
    jmp.d32 L_0043404c                           # 00434233
L_00434238:
    # block 0x00434238: <unfilled>
    pop edi                                      # 00434238
    {load} mov esp, ebp                          # 00434239
    pop ebp                                      # 0043423b
    ret                                          # 0043423c
