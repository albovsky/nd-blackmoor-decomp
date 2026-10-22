# FUN_0051de13
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051de13
# extent:       0x0051de13-0x0051de51 (62 code bytes)
# span:         0x0051de13-0x0051de51 (code 62, tables 0, padding 0)
# sha256:       4799b4016f4b06ad805ad274f1475ab780cd7f80c07b9d4ca69e219746cd2134
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CDialog::~CDialog
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_1c
# callees:      calls FUN_0050f978, FUN_0051b414, FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051b414, .text + (0x0051b414 - 0x401000)

.org 0x0051de13 - 0x401000
.globl FUN_0051de13
FUN_0051de13:
    # block 0x0051de13: entry, 10 instruction(s), calls FUN_0050f978, ends with je to 0x0051de39 (forward)
    mov eax, 0x528d24                            # 0051de13
    call FUN_0050f978                            # 0051de18
    push ecx                                     # 0051de1d
    push esi                                     # 0051de1e
    {load} mov esi, ecx                          # 0051de1f
    mov dword ptr [ebp - field_minus_10], esi    # 0051de21
    mov dword ptr [esi], 0x52f29c                # 0051de24
    and dword ptr [ebp - field_minus_4], 0x0     # 0051de2a
    cmp dword ptr [esi + field_1c], 0x0          # 0051de2e
    je.d8 L_0051de39                             # 0051de32
    # block 0x0051de34: entered by fall-through of je at 0x0051de32, 1 instruction(s), calls FUN_0051b414, falls into the block at 0x0051de39
    call FUN_0051b414                            # 0051de34
L_0051de39:
    # block 0x0051de39: entered by je at 0x0051de32, 8 instruction(s), calls FUN_0051b257, ends with ret
    or dword ptr [ebp - field_minus_4], -0x1     # 0051de39
    {load} mov ecx, esi                          # 0051de3d
    call FUN_0051b257                            # 0051de3f
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051de44
    pop esi                                      # 0051de47
    mov dword ptr fs:[0x0], ecx                  # 0051de48
    leave                                        # 0051de4f
    ret                                          # 0051de50

