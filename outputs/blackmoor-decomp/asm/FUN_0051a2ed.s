# FUN_0051a2ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a2ed
# extent:       0x0051a2ed-0x0051a316 (41 code bytes)
# span:         0x0051a2ed-0x0051a316 (code 41, tables 0, padding 0)
# sha256:       6db1c773d532fba0737f373d8ca676b94fcd913535d49c2fcebc546efb41d920
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a2ed
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051a2cd
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
.set FUN_0051a2cd, .text + (0x0051a2cd - 0x401000)

.org 0x0051a2ed - 0x401000
.globl FUN_0051a2ed
FUN_0051a2ed:
    # block 0x0051a2ed: entry, 11 instruction(s), calls FUN_0050f978, FUN_0051a2cd, ends with ret
    mov eax, 0x52923c                            # 0051a2ed
    call FUN_0050f978                            # 0051a2f2
    push ecx                                     # 0051a2f7
    mov dword ptr [ebp - field_minus_10], ecx    # 0051a2f8
    mov dword ptr [ecx], 0x530128                # 0051a2fb
    and dword ptr [ebp - field_minus_4], 0x0     # 0051a301
    call FUN_0051a2cd                            # 0051a305
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051a30a
    mov dword ptr fs:[0x0], ecx                  # 0051a30d
    leave                                        # 0051a314
    ret                                          # 0051a315

