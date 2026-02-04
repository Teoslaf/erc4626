// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {TargetFunction} from "./TargetFunction.sol";
import {Test} from "forge-std/Test.sol";

contract InvariantTest is Test, TargetFunction {
    function setUp() public override {
        super.setUp();
        targetContract(address(this));
    }

    function invariant_totalAssets() public view {
        assertGe(vault.totalAssets(), vault.convertToAssets(vault.totalSupply()));
    }

    function invariant_totalSupply() public view {
        assertEq(vault.totalSupply(), _sumOfBalance());
    }

    function invariant_previewDeposit() public view {
        uint256 shares = vault.previewDeposit(1e18);
        assertGt(shares, 0, "Depositing 1 token should give shares");
    }

    // Use actual vault state, not hardcoded values
    function invariant_convertFunctionsRoundDown() public view {
        uint256 vaultAssets = vault.totalAssets();
        if (vaultAssets == 0) return;

        // Use a small portion of actual vault assets
        uint256 testAssets = vaultAssets / 1000; // 0.1% of vault
        if (testAssets == 0) testAssets = 1;

        uint256 shares = vault.convertToShares(testAssets);
        uint256 backToAssets = vault.convertToAssets(shares);

        assertLe(backToAssets, testAssets, "convertTo functions must round down");
    }

    function invariant_convertFunctionsConsistent() public view {
        uint256 vaultAssets = vault.totalAssets();
        if (vaultAssets == 0) return;

        // Test with actual vault amounts
        uint256 testAmount = vaultAssets / 100;
        if (testAmount == 0) testAmount = 1;

        uint256 shares1 = vault.convertToShares(testAmount);
        uint256 shares2 = vault.convertToShares(testAmount);

        assertEq(shares1, shares2, "convertToShares must be consistent");
    }

    function invariant_maxFunctionsWork() public view {
        // Test with actual user balances
        uint256 userShares = vault.balanceOf(address(this));
        uint256 maxRedeem = vault.maxRedeem(address(this));

        assertEq(maxRedeem, userShares, "maxRedeem must equal user's shares");
    }

    function invariant_convertToSharesMatchesPreview() public view {
        uint256 vaultAssets = vault.totalAssets();
        if (vaultAssets == 0) return;

        uint256 testAssets = vaultAssets / 100;
        if (testAssets == 0) testAssets = 1e18;

        uint256 convertedShares = vault.convertToShares(testAssets);
        uint256 previewShares = vault.previewDeposit(testAssets);

        assertApproxEqAbs(convertedShares, previewShares, 1, "convertToShares should match previewDeposit");
    }

    // Test convertToAssets matches previewRedeem (shares → assets)
    function invariant_convertToAssetsMatchesPreview() public view {
        uint256 vaultSupply = vault.totalSupply();
        if (vaultSupply == 0) return;

        // Test with 1% of total shares
        uint256 testShares = vaultSupply / 100;
        if (testShares == 0) testShares = 1e18;

        uint256 convertedAssets = vault.convertToAssets(testShares);
        uint256 previewAssets = vault.previewRedeem(testShares);

        assertApproxEqAbs(convertedAssets, previewAssets, 1, "convertToAssets should match previewRedeem");
    }

    ///////////////////////////////////////////////////////////////

    function _sumOfBalance() internal view returns (uint256) {
        return
            vault.balanceOf(address(this)) + vault.balanceOf(alice) + vault.balanceOf(bob) + vault.balanceOf(address(0));
    }
}

// Collateral caps enable zero-cost DOS of public sales

// forceWithdrawToWrapper reverts on capital + yield withdrawal due to burning non-existent yield shares

// Attacker will break wrapper invariant causing accounting corruption

// Stale oracle pricing and slippage protection combined with irreversible ftACL investment tracking permanently locks whitelisted users out of reinvestment

// Circuit breaker design breaks protocol promise of instant liquidity

// Collateral cap not implemented per-sale, blocks subsequent sales

// Circuit Breaker emergencyOverride Function is Ineffective
