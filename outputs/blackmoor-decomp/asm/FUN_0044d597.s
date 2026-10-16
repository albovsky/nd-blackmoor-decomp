# FUN_0044d597
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d597
# extent:       0x0044d597-0x0044d624 (141 code bytes)
# span:         0x0044d597-0x0044d624 (code 141, tables 0, padding 0)
# sha256:       fdd609c73c693ddb44cdd811fe51f8c9d12eef51a67ca73ca9030c31bd4954e4
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d597
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_24, field_263; [ecx + n] field_31
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_31, 0x31  # offset +0x31
.equ field_263, 0x263  # offset +0x263

# --- external targets -----------------------------------------------

.org 0x0044d597 - 0x401000
.globl FUN_0044d597
FUN_0044d597:
    # block 0x0044d597: entry, 31 instruction(s), ends with ret 0x4
    push ebp                                     # 0044d597
    {load} mov ebp, esp                          # 0044d598
    sub esp, 0x8                                 # 0044d59a
    mov dword ptr [ebp - local_8], ecx           # 0044d59d
    mov eax, dword ptr [ebp - local_8]           # 0044d5a0
    movsx ecx, word ptr [eax + field_1e]         # 0044d5a3
    imul ecx, ecx, 0x8d                          # 0044d5a7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0044d5ad
    mov dword ptr [ebp - local_4], edx           # 0044d5b3
    mov eax, dword ptr [ebp - local_4]           # 0044d5b6
    movsx ecx, word ptr [eax + field_263]        # 0044d5b9
    mov dword ptr [0x5b44f0], ecx                # 0044d5c0
    mov dword ptr [0x5b44f4], 0x1                # 0044d5c6
    mov edx, dword ptr [0x5d0377]                # 0044d5d0
    mov dword ptr [0x5d162d], edx                # 0044d5d6
    mov eax, dword ptr [0x5b44f0]                # 0044d5dc
    shl eax, 0x5                                 # 0044d5e1
    mov ecx, dword ptr [0x5b44f4]                # 0044d5e4
    shl ecx, 0x4                                 # 0044d5ea
    lea edx, [eax + ecx + 0x5b160c]              # 0044d5ed
    mov dword ptr [0x5d1631], edx                # 0044d5f4
    mov dword ptr [0x5d1639], 0x1                # 0044d5fa
    mov dword ptr [0x5c39e5], 0x276e             # 0044d604
    mov eax, dword ptr [ebp - local_8]           # 0044d60e
    mov byte ptr [eax + field_24], 0x1           # 0044d611
    mov ecx, dword ptr [ebp - local_8]           # 0044d615
    mov edx, dword ptr [ebp + arg_8]             # 0044d618
    mov dword ptr [ecx + field_31], edx          # 0044d61b
    {load} mov esp, ebp                          # 0044d61e
    pop ebp                                      # 0044d620
    ret 0x4                                      # 0044d621

