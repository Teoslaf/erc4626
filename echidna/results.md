# Issues


1. verify_convertToAssetsMustNotRevert

Issue: Even with bounds checking, there's still an overflow when totalAssets becomes extremely large
Root cause: The recognizeProfitProxy is minting tokens directly to the vault, creating astronomical balances
Numbers: totalAssets = 4635084570280944486396651490944140303696215837698679565095001962906625649198, trying to convert 25 shares

2. verify_previewMintRoundingDirection - Rounding violation

Issue: previewMint(1) returns 0, violating the rule that you can't mint shares for free
Root cause: After massive deposits followed by massive losses, extreme asset/share ratios cause previewMint(1) to round to 0
Security Impact: Allows free share minting, enabling fund theft

3. verify_convertToSharesMustNotRevert - Arithmetic Issues

Issue: convertToShares() reverts with certain input combinations
Root cause: Extreme asset/share ratios from massive deposits followed by losses cause arithmetic issues
Call sequence: depositForSelfSimple(max_uint) -> recognizeLossProxy(max_uint-1) -> convertToShares fails

