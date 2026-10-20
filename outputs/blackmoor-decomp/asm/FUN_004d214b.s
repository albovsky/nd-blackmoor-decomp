# FUN_004d214b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d214b
# extent:       0x004d214b-0x004d2535 (1002 code bytes)
# span:         0x004d214b-0x004d270b (code 1002, tables 470, padding 0)
# sha256:       7e4ab40191c410b5d1640f9ae05dd77711431c9a42735e7ea5b989760638756c
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d214b_lookup_word
# naming:       native port src/original_methods_fl30b.c:m4d214b_lookup_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Byte-to-word lookup (jmp-table switch, 53 mapped values, default 0); all 256 byte values run through the original; window covers the jump and index tables. See fl30b-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_5b, field_61, field_67, field_6d, field_73, field_79, field_7f, field_85, field_8b, field_91, field_97, field_9d and 6 more; [ecx + n] field_59, field_5f, field_65, field_6b, field_71, field_77, field_7d, field_83, field_89, field_8f, field_95, field_9b and 6 more; [edx + n] field_5d, field_63, field_69, field_6f, field_75, field_7b, field_81, field_87, field_8d, field_93, field_99, field_9f and 5 more
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30b.c:m4d214b_lookup_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 235 instruction(s), 1 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_59, 0x59  # offset +0x59
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5d, 0x5d  # offset +0x5d
.equ field_5f, 0x5f  # offset +0x5f
.equ field_61, 0x61  # offset +0x61
.equ field_63, 0x63  # offset +0x63
.equ field_65, 0x65  # offset +0x65
.equ field_67, 0x67  # offset +0x67
.equ field_69, 0x69  # offset +0x69
.equ field_6b, 0x6b  # offset +0x6b
.equ field_6d, 0x6d  # offset +0x6d
.equ field_6f, 0x6f  # offset +0x6f
.equ field_71, 0x71  # offset +0x71
.equ field_73, 0x73  # offset +0x73
.equ field_75, 0x75  # offset +0x75
.equ field_77, 0x77  # offset +0x77
.equ field_79, 0x79  # offset +0x79
.equ field_7b, 0x7b  # offset +0x7b
.equ field_7d, 0x7d  # offset +0x7d
.equ field_7f, 0x7f  # offset +0x7f
.equ field_81, 0x81  # offset +0x81
.equ field_83, 0x83  # offset +0x83
.equ field_85, 0x85  # offset +0x85
.equ field_87, 0x87  # offset +0x87
.equ field_89, 0x89  # offset +0x89
.equ field_8b, 0x8b  # offset +0x8b
.equ field_8d, 0x8d  # offset +0x8d
.equ field_8f, 0x8f  # offset +0x8f
.equ field_91, 0x91  # offset +0x91
.equ field_93, 0x93  # offset +0x93
.equ field_95, 0x95  # offset +0x95
.equ field_97, 0x97  # offset +0x97
.equ field_99, 0x99  # offset +0x99
.equ field_9b, 0x9b  # offset +0x9b
.equ field_9d, 0x9d  # offset +0x9d
.equ field_9f, 0x9f  # offset +0x9f
.equ field_a1, 0xa1  # offset +0xa1
.equ field_a3, 0xa3  # offset +0xa3
.equ field_a5, 0xa5  # offset +0xa5
.equ field_a7, 0xa7  # offset +0xa7
.equ field_a9, 0xa9  # offset +0xa9
.equ field_ab, 0xab  # offset +0xab
.equ field_ad, 0xad  # offset +0xad
.equ field_af, 0xaf  # offset +0xaf
.equ field_b1, 0xb1  # offset +0xb1
.equ field_b3, 0xb3  # offset +0xb3
.equ field_b5, 0xb5  # offset +0xb5
.equ field_b7, 0xb7  # offset +0xb7
.equ field_b9, 0xb9  # offset +0xb9
.equ field_bb, 0xbb  # offset +0xbb
.equ field_bd, 0xbd  # offset +0xbd
.equ field_bf, 0xbf  # offset +0xbf
.equ field_c1, 0xc1  # offset +0xc1

# --- external targets -----------------------------------------------

.org 0x004d214b - 0x401000
.globl FUN_004d214b
FUN_004d214b:
    # block 0x004d214b: entry, 10 instruction(s), ends with ja to 0x004d251e (forward)
    push ebp                                     # 004d214b
    {load} mov ebp, esp                          # 004d214c
    sub esp, 0x8                                 # 004d214e
    movsx eax, byte ptr [ebp + arg_8]            # 004d2151
    mov dword ptr [ebp - local_8], eax           # 004d2155
    mov ecx, dword ptr [ebp - local_8]           # 004d2158
    add ecx, 0x80                                # 004d215b
    mov dword ptr [ebp - local_8], ecx           # 004d2161
    cmp dword ptr [ebp - local_8], 0xfd          # 004d2164
    ja.d32 L_004d251e                            # 004d216b
    # block 0x004d2171: entered by fall-through of ja at 0x004d216b, 4 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4d2535]
    mov eax, dword ptr [ebp - local_8]           # 004d2171
    {load} xor edx, edx                          # 004d2174
    mov dl, byte ptr [eax + IDXTAB_004d260d_VA]  # 004d2176
    jmp dword ptr [4*edx + SWTAB_004d2535_VA]    # 004d217c
L_004d2183:
    # block 0x004d2183: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d2183
    mov dx, word ptr [ecx + field_59]            # 004d2186
    mov word ptr [ebp - local_4], dx             # 004d218a
    jmp.d32 L_004d2522                           # 004d218e
L_004d2193:
    # block 0x004d2193: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2193
    mov cx, word ptr [eax + field_5b]            # 004d2196
    mov word ptr [ebp - local_4], cx             # 004d219a
    jmp.d32 L_004d2522                           # 004d219e
L_004d21a3:
    # block 0x004d21a3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d21a3
    mov ax, word ptr [edx + field_5d]            # 004d21a6
    mov word ptr [ebp - local_4], ax             # 004d21aa
    jmp.d32 L_004d2522                           # 004d21ae
L_004d21b3:
    # block 0x004d21b3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d21b3
    mov dx, word ptr [ecx + field_5f]            # 004d21b6
    mov word ptr [ebp - local_4], dx             # 004d21ba
    jmp.d32 L_004d2522                           # 004d21be
L_004d21c3:
    # block 0x004d21c3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d21c3
    mov cx, word ptr [eax + field_61]            # 004d21c6
    mov word ptr [ebp - local_4], cx             # 004d21ca
    jmp.d32 L_004d2522                           # 004d21ce
L_004d21d3:
    # block 0x004d21d3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d21d3
    mov ax, word ptr [edx + field_63]            # 004d21d6
    mov word ptr [ebp - local_4], ax             # 004d21da
    jmp.d32 L_004d2522                           # 004d21de
L_004d21e3:
    # block 0x004d21e3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d21e3
    mov dx, word ptr [ecx + field_65]            # 004d21e6
    mov word ptr [ebp - local_4], dx             # 004d21ea
    jmp.d32 L_004d2522                           # 004d21ee
L_004d21f3:
    # block 0x004d21f3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d21f3
    mov cx, word ptr [eax + field_67]            # 004d21f6
    mov word ptr [ebp - local_4], cx             # 004d21fa
    jmp.d32 L_004d2522                           # 004d21fe
L_004d2203:
    # block 0x004d2203: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d2203
    mov ax, word ptr [edx + field_69]            # 004d2206
    mov word ptr [ebp - local_4], ax             # 004d220a
    jmp.d32 L_004d2522                           # 004d220e
L_004d2213:
    # block 0x004d2213: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d2213
    mov dx, word ptr [ecx + field_6b]            # 004d2216
    mov word ptr [ebp - local_4], dx             # 004d221a
    jmp.d32 L_004d2522                           # 004d221e
L_004d2223:
    # block 0x004d2223: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2223
    mov cx, word ptr [eax + field_6d]            # 004d2226
    mov word ptr [ebp - local_4], cx             # 004d222a
    jmp.d32 L_004d2522                           # 004d222e
L_004d2233:
    # block 0x004d2233: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d2233
    mov ax, word ptr [edx + field_6f]            # 004d2236
    mov word ptr [ebp - local_4], ax             # 004d223a
    jmp.d32 L_004d2522                           # 004d223e
L_004d2243:
    # block 0x004d2243: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d2243
    mov dx, word ptr [ecx + field_71]            # 004d2246
    mov word ptr [ebp - local_4], dx             # 004d224a
    jmp.d32 L_004d2522                           # 004d224e
L_004d2253:
    # block 0x004d2253: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2253
    mov cx, word ptr [eax + field_73]            # 004d2256
    mov word ptr [ebp - local_4], cx             # 004d225a
    jmp.d32 L_004d2522                           # 004d225e
L_004d2263:
    # block 0x004d2263: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d2263
    mov ax, word ptr [edx + field_75]            # 004d2266
    mov word ptr [ebp - local_4], ax             # 004d226a
    jmp.d32 L_004d2522                           # 004d226e
L_004d2273:
    # block 0x004d2273: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d2273
    mov dx, word ptr [ecx + field_77]            # 004d2276
    mov word ptr [ebp - local_4], dx             # 004d227a
    jmp.d32 L_004d2522                           # 004d227e
L_004d2283:
    # block 0x004d2283: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2283
    mov cx, word ptr [eax + field_79]            # 004d2286
    mov word ptr [ebp - local_4], cx             # 004d228a
    jmp.d32 L_004d2522                           # 004d228e
L_004d2293:
    # block 0x004d2293: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d2293
    mov ax, word ptr [edx + field_7b]            # 004d2296
    mov word ptr [ebp - local_4], ax             # 004d229a
    jmp.d32 L_004d2522                           # 004d229e
L_004d22a3:
    # block 0x004d22a3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d22a3
    mov dx, word ptr [ecx + field_7d]            # 004d22a6
    mov word ptr [ebp - local_4], dx             # 004d22aa
    jmp.d32 L_004d2522                           # 004d22ae
L_004d22b3:
    # block 0x004d22b3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d22b3
    mov cx, word ptr [eax + field_7f]            # 004d22b6
    mov word ptr [ebp - local_4], cx             # 004d22ba
    jmp.d32 L_004d2522                           # 004d22be
L_004d22c3:
    # block 0x004d22c3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d22c3
    mov ax, word ptr [edx + field_81]            # 004d22c6
    mov word ptr [ebp - local_4], ax             # 004d22cd
    jmp.d32 L_004d2522                           # 004d22d1
L_004d22d6:
    # block 0x004d22d6: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d22d6
    mov dx, word ptr [ecx + field_83]            # 004d22d9
    mov word ptr [ebp - local_4], dx             # 004d22e0
    jmp.d32 L_004d2522                           # 004d22e4
L_004d22e9:
    # block 0x004d22e9: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d22e9
    mov cx, word ptr [eax + field_85]            # 004d22ec
    mov word ptr [ebp - local_4], cx             # 004d22f3
    jmp.d32 L_004d2522                           # 004d22f7
L_004d22fc:
    # block 0x004d22fc: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d22fc
    mov ax, word ptr [edx + field_87]            # 004d22ff
    mov word ptr [ebp - local_4], ax             # 004d2306
    jmp.d32 L_004d2522                           # 004d230a
L_004d230f:
    # block 0x004d230f: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d230f
    mov dx, word ptr [ecx + field_89]            # 004d2312
    mov word ptr [ebp - local_4], dx             # 004d2319
    jmp.d32 L_004d2522                           # 004d231d
L_004d2322:
    # block 0x004d2322: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2322
    mov cx, word ptr [eax + field_8b]            # 004d2325
    mov word ptr [ebp - local_4], cx             # 004d232c
    jmp.d32 L_004d2522                           # 004d2330
L_004d2335:
    # block 0x004d2335: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d2335
    mov ax, word ptr [edx + field_8d]            # 004d2338
    mov word ptr [ebp - local_4], ax             # 004d233f
    jmp.d32 L_004d2522                           # 004d2343
L_004d2348:
    # block 0x004d2348: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d2348
    mov dx, word ptr [ecx + field_8f]            # 004d234b
    mov word ptr [ebp - local_4], dx             # 004d2352
    jmp.d32 L_004d2522                           # 004d2356
L_004d235b:
    # block 0x004d235b: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d235b
    mov cx, word ptr [eax + field_91]            # 004d235e
    mov word ptr [ebp - local_4], cx             # 004d2365
    jmp.d32 L_004d2522                           # 004d2369
L_004d236e:
    # block 0x004d236e: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d236e
    mov ax, word ptr [edx + field_93]            # 004d2371
    mov word ptr [ebp - local_4], ax             # 004d2378
    jmp.d32 L_004d2522                           # 004d237c
L_004d2381:
    # block 0x004d2381: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d2381
    mov dx, word ptr [ecx + field_95]            # 004d2384
    mov word ptr [ebp - local_4], dx             # 004d238b
    jmp.d32 L_004d2522                           # 004d238f
L_004d2394:
    # block 0x004d2394: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2394
    mov cx, word ptr [eax + field_97]            # 004d2397
    mov word ptr [ebp - local_4], cx             # 004d239e
    jmp.d32 L_004d2522                           # 004d23a2
L_004d23a7:
    # block 0x004d23a7: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d23a7
    mov ax, word ptr [edx + field_99]            # 004d23aa
    mov word ptr [ebp - local_4], ax             # 004d23b1
    jmp.d32 L_004d2522                           # 004d23b5
L_004d23ba:
    # block 0x004d23ba: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d23ba
    mov dx, word ptr [ecx + field_9b]            # 004d23bd
    mov word ptr [ebp - local_4], dx             # 004d23c4
    jmp.d32 L_004d2522                           # 004d23c8
L_004d23cd:
    # block 0x004d23cd: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d23cd
    mov cx, word ptr [eax + field_9d]            # 004d23d0
    mov word ptr [ebp - local_4], cx             # 004d23d7
    jmp.d32 L_004d2522                           # 004d23db
L_004d23e0:
    # block 0x004d23e0: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d23e0
    mov ax, word ptr [edx + field_9f]            # 004d23e3
    mov word ptr [ebp - local_4], ax             # 004d23ea
    jmp.d32 L_004d2522                           # 004d23ee
L_004d23f3:
    # block 0x004d23f3: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d23f3
    mov dx, word ptr [ecx + field_a1]            # 004d23f6
    mov word ptr [ebp - local_4], dx             # 004d23fd
    jmp.d32 L_004d2522                           # 004d2401
L_004d2406:
    # block 0x004d2406: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2406
    mov cx, word ptr [eax + field_a3]            # 004d2409
    mov word ptr [ebp - local_4], cx             # 004d2410
    jmp.d32 L_004d2522                           # 004d2414
L_004d2419:
    # block 0x004d2419: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d2419
    mov ax, word ptr [edx + field_a5]            # 004d241c
    mov word ptr [ebp - local_4], ax             # 004d2423
    jmp.d32 L_004d2522                           # 004d2427
L_004d242c:
    # block 0x004d242c: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d242c
    mov dx, word ptr [ecx + field_a7]            # 004d242f
    mov word ptr [ebp - local_4], dx             # 004d2436
    jmp.d32 L_004d2522                           # 004d243a
L_004d243f:
    # block 0x004d243f: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d243f
    mov cx, word ptr [eax + field_a9]            # 004d2442
    mov word ptr [ebp - local_4], cx             # 004d2449
    jmp.d32 L_004d2522                           # 004d244d
L_004d2452:
    # block 0x004d2452: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d2452
    mov ax, word ptr [edx + field_ab]            # 004d2455
    mov word ptr [ebp - local_4], ax             # 004d245c
    jmp.d32 L_004d2522                           # 004d2460
L_004d2465:
    # block 0x004d2465: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d2465
    mov dx, word ptr [ecx + field_ad]            # 004d2468
    mov word ptr [ebp - local_4], dx             # 004d246f
    jmp.d32 L_004d2522                           # 004d2473
L_004d2478:
    # block 0x004d2478: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d2478
    mov cx, word ptr [eax + field_af]            # 004d247b
    mov word ptr [ebp - local_4], cx             # 004d2482
    jmp.d32 L_004d2522                           # 004d2486
L_004d248b:
    # block 0x004d248b: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d248b
    mov ax, word ptr [edx + field_b1]            # 004d248e
    mov word ptr [ebp - local_4], ax             # 004d2495
    jmp.d32 L_004d2522                           # 004d2499
L_004d249e:
    # block 0x004d249e: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d249e
    mov dx, word ptr [ecx + field_b3]            # 004d24a1
    mov word ptr [ebp - local_4], dx             # 004d24a8
    jmp.d8 L_004d2522                            # 004d24ac
L_004d24ae:
    # block 0x004d24ae: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d24ae
    mov cx, word ptr [eax + field_b5]            # 004d24b1
    mov word ptr [ebp - local_4], cx             # 004d24b8
    jmp.d8 L_004d2522                            # 004d24bc
L_004d24be:
    # block 0x004d24be: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d24be
    mov ax, word ptr [edx + field_b7]            # 004d24c1
    mov word ptr [ebp - local_4], ax             # 004d24c8
    jmp.d8 L_004d2522                            # 004d24cc
L_004d24ce:
    # block 0x004d24ce: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d24ce
    mov dx, word ptr [ecx + field_b9]            # 004d24d1
    mov word ptr [ebp - local_4], dx             # 004d24d8
    jmp.d8 L_004d2522                            # 004d24dc
L_004d24de:
    # block 0x004d24de: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d24de
    mov cx, word ptr [eax + field_bb]            # 004d24e1
    mov word ptr [ebp - local_4], cx             # 004d24e8
    jmp.d8 L_004d2522                            # 004d24ec
L_004d24ee:
    # block 0x004d24ee: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov edx, dword ptr [ebp + arg_c]             # 004d24ee
    mov ax, word ptr [edx + field_bd]            # 004d24f1
    mov word ptr [ebp - local_4], ax             # 004d24f8
    jmp.d8 L_004d2522                            # 004d24fc
L_004d24fe:
    # block 0x004d24fe: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov ecx, dword ptr [ebp + arg_c]             # 004d24fe
    mov dx, word ptr [ecx + field_bf]            # 004d2501
    mov word ptr [ebp - local_4], dx             # 004d2508
    jmp.d8 L_004d2522                            # 004d250c
L_004d250e:
    # block 0x004d250e: entered by switch case, 4 instruction(s), ends with forward jump to 0x004d2522
    mov eax, dword ptr [ebp + arg_c]             # 004d250e
    mov cx, word ptr [eax + field_c1]            # 004d2511
    mov word ptr [ebp - local_4], cx             # 004d2518
    jmp.d8 L_004d2522                            # 004d251c
L_004d251e:
    # block 0x004d251e: entered by ja at 0x004d216b; switch case, 2 instruction(s), ends with forward jump to 0x004d2531
    {load} xor eax, eax                          # 004d251e
    jmp.d8 L_004d2531                            # 004d2520
L_004d2522:
    # block 0x004d2522: entered by jmp at 0x004d218e; jmp at 0x004d219e; jmp at 0x004d21ae; jmp at 0x004d21be; more, 4 instruction(s), falls into the block at 0x004d2531
    mov edx, dword ptr [ebp + arg_10]            # 004d2522
    mov ax, word ptr [ebp - local_4]             # 004d2525
    mov word ptr [edx], ax                       # 004d2529
    mov eax, 0x1                                 # 004d252c
L_004d2531:
    # block 0x004d2531: entered by jmp at 0x004d2520, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d2531
    pop ebp                                      # 004d2533
    ret                                          # 004d2534

# --- data items (not part of the function) -------------------------
.org 0x004d2535 - 0x401000
SWTAB_004d2535:  # 54 case address(es)
    .long L_004d250e - .text + 0x401000
    .long L_004d23ba - .text + 0x401000
    .long L_004d23cd - .text + 0x401000
    .long L_004d22fc - .text + 0x401000
    .long L_004d2348 - .text + 0x401000
    .long L_004d248b - .text + 0x401000
    .long L_004d2406 - .text + 0x401000
    .long L_004d23e0 - .text + 0x401000
    .long L_004d236e - .text + 0x401000
    .long L_004d2394 - .text + 0x401000
    .long L_004d2465 - .text + 0x401000
    .long L_004d2283 - .text + 0x401000
    .long L_004d2419 - .text + 0x401000
    .long L_004d230f - .text + 0x401000
    .long L_004d235b - .text + 0x401000
    .long L_004d249e - .text + 0x401000
    .long L_004d2293 - .text + 0x401000
    .long L_004d22a3 - .text + 0x401000
    .long L_004d22b3 - .text + 0x401000
    .long L_004d22c3 - .text + 0x401000
    .long L_004d22d6 - .text + 0x401000
    .long L_004d242c - .text + 0x401000
    .long L_004d2322 - .text + 0x401000
    .long L_004d23f3 - .text + 0x401000
    .long L_004d243f - .text + 0x401000
    .long L_004d22e9 - .text + 0x401000
    .long L_004d2381 - .text + 0x401000
    .long L_004d2335 - .text + 0x401000
    .long L_004d2452 - .text + 0x401000
    .long L_004d23a7 - .text + 0x401000
    .long L_004d21e3 - .text + 0x401000
    .long L_004d24ae - .text + 0x401000
    .long L_004d24be - .text + 0x401000
    .long L_004d21f3 - .text + 0x401000
    .long L_004d2203 - .text + 0x401000
    .long L_004d2253 - .text + 0x401000
    .long L_004d2223 - .text + 0x401000
    .long L_004d2233 - .text + 0x401000
    .long L_004d2213 - .text + 0x401000
    .long L_004d2243 - .text + 0x401000
    .long L_004d2193 - .text + 0x401000
    .long L_004d21c3 - .text + 0x401000
    .long L_004d2183 - .text + 0x401000
    .long L_004d2273 - .text + 0x401000
    .long L_004d21b3 - .text + 0x401000
    .long L_004d2263 - .text + 0x401000
    .long L_004d24ce - .text + 0x401000
    .long L_004d21a3 - .text + 0x401000
    .long L_004d24de - .text + 0x401000
    .long L_004d21d3 - .text + 0x401000
    .long L_004d2478 - .text + 0x401000
    .long L_004d24ee - .text + 0x401000
    .long L_004d24fe - .text + 0x401000
    .long L_004d251e - .text + 0x401000
.org 0x004d260d - 0x401000
IDXTAB_004d260d:  # index table of FUN_004d214b for the switch jump at 0x004d217c (254 byte(s))
    .byte 0, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53
    .byte 53, 1, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 2
    .byte 3, 53, 53, 53, 4, 5, 53, 53, 53, 6, 53, 53, 53, 53, 53, 53
    .byte 53, 7, 53, 53, 53, 53, 8, 53, 53, 53, 53, 53, 9, 53, 53, 10
    .byte 11, 12, 13, 53, 14, 15, 53, 16, 17, 18, 19, 20, 53, 21, 22, 53
    .byte 53, 23, 53, 24, 25, 53, 26, 53, 53, 27, 28, 53, 29, 53, 53, 53
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53
    .byte 53, 30, 53, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 44, 45, 46, 47, 48, 49
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 50
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53
    .byte 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 51, 53, 52
.set SWTAB_004d2535_VA, SWTAB_004d2535 - .text + 0x401000
.set IDXTAB_004d260d_VA, IDXTAB_004d260d - .text + 0x401000

