# FUN_005268a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005268a7
# extent:       0x005268a7-0x005268fc (85 code bytes)
# span:         0x005268a7-0x005268fc (code 85, tables 0, padding 0)
# sha256:       bb32baa478c9f4b5112832591157319ad0ed538fe514ba32392c28e2d79ce833
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005268a7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_b0
# callees:      calls FUN_0050f978, FUN_00519cdf, FUN_005267f2, FUN_0051de13
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_b0, 0xb0  # offset -0xb0

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00519cdf, .text + (0x00519cdf - 0x401000)
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)
.set FUN_005267f2, .text + (0x005267f2 - 0x401000)

.org 0x005268a7 - 0x401000
.globl FUN_005268a7
FUN_005268a7:
    # block 0x005268a7: entry, 23 instruction(s), calls FUN_0050f978, FUN_00519cdf, FUN_005267f2, FUN_0051de13, ends with ret
    mov eax, 0x528e2f                            # 005268a7
    call FUN_0050f978                            # 005268ac
    sub esp, 0xa4                                # 005268b1
    push esi                                     # 005268b7
    {load} mov esi, ecx                          # 005268b8
    push 0x0                                     # 005268ba
    push 0x14000c                                # 005268bc
    push 0x1                                     # 005268c1
    lea ecx, [ebp - field_minus_b0]              # 005268c3
    call FUN_00519cdf                            # 005268c9
    and dword ptr [ebp - field_minus_4], 0x0     # 005268ce
    lea eax, [ebp - field_minus_b0]              # 005268d2
    push eax                                     # 005268d8
    {load} mov ecx, esi                          # 005268d9
    call FUN_005267f2                            # 005268db
    or dword ptr [ebp - field_minus_4], -0x1     # 005268e0
    lea ecx, [ebp - field_minus_b0]              # 005268e4
    call FUN_0051de13                            # 005268ea
    mov ecx, dword ptr [ebp - field_minus_c]     # 005268ef
    pop esi                                      # 005268f2
    mov dword ptr fs:[0x0], ecx                  # 005268f3
    leave                                        # 005268fa
    ret                                          # 005268fb

