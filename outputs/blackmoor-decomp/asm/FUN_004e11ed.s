# FUN_004e11ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e11ed
# extent:       0x004e11ed-0x004e1305 (280 code bytes)
# span:         0x004e11ed-0x004e1305 (code 280, tables 0, padding 0)
# sha256:       00c967e067dc7c9f95c5b9b8d7c400c6cd23dc55c62fc00663b089999380cea2
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e11ed
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_753, field_757, field_75b, field_f2a; [ecx + n] field_154, field_753; [edx + n] field_753
# callees:      calls FUN_004e2956, FUN_004e2b99, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_154, 0x154  # offset +0x154
.equ field_753, 0x753  # offset +0x753
.equ field_757, 0x757  # offset +0x757
.equ field_75b, 0x75b  # offset +0x75b
.equ field_f2a, 0xf2a  # offset +0xf2a

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004e2956, .text + (0x004e2956 - 0x401000)
.set FUN_004e2b99, .text + (0x004e2b99 - 0x401000)

.org 0x004e11ed - 0x401000
.globl FUN_004e11ed
FUN_004e11ed:
    # block 0x004e11ed: entry, 7 instruction(s), ends with je to 0x004e1205 (forward)
    push ebp                                     # 004e11ed
    {load} mov ebp, esp                          # 004e11ee
    push ecx                                     # 004e11f0
    mov dword ptr [ebp - local_4], ecx           # 004e11f1
    mov eax, dword ptr [ebp - local_4]           # 004e11f4
    cmp dword ptr [eax + field_f2a], 0x1         # 004e11f7
    je.d8 L_004e1205                             # 004e11fe
    # block 0x004e1200: entered by fall-through of je at 0x004e11fe, 1 instruction(s), ends with forward jump to 0x004e1301
    jmp.d32 L_004e1301                           # 004e1200
L_004e1205:
    # block 0x004e1205: entered by je at 0x004e11fe, 3 instruction(s), ends with forward jump to 0x004e1229
    mov ecx, dword ptr [ebp - local_4]           # 004e1205
    mov dword ptr [ecx + field_753], 0x0         # 004e1208
    jmp.d8 L_004e1229                            # 004e1212
L_004e1214:
    # block 0x004e1214: entered by jmp at 0x004e12fc, 5 instruction(s), falls into the block at 0x004e1229
    mov edx, dword ptr [ebp - local_4]           # 004e1214
    mov eax, dword ptr [edx + field_753]         # 004e1217
    add eax, 0x1                                 # 004e121d
    mov ecx, dword ptr [ebp - local_4]           # 004e1220
    mov dword ptr [ecx + field_753], eax         # 004e1223
L_004e1229:
    # block 0x004e1229: entered by jmp at 0x004e1212, 3 instruction(s), ends with jge to 0x004e1301 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e1229
    cmp dword ptr [edx + field_753], 0x5         # 004e122c
    jge.d32 L_004e1301                           # 004e1233
    # block 0x004e1239: entered by fall-through of jge at 0x004e1233, 5 instruction(s), ends with je to 0x004e128c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e1239
    mov ecx, dword ptr [eax + field_753]         # 004e123c
    imul ecx, ecx, 0x1a4                         # 004e1242
    cmp dword ptr [ecx + 0x5a17b4], 0x0          # 004e1248
    je.d8 L_004e128c                             # 004e124f
    # block 0x004e1251: entered by fall-through of je at 0x004e124f, 5 instruction(s), ends with je to 0x004e12ac (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e1251
    mov eax, dword ptr [edx + field_753]         # 004e1254
    imul eax, eax, 0x1a4                         # 004e125a
    cmp dword ptr [eax + 0x5a17b4], 0x0          # 004e1260
    je.d8 L_004e12ac                             # 004e1267
    # block 0x004e1269: entered by fall-through of je at 0x004e1267, 8 instruction(s), calls FUN_004e2956, ends with jne to 0x004e12ac (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e1269
    mov edx, dword ptr [ecx + field_753]         # 004e126c
    imul edx, edx, 0x18f                         # 004e1272
    mov eax, dword ptr [ebp - local_4]           # 004e1278
    lea ecx, [eax + edx + field_757]             # 004e127b
    call FUN_004e2956                            # 004e1282
    cmp eax, 0x3                                 # 004e1287
    jne.d8 L_004e12ac                            # 004e128a
L_004e128c:
    # block 0x004e128c: entered by je at 0x004e124f; fall-through of jne at 0x004e128a, 7 instruction(s), calls FUN_004e2b99, ends with forward jump to 0x004e12fc
    mov ecx, dword ptr [ebp - local_4]           # 004e128c
    mov edx, dword ptr [ecx + field_753]         # 004e128f
    imul edx, edx, 0x18f                         # 004e1295
    mov eax, dword ptr [ebp - local_4]           # 004e129b
    lea ecx, [eax + edx + field_757]             # 004e129e
    call FUN_004e2b99                            # 004e12a5
    jmp.d8 L_004e12fc                            # 004e12aa
L_004e12ac:
    # block 0x004e12ac: entered by je at 0x004e1267; jne at 0x004e128a, 19 instruction(s), calls FUN_004c5377, falls into the block at 0x004e12fc
    push 0x55be80                                # 004e12ac
    mov ecx, dword ptr [ebp - local_4]           # 004e12b1
    mov edx, dword ptr [ecx + field_753]         # 004e12b4
    imul edx, edx, 0x18f                         # 004e12ba
    mov eax, dword ptr [ebp - local_4]           # 004e12c0
    lea ecx, [eax + edx + field_75b]             # 004e12c3
    push ecx                                     # 004e12ca
    mov edx, dword ptr [ebp - local_4]           # 004e12cb
    mov eax, dword ptr [edx + field_753]         # 004e12ce
    imul eax, eax, 0x162                         # 004e12d4
    mov ecx, dword ptr [ebp - local_4]           # 004e12da
    lea edx, [ecx + eax + field_154]             # 004e12dd
    push edx                                     # 004e12e4
    mov eax, dword ptr [0x5cf665]                # 004e12e5
    push eax                                     # 004e12ea
    mov ecx, dword ptr [0x5d0377]                # 004e12eb
    push ecx                                     # 004e12f1
    mov ecx, 0x5cf659                            # 004e12f2
    call FUN_004c5377                            # 004e12f7
L_004e12fc:
    # block 0x004e12fc: entered by jmp at 0x004e12aa, 1 instruction(s), ends with backward jump to 0x004e1214
    jmp.d32 L_004e1214                           # 004e12fc
L_004e1301:
    # block 0x004e1301: entered by jmp at 0x004e1200; jge at 0x004e1233, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e1301
    pop ebp                                      # 004e1303
    ret                                          # 004e1304

