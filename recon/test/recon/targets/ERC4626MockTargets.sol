// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "../BeforeAfter.sol";
import {Properties} from "../Properties.sol";
// Chimera deps
import {vm} from "@chimera/Hevm.sol";

// Helpers
import {Panic} from "@recon/Panic.sol";

import "src/vault.sol";

abstract contract ERC4626MockTargets is
    BaseTargetFunctions,
    Properties
{
    /// CUSTOM TARGET FUNCTIONS - Add your own target functions here ///


    /// AUTO GENERATED TARGET FUNCTIONS - WARNING: DO NOT DELETE OR MODIFY THIS LINE ///

    function vaultImpl_approve(address spender, uint256 amount) public asActor {
        vaultImpl.approve(spender, amount);
    }

    function vaultImpl_deposit(uint256 assets, address receiver) public asActor {
        vaultImpl.deposit(assets, receiver);
    }

    function vaultImpl_mint(uint256 shares, address receiver) public asActor {
        vaultImpl.mint(shares, receiver);
    }

    function vaultImpl_permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public asActor {
        vaultImpl.permit(owner, spender, value, deadline, v, r, s);
    }

    function vaultImpl_recognizeLoss(uint256 loss) public asActor {
        vaultImpl.recognizeLoss(loss);
    }

    function vaultImpl_recognizeProfit(uint256 profit) public asActor {
        vaultImpl.recognizeProfit(profit);
    }

    function vaultImpl_redeem(uint256 shares, address receiver, address owner) public asActor {
        vaultImpl.redeem(shares, receiver, owner);
    }

    function vaultImpl_transfer(address to, uint256 amount) public asActor {
        vaultImpl.transfer(to, amount);
    }

    function vaultImpl_transferFrom(address from, address to, uint256 amount) public asActor {
        vaultImpl.transferFrom(from, to, amount);
    }

    function vaultImpl_withdraw(uint256 assets, address receiver, address owner) public asActor {
        vaultImpl.withdraw(assets, receiver, owner);
    }
}