# FUN_0041c509
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041c509
# extent:       0x0041c509-0x0041c544 (59 code bytes)
# span:         0x0041c509-0x0041c544 (code 59, tables 0, padding 0)
# sha256:       c45a051ca335fa01632409dbcea808084db267335f39ca0bec9bc75d3d290690
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41c509_init_fields
# naming:       native port src/original_methods_fl20a.c:m41c509_init_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m41c509_init_fields. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 59 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_21, field_27; [ecx + n] field_23, field_29; [edx + n] field_25
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20a.c:m41c509_init_fields (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29

# --- external targets -----------------------------------------------

.org 0x0041c509 - 0x401000
.globl FUN_0041c509
FUN_0041c509:
    # block 0x0041c509: entry, 17 instruction(s), ends with ret 0x4
    push ebp                                     # 0041c509
    {load} mov ebp, esp                          # 0041c50a
    push ecx                                     # 0041c50c
    mov dword ptr [ebp - local_4], ecx           # 0041c50d
    mov eax, dword ptr [ebp + arg_8]             # 0041c510
    mov word ptr [eax + field_21], 0xc           # 0041c513
    mov ecx, dword ptr [ebp + arg_8]             # 0041c519
    mov word ptr [ecx + field_23], 0x2           # 0041c51c
    mov edx, dword ptr [ebp + arg_8]             # 0041c522
    mov word ptr [edx + field_25], 0x1           # 0041c525
    mov eax, dword ptr [ebp + arg_8]             # 0041c52b
    mov word ptr [eax + field_27], 0x1           # 0041c52e
    mov ecx, dword ptr [ebp + arg_8]             # 0041c534
    mov dword ptr [ecx + field_29], 0x1          # 0041c537
    {load} mov esp, ebp                          # 0041c53e
    pop ebp                                      # 0041c540
    ret 0x4                                      # 0041c541

