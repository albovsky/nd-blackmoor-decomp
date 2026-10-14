# FUN_00433eaa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00433eaa
# extent:       0x00433eaa-0x00434025 (379 code bytes)
# span:         0x00433eaa-0x00434025 (code 379, tables 0, padding 0)
# sha256:       f0ee25c4ace7be4b20f134aac190d84b298dc481e2b97724855d2e7d4b7949db
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         CHiff::index_data_records
# arguments:    thiscall: ecx=this (spilled); no stack arguments; plain ret; no return value
# locals:       [ebp-4]=declared DATA length read big-endian after a marker; [ebp-8]=byte offset scanned so far; [ebp-0xc]=saved this; edi saved and restored
# fields:       this+0x1008: running scan pointer, initialised from this+0x1118 and advanced bytewise; this+0x1118: extracted resource base pointer; this+0x1124: extracted resource size; this+0x1144[n]: table of DATA marker pointers; this+0x3084[n]: table of DATA extents (declared length + 8); this+0x5f64: DATA count, reset to 0 at entry and incremented per record; globals 0x00545e6c/0x00545e74: the 4-character DATA marker string used twice for its strlen; 0x00583979 and 0x005cf659: objects passed in ecx to the error and quit routines
# callees:      FUN_00434773 = CHiff::is_data_signature (stack arg pointer, returns 1 when the four bytes are DATA); FUN_004347b8 = read big-endian dword at a pointer (stack arg, thiscall); FUN_0042639d = report error (message, caller name; ecx=0x583979); FUN_004c97b4 = post quit message
# track-n:      outputs/blackmoor-decomp/src/hiff.c:scan_data_records
# unverified:   after the too-many-DATAs error the original calls the quit routine and then continues storing into the tables (no early return), a case the native code rejects with HIFF_ERR_LIMIT; the big-endian length read at marker+4 and the skip of marker+16 are not bounds checked against the resource size ; size-3 is an unsigned subtract, so sizes 1 and 2 wrap and the scan is unbounded, and a DATA marker within 7 bytes of the end makes the length read at marker+4 run up to 4 bytes past the buffer (the advance to marker+16 is only a pointer move); Track N rejects these; the identity of the strings at 0x545e6c/0x545e74 as the DATA marker was read from the original data and both have length 4; the name CHiff::index_data_records was chosen by the annotator (the error strings in the binary call this routine CreateDATADatabase); the error-routine argument roles are inferred from their strings; the outer while(1) is a constant-true test (mov ecx,1 / test) kept as written by the compiler
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_declared_length, 0x4  # [ebp - 0x4]
.equ local_offset, 0x8  # [ebp - 0x8]
.equ local_saved_this, 0xc  # [ebp - 0xc]

.equ field_1008, 0x1008  # offset
.equ field_1118, 0x1118  # offset
.equ field_1124, 0x1124  # offset
.equ field_1144, 0x1144  # offset
.equ field_3084, 0x3084  # offset
.equ field_5f64, 0x5f64  # offset

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_00434773, .text + (0x00434773 - 0x401000)
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x00433eaa - 0x401000
.globl FUN_00433eaa
FUN_00433eaa:
    # block 0x00433eaa: function entry: build frame, spill this, offset = 0, this+0x5f64 (DATA count) = 0, this+0x1008 (scan pointer) = this+0x1118 (resource base)
    push ebp                                     # 00433eaa
    {load} mov ebp, esp                          # 00433eab
    sub esp, 0xc                                 # 00433ead
    push edi                                     # 00433eb0
    mov dword ptr [ebp - local_saved_this], ecx           # 00433eb1
    mov dword ptr [ebp - local_offset], 0x0           # 00433eb4
    mov eax, dword ptr [ebp - local_saved_this]           # 00433ebb
    mov dword ptr [eax + field_5f64], 0x0            # 00433ebe
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433ec8
    mov edx, dword ptr [ebp - local_saved_this]           # 00433ecb
    mov eax, dword ptr [edx + field_1118]            # 00433ece
    mov dword ptr [ecx + field_1008], eax            # 00433ed4
L_scan_loop:
    # block 0x00433eda: L_scan_loop: constant-true loop head (mov ecx,1 / test / je never taken to L_return)
    mov ecx, 0x1                                 # 00433eda
    test ecx, ecx                                # 00433edf
    je.d32 L_return                            # 00433ee1
    # block 0x00433ee7: compute size - 3 from this+0x1124 and compare unsigned with offset; offset below it continues to L_probe_signature
    mov edx, dword ptr [ebp - local_saved_this]           # 00433ee7
    mov eax, dword ptr [edx + field_1124]            # 00433eea
    sub eax, 0x3                                 # 00433ef0
    cmp dword ptr [ebp - local_offset], eax           # 00433ef3
    jb.d8 L_probe_signature                             # 00433ef6
    # block 0x00433ef8: offset >= size - 3: scanning is finished, jump to L_return
    jmp.d32 L_return                           # 00433ef8
L_probe_signature:
    # block 0x00433efd: L_probe_signature: call FUN_00434773 with the scan pointer; non-zero (DATA found) goes to L_found_data
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433efd
    mov edx, dword ptr [ecx + field_1008]            # 00433f00
    push edx                                     # 00433f06
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433f07
    call FUN_00434773                            # 00433f0a
    test eax, eax                                # 00433f0f
    jne.d8 L_found_data                            # 00433f11
    # block 0x00433f13: no DATA here: scan pointer + 1, offset + 1, loop to L_scan_loop
    mov eax, dword ptr [ebp - local_saved_this]           # 00433f13
    mov ecx, dword ptr [eax + field_1008]            # 00433f16
    add ecx, 0x1                                 # 00433f1c
    mov edx, dword ptr [ebp - local_saved_this]           # 00433f1f
    mov dword ptr [edx + field_1008], ecx            # 00433f22
    mov eax, dword ptr [ebp - local_offset]           # 00433f28
    add eax, 0x1                                 # 00433f2b
    mov dword ptr [ebp - local_offset], eax           # 00433f2e
    jmp.d8 L_scan_loop                            # 00433f31
L_found_data:
    # block 0x00433f33: L_found_data: signed compare DATA count with 0x3e6; at most 0x3e6 skips the error report
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433f33
    cmp dword ptr [ecx + field_5f64], 0x3e6          # 00433f36
    jle.d8 L_record_data                            # 00433f40
    # block 0x00433f42: count above 0x3e6: report 'too many DATAs' through FUN_0042639d and call the quit routine, then fall into L_record_data (no early return)
    push 0x545e38                                # 00433f42
    push 0x545e4c                                # 00433f47
    mov ecx, 0x583979                            # 00433f4c
    call FUN_0042639d                            # 00433f51
    mov ecx, 0x5cf659                            # 00433f56
    call FUN_004c97b4                            # 00433f5b
L_record_data:
    # block 0x00433f60: L_record_data: this+0x1144[count] = scan pointer; scan pointer and offset advance by the 4-character marker length; declared length = big-endian dword at the scan pointer; this+0x3084[count] = declared length + 8; count++; scan pointer and offset advance by 0xc (record resumes at marker+16); loop to L_scan_loop
    mov edx, dword ptr [ebp - local_saved_this]           # 00433f60
    mov eax, dword ptr [edx + field_5f64]            # 00433f63
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433f69
    mov edx, dword ptr [ebp - local_saved_this]           # 00433f6c
    mov edx, dword ptr [edx + field_1008]            # 00433f6f
    mov dword ptr [ecx + 4*eax + field_1144], edx    # 00433f75
    mov edi, 0x545e6c                            # 00433f7c
    or ecx, -0x1                                 # 00433f81
    {load} xor eax, eax                          # 00433f84
    repne scasb al, byte ptr es:[edi]            # 00433f86
    not ecx                                      # 00433f88
    add ecx, -0x1                                # 00433f8a
    mov eax, dword ptr [ebp - local_saved_this]           # 00433f8d
    mov edx, dword ptr [eax + field_1008]            # 00433f90
    {load} add edx, ecx                          # 00433f96
    mov eax, dword ptr [ebp - local_saved_this]           # 00433f98
    mov dword ptr [eax + field_1008], edx            # 00433f9b
    mov edi, 0x545e74                            # 00433fa1
    or ecx, -0x1                                 # 00433fa6
    {load} xor eax, eax                          # 00433fa9
    repne scasb al, byte ptr es:[edi]            # 00433fab
    not ecx                                      # 00433fad
    add ecx, -0x1                                # 00433faf
    mov edx, dword ptr [ebp - local_offset]           # 00433fb2
    {load} add edx, ecx                          # 00433fb5
    mov dword ptr [ebp - local_offset], edx           # 00433fb7
    mov eax, dword ptr [ebp - local_saved_this]           # 00433fba
    mov ecx, dword ptr [eax + field_1008]            # 00433fbd
    push ecx                                     # 00433fc3
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433fc4
    call FUN_004347b8                            # 00433fc7
    mov dword ptr [ebp - local_declared_length], eax           # 00433fcc
    mov edx, dword ptr [ebp - local_declared_length]           # 00433fcf
    add edx, 0x8                                 # 00433fd2
    mov eax, dword ptr [ebp - local_saved_this]           # 00433fd5
    mov ecx, dword ptr [eax + field_5f64]            # 00433fd8
    mov eax, dword ptr [ebp - local_saved_this]           # 00433fde
    mov dword ptr [eax + 4*ecx + field_3084], edx    # 00433fe1
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433fe8
    mov edx, dword ptr [ecx + field_5f64]            # 00433feb
    add edx, 0x1                                 # 00433ff1
    mov eax, dword ptr [ebp - local_saved_this]           # 00433ff4
    mov dword ptr [eax + field_5f64], edx            # 00433ff7
    mov ecx, dword ptr [ebp - local_saved_this]           # 00433ffd
    mov edx, dword ptr [ecx + field_1008]            # 00434000
    add edx, 0xc                                 # 00434006
    mov eax, dword ptr [ebp - local_saved_this]           # 00434009
    mov dword ptr [eax + field_1008], edx            # 0043400c
    mov ecx, dword ptr [ebp - local_offset]           # 00434012
    add ecx, 0xc                                 # 00434015
    mov dword ptr [ebp - local_offset], ecx           # 00434018
    jmp.d32 L_scan_loop                           # 0043401b
L_return:
    # block 0x00434020: L_return: restore edi, tear down the frame, plain ret
    pop edi                                      # 00434020
    {load} mov esp, ebp                          # 00434021
    pop ebp                                      # 00434023
    ret                                          # 00434024
