// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20Mock, ERC4626Mock} from "../src/Mocks.sol";

abstract contract Setup {
    ERC20Mock asset;
    ERC4626Mock vault;

    address internal alice = address(0x1);
    address internal bob = address(0x2);
    address internal charlie = address(0x3);

    function setUp() public virtual {
        asset = new ERC20Mock(" Asset ", " AST ", 18);
        vault = new ERC4626Mock(asset, "VAST", "VST");

        asset.mint(address(this), 1000000);
        asset.approve(address(vault), type(uint256).max);
    }
}
