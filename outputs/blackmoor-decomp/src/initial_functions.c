/* Initial, small recovered field-access functions.
 * This is a baseline for the matching verifier, not a recovered engine.
 * thiscall preserves the original x86 ECX receiver convention.
 */

/* REA evidence: ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859; original VA 0x51cfd1.
 * Semantic name and owning class remain unknown. */
unsigned int __attribute__((thiscall)) FUN_0051cfd1(const void *self) {
    return *(const unsigned int *)((const char *)self + 0x24) & 0x10u;
}

/* REA evidence: ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5; original VA 0x52398b.
 * Semantic name and owning class remain unknown. */
unsigned int __attribute__((thiscall)) FUN_0052398b(const void *self) {
    return *(const unsigned int *)((const char *)self + 0x98);
}
