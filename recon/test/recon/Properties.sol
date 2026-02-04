// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import "src/vault.sol"; // Import the vault contracts

abstract contract Properties is BeforeAfter, Asserts {
    
    // Helper functions from the properties library
    function clampLte(uint256 value, uint256 max) internal pure returns (uint256) {
        return value > max ? max : value;
    }
    
    // Mock the supportsInternalTestingIface - set to true to enable rounding tests
    bool constant supportsInternalTestingIface = true;
    
    // Mock vault and asset references
    function vault() internal view returns (ERC4626Mock) {
        return vaultImpl;
    }
    
    function asset() internal view returns (ERC20Mock) {
        return token;
    }
    
    // Mock assertion functions to match library interface
    function assertWithMsg(bool condition, string memory message) internal {
        t(condition, message);
    }
    

    
    // Mock logging
    event LogUint256(string, uint256);
        function verify_convertToAssetsMustNotRevert(uint256 shares) public {
        // arbitrarily define "reasonable values" to be 10**(token.decimals+20)
        uint256 reasonably_largest_value = 10 ** (20 + 20);

        // prevent scenarios where there is enough totalSupply to trigger overflows
        require(vault().totalSupply() <= reasonably_largest_value);
        shares = clampLte(shares, reasonably_largest_value);

        // exclude the possibility of idiosyncratic reverts. Might have to add more in future.
        shares = clampLte(shares, vault().totalSupply());

        emit LogUint256("totalSupply", vault().totalSupply());
        emit LogUint256("totalAssets", vault().totalAssets());

        try vault().convertToAssets(shares) {
            return;
        } catch {
            assertWithMsg(false, "vault.convertToAssets() must not revert");
        }
    }
}

