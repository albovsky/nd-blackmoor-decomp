# FUN_0050c17c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c17c
# extent:       0x0050c17c-0x0050c193 (23 code bytes)
# span:         0x0050c17c-0x0050c193 (code 23, tables 0, padding 0)
# sha256:       344c2287fcc9556cbc6d800121fec4e599e6c0528cda5c88d3303bb5ede5809f
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c17c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_20
# callees:      calls USER32.dll!GetParent, FUN_0051abe4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)

.org 0x0050c17c - 0x401000
.globl FUN_0050c17c
FUN_0050c17c:
    # block 0x0050c17c: entry, 3 instruction(s), ends with jne to 0x0050c18c (forward)
    mov eax, dword ptr [ecx + field_20]          # 0050c17c
    test eax, eax                                # 0050c17f
    jne.d8 L_0050c18c                            # 0050c181
    # block 0x0050c183: entered by fall-through of jne at 0x0050c181, 2 instruction(s), calls USER32.dll!GetParent, falls into the block at 0x0050c18c
    push dword ptr [ecx + field_1c]              # 0050c183
    call dword ptr [0x52a3dc]                    # 0050c186
L_0050c18c:
    # block 0x0050c18c: entered by jne at 0x0050c181, 3 instruction(s), calls FUN_0051abe4, ends with ret
    push eax                                     # 0050c18c
    call FUN_0051abe4                            # 0050c18d
    ret                                          # 0050c192

