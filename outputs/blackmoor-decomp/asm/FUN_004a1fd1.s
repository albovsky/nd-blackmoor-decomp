# FUN_004a1fd1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1fd1
# extent:       0x004a1fd1-0x004a2069 (152 code bytes)
# span:         0x004a1fd1-0x004a2069 (code 152, tables 0, padding 0)
# sha256:       08277bd72c5ab24e2b3ae1f70db766b33a62abd33cee4e2cc70658571e372ce5
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a1fd1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_20, field_58; [ecx + n] field_20, field_4c, field_14d, field_14f; [edx + n] field_14f, field_151
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_20, 0x20  # offset +0x20
.equ field_4c, 0x4c  # offset +0x4c
.equ field_58, 0x58  # offset +0x58
.equ field_14d, 0x14d  # offset +0x14d
.equ field_14f, 0x14f  # offset +0x14f
.equ field_151, 0x151  # offset +0x151

# --- external targets -----------------------------------------------

.org 0x004a1fd1 - 0x401000
.globl FUN_004a1fd1
FUN_004a1fd1:
    # block 0x004a1fd1: entry, 10 instruction(s), ends with forward jump to 0x004a1ffc
    push ebp                                     # 004a1fd1
    {load} mov ebp, esp                          # 004a1fd2
    sub esp, 0xc                                 # 004a1fd4
    mov dword ptr [ebp - local_c], ecx           # 004a1fd7
    mov dword ptr [ebp - local_8], 0x0           # 004a1fda
    mov eax, dword ptr [ebp - local_c]           # 004a1fe1
    mov ecx, dword ptr [eax + field_20]          # 004a1fe4
    movsx edx, word ptr [ecx + field_14f]        # 004a1fe7
    mov dword ptr [ebp - local_4], edx           # 004a1fee
    jmp.d8 L_004a1ffc                            # 004a1ff1
L_004a1ff3:
    # block 0x004a1ff3: entered by jmp at 0x004a2040, 3 instruction(s), falls into the block at 0x004a1ffc
    mov eax, dword ptr [ebp - local_4]           # 004a1ff3
    add eax, 0x1                                 # 004a1ff6
    mov dword ptr [ebp - local_4], eax           # 004a1ff9
L_004a1ffc:
    # block 0x004a1ffc: entered by jmp at 0x004a1ff1, 9 instruction(s), ends with jge to 0x004a2042 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004a1ffc
    mov edx, dword ptr [ecx + field_20]          # 004a1fff
    movsx eax, word ptr [edx + field_14f]        # 004a2002
    mov ecx, dword ptr [ebp - local_c]           # 004a2009
    mov edx, dword ptr [ecx + field_20]          # 004a200c
    movsx ecx, word ptr [edx + field_151]        # 004a200f
    {load} add eax, ecx                          # 004a2016
    cmp dword ptr [ebp - local_4], eax           # 004a2018
    jge.d8 L_004a2042                            # 004a201b
    # block 0x004a201d: entered by fall-through of jge at 0x004a201b, 6 instruction(s), ends with jne to 0x004a2040 (forward)
    movsx edx, word ptr [0x58c94f]               # 004a201d
    imul edx, edx, 0xf                           # 004a2024
    mov eax, dword ptr [ebp - local_4]           # 004a2027
    movsx ecx, byte ptr [edx + eax + 0x594d82]   # 004a202a
    cmp ecx, 0x1                                 # 004a2032
    jne.d8 L_004a2040                            # 004a2035
    # block 0x004a2037: entered by fall-through of jne at 0x004a2035, 3 instruction(s), falls into the block at 0x004a2040
    mov edx, dword ptr [ebp - local_8]           # 004a2037
    add edx, 0x1                                 # 004a203a
    mov dword ptr [ebp - local_8], edx           # 004a203d
L_004a2040:
    # block 0x004a2040: entered by jne at 0x004a2035, 1 instruction(s), ends with backward jump to 0x004a1ff3
    jmp.d8 L_004a1ff3                            # 004a2040
L_004a2042:
    # block 0x004a2042: entered by jge at 0x004a201b, 5 instruction(s), ends with jl to 0x004a2065 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004a2042
    mov ecx, dword ptr [eax + field_20]          # 004a2045
    movsx edx, word ptr [ecx + field_14d]        # 004a2048
    cmp dword ptr [ebp - local_8], edx           # 004a204f
    jl.d8 L_004a2065                             # 004a2052
    # block 0x004a2054: entered by fall-through of jl at 0x004a2052, 4 instruction(s), falls into the block at 0x004a2065
    mov eax, dword ptr [ebp - local_c]           # 004a2054
    mov byte ptr [eax + field_58], 0x1           # 004a2057
    mov ecx, dword ptr [ebp - local_c]           # 004a205b
    mov dword ptr [ecx + field_4c], 0x4          # 004a205e
L_004a2065:
    # block 0x004a2065: entered by jl at 0x004a2052, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a2065
    pop ebp                                      # 004a2067
    ret                                          # 004a2068

