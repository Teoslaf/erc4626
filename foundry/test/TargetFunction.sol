// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Setup} from "./Setup.sol";
import {Test} from "forge-std/Test.sol";

abstract contract TargetFunction is Setup, Test {
    function vault_withdraw_not_owner(uint256 asset, uint256 allowanceAmount) public {
        vm.startPrank(alice);
        vault.mint(asset, alice);
        vault.approve(address(vault), asset);
        vault.deposit(asset, alice);
        vault.approve(bob, allowanceAmount);
        vm.stopPrank();

        uint256 maxWithdraw = vault_maxWithdraw(alice);
        if (maxWithdraw == 0) return;

        vm.prank(bob);
        vault.withdraw(maxWithdraw, bob, alice);
    }

    function vault_redeem_not_owner(uint256 shares, uint256 allowanceAmount) public {
        vm.startPrank(alice);
        uint256 assets = vault.previewMint(shares);
        asset.mint(alice, assets + 1);
        asset.approve(address(vault), assets + 1);
        vault.mint(shares, alice);
        vm.stopPrank();
        vault.redeem(shares, address(this), address(this));

        vault.approve(bob, allowanceAmount);
        vm.stopPrank();

        uint256 maxRedeem = vault.maxRedeem(alice);
        if (maxRedeem == 0) return;

        uint256 redeemAmount = bound(shares, 1, maxRedeem);

        vm.prank(bob);
        vault.redeem(redeemAmount, bob, alice);
    }

    ///////////////////////////////////////////

    function vault_deposit(uint256 assets) public {
        assets = bound(assets, 1, 1_000_000e18);

        vault.convertToShares(assets);
        vault.maxDeposit(address(this));

        asset.mint(address(this), assets);
        asset.approve(address(vault), assets);
        vault.deposit(assets, address(this));
    }

    function vault_mint(uint256 shares) public {
        shares = bound(shares, 1, 1_000_000e18);

        vault.previewMint(shares);
        vault.maxMint(address(this));

        uint256 assets = vault.previewMint(shares);
        asset.mint(address(this), assets + 1);
        asset.approve(address(vault), assets + 1);
        vault.mint(shares, address(this));
    }

    function vault_withdraw(uint256 assets) public {
        uint256 maxWithdraw = vault.maxWithdraw(address(this));
        if (maxWithdraw == 0) return;

        assets = bound(assets, 1, maxWithdraw);

        vault.previewWithdraw(assets);
        vault.convertToShares(assets);

        vault.withdraw(assets, address(this), address(this));
    }

    function vault_redeem(uint256 shares) public {
        uint256 maxRedeem = vault.maxRedeem(address(this));
        if (maxRedeem == 0) return;

        shares = bound(shares, 1, maxRedeem);

        vault.previewRedeem(shares);

        vault.redeem(shares, address(this), address(this));
    }

    function vault_maxDeposit(address owner) public view returns (uint256) {
        return vault.maxDeposit(owner);
    }

    function vault_maxMint(address owner) public view returns (uint256) {
        return vault.maxMint(owner);
    }

    function vault_convertToShares(uint256 assets) public view returns (uint256) {
        return vault.convertToShares(assets);
    }

    function vault_previewMint(uint256 shares) public view returns (uint256) {
        return vault.previewMint(shares);
    }

    function vault_previewWithdraw(uint256 assets) public view returns (uint256) {
        return vault.previewWithdraw(assets);
    }

    function vault_previewRedeem(uint256 shares) public view returns (uint256) {
        return vault.previewRedeem(shares);
    }

    function vault_maxWithdraw(address owner) public view returns (uint256) {
        return vault.maxWithdraw(owner);
    }

    function vault_maxRedeem(address owner) public view returns (uint256) {
        return vault.maxRedeem(owner);
    }
}
