// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {CryticERC4626PropertyTests} from "properties/ERC4626/ERC4626PropertyTests.sol";
// this token _must_ be the vault's underlying asset
import {TestERC20Token} from "properties/ERC4626/util/TestERC20Token.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC4626} from "solmate/tokens/ERC4626.sol";

// change to your vault implementation
import {VaultImpl} from "../src/Vault.sol";


contract VaultImplInternalTestable is VaultImpl {
	    constructor(ERC20 _asset, string memory _name, string memory _symbol)
		VaultImpl(_asset, _name, _symbol) {}

		function recognizeProfit(uint256 profit) public {
			TestERC20Token(address(asset)).mint(address(this), profit);
			_totalAssets += profit;
		}
		function recognizeLoss(uint256 loss) public {
			TestERC20Token(address(asset)).burn(address(this), loss);
			_totalAssets -= loss;
		}
}
contract CryticERC4626Harness is CryticERC4626PropertyTests {
    constructor() {
        TestERC20Token _asset = new TestERC20Token("Test Token", "TT", 18);
        VaultImplInternalTestable _vault = new VaultImplInternalTestable(ERC20(address(_asset)), "Vault Token", "VTT");
        initialize(address(_vault), address(_asset), true);
    }
}

//echidna test/CryticERC4626Harness.sol --contract CryticERC4626Harness --config ./echidna.config.yaml
