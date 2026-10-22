# FUN_00521ef1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521ef1
# extent:       0x00521ef1-0x00521f4d (92 code bytes)
# span:         0x00521ef1-0x00521f4d (code 92, tables 0, padding 0)
# sha256:       49fee45cb8a595f14fdc6cd50255bb84572b28058dd786bddf5450e6f1a3169a
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521ef1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_minus_4, field_minus_c, field_minus_10; [esi + n] field_64, field_78
# callees:      calls FUN_0050f978, FUN_0051a7c3, FUN_0051a0ee, FUN_0051e8f7, FUN_00521f4d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_64, 0x64  # offset +0x64
.equ field_78, 0x78  # offset +0x78

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a0ee, .text + (0x0051a0ee - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)
.set FUN_00521f4d, .text + (0x00521f4d - 0x401000)

.org 0x00521ef1 - 0x401000
.globl FUN_00521ef1
FUN_00521ef1:
    # block 0x00521ef1: entry, 27 instruction(s), calls FUN_0050f978, FUN_0051a7c3, FUN_0051a0ee, FUN_0051e8f7, FUN_00521f4d, ends with ret 0xc
    mov eax, 0x528cea                            # 00521ef1
    call FUN_0050f978                            # 00521ef6
    push ecx                                     # 00521efb
    push esi                                     # 00521efc
    {load} mov esi, ecx                          # 00521efd
    mov dword ptr [ebp - field_minus_10], esi    # 00521eff
    call FUN_0051a7c3                            # 00521f02
    and dword ptr [ebp - field_minus_4], 0x0     # 00521f07
    lea ecx, [esi + field_64]                    # 00521f0b
    call FUN_0051a0ee                            # 00521f0e
    mov eax, dword ptr [0x5679b0]                # 00521f13
    lea ecx, [esi + field_78]                    # 00521f18
    mov dword ptr [ecx], eax                     # 00521f1b
    push dword ptr [ebp + field_8]               # 00521f1d
    mov byte ptr [ebp - field_minus_4], 0x2      # 00521f20
    mov dword ptr [esi], 0x52f0c8                # 00521f24
    call FUN_0051e8f7                            # 00521f2a
    push dword ptr [ebp + field_10]              # 00521f2f
    {load} mov ecx, esi                          # 00521f32
    push dword ptr [ebp + field_c]               # 00521f34
    call FUN_00521f4d                            # 00521f37
    mov ecx, dword ptr [ebp - field_minus_c]     # 00521f3c
    {load} mov eax, esi                          # 00521f3f
    pop esi                                      # 00521f41
    mov dword ptr fs:[0x0], ecx                  # 00521f42
    leave                                        # 00521f49
    ret 0xc                                      # 00521f4a

