# FUN_0042b2e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042b2e4
# extent:       0x0042b2e4-0x0042b510 (556 code bytes)
# span:         0x0042b2e4-0x0042b510 (code 556, tables 0, padding 0)
# sha256:       42f18431421029a9cc80c950e85be0b860c58e13d5f34687e1e4b7599860e447
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         ActionSlot::execute_frame_hotspot_action
# arguments:    cdecl-style: [ebp+8] = action slot index (signed 16-bit read, movsx of the low word of the dword argument); plain ret, the caller pops it; no return value (eax is scratch); no this (ecx unused)
# locals:       [ebp-local_phase] = dword, the slot phase read from 0x5bb632 + slot*0x8d (slot+0x4f with slot base 0x5bb5e3); [ebp-local_rec_index] = signed 16-bit payload record loop counter
# fields:       Action slot table, slot i at 0x5bb5e3 + i*0x8d (stride 0x8d): 0x5bb5e5 (slot+2) dword payload pointer, read; 0x5bb625 (slot+0x42) byte completion latch, written 1 in phase 2; 0x5bb626 (slot+0x43) dword hotspot-active flag, written 0 then 1 on a frame match; 0x5bb62a/0x5bb62c/0x5bb62e/0x5bb630 (slot+0x47/+0x49/+0x4b/+0x4d) words, hotspot rectangle exported from the matching record; 0x5bb632 (slot+0x4f) dword phase, read, and set to 1 when it was 0. Payload (via the slot payload pointer): +0x02, +0x04, +0x06 words, scene request values read in phase 2; +0x08 signed word record count; records of 0x12 bytes starting at payload+0x0a, record+0 word frame, record+2 / +6 / +0xa / +0xe words copied (payload+0xc, +0x10, +0x14, +0x18). Globals: 0x005bb1ca dword written 1 when phase was 0; 0x005bb50b word read (current frame); phase 2 writes 0x005bb57b (dword, sign-extended payload word +2), 0x005bb599 (word, payload word +4), 0x005c39ff (word, payload word +6), 0x005bb595 (word 0), 0x005bb59b (dword 0), 0x005bb59f (dword 0), 0x005bb5a3 (dword 1), 0x00583999 (dword 4, engine state)
# callees:      none
# track-n:      host-adapter: none
# unverified:   The name is my label. Evidence for its role: the unverified pseudocode of FUN_00427a50 calls this routine from the case for slot type byte 0x0c (after FUN_00423f57 with mode 0 says the dependency tree is satisfied), and s0-action-runtime-trace.md documents the slot layout (stride 0x8d, completion latch +0x42, hotspot-active +0x43, rectangle +0x47..+0x4d, phase +0x4f, payload pointer +2); the slot base 0x5bb5e3 is that trace plus the 427a50 switch on the byte at 0x5bb5e3. The trace documents the hotspot executors for types 0x0d (FUN_0042ae73) and 0x6a (FUN_0042e844), not type 0x0c; this routine has the same structure as FUN_0042e844 as described there (frame match then rectangle export) but that identity is not claimed. Phases are only the three values 0, 1, 2 that the bytes test; any other phase value returns without effect. Meaning of the payload words at +2, +4, +6 (copied to 0x5bb57b, 0x5bb599, 0x5c39ff in phase 2), of the globals 0x5bb1ca, 0x5bb595, 0x5bb59b, 0x5bb59f, 0x5bb5a3 and of the value 4 stored to 0x583999 is not established beyond Track N labels (caption_lifecycle.h names 0x5bb57b scene_request, 0x5c39ff scene_request_flag and 0x583999 engine_state). The rectangle edge order (left, top, right, bottom) rests on the trace and FUN_0042ae73, not on a read of the consumer here. Out-of-range slot indices and negative record counts are not guarded in the original.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_rec_index, 0x4  # [ebp - 0x4]: signed 16-bit payload record loop counter (word)
.equ local_phase, 0x8  # [ebp - 0x8]: slot phase dword read from slot+0x4f
.equ arg_slot, 0x8  # [ebp + 0x8]: action slot index (low word, signed)

# --- fields of the slot payload ------------------------------------------
.equ pay_req_word_2, 0x2  # payload+0x2: signed word, sign-extended into 0x5bb57b in phase 2
.equ pay_req_word_4, 0x4  # payload+0x4: word, stored to 0x5bb599 in phase 2
.equ pay_req_word_6, 0x6  # payload+0x6: word, stored to 0x5c39ff in phase 2
.equ pay_record_count, 0x8  # payload+0x8: signed word, number of 0x12-byte records
.equ rec_frame, 0xa  # payload+0xa+i*0x12: signed word, record frame compared with the word at 0x5bb50b
.equ rec_left, 0xc  # payload+0xc+i*0x12: word copied to slot+0x47 (0x5bb62a)
.equ rec_top, 0x10  # payload+0x10+i*0x12: word copied to slot+0x49 (0x5bb62c)
.equ rec_right, 0x14  # payload+0x14+i*0x12: word copied to slot+0x4b (0x5bb62e)
.equ rec_bottom, 0x18  # payload+0x18+i*0x12: word copied to slot+0x4d (0x5bb630)

# --- external targets -----------------------------------------------

.org 0x0042b2e4 - 0x401000
.globl FUN_0042b2e4
FUN_0042b2e4:
    # block 0x0042b2e4: entry: phase = dword at 0x5bb632 + slot*0x8d (slot index is the sign-extended low word of the argument); if the phase is 0 jump to phase_zero_start (je)
    push ebp                                     # 0042b2e4
    {load} mov ebp, esp                          # 0042b2e5
    sub esp, 0x8                                 # 0042b2e7
    movsx eax, word ptr [ebp + arg_slot]            # 0042b2ea
    imul eax, eax, 0x8d                          # 0042b2ee
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042b2f4
    mov dword ptr [ebp - local_phase], ecx           # 0042b2fa
    cmp dword ptr [ebp - local_phase], 0x0           # 0042b2fd
    je.d8 phase_zero_start                             # 0042b301
    # block 0x0042b303: phase != 0: if phase == 1 jump to phase_one_scan (je)
    cmp dword ptr [ebp - local_phase], 0x1           # 0042b303
    je.d8 phase_one_scan                             # 0042b307
    # block 0x0042b309: phase not 0 or 1: if phase == 2 jump to phase_two_complete (je)
    cmp dword ptr [ebp - local_phase], 0x2           # 0042b309
    je.d32 phase_two_complete                            # 0042b30d
    # block 0x0042b313: any other phase: jump to the epilogue, no effect
    jmp.d32 epilogue                           # 0042b313
phase_zero_start:
    # block 0x0042b318: phase 0: 0x5bb1ca = 1, slot phase (0x5bb632 + slot*0x8d) = 1, then fall into phase_one_scan
    mov dword ptr [0x5bb1ca], 0x1                # 0042b318
    movsx edx, word ptr [ebp + arg_slot]            # 0042b322
    imul edx, edx, 0x8d                          # 0042b326
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042b32c
phase_one_scan:
    # block 0x0042b336: phase 1 (also reached from phase 0): hotspot-active dword slot+0x43 (0x5bb626) = 0, record index = 0, jump to scan_test
    movsx eax, word ptr [ebp + arg_slot]            # 0042b336
    imul eax, eax, 0x8d                          # 0042b33a
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042b340
    mov word ptr [ebp - local_rec_index], 0x0            # 0042b34a
    jmp.d8 scan_test                            # 0042b350
scan_next_record:
    # block 0x0042b352: scan increment: record index = (word) index + 1
    mov cx, word ptr [ebp - local_rec_index]             # 0042b352
    add cx, 0x1                                  # 0042b356
    mov word ptr [ebp - local_rec_index], cx             # 0042b35a
scan_test:
    # block 0x0042b35e: scan test: sign-extend the index and the payload record count (word payload+8); if index >= count (jge) the scan ends: jump to done_scan
    movsx edx, word ptr [ebp - local_rec_index]          # 0042b35e
    movsx eax, word ptr [ebp + arg_slot]            # 0042b362
    imul eax, eax, 0x8d                          # 0042b366
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042b36c
    movsx eax, word ptr [ecx + pay_record_count]          # 0042b372
    {load} cmp edx, eax                          # 0042b376
    jge.d32 done_scan                           # 0042b378
    # block 0x0042b37e: compare record frame: if the signed word at payload+0xa+index*0x12 differs from the signed word at 0x5bb50b jump to record_mismatch (jne)
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b37e
    imul ecx, ecx, 0x8d                          # 0042b382
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b388
    movsx eax, word ptr [ebp - local_rec_index]          # 0042b38e
    imul eax, eax, 0x12                          # 0042b392
    movsx ecx, word ptr [edx + eax + rec_frame]    # 0042b395
    movsx edx, word ptr [0x5bb50b]               # 0042b39a
    {load} cmp ecx, edx                          # 0042b3a1
    jne.d32 record_mismatch                           # 0042b3a3
    # block 0x0042b3a9: frame match: slot+0x43 (0x5bb626) = 1; copy the four rectangle words from the record (payload+0xc, +0x10, +0x14, +0x18 plus index*0x12) to slot+0x47 (0x5bb62a), +0x49 (0x5bb62c), +0x4b (0x5bb62e), +0x4d (0x5bb630); stop scanning (jump to done_scan)
    movsx eax, word ptr [ebp + arg_slot]            # 0042b3a9
    imul eax, eax, 0x8d                          # 0042b3ad
    mov dword ptr [eax + 0x5bb626], 0x1          # 0042b3b3
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b3bd
    imul ecx, ecx, 0x8d                          # 0042b3c1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b3c7
    movsx eax, word ptr [ebp - local_rec_index]          # 0042b3cd
    imul eax, eax, 0x12                          # 0042b3d1
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b3d4
    imul ecx, ecx, 0x8d                          # 0042b3d8
    mov dx, word ptr [edx + eax + rec_left]       # 0042b3de
    mov word ptr [ecx + 0x5bb62a], dx            # 0042b3e3
    movsx eax, word ptr [ebp + arg_slot]            # 0042b3ea
    imul eax, eax, 0x8d                          # 0042b3ee
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042b3f4
    movsx edx, word ptr [ebp - local_rec_index]          # 0042b3fa
    imul edx, edx, 0x12                          # 0042b3fe
    movsx eax, word ptr [ebp + arg_slot]            # 0042b401
    imul eax, eax, 0x8d                          # 0042b405
    mov cx, word ptr [ecx + edx + rec_top]      # 0042b40b
    mov word ptr [eax + 0x5bb62c], cx            # 0042b410
    movsx edx, word ptr [ebp + arg_slot]            # 0042b417
    imul edx, edx, 0x8d                          # 0042b41b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b421
    movsx ecx, word ptr [ebp - local_rec_index]          # 0042b427
    imul ecx, ecx, 0x12                          # 0042b42b
    movsx edx, word ptr [ebp + arg_slot]            # 0042b42e
    imul edx, edx, 0x8d                          # 0042b432
    mov ax, word ptr [eax + ecx + rec_right]      # 0042b438
    mov word ptr [edx + 0x5bb62e], ax            # 0042b43d
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b444
    imul ecx, ecx, 0x8d                          # 0042b448
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b44e
    movsx eax, word ptr [ebp - local_rec_index]          # 0042b454
    imul eax, eax, 0x12                          # 0042b458
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b45b
    imul ecx, ecx, 0x8d                          # 0042b45f
    mov dx, word ptr [edx + eax + rec_bottom]      # 0042b465
    mov word ptr [ecx + 0x5bb630], dx            # 0042b46a
    jmp.d8 done_scan                            # 0042b471
record_mismatch:
    # block 0x0042b473: record mismatch: go to scan_next_record
    jmp.d32 scan_next_record                           # 0042b473
done_scan:
    # block 0x0042b478: scan finished (match found or no records left): jump to the epilogue
    jmp.d32 epilogue                           # 0042b478
phase_two_complete:
    # block 0x0042b47d: phase 2: completion latch byte slot+0x42 (0x5bb625) = 1; 0x5bb57b = sign-extended payload word +2; 0x5bb599 = payload word +4; 0x5c39ff = payload word +6; 0x5bb595 = 0 (word); 0x5bb59b = 0; 0x5bb59f = 0; 0x5bb5a3 = 1; 0x583999 = 4
    movsx eax, word ptr [ebp + arg_slot]            # 0042b47d
    imul eax, eax, 0x8d                          # 0042b481
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042b487
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b48e
    imul ecx, ecx, 0x8d                          # 0042b492
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b498
    movsx eax, word ptr [edx + pay_req_word_2]          # 0042b49e
    mov dword ptr [0x5bb57b], eax                # 0042b4a2
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b4a7
    imul ecx, ecx, 0x8d                          # 0042b4ab
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b4b1
    mov ax, word ptr [edx + pay_req_word_4]             # 0042b4b7
    mov word ptr [0x5bb599], ax                  # 0042b4bb
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b4c1
    imul ecx, ecx, 0x8d                          # 0042b4c5
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b4cb
    mov ax, word ptr [edx + pay_req_word_6]             # 0042b4d1
    mov word ptr [0x5c39ff], ax                  # 0042b4d5
    mov word ptr [0x5bb595], 0x0                 # 0042b4db
    mov dword ptr [0x5bb59b], 0x0                # 0042b4e4
    mov dword ptr [0x5bb59f], 0x0                # 0042b4ee
    mov dword ptr [0x5bb5a3], 0x1                # 0042b4f8
    mov dword ptr [0x583999], 0x4                # 0042b502
epilogue:
    # block 0x0042b50c: epilogue: restore the frame and return (plain ret, the caller pops the argument)
    {load} mov esp, ebp                          # 0042b50c
    pop ebp                                      # 0042b50e
    ret                                          # 0042b50f
