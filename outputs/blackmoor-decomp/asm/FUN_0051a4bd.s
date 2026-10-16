# FUN_0051a4bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a4bd
# extent:       0x0051a4bd-0x0051a4e6 (41 code bytes)
# span:         0x0051a4bd-0x0051a4e6 (code 41, tables 0, padding 0)
# sha256:       58eab64fd8968cbe4e4817f1d355ae958d11b7be87554d4783f130e9fac75f40
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a4bd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051a492
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a492, .text + (0x0051a492 - 0x401000)

.org 0x0051a4bd - 0x401000
.globl FUN_0051a4bd
FUN_0051a4bd:
    # block 0x0051a4bd: entry, 11 instruction(s), calls FUN_0050f978, FUN_0051a492, ends with ret
    mov eax, 0x5290cc                            # 0051a4bd
    call FUN_0050f978                            # 0051a4c2
    push ecx                                     # 0051a4c7
    mov dword ptr [ebp - field_minus_10], ecx    # 0051a4c8
    mov dword ptr [ecx], 0x52febc                # 0051a4cb
    and dword ptr [ebp - field_minus_4], 0x0     # 0051a4d1
    call FUN_0051a492                            # 0051a4d5
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051a4da
    mov dword ptr fs:[0x0], ecx                  # 0051a4dd
    leave                                        # 0051a4e4
    ret                                          # 0051a4e5

