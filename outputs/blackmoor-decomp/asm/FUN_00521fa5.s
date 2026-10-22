# FUN_00521fa5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521fa5
# extent:       0x00521fa5-0x00521ffc (87 code bytes)
# span:         0x00521fa5-0x00521ffc (code 87, tables 0, padding 0)
# sha256:       b412896211b2cb9ea5784c6d268b80035f6c5a1ef1e21b6dbf2d528d913bfca7
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521fa5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_5c, field_64, field_78
# callees:      calls FUN_0050f978, FUN_0051dc6c, FUN_0051e7ba, FUN_0051a121, FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_5c, 0x5c  # offset +0x5c
.equ field_64, 0x64  # offset +0x64
.equ field_78, 0x78  # offset +0x78

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a121, .text + (0x0051a121 - 0x401000)
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00521fa5 - 0x401000
.globl FUN_00521fa5
FUN_00521fa5:
    # block 0x00521fa5: entry, 25 instruction(s), calls FUN_0050f978, FUN_0051dc6c, FUN_0051e7ba, FUN_0051a121, FUN_0051b257, ends with ret
    mov eax, 0x528d12                            # 00521fa5
    call FUN_0050f978                            # 00521faa
    push ecx                                     # 00521faf
    push esi                                     # 00521fb0
    {load} mov esi, ecx                          # 00521fb1
    mov dword ptr [ebp - field_minus_10], esi    # 00521fb3
    mov dword ptr [esi], 0x52f0c8                # 00521fb6
    push dword ptr [esi + field_5c]              # 00521fbc
    mov dword ptr [ebp - field_minus_4], 0x2     # 00521fbf
    call FUN_0051dc6c                            # 00521fc6
    pop ecx                                      # 00521fcb
    mov byte ptr [ebp - field_minus_4], 0x1      # 00521fcc
    lea ecx, [esi + field_78]                    # 00521fd0
    call FUN_0051e7ba                            # 00521fd3
    and byte ptr [ebp - field_minus_4], 0x0      # 00521fd8
    lea ecx, [esi + field_64]                    # 00521fdc
    call FUN_0051a121                            # 00521fdf
    or dword ptr [ebp - field_minus_4], -0x1     # 00521fe4
    {load} mov ecx, esi                          # 00521fe8
    call FUN_0051b257                            # 00521fea
    mov ecx, dword ptr [ebp - field_minus_c]     # 00521fef
    pop esi                                      # 00521ff2
    mov dword ptr fs:[0x0], ecx                  # 00521ff3
    leave                                        # 00521ffa
    ret                                          # 00521ffb

