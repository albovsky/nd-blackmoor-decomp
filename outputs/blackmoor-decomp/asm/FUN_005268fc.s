# FUN_005268fc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005268fc
# extent:       0x005268fc-0x0052694b (79 code bytes)
# span:         0x005268fc-0x0052694b (code 79, tables 0, padding 0)
# sha256:       2e0fc03e6298ae7d9f5fb8bc57c0d96cdfad24e2bdb969b21a5e880bcf6b2607
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CWinThread::~CWinThread
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_28
# callees:      calls FUN_0050f978, KERNEL32.dll!CloseHandle, FUN_00525397, FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x005268fc - 0x401000
.globl FUN_005268fc
FUN_005268fc:
    # block 0x005268fc: entry, 11 instruction(s), calls FUN_0050f978, ends with je to 0x00526925 (forward)
    mov eax, 0x528ddc                            # 005268fc
    call FUN_0050f978                            # 00526901
    push ecx                                     # 00526906
    push esi                                     # 00526907
    {load} mov esi, ecx                          # 00526908
    mov dword ptr [ebp - field_minus_10], esi    # 0052690a
    mov dword ptr [esi], 0x52f3c0                # 0052690d
    mov eax, dword ptr [esi + field_28]          # 00526913
    and dword ptr [ebp - field_minus_4], 0x0     # 00526916
    test eax, eax                                # 0052691a
    je.d8 L_00526925                             # 0052691c
    # block 0x0052691e: entered by fall-through of je at 0x0052691c, 2 instruction(s), calls KERNEL32.dll!CloseHandle, falls into the block at 0x00526925
    push eax                                     # 0052691e
    call dword ptr [0x52a2b8]                    # 0052691f
L_00526925:
    # block 0x00526925: entered by je at 0x0052691c, 3 instruction(s), calls FUN_00525397, ends with jne to 0x00526933 (forward)
    call FUN_00525397                            # 00526925
    cmp dword ptr [eax + field_4], esi           # 0052692a
    jne.d8 L_00526933                            # 0052692d
    # block 0x0052692f: entered by fall-through of jne at 0x0052692d, 1 instruction(s), falls into the block at 0x00526933
    and dword ptr [eax + field_4], 0x0           # 0052692f
L_00526933:
    # block 0x00526933: entered by jne at 0x0052692d, 8 instruction(s), calls FUN_0051d730, ends with ret
    or dword ptr [ebp - field_minus_4], -0x1     # 00526933
    {load} mov ecx, esi                          # 00526937
    call FUN_0051d730                            # 00526939
    mov ecx, dword ptr [ebp - field_minus_c]     # 0052693e
    pop esi                                      # 00526941
    mov dword ptr fs:[0x0], ecx                  # 00526942
    leave                                        # 00526949
    ret                                          # 0052694a

