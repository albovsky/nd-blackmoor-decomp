# FUN_0041a19c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a19c
# extent:       0x0041a19c-0x0041a216 (122 code bytes)
# span:         0x0041a19c-0x0041a216 (code 122, tables 0, padding 0)
# sha256:       67a80d476025b579f23ef3efee6ffd156e77e69629eb16a11efdc197e4a77d19
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
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
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------

.org 0x0041a19c - 0x401000
.globl FUN_0041a19c
FUN_0041a19c:
    # block 0x0041a19c: <unfilled>
    push ebp                                     # 0041a19c
    {load} mov ebp, esp                          # 0041a19d
    sub esp, 0x10                                # 0041a19f
    push edi                                     # 0041a1a2
    mov dword ptr [ebp - local_10], ecx          # 0041a1a3
    mov word ptr [ebp - local_c], 0x0            # 0041a1a6
    mov word ptr [ebp - local_4], 0x0            # 0041a1ac
    jmp.d8 L_0041a1c0                            # 0041a1b2
L_0041a1b4:
    # block 0x0041a1b4: <unfilled>
    mov ax, word ptr [ebp - local_4]             # 0041a1b4
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041a1b8
    mov word ptr [ebp - local_4], ax             # 0041a1bc
L_0041a1c0:
    # block 0x0041a1c0: <unfilled>
    movsx edx, word ptr [ebp - local_4]          # 0041a1c0
    mov edi, dword ptr [ebp + arg_8]             # 0041a1c4
    or ecx, -0x1                                 # 0041a1c7
    {load} xor eax, eax                          # 0041a1ca
    repne scasb al, byte ptr es:[edi]            # 0041a1cc
    not ecx                                      # 0041a1ce
    add ecx, -0x1                                # 0041a1d0
    movsx eax, cx                                # 0041a1d3
    {load} cmp edx, eax                          # 0041a1d6
    jge.d8 L_0041a1f3                            # 0041a1d8
    # block 0x0041a1da: <unfilled>
    movsx ecx, word ptr [ebp - local_4]          # 0041a1da
    mov edx, dword ptr [ebp + arg_8]             # 0041a1de
    movsx ax, byte ptr [edx + ecx]               # 0041a1e1
    mov cx, word ptr [ebp - local_c]             # 0041a1e6
    {load} add cx, ax                            # 0041a1ea
    mov word ptr [ebp - local_c], cx             # 0041a1ed
    jmp.d8 L_0041a1b4                            # 0041a1f1
L_0041a1f3:
    # block 0x0041a1f3: <unfilled>
    movsx edx, word ptr [ebp - local_c]          # 0041a1f3
    and edx, 0x800003ff                          # 0041a1f7
    jns.d8 L_0041a207                            # 0041a1fd
    # block 0x0041a1ff: <unfilled>
    dec edx                                      # 0041a1ff
    or edx, 0xfffffc00                           # 0041a200
    inc edx                                      # 0041a206
L_0041a207:
    # block 0x0041a207: <unfilled>
    mov word ptr [ebp - local_8], dx             # 0041a207
    mov ax, word ptr [ebp - local_8]             # 0041a20b
    pop edi                                      # 0041a20f
    {load} mov esp, ebp                          # 0041a210
    pop ebp                                      # 0041a212
    ret 0x4                                      # 0041a213
