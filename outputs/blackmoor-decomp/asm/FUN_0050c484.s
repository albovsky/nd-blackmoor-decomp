# FUN_0050c484
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c484
# extent:       0x0050c484-0x0050c4cc (72 code bytes)
# span:         0x0050c484-0x0050c4cc (code 72, tables 0, padding 0)
# sha256:       c2bc358b83a9be6e035d285446725b2b53210b0080b226dbc313e051a8c37a24
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c484
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_4, field_20
# callees:      calls FUN_0050f978, FUN_0051f8c4, FUN_0051a4bd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a4bd, .text + (0x0051a4bd - 0x401000)
.set FUN_0051f8c4, .text + (0x0051f8c4 - 0x401000)

.org 0x0050c484 - 0x401000
.globl FUN_0050c484
FUN_0050c484:
    # block 0x0050c484: entry, 20 instruction(s), calls FUN_0050f978, FUN_0051f8c4, FUN_0051a4bd, ends with ret
    mov eax, 0x5290ba                            # 0050c484
    call FUN_0050f978                            # 0050c489
    push ecx                                     # 0050c48e
    push esi                                     # 0050c48f
    {load} mov esi, ecx                          # 0050c490
    mov dword ptr [ebp - field_minus_10], esi    # 0050c492
    mov dword ptr [esi], 0x52fe80                # 0050c495
    mov dword ptr [ebp - field_minus_4], 0x1     # 0050c49b
    call FUN_0051f8c4                            # 0050c4a2
    and byte ptr [ebp - field_minus_4], 0x0      # 0050c4a7
    lea ecx, [esi + field_20]                    # 0050c4ab
    call FUN_0051a4bd                            # 0050c4ae
    or dword ptr [ebp - field_minus_4], -0x1     # 0050c4b3
    lea ecx, [esi + field_4]                     # 0050c4b7
    call FUN_0051a4bd                            # 0050c4ba
    mov ecx, dword ptr [ebp - field_minus_c]     # 0050c4bf
    pop esi                                      # 0050c4c2
    mov dword ptr fs:[0x0], ecx                  # 0050c4c3
    leave                                        # 0050c4ca
    ret                                          # 0050c4cb

