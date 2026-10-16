# FUN_0045ae6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045ae6e
# extent:       0x0045ae6e-0x0045b2c8 (1114 code bytes)
# span:         0x0045ae6e-0x0045b2d0 (code 1114, tables 0, padding 8)
# sha256:       ee38f9276a94f2818ff19ba08fe659a5e3c6793af28f91619336bb67795e0597
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045ae6e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [ecx + n] field_a1; [edx + n] field_21, field_a1
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 280 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_21, 0x21  # offset +0x21
.equ field_a1, 0xa1  # offset +0xa1

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x0045ae6e - 0x401000
.globl FUN_0045ae6e
FUN_0045ae6e:
    # block 0x0045ae6e: entry, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0045aeae
    push ebp                                     # 0045ae6e
    {load} mov ebp, esp                          # 0045ae6f
    sub esp, 0x2c                                # 0045ae71
    call dword ptr [0x52a23c]                    # 0045ae74
    mov dword ptr [ebp - local_2c], eax          # 0045ae7a
    movsx eax, word ptr [0x61c809]               # 0045ae7d
    imul eax, eax, 0x8d                          # 0045ae84
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045ae8a
    mov dword ptr [ebp - local_1c], ecx          # 0045ae90
    mov dword ptr [ebp - local_14], 0x12c        # 0045ae93
    mov word ptr [ebp - local_c], 0x0            # 0045ae9a
    jmp.d8 L_0045aeae                            # 0045aea0
L_0045aea2:
    # block 0x0045aea2: entered by jmp at 0x0045af0a, 3 instruction(s), falls into the block at 0x0045aeae
    mov dx, word ptr [ebp - local_c]             # 0045aea2
    add dx, 0x1                                  # 0045aea6
    mov word ptr [ebp - local_c], dx             # 0045aeaa
L_0045aeae:
    # block 0x0045aeae: entered by jmp at 0x0045aea0, 3 instruction(s), ends with jge to 0x0045af0c (forward)
    movsx eax, word ptr [ebp - local_c]          # 0045aeae
    cmp eax, 0x4                                 # 0045aeb2
    jge.d8 L_0045af0c                            # 0045aeb5
    # block 0x0045aeb7: entered by fall-through of jge at 0x0045aeb5, 5 instruction(s), ends with je to 0x0045af0a (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0045aeb7
    {load} xor edx, edx                          # 0045aebb
    mov dl, byte ptr [ecx + 0x61c80b]            # 0045aebd
    test edx, edx                                # 0045aec3
    je.d8 L_0045af0a                             # 0045aec5
    # block 0x0045aec7: entered by fall-through of je at 0x0045aec5, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x0045af0a
    push 0x54a944                                # 0045aec7
    movsx eax, word ptr [ebp - local_c]          # 0045aecc
    shl eax, 0x4                                 # 0045aed0
    add eax, 0x61c865                            # 0045aed3
    push eax                                     # 0045aed8
    movsx ecx, word ptr [ebp - local_c]          # 0045aed9
    shl ecx, 0x4                                 # 0045aedd
    mov edx, dword ptr [ebp - local_1c]          # 0045aee0
    lea eax, [edx + ecx + field_21]              # 0045aee3
    push eax                                     # 0045aee7
    mov ecx, dword ptr [0x5cf665]                # 0045aee8
    push ecx                                     # 0045aeee
    movsx edx, word ptr [0x61c80f]               # 0045aeef
    imul edx, edx, 0x4a                          # 0045aef6
    mov eax, dword ptr [edx + 0x5d1599]          # 0045aef9
    push eax                                     # 0045aeff
    mov ecx, 0x5cf659                            # 0045af00
    call FUN_004c5377                            # 0045af05
L_0045af0a:
    # block 0x0045af0a: entered by je at 0x0045aec5, 1 instruction(s), ends with backward jump to 0x0045aea2
    jmp.d8 L_0045aea2                            # 0045af0a
L_0045af0c:
    # block 0x0045af0c: entered by jge at 0x0045aeb5, 2 instruction(s), ends with jne to 0x0045b2c4 (forward)
    cmp dword ptr [0x585d65], 0x1                # 0045af0c
    jne.d32 L_0045b2c4                           # 0045af13
    # block 0x0045af19: entered by fall-through of jne at 0x0045af13, 6 instruction(s), ends with jge to 0x0045af38 (forward)
    movsx ecx, word ptr [0x61c811]               # 0045af19
    sub ecx, dword ptr [0x585d6d]                # 0045af20
    mov word ptr [ebp - local_4], cx             # 0045af26
    movsx edx, word ptr [ebp - local_4]          # 0045af2a
    test edx, edx                                # 0045af2e
    jge.d8 L_0045af38                            # 0045af30
    # block 0x0045af32: entered by fall-through of jge at 0x0045af30, 1 instruction(s), falls into the block at 0x0045af38
    mov word ptr [ebp - local_4], 0x0            # 0045af32
L_0045af38:
    # block 0x0045af38: entered by jge at 0x0045af30, 3 instruction(s), ends with jne to 0x0045af4e (forward)
    movsx eax, word ptr [ebp - local_4]          # 0045af38
    test eax, eax                                # 0045af3c
    jne.d8 L_0045af4e                            # 0045af3e
    # block 0x0045af40: entered by fall-through of jne at 0x0045af3e, 3 instruction(s), ends with forward jump to 0x0045af6e
    mov word ptr [ebp - local_24], 0x0           # 0045af40
    mov word ptr [ebp - local_28], 0x0           # 0045af46
    jmp.d8 L_0045af6e                            # 0045af4c
L_0045af4e:
    # block 0x0045af4e: entered by jne at 0x0045af3e, 10 instruction(s), falls into the block at 0x0045af6e
    movsx eax, word ptr [ebp - local_4]          # 0045af4e
    cdq                                          # 0045af52
    mov ecx, 0x3c                                # 0045af53
    idiv ecx                                     # 0045af58
    mov word ptr [ebp - local_24], dx            # 0045af5a
    movsx eax, word ptr [ebp - local_4]          # 0045af5e
    cdq                                          # 0045af62
    mov ecx, 0x3c                                # 0045af63
    idiv ecx                                     # 0045af68
    mov word ptr [ebp - local_28], ax            # 0045af6a
L_0045af6e:
    # block 0x0045af6e: entered by jmp at 0x0045af4c, 3 instruction(s), ends with jne to 0x0045af84 (forward)
    movsx edx, word ptr [ebp - local_28]         # 0045af6e
    test edx, edx                                # 0045af72
    jne.d8 L_0045af84                            # 0045af74
    # block 0x0045af76: entered by fall-through of jne at 0x0045af74, 3 instruction(s), ends with forward jump to 0x0045afa4
    mov word ptr [ebp - local_20], 0x0           # 0045af76
    mov word ptr [ebp - local_10], 0x0           # 0045af7c
    jmp.d8 L_0045afa4                            # 0045af82
L_0045af84:
    # block 0x0045af84: entered by jne at 0x0045af74, 10 instruction(s), falls into the block at 0x0045afa4
    movsx eax, word ptr [ebp - local_28]         # 0045af84
    cdq                                          # 0045af88
    mov ecx, 0xa                                 # 0045af89
    idiv ecx                                     # 0045af8e
    mov word ptr [ebp - local_20], ax            # 0045af90
    movsx eax, word ptr [ebp - local_28]         # 0045af94
    cdq                                          # 0045af98
    mov ecx, 0xa                                 # 0045af99
    idiv ecx                                     # 0045af9e
    mov word ptr [ebp - local_10], dx            # 0045afa0
L_0045afa4:
    # block 0x0045afa4: entered by jmp at 0x0045af82, 3 instruction(s), ends with jne to 0x0045afba (forward)
    movsx edx, word ptr [ebp - local_24]         # 0045afa4
    test edx, edx                                # 0045afa8
    jne.d8 L_0045afba                            # 0045afaa
    # block 0x0045afac: entered by fall-through of jne at 0x0045afaa, 3 instruction(s), ends with forward jump to 0x0045afda
    mov word ptr [ebp - local_8], 0x0            # 0045afac
    mov word ptr [ebp - local_18], 0x0           # 0045afb2
    jmp.d8 L_0045afda                            # 0045afb8
L_0045afba:
    # block 0x0045afba: entered by jne at 0x0045afaa, 10 instruction(s), falls into the block at 0x0045afda
    movsx eax, word ptr [ebp - local_24]         # 0045afba
    cdq                                          # 0045afbe
    mov ecx, 0xa                                 # 0045afbf
    idiv ecx                                     # 0045afc4
    mov word ptr [ebp - local_8], ax             # 0045afc6
    movsx eax, word ptr [ebp - local_24]         # 0045afca
    cdq                                          # 0045afce
    mov ecx, 0xa                                 # 0045afcf
    idiv ecx                                     # 0045afd4
    mov word ptr [ebp - local_18], dx            # 0045afd6
L_0045afda:
    # block 0x0045afda: entered by jmp at 0x0045afb8, 3 instruction(s), ends with jge to 0x0045b127 (forward)
    movsx edx, word ptr [0x61c813]               # 0045afda
    cmp dword ptr [0x585d6d], edx                # 0045afe1
    jge.d32 L_0045b127                           # 0045afe7
    # block 0x0045afed: entered by fall-through of jge at 0x0045afe7, 77 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0045b2c4
    push 0x54a95c                                # 0045afed
    push 0x61c815                                # 0045aff2
    movsx eax, word ptr [ebp - local_20]         # 0045aff7
    shl eax, 0x4                                 # 0045affb
    mov ecx, dword ptr [ebp - local_1c]          # 0045affe
    lea edx, [ecx + eax + field_a1]              # 0045b001
    push edx                                     # 0045b008
    mov eax, dword ptr [0x5cf665]                # 0045b009
    push eax                                     # 0045b00e
    movsx ecx, word ptr [0x61c80f]               # 0045b00f
    imul ecx, ecx, 0x4a                          # 0045b016
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045b019
    push edx                                     # 0045b01f
    mov ecx, 0x5cf659                            # 0045b020
    call FUN_004c5377                            # 0045b025
    push 0x54a980                                # 0045b02a
    push 0x61c825                                # 0045b02f
    movsx eax, word ptr [ebp - local_10]         # 0045b034
    shl eax, 0x4                                 # 0045b038
    mov ecx, dword ptr [ebp - local_1c]          # 0045b03b
    lea edx, [ecx + eax + field_a1]              # 0045b03e
    push edx                                     # 0045b045
    mov eax, dword ptr [0x5cf665]                # 0045b046
    push eax                                     # 0045b04b
    movsx ecx, word ptr [0x61c80f]               # 0045b04c
    imul ecx, ecx, 0x4a                          # 0045b053
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045b056
    push edx                                     # 0045b05c
    mov ecx, 0x5cf659                            # 0045b05d
    call FUN_004c5377                            # 0045b062
    push 0x54a9a4                                # 0045b067
    push 0x61c835                                # 0045b06c
    movsx eax, word ptr [ebp - local_8]          # 0045b071
    shl eax, 0x4                                 # 0045b075
    mov ecx, dword ptr [ebp - local_1c]          # 0045b078
    lea edx, [ecx + eax + field_a1]              # 0045b07b
    push edx                                     # 0045b082
    mov eax, dword ptr [0x5cf665]                # 0045b083
    push eax                                     # 0045b088
    movsx ecx, word ptr [0x61c80f]               # 0045b089
    imul ecx, ecx, 0x4a                          # 0045b090
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045b093
    push edx                                     # 0045b099
    mov ecx, 0x5cf659                            # 0045b09a
    call FUN_004c5377                            # 0045b09f
    push 0x54a9c8                                # 0045b0a4
    push 0x61c845                                # 0045b0a9
    movsx eax, word ptr [ebp - local_18]         # 0045b0ae
    shl eax, 0x4                                 # 0045b0b2
    mov ecx, dword ptr [ebp - local_1c]          # 0045b0b5
    lea edx, [ecx + eax + field_a1]              # 0045b0b8
    push edx                                     # 0045b0bf
    mov eax, dword ptr [0x5cf665]                # 0045b0c0
    push eax                                     # 0045b0c5
    movsx ecx, word ptr [0x61c80f]               # 0045b0c6
    imul ecx, ecx, 0x4a                          # 0045b0cd
    mov edx, dword ptr [ecx + 0x5d1599]          # 0045b0d0
    push edx                                     # 0045b0d6
    mov ecx, 0x5cf659                            # 0045b0d7
    call FUN_004c5377                            # 0045b0dc
    push 0x54a9ec                                # 0045b0e1
    push 0x61c855                                # 0045b0e6
    mov eax, dword ptr [ebp - local_1c]          # 0045b0eb
    add eax, 0x181                               # 0045b0ee
    push eax                                     # 0045b0f3
    mov ecx, dword ptr [0x5cf665]                # 0045b0f4
    push ecx                                     # 0045b0fa
    movsx edx, word ptr [0x61c80f]               # 0045b0fb
    imul edx, edx, 0x4a                          # 0045b102
    mov eax, dword ptr [edx + 0x5d1599]          # 0045b105
    push eax                                     # 0045b10b
    mov ecx, 0x5cf659                            # 0045b10c
    call FUN_004c5377                            # 0045b111
    mov ecx, dword ptr [ebp - local_2c]          # 0045b116
    add ecx, dword ptr [ebp - local_14]          # 0045b119
    mov dword ptr [0x63a858], ecx                # 0045b11c
    jmp.d32 L_0045b2c4                           # 0045b122
L_0045b127:
    # block 0x0045b127: entered by jge at 0x0045afe7, 3 instruction(s), ends with jae to 0x0045b15c (forward)
    mov edx, dword ptr [0x63a858]                # 0045b127
    cmp edx, dword ptr [ebp - local_2c]          # 0045b12d
    jae.d8 L_0045b15c                            # 0045b130
    # block 0x0045b132: entered by fall-through of jae at 0x0045b130, 5 instruction(s), ends with je to 0x0045b152 (forward)
    mov eax, dword ptr [ebp - local_2c]          # 0045b132
    add eax, dword ptr [ebp - local_14]          # 0045b135
    mov dword ptr [0x63a858], eax                # 0045b138
    cmp dword ptr [0x63a85c], 0x0                # 0045b13d
    je.d8 L_0045b152                             # 0045b144
    # block 0x0045b146: entered by fall-through of je at 0x0045b144, 2 instruction(s), ends with forward jump to 0x0045b15c
    mov dword ptr [0x63a85c], 0x0                # 0045b146
    jmp.d8 L_0045b15c                            # 0045b150
L_0045b152:
    # block 0x0045b152: entered by je at 0x0045b144, 1 instruction(s), falls into the block at 0x0045b15c
    mov dword ptr [0x63a85c], 0x1                # 0045b152
L_0045b15c:
    # block 0x0045b15c: entered by jae at 0x0045b130; jmp at 0x0045b150, 2 instruction(s), ends with je to 0x0045b299 (forward)
    cmp dword ptr [0x63a85c], 0x0                # 0045b15c
    je.d32 L_0045b299                            # 0045b163
    # block 0x0045b169: entered by fall-through of je at 0x0045b163, 74 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0045b2c4
    push 0x54aa08                                # 0045b169
    push 0x61c815                                # 0045b16e
    movsx ecx, word ptr [ebp - local_20]         # 0045b173
    shl ecx, 0x4                                 # 0045b177
    mov edx, dword ptr [ebp - local_1c]          # 0045b17a
    lea eax, [edx + ecx + field_a1]              # 0045b17d
    push eax                                     # 0045b184
    mov ecx, dword ptr [0x5cf665]                # 0045b185
    push ecx                                     # 0045b18b
    movsx edx, word ptr [0x61c80f]               # 0045b18c
    imul edx, edx, 0x4a                          # 0045b193
    mov eax, dword ptr [edx + 0x5d1599]          # 0045b196
    push eax                                     # 0045b19c
    mov ecx, 0x5cf659                            # 0045b19d
    call FUN_004c5377                            # 0045b1a2
    push 0x54aa2c                                # 0045b1a7
    push 0x61c825                                # 0045b1ac
    movsx ecx, word ptr [ebp - local_10]         # 0045b1b1
    shl ecx, 0x4                                 # 0045b1b5
    mov edx, dword ptr [ebp - local_1c]          # 0045b1b8
    lea eax, [edx + ecx + field_a1]              # 0045b1bb
    push eax                                     # 0045b1c2
    mov ecx, dword ptr [0x5cf665]                # 0045b1c3
    push ecx                                     # 0045b1c9
    movsx edx, word ptr [0x61c80f]               # 0045b1ca
    imul edx, edx, 0x4a                          # 0045b1d1
    mov eax, dword ptr [edx + 0x5d1599]          # 0045b1d4
    push eax                                     # 0045b1da
    mov ecx, 0x5cf659                            # 0045b1db
    call FUN_004c5377                            # 0045b1e0
    push 0x54aa50                                # 0045b1e5
    push 0x61c835                                # 0045b1ea
    movsx ecx, word ptr [ebp - local_8]          # 0045b1ef
    shl ecx, 0x4                                 # 0045b1f3
    mov edx, dword ptr [ebp - local_1c]          # 0045b1f6
    lea eax, [edx + ecx + field_a1]              # 0045b1f9
    push eax                                     # 0045b200
    mov ecx, dword ptr [0x5cf665]                # 0045b201
    push ecx                                     # 0045b207
    movsx edx, word ptr [0x61c80f]               # 0045b208
    imul edx, edx, 0x4a                          # 0045b20f
    mov eax, dword ptr [edx + 0x5d1599]          # 0045b212
    push eax                                     # 0045b218
    mov ecx, 0x5cf659                            # 0045b219
    call FUN_004c5377                            # 0045b21e
    push 0x54aa74                                # 0045b223
    push 0x61c845                                # 0045b228
    movsx ecx, word ptr [ebp - local_18]         # 0045b22d
    shl ecx, 0x4                                 # 0045b231
    mov edx, dword ptr [ebp - local_1c]          # 0045b234
    lea eax, [edx + ecx + field_a1]              # 0045b237
    push eax                                     # 0045b23e
    mov ecx, dword ptr [0x5cf665]                # 0045b23f
    push ecx                                     # 0045b245
    movsx edx, word ptr [0x61c80f]               # 0045b246
    imul edx, edx, 0x4a                          # 0045b24d
    mov eax, dword ptr [edx + 0x5d1599]          # 0045b250
    push eax                                     # 0045b256
    mov ecx, 0x5cf659                            # 0045b257
    call FUN_004c5377                            # 0045b25c
    push 0x54aa98                                # 0045b261
    push 0x61c855                                # 0045b266
    mov ecx, dword ptr [ebp - local_1c]          # 0045b26b
    add ecx, 0x181                               # 0045b26e
    push ecx                                     # 0045b274
    mov edx, dword ptr [0x5cf665]                # 0045b275
    push edx                                     # 0045b27b
    movsx eax, word ptr [0x61c80f]               # 0045b27c
    imul eax, eax, 0x4a                          # 0045b283
    mov ecx, dword ptr [eax + 0x5d1599]          # 0045b286
    push ecx                                     # 0045b28c
    mov ecx, 0x5cf659                            # 0045b28d
    call FUN_004c5377                            # 0045b292
    jmp.d8 L_0045b2c4                            # 0045b297
L_0045b299:
    # block 0x0045b299: entered by je at 0x0045b163, 11 instruction(s), calls FUN_004c5377, falls into the block at 0x0045b2c4
    push 0x54aab4                                # 0045b299
    push 0x61c8a5                                # 0045b29e
    mov edx, dword ptr [ebp - local_1c]          # 0045b2a3
    add edx, 0x1a1                               # 0045b2a6
    push edx                                     # 0045b2ac
    mov eax, dword ptr [0x5cf665]                # 0045b2ad
    push eax                                     # 0045b2b2
    mov ecx, dword ptr [0x5d15e3]                # 0045b2b3
    push ecx                                     # 0045b2b9
    mov ecx, 0x5cf659                            # 0045b2ba
    call FUN_004c5377                            # 0045b2bf
L_0045b2c4:
    # block 0x0045b2c4: entered by jne at 0x0045af13; jmp at 0x0045b122; jmp at 0x0045b297, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045b2c4
    pop ebp                                      # 0045b2c6
    ret                                          # 0045b2c7

# --- data items (not part of the function) -------------------------
.org 0x0045b2c8 - 0x401000
PAD_0045b2c8:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

