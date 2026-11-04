# Finish Apple signing and approval

This Mac already has a Developer ID Application certificate. The remaining
setup is an Apple notarization login saved in Keychain. A **profile** is just
the name you give that saved login; players never need it. Apple notarization
is needed for Gatekeeper to accept the app on other Macs.

1. Use your existing [Apple Developer Program](https://developer.apple.com/programs/)
   membership. If setting up another build Mac, install a **Developer ID
   Application** certificate with its private key in the login keychain.
   Find the certificate's identity hash and team:

   ```sh
   security find-identity -v -p codesigning
   ```

2. In your own Terminal, save the notarization login:

   ```sh
   xcrun notarytool store-credentials blackmoor-notary
   ```

   Answer the private prompts for your Apple ID, the same team as the
   certificate, and an app-specific password. Never paste passwords, keys or
   profile contents into chat, this repository or build logs.

3. Export these two selections, using the identity hash from step 1:

   ```sh
   export BLACKMOOR_SIGN_IDENTITY="YOUR_DEVELOPER_ID_IDENTITY_HASH"
   export BLACKMOOR_NOTARY_PROFILE="blackmoor-notary"
   ```

4. Build from your own supported executable, after the one-time prerequisites
   in [INSTALL.md](INSTALL.md):

   ```sh
   export GAME_EXE="/absolute/path/to/your/GAME.EXE"
   script/package_macos.sh
   ```

The script signs every nested binary with hardened runtime and no extra
entitlements, submits to Apple, requires **Accepted**, staples and validates
both the app and DMG, and checks Gatekeeper. It prints the local DMG's path,
SHA-256 and size. Invalid supplied credentials fail visibly.

With both selections absent, it makes a clearly labeled **AD-HOC, UNNOTARIZED**
package that Gatekeeper rejects on another Mac. That fallback omits hardened
runtime because ad-hoc libraries have no Developer ID team; no entitlement
disables library validation. An identity alone still needs notarization.

Keep the derived app, DMG and generated C on your disk for your own Macs and
named testers. Never commit them or upload them to a public host. Public
distribution remains a separate question for Glib. A second Mac, macOS 11 and
real speakers still need separate verification.

Apple's [notarization workflow](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)
and [Developer ID guide](https://developer.apple.com/developer-id/) explain the account setup.
