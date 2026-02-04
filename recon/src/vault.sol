// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC4626} from "solmate/tokens/ERC4626.sol";


contract ERC20Mock is ERC20 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals) ERC20(_name, _symbol, _decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract ERC4626Mock is ERC4626 {
    constructor(ERC20 _asset, string memory _name, string memory _symbol) ERC4626(_asset, _name, _symbol) {}

    uint256 _totalAssets;

    function totalAssets() public view override returns (uint256) {
        return _totalAssets;
    }

    function beforeWithdraw(uint256 assets, uint256) internal override {
        _totalAssets = _totalAssets - assets;
    }

    function afterDeposit(uint256 assets, uint256) internal override {
        _totalAssets = _totalAssets + assets;
    }

    function recognizeProfit(uint256 profit) public {
        ERC20Mock(address(asset)).mint(address(this), profit);
        _totalAssets += profit;
    }

    function recognizeLoss(uint256 loss) public {
        ERC20Mock(address(asset)).mint(address(0), loss);
        
		_totalAssets -= loss;
}
}