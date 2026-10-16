# FUN_00525c99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00525c99
# extent:       0x00525c99-0x00525cda (65 code bytes)
# span:         0x00525c99-0x00525cda (code 65, tables 0, padding 0)
# sha256:       b8a2e16d9a918c4dbdddf333909c24f98ed4311e7415e636e13a899bd3b037e5
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00525c99
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_8, field_10
# callees:      calls FUN_0050f978, KERNEL32.dll!FreeLibrary; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)

.org 0x00525c99 - 0x401000
.globl FUN_00525c99
FUN_00525c99:
    # block 0x00525c99: entry, 11 instruction(s), calls FUN_0050f978, ends with je to 0x00525cbf (forward)
    mov eax, 0x5290e0                            # 00525c99
    call FUN_0050f978                            # 00525c9e
    push ecx                                     # 00525ca3
    push esi                                     # 00525ca4
    {load} mov esi, ecx                          # 00525ca5
    mov dword ptr [ebp - field_minus_10], esi    # 00525ca7
    mov dword ptr [esi], 0x52ec38                # 00525caa
    mov eax, dword ptr [esi + field_10]          # 00525cb0
    and dword ptr [ebp - field_minus_4], 0x0     # 00525cb3
    test eax, eax                                # 00525cb7
    je.d8 L_00525cbf                             # 00525cb9
    # block 0x00525cbb: entered by fall-through of je at 0x00525cb9, 2 instruction(s), calls indirect eax, falls into the block at 0x00525cbf
    push 0x0                                     # 00525cbb
    call eax                                     # 00525cbd
L_00525cbf:
    # block 0x00525cbf: entered by je at 0x00525cb9, 3 instruction(s), ends with je to 0x00525ccd (forward)
    mov esi, dword ptr [esi + field_8]           # 00525cbf
    test esi, esi                                # 00525cc2
    je.d8 L_00525ccd                             # 00525cc4
    # block 0x00525cc6: entered by fall-through of je at 0x00525cc4, 2 instruction(s), calls KERNEL32.dll!FreeLibrary, falls into the block at 0x00525ccd
    push esi                                     # 00525cc6
    call dword ptr [0x52a214]                    # 00525cc7
L_00525ccd:
    # block 0x00525ccd: entered by je at 0x00525cc4, 5 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525ccd
    pop esi                                      # 00525cd0
    mov dword ptr fs:[0x0], ecx                  # 00525cd1
    leave                                        # 00525cd8
    ret                                          # 00525cd9

