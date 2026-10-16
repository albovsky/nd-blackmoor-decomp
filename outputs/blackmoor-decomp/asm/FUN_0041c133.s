# FUN_0041c133
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041c133
# extent:       0x0041c133-0x0041c29a (359 code bytes)
# span:         0x0041c133-0x0041c29a (code 359, tables 0, padding 0)
# sha256:       e3f905ef959ae4fba5e7e5bb763663df540ee62a7976de1f93d1b075900aa684
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041c133
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       11 ebp-relative slot(s): local_4, local_c, local_30, local_34, local_610, local_545c, local_657c, local_6580, local_6584, local_6588, local_658c
# fields:       [ecx + n] field_21, field_23; [edx + n] field_23
# callees:      calls FUN_0050c920, FUN_00433c60, FUN_004343a2, FUN_00423142, FUN_00433e63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 85 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_610, 0x610  # offset -0x610
.equ local_545c, 0x545c  # offset -0x545c
.equ local_657c, 0x657c  # offset -0x657c
.equ local_6580, 0x6580  # offset -0x6580
.equ local_6584, 0x6584  # offset -0x6584
.equ local_6588, 0x6588  # offset -0x6588
.equ local_658c, 0x658c  # offset -0x658c
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23

# --- external targets -----------------------------------------------
.set FUN_00423142, .text + (0x00423142 - 0x401000)
.set FUN_00433c60, .text + (0x00433c60 - 0x401000)
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)
.set FUN_004343a2, .text + (0x004343a2 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)

.org 0x0041c133 - 0x401000
.globl FUN_0041c133
FUN_0041c133:
    # block 0x0041c133: entry, 27 instruction(s), calls FUN_0050c920, FUN_00433c60, FUN_004343a2, ends with forward jump to 0x0041c1ca
    push ebp                                     # 0041c133
    {load} mov ebp, esp                          # 0041c134
    push -0x1                                    # 0041c136
    push 0x5273a2                                # 0041c138
    mov eax, dword ptr fs:[0x0]                  # 0041c13d
    push eax                                     # 0041c143
    mov dword ptr fs:[0x0], esp                  # 0041c144
    mov eax, 0x6580                              # 0041c14b
    call FUN_0050c920                            # 0041c150
    push esi                                     # 0041c155
    push edi                                     # 0041c156
    mov dword ptr [ebp - local_658c], ecx        # 0041c157
    push 0x5b01ae                                # 0041c15d
    lea ecx, [ebp - local_657c]                  # 0041c162
    call FUN_00433c60                            # 0041c168
    mov dword ptr [ebp - local_4], 0x0           # 0041c16d
    mov dword ptr [ebp - local_34], 0x2          # 0041c174
    mov dword ptr [ebp - local_6584], 0x0        # 0041c17b
    mov dword ptr [ebp - local_6588], 0x0        # 0041c185
    push 0x5431a8                                # 0041c18f
    lea ecx, [ebp - local_657c]                  # 0041c194
    call FUN_004343a2                            # 0041c19a
    mov eax, dword ptr [ebp - local_545c]        # 0041c19f
    mov cx, word ptr [eax]                       # 0041c1a5
    mov word ptr [ebp - local_6588], cx          # 0041c1a8
    mov dword ptr [ebp - local_6580], 0x0        # 0041c1af
    jmp.d8 L_0041c1ca                            # 0041c1b9
L_0041c1bb:
    # block 0x0041c1bb: entered by jmp at 0x0041c273, 3 instruction(s), falls into the block at 0x0041c1ca
    mov edx, dword ptr [ebp - local_6580]        # 0041c1bb
    add edx, 0x1                                 # 0041c1c1
    mov dword ptr [ebp - local_6580], edx        # 0041c1c4
L_0041c1ca:
    # block 0x0041c1ca: entered by jmp at 0x0041c1b9, 3 instruction(s), ends with jge to 0x0041c278 (forward)
    mov eax, dword ptr [ebp - local_6580]        # 0041c1ca
    cmp eax, dword ptr [ebp - local_6588]        # 0041c1d0
    jge.d32 L_0041c278                           # 0041c1d6
    # block 0x0041c1dc: entered by fall-through of jge at 0x0041c1d6, 42 instruction(s), calls FUN_00423142, ends with backward jump to 0x0041c1bb
    mov ecx, 0x8                                 # 0041c1dc
    {load} xor eax, eax                          # 0041c1e1
    lea edi, [ebp - local_30]                    # 0041c1e3
    rep stosd dword ptr es:[edi], eax            # 0041c1e6
    stosb byte ptr es:[edi], al                  # 0041c1e8
    mov ecx, 0x177                               # 0041c1e9
    {load} xor eax, eax                          # 0041c1ee
    lea edi, [ebp - local_610]                   # 0041c1f0
    rep stosd dword ptr es:[edi], eax            # 0041c1f6
    mov esi, dword ptr [ebp - local_545c]        # 0041c1f8
    add esi, dword ptr [ebp - local_34]          # 0041c1fe
    mov ecx, 0x8                                 # 0041c201
    lea edi, [ebp - local_30]                    # 0041c206
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c209
    movsb byte ptr es:[edi], byte ptr [esi]      # 0041c20b
    mov ecx, dword ptr [ebp - local_545c]        # 0041c20c
    add ecx, dword ptr [ebp - local_34]          # 0041c212
    mov dx, word ptr [ecx + field_21]            # 0041c215
    mov word ptr [ebp - local_6584], dx          # 0041c219
    mov ecx, dword ptr [ebp - local_6584]        # 0041c220
    mov eax, dword ptr [ebp - local_34]          # 0041c226
    mov edx, dword ptr [ebp - local_545c]        # 0041c229
    lea esi, [edx + eax + field_23]              # 0041c22f
    lea edi, [ebp - local_610]                   # 0041c233
    {load} mov eax, ecx                          # 0041c239
    shr ecx, 0x2                                 # 0041c23b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041c23e
    {load} mov ecx, eax                          # 0041c240
    and ecx, 0x3                                 # 0041c242
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041c245
    lea ecx, [ebp - local_610]                   # 0041c247
    push ecx                                     # 0041c24d
    lea edx, [ebp - local_30]                    # 0041c24e
    push edx                                     # 0041c251
    mov ecx, dword ptr [ebp - local_658c]        # 0041c252
    add ecx, 0xfd1                               # 0041c258
    call FUN_00423142                            # 0041c25e
    mov eax, dword ptr [ebp - local_6584]        # 0041c263
    mov ecx, dword ptr [ebp - local_34]          # 0041c269
    lea edx, [ecx + eax + field_23]              # 0041c26c
    mov dword ptr [ebp - local_34], edx          # 0041c270
    jmp.d32 L_0041c1bb                           # 0041c273
L_0041c278:
    # block 0x0041c278: entered by jge at 0x0041c1d6, 10 instruction(s), calls FUN_00433e63, ends with ret
    mov dword ptr [ebp - local_4], 0xffffffff    # 0041c278
    lea ecx, [ebp - local_657c]                  # 0041c27f
    call FUN_00433e63                            # 0041c285
    mov ecx, dword ptr [ebp - local_c]           # 0041c28a
    mov dword ptr fs:[0x0], ecx                  # 0041c28d
    pop edi                                      # 0041c294
    pop esi                                      # 0041c295
    {load} mov esp, ebp                          # 0041c296
    pop ebp                                      # 0041c298
    ret                                          # 0041c299

