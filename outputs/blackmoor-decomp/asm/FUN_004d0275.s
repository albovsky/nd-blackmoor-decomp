# FUN_004d0275
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d0275
# extent:       0x004d0275-0x004d040a (405 code bytes)
# span:         0x004d0275-0x004d040a (code 405, tables 0, padding 0)
# sha256:       dae761154a0273ea0c757821a57e987dc23a2b05cc57e5df6a78224d385b57b8
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d0275
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_21, field_25, field_e5; [ecx + n] field_e5, field_e9, field_ed; [edx + n] field_f1
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 89 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_e5, 0xe5  # offset +0xe5
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed
.equ field_f1, 0xf1  # offset +0xf1

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004d0275 - 0x401000
.globl FUN_004d0275
FUN_004d0275:
    # block 0x004d0275: entry, 5 instruction(s), ends with forward jump to 0x004d028f
    push ebp                                     # 004d0275
    {load} mov ebp, esp                          # 004d0276
    sub esp, 0x14                                # 004d0278
    mov word ptr [ebp - local_4], 0x0            # 004d027b
    jmp.d8 L_004d028f                            # 004d0281
L_004d0283:
    # block 0x004d0283: entered by jmp at 0x004d0401, 3 instruction(s), falls into the block at 0x004d028f
    mov ax, word ptr [ebp - local_4]             # 004d0283
    .insn 0x66, 0x05, 0x0001{:u16}               # 004d0287
    mov word ptr [ebp - local_4], ax             # 004d028b
L_004d028f:
    # block 0x004d028f: entered by jmp at 0x004d0281, 7 instruction(s), ends with jge to 0x004d0406 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004d028f
    movsx edx, word ptr [0x5b51ac]               # 004d0293
    imul edx, edx, 0x8d                          # 004d029a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d02a0
    movsx edx, word ptr [eax + field_21]         # 004d02a6
    {load} cmp ecx, edx                          # 004d02aa
    jge.d32 L_004d0406                           # 004d02ac
    # block 0x004d02b2: entered by fall-through of jge at 0x004d02ac, 35 instruction(s), ends with jne to 0x004d03ba (forward)
    movsx eax, word ptr [0x5b51ac]               # 004d02b2
    imul eax, eax, 0x8d                          # 004d02b9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d02bf
    movsx edx, word ptr [ebp - local_4]          # 004d02c5
    shl edx, 0x4                                 # 004d02c9
    mov eax, dword ptr [ecx + edx + field_e9]    # 004d02cc
    add eax, dword ptr [0x58318a]                # 004d02d3
    mov dword ptr [ebp - local_10], eax          # 004d02d9
    movsx ecx, word ptr [0x5b51ac]               # 004d02dc
    imul ecx, ecx, 0x8d                          # 004d02e3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004d02e9
    movsx eax, word ptr [ebp - local_4]          # 004d02ef
    shl eax, 0x4                                 # 004d02f3
    mov ecx, dword ptr [edx + eax + field_f1]    # 004d02f6
    add ecx, dword ptr [0x58318a]                # 004d02fd
    mov dword ptr [ebp - local_8], ecx           # 004d0303
    movsx edx, word ptr [0x5b51ac]               # 004d0306
    imul edx, edx, 0x8d                          # 004d030d
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d0313
    movsx ecx, word ptr [ebp - local_4]          # 004d0319
    shl ecx, 0x4                                 # 004d031d
    mov edx, dword ptr [eax + ecx + field_e5]    # 004d0320
    add edx, dword ptr [0x583186]                # 004d0327
    mov dword ptr [ebp - local_14], edx          # 004d032d
    movsx eax, word ptr [0x5b51ac]               # 004d0330
    imul eax, eax, 0x8d                          # 004d0337
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d033d
    movsx edx, word ptr [ebp - local_4]          # 004d0343
    shl edx, 0x4                                 # 004d0347
    mov eax, dword ptr [ecx + edx + field_ed]    # 004d034a
    add eax, dword ptr [0x583186]                # 004d0351
    mov dword ptr [ebp - local_c], eax           # 004d0357
    movsx ecx, word ptr [ebp - local_4]          # 004d035a
    cmp dword ptr [4*ecx + 0x5b518b], 0x1        # 004d035e
    jne.d8 L_004d03ba                            # 004d0366
    # block 0x004d0368: entered by fall-through of jne at 0x004d0366, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x004d03ba
    push 0x559f68                                # 004d0368
    lea edx, [ebp - local_14]                    # 004d036d
    push edx                                     # 004d0370
    movsx eax, word ptr [0x5b51ac]               # 004d0371
    imul eax, eax, 0x8d                          # 004d0378
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004d037e
    movsx edx, word ptr [ebp - local_4]          # 004d0384
    shl edx, 0x4                                 # 004d0388
    lea eax, [ecx + edx + field_e5]              # 004d038b
    push eax                                     # 004d0392
    mov ecx, dword ptr [0x5cf665]                # 004d0393
    push ecx                                     # 004d0399
    mov edx, dword ptr [0x5d15e3]                # 004d039a
    push edx                                     # 004d03a0
    mov ecx, 0x5cf659                            # 004d03a1
    call FUN_004c5377                            # 004d03a6
    movsx eax, word ptr [ebp - local_4]          # 004d03ab
    mov dword ptr [4*eax + 0x5b518b], 0x0        # 004d03af
L_004d03ba:
    # block 0x004d03ba: entered by jne at 0x004d0366, 18 instruction(s), calls FUN_004c5d4b, ends with backward jump to 0x004d0283
    push 0x559f80                                # 004d03ba
    lea ecx, [ebp - local_14]                    # 004d03bf
    push ecx                                     # 004d03c2
    movsx edx, word ptr [0x5b51ac]               # 004d03c3
    imul edx, edx, 0x8d                          # 004d03ca
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004d03d0
    movsx ecx, word ptr [ebp - local_4]          # 004d03d6
    mov edx, dword ptr [4*ecx + 0x5b516b]        # 004d03da
    shl edx, 0x4                                 # 004d03e1
    lea eax, [eax + edx + field_25]              # 004d03e4
    push eax                                     # 004d03e8
    mov ecx, dword ptr [0x5cf665]                # 004d03e9
    push ecx                                     # 004d03ef
    mov edx, dword ptr [0x5d1acd]                # 004d03f0
    push edx                                     # 004d03f6
    mov ecx, 0x5cf659                            # 004d03f7
    call FUN_004c5d4b                            # 004d03fc
    jmp.d32 L_004d0283                           # 004d0401
L_004d0406:
    # block 0x004d0406: entered by jge at 0x004d02ac, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d0406
    pop ebp                                      # 004d0408
    ret                                          # 004d0409

